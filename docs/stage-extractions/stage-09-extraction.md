# Stage 9: VERIFICATION AGENT SETUP --- Extraction Dossier

## Purpose

Stage 9 sets up an independent verification agent that audits the builder agent's work after each phase. The core principle: **the checker is NOT the same agent as the builder**. The builder cannot be trusted to check its own work --- a separate agent with no loyalty to the builder's output, no sunk cost, and clean context makes the pass/fail determination.

Stage 9 was originally called "PROTOCOL INJECTION" (embedding pulse/seam/full checkpoints into phases). It was later split and renamed to "VERIFICATION AGENT SETUP" to specifically address the need for a **separate agent with decision authority** running alongside the build. As stated in the source: "It's not just injecting text anymore, it's defining a separate agent's role and instructions."

## The Two Verification Approaches (Automated vs Manual)

### Approach 1: Bash/CLI Automated Pipeline

A dedicated verifier agent (Agent B) runs after each phase, completely separate from the builder agent (Agent A):

```
PHASE 1:
  -> Agent A (Builder): Executes the phase, writes code
  -> Git diff captured automatically (mechanical, no agent involved)
  -> Agent B (Verifier): Fresh agent, clean context, sees ONLY:
      - The allowed file list
      - The diff output
      - The functional check results
      - The violation decision tree
  -> Agent B makes the call: pass, fix, or redo
```

Agent B has NO loyalty to Agent A's work. It didn't write it. It has no sunk cost. It just looks at the evidence and follows the decision tree.

**Cost efficiency**: Agent B barely uses any tokens. It reads a file list, a diff, and makes a classification. Maybe **10K tokens per phase verification**. Across a 4-phase build, that's 40K tokens for a completely independent auditor. Negligible.

**Persistent verifier concept**: One Agent B lives across the entire build. It accumulates context --- "Phase 1 was clean, Phase 2 had a minor drift on a types file, Phase 3..." By Phase 4 it has a PATTERN. If it notices the builder keeps drifting toward the same files, it flags a systemic issue, not just individual violations.

**Auto-retry logic (2 strikes then human review)**:

```bash
# Run phase build
run_phase_builder "phase-2.md"

# Run verification
RESULT=$(run_phase_verifier "phase-2")

if [ "$RESULT" = "CRITICAL" ] || [ "$RESULT" = "HIGH" ]; then
    git reset --hard PHASE_2_BASELINE
    echo "Phase 2 failed verification. Retrying with fresh agent..."
    run_phase_builder "phase-2.md"  # Fresh agent, fresh context
    RESULT=$(run_phase_verifier "phase-2")

    if [ "$RESULT" = "CRITICAL" ] || [ "$RESULT" = "HIGH" ]; then
        echo "Phase 2 failed twice. Stopping for human review."
        exit 1
    fi
fi
```

Two strikes and it stops for human intervention. Rationale: 9 out of 10 agents are fine. If the first goes rogue, the second almost certainly won't. If TWO in a row fail the same phase, something's wrong with the **phase spec itself**, not the agents. That's a human problem.

### Approach 2: Manual/Web (Phase N+1 Agent Checks Phase N)

For users who are NOT using bash/CLI automation (e.g., pasting prompts into Claude Code web, desktop app, or other web-based builders):

**The problem**: If they need a Phase 1 checker agent, then Phase 2 builder, then Phase 2 checker agent, you've just **doubled the amount of agents and the amount of times they actually have to start it up**. For people multitasking, you could get 5-25 minutes between each agent. What could have been done in an hour and a half now becomes 4-5 hours. Plus leaving for an errand breaks the entire flow.

**The solution**: Each phase agent **starts with a diff check of the previous phase's output** before doing its own work. Phase 2 opens with: "Validate Phase 1 deliverables against these criteria, flag issues, then proceed with Phase 2 work." If something's off, it fixes it inline rather than bouncing back.

This means:
- **Same number of agents as phases** (not 2x)
- **No idle time** between "build" and "check"
- **The check becomes a 30-second preamble**, not a separate 10-minute agent run

### Why This Avoids Doubling Agent Count

For manual/web users, the check is embedded as the opening task of the next phase's prompt. The user pastes Phase 2's prompt and it starts by validating Phase 1. One flow, two delivery methods.

For bash/CLI users, the separate verifier is justified because it runs automatically with zero human intervention --- the time cost is machine time, not human time.

The same core prompts are used for both approaches --- a flag/picker at the end wraps the same core prompts differently (one with bash chaining commands baked in, one without). Not two separate PRDs.

## What Gets Verified

### The Git Diff Comparison (Ground Truth)

The `git diff` command is the "CCTV camera." It is deterministic, cannot be fooled, cannot hallucinate, cannot miss anything.

**The flow**:
1. Take snapshot (git commit hash before agent starts)
2. Agent does its work (can touch anything technically)
3. Script runs `git diff --name-only` against the snapshot
4. Compares modified files against the ALLOWED list
5. Any file NOT on the allowed list = BUILD REJECTED
6. `git reset --hard $SNAPSHOT` = everything reverted
7. Agent has to try again

This is an **alarm system, not a fence**. The agent CAN touch whatever it wants during the build. But the moment it finishes, the diff captures EVERY file that was created, modified, or deleted and compares against the sanctioned list.

### The Four-Step End-of-Phase Verification

Injected at the end of every phase in the PRD text:

**Step 1: Self-Report**
Agent lists every file it created or modified. Compares against the Allowed Files list at the top of the phase.

**Step 2: Diff Check**
Run: `git diff PHASE_N_BASELINE..HEAD --name-only`
Compare this output against the self-report AND the Allowed Files list.

**Step 3: Violation Response**
If ANY file appears in the diff that is NOT in Allowed Files:
- If it's a shared type/config file -> log and proceed
- If it's from another phase's domain -> STOP and revert that file
- If it's a core system file (.env, CLAUDE.md, config) -> FULL STOP

**Step 4: Functional Verification**
- Does the app compile? Run: `npm run build`
- Do existing features still work? Run: `npm run test` (if tests exist)
- Do the new pages/components render without errors?

**ALL FOUR STEPS MUST PASS BEFORE THE NEXT PHASE BEGINS.**

### Self-Report vs Ground Truth

The self-evaluation (Step 1) is a first pass. The git diff (Step 2) is the ground truth. If they don't match, **that itself is a violation**. An agent could lie about what it touched --- that's why the mechanical diff is the real verification, not the self-reported list.

## Violation Handling

The full decision tree is embedded INTO the phase text that the agent reads:

```
VIOLATION DETECTED
|
+-- SEVERITY: LOW (touched a shared types file, added an import to an existing util)
|   Action: Log it. Note it in the phase report. Proceed.
|   Reasoning: Some cross-cutting concerns are unavoidable.
|   The type file serves multiple phases. This is expected.
|
+-- SEVERITY: MEDIUM (modified a file from a different phase's domain)
|   Action: STOP. Review the change.
|   +-- If the change is ADDITIVE (added an export, added a prop):
|   |   Probably okay. The next phase needed a hook point.
|   |   Log it, note it, proceed with caution.
|   +-- If the change is DESTRUCTIVE (renamed something, changed logic):
|   |   REVERT that specific file to baseline.
|   |   Re-run the phase with explicit instruction:
|   |   "Do NOT modify [file]. Work around it."
|   +-- If unclear:
|       Flag for human review. Don't proceed until resolved.
|
+-- SEVERITY: HIGH (deleted files, modified core config, changed auth logic)
|   Action: REVERT ENTIRE PHASE.
|   The agent went off-script in a dangerous way.
|   Re-run with tighter constraints or break the phase smaller.
|
+-- SEVERITY: CRITICAL (modified CLAUDE.md, changed environment files,
|                        touched .env, altered build config)
    Action: FULL STOP. REVERT. FLAG.
    This is either a prompt injection attempt or a
    catastrophically confused agent. Human must intervene.
```

Three outcomes at the phase boundary:
- **CLEAN**: Agent only touched sanctioned files -> proceed to next phase
- **MINOR DRIFT**: Agent touched 1-2 extra files that are reasonable (like a shared types file) -> flag it, human reviews, probably fine
- **MAJOR DRIFT**: Agent modified files from a different phase's domain -> STOP. Either revert or inspect every change manually.

Because violations are detected at the **phase boundary** (not at the end of the entire build), the blast radius is small --- one phase worth of work, not the whole project.

## Inputs

- **From Stage 8 (Phase Sequencing)**: The rough phase splits with file sandboxes and build orders already defined
- **The allowed file list per phase**: Explicit whitelist of files the agent CAN modify, CAN read, and CANNOT touch
- **The build order within each phase**: Forced linear sequence with pulse/seam check insertion points
- **The violation handling instructions**: The decision tree (approximately ~2,000 tokens of overhead per phase)

## Process

1. **Take the phases from Stage 8** with their file sandboxes and build orders
2. **Inject checkpoint protocols inline** into each phase:
   - Pulse checks after individual files (lightweight: does it exist? does it export expected functions?)
   - Seam checks at connection points (does SignIn.tsx import from AuthContext? Does AuthContext import from auth.ts?)
   - Full checkpoint at phase boundary with pattern verification
3. **Embed the verification prompt** at the end of each phase (self-report + diff check + violation response + functional verification)
4. **Embed the violation decision tree** into the phase text so the agent knows exactly what to do for each severity level
5. **Define the verifier agent's role and instructions** (for bash/CLI: separate Agent B; for manual/web: preamble in next phase's prompt)
6. **Quick validation**: Does the phase still fit within context budget after injection? If not, adjust the split point from Stage 8
7. **Configure auto-retry logic** (for bash/CLI): 2 strikes on the same phase triggers human review stop

Stage 9 doesn't just "tag" protocols onto phases. It **REWRITES the phases to embed the protocols inline**. The pulse checks live INSIDE the build order. The seam checks live at connection points WITHIN the phase. The full checkpoint with pattern verification lives at the phase boundary.

## Outputs

- **Fully instrumented phase documents**: Each phase now contains embedded pulse checks, seam checks, full checkpoint protocol, verification prompts, and violation decision tree
- **Verifier agent instructions**: For bash/CLI --- separate agent definition with minimal token footprint (~10K per verification); for manual/web --- validation preamble baked into Phase N+1's prompt
- **Auto-retry configuration**: Bash script logic for 2-strike retry with escalation to human review
- **Violation handling protocol**: Complete decision tree embedded in every phase's text

## Rules & Constraints

1. **The checker is NEVER the same agent as the builder** (for bash/CLI). The builder cannot be trusted to audit its own work.
2. **Git diff is the ground truth**, not agent self-reporting. The diff is deterministic, cannot be fooled, cannot hallucinate.
3. **Two strikes and stop**: If two consecutive fresh agents fail the same phase, the problem is the phase spec, not the agents. Human must intervene.
4. **Verification overhead is predictable**: ~25,000 tokens total per-phase overhead (including build rules preamble ~8K, sandbox declaration ~2K, build order with pulse points ~3K, seam check definitions ~2K, full checkpoint ~5K, pattern verification ~3K, violation handling ~2K).
5. **The violation decision tree goes INTO the phase text** --- it is not external logic. The agent self-evaluates after building, following the embedded tree.
6. **Detection over prevention**: You don't physically prevent the agent from touching files (that would require OS-level sandboxing). You DETECT violations immediately at the phase boundary. The alarm + rollback approach is simpler and equally effective.
7. **Blast radius is contained**: Because verification happens at each phase boundary, violations only affect one phase worth of work, not the entire project.
8. **For manual/web users, never double the agent count**: The verification check is merged as a 30-second preamble into the next phase, keeping agent count equal to phase count.
9. **Stage 8 and Stage 9 are tightly coupled**: Stage 8 does a rough split based on estimated overhead, Stage 9 injects the actual protocols, then a quick validation confirms it still fits. This is a single pass, not a back-and-forth loop.

## Examples

### Bash/CLI Verification Flow (Automated)

```
PHASE 1:
  -> Agent A builds (writes code per phase instructions)
  -> Mechanical: git diff captured
  -> Agent B (Verifier) receives:
      - Allowed file list from phase spec
      - git diff output
      - npm run build result
      - npm run test result
  -> Agent B classifies: CLEAN / LOW / MEDIUM / HIGH / CRITICAL
  -> If CLEAN or LOW: proceed to Phase 2
  -> If HIGH/CRITICAL: git reset --hard, retry with fresh Agent A
  -> If second failure: STOP for human review
```

### Manual/Web Verification Flow (Merged into Next Phase)

Phase 2's prompt begins with:
> "Validate Phase 1 deliverables against these criteria, flag issues, then proceed with Phase 2 work."

The check is a 30-second preamble, not a separate 10-minute agent run.

### Injected Phase Structure (After Stage 9)

```
Phase 1: Auth System
+-- FILES ALLOWED: [list]
+-- BUILD ORDER:
|   1. Create src/lib/auth.ts
|      <- PULSE after this file (does it exist? does it export expected functions?)
|   2. Create src/contexts/AuthContext.tsx
|      <- PULSE after this file
|   3. Create src/pages/SignIn.tsx
|      <- PULSE after this file (3 files done = pulse cycle complete)
|      <- SEAM CHECK: does SignIn.tsx import from AuthContext?
|        Does AuthContext import from auth.ts? Are the doors connected?
|   4. Create src/pages/SignUp.tsx
|      <- PULSE after this file
|   5. Wire routes in App.tsx
|      <- PULSE after this file
|      <- SEAM CHECK: do routes point to actual page components?
|
+-- END OF PHASE: FULL CHECKPOINT
|   +-- PATTERN VERIFICATION:
|   |   +-- List every file created or modified
|   |   +-- Compare against FILES ALLOWED list
|   |   +-- FLAG any file touched that wasn't in the sandbox
|   |   +-- FLAG any file in BUILD ORDER that wasn't completed
|   |   +-- FLAG any unexpected imports or dependencies
|   +-- FUNCTIONAL CHECK:
|   |   +-- Does the app compile?
|   |   +-- Do the auth pages render?
|   |   +-- Can you navigate to /sign-in and /sign-up?
|   +-- GATE: Pass/fail. If fail, fix before Phase 2 starts.
```

## Connections to Other Stages

- **Stage 8 (Phase Sequencing)**: Provides the raw phase splits, file sandboxes, and build orders that Stage 9 instruments with verification protocols. Stage 8 does a rough split based on estimated overhead; Stage 9 injects the actual protocols and validates fit.
- **Stage 5 (7-Question Scaffolding)**: The Wall/Door/Room classifications from Stage 5 inform what the verification agent checks --- walls should be deterministic (script-verifiable), doors should be constrained, rooms get more latitude.
- **Stage 10 (Output)**: Receives the fully instrumented phases from Stage 9 and renders them into the output package (phase markdown files, build.sh, CLAUDE.md, BUILD_RULES.md). The verification protocols are already embedded in the phase text at this point.
- **The Sandbox System (from Stripe Minions pattern)**: Stage 9 operationalizes the sandbox concept --- the per-phase file whitelists from Stage 8 become enforceable through the git diff verification that Stage 9 defines.
- **The Deterministic/AI Hybrid (Blueprint pattern)**: Stage 9 defines which parts are deterministic (git diff, npm run build, npm run lint) and which are AI judgment (classifying violation severity, deciding whether a drift is acceptable). The principle: if you can do it with a script, don't let the AI do it.
- **Martin's Build Rules**: The verification preamble references the build rules that were baked in during Stage 5 and persist in CLAUDE.md/BUILD_RULES.md. The verifier checks compliance against these rules.
- **The Platform Picker (Output stage)**: The verification approach adapts based on the platform choice --- bash/CLI gets the dedicated verifier agent; manual/web gets the merged preamble approach. Same verification logic, different delivery wrapper.
