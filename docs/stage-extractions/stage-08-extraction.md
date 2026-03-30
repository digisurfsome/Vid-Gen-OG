# Stage 8: PROTOCOL INJECTION — Extraction Dossier

## Purpose

Stage 8 takes the phases defined in Stage 7 (with their file sandboxes and build orders) and injects testing/verification checkpoints INTO them. It doesn't just "tag" protocols onto phases — it REWRITES the phases to embed the protocols inline. The result is a phase that is a self-contained, self-verifying build unit.

Source: "This is the key insight: Stage 9 doesn't just 'tag' protocols onto phases. It REWRITES the phases to embed the protocols inline."

Note: In the source material, this functionality is sometimes attributed to Stage 9 (in the 10-stage numbering with separate wireframe/style stages) and sometimes to Stage 8 (in the consolidated numbering). The functionality is the same regardless of numbering.

## The Seven Enforcement Mechanisms (Where They Live)

The source explicitly maps seven enforcement mechanisms:

| Letter | Mechanism | Where It Lives |
|--------|-----------|---------------|
| A | Pulse checks (every 3 files) | Stage 8 (Protocol Injection) |
| B | Seam checks (at connection points) | Stage 8 (Protocol Injection) |
| C | Full checkpoints (end of phase) | Stage 8 (Protocol Injection) |
| D | File sandboxing | Stage 7 (Phase Sequencing) |
| E | Build order within phase | Stage 7 (Phase Sequencing) |
| F | Post-build pattern verification | Stage 8 (Protocol Injection) |
| G | Martin's 1,500 lines | Stage 5 (as the lens) |

## The Three Protocol Tiers

### PULSE Checks (Lightweight — Every 3 Files)
Quick verification after each file is created:
- Does the file exist?
- Does it export expected functions?
- Runs after every file in the build order
- Cycle completes every 3 files

### SEAM Checks (Medium — At Connection Points)
Integration verification at points where mechanisms connect:
- Does component A import from component B correctly?
- Do routes point to actual page components?
- Are the "doors" between rooms properly connected?
- Tag-triggered: placed at specific points where two mechanisms interface

### FULL Checkpoint (Comprehensive — End of Phase)
Complete verification at phase boundaries. Includes:

**Pattern Verification (F):**
- List every file created or modified
- Compare against FILES ALLOWED list
- FLAG any file touched that wasn't in the sandbox
- FLAG any file in BUILD ORDER that wasn't completed
- FLAG any unexpected imports or dependencies

**Functional Check:**
- Does the app compile?
- Do the pages render?
- Can you navigate to expected routes?

**Gate:** Pass/fail. If fail, fix before next phase starts.

## Violation Decision Tree

Source: "Three outcomes after pattern verification:"

```
VIOLATION DETECTED
├─ ✅ CLEAN: Agent only touched sanctioned files → proceed to next phase
├─ ⚠️ MINOR DRIFT: Agent touched 1-2 extra files that are reasonable
│   (like a shared types file) → flag it, human reviews, probably fine
├─ 🚫 MAJOR DRIFT: Agent modified files from a different phase's domain
│   → STOP. Either revert or inspect every change manually.
```

More detailed decision tree from the synthesis:
```
VIOLATION DETECTED
├─ LOW (touched shared types/config): Log it, proceed
├─ MEDIUM (modified another phase's file):
│   ├─ Additive change: Log, proceed with caution
│   ├─ Destructive change: REVERT that file, re-run
│   └─ Unclear: Flag for human review
├─ HIGH (deleted files, changed core config): REVERT ENTIRE PHASE
└─ CRITICAL (modified .env, CLAUDE.md, build config): FULL STOP
```

## Git Diff Verification

Source: "You're not preventing bad behavior — you're DETECTING it immediately."

The process:
1. **BEFORE** the phase runs: File sandbox is DECLARED (allowed, read-only, forbidden)
2. **DURING** the phase: Agent builds (can't physically prevent it from touching other files)
3. **AFTER** the phase: Run a diff — what files were actually created/modified?
4. **COMPARE** actual changes against sandbox list
5. **DECIDE** based on violation severity

"Because you detect it at the phase boundary (not at the end of the entire build), the blast radius is small. One phase worth of work, not the whole project."

## Example: Protocol-Injected Phase

```
Phase 1: Auth System
├── FILES ALLOWED: [list]
├── BUILD ORDER:
│   1. Create src/lib/auth.ts
│      ← PULSE after this file (does it exist? exports expected functions?)
│   2. Create src/contexts/AuthContext.tsx
│      ← PULSE after this file
│   3. Create src/pages/SignIn.tsx
│      ← PULSE after this file (3 files done = pulse cycle complete)
│      ← SEAM CHECK: does SignIn.tsx import from AuthContext?
│        Does AuthContext import from auth.ts? Are the doors connected?
│   4. Create src/pages/SignUp.tsx
│      ← PULSE after this file
│   5. Wire routes in App.tsx
│      ← PULSE after this file
│      ← SEAM CHECK: do routes point to actual page components?
│
├── END OF PHASE: FULL CHECKPOINT
│   ├── PATTERN VERIFICATION:
│   │   ├── List every file created or modified
│   │   ├── Compare against FILES ALLOWED list
│   │   ├── FLAG any file touched that wasn't in the sandbox
│   │   ├── FLAG any file in BUILD ORDER that wasn't completed
│   │   └── FLAG any unexpected imports or dependencies
│   ├── FUNCTIONAL CHECK:
│   │   ├── Does the app compile?
│   │   ├── Do the auth pages render?
│   │   └── Can you navigate to /sign-in and /sign-up?
│   └── GATE: Pass/fail. If fail, fix before Phase 2 starts.
```

## Inputs

- Phases from Stage 7 with file sandboxes and build orders already defined
- The pulse/seam/full protocol templates

## Process

1. Take each phase from Stage 7
2. Insert PULSE checkpoints after each file in the build order
3. Insert SEAM checks at connection points within the phase (where mechanisms interface)
4. Insert FULL checkpoint with pattern verification at the phase boundary
5. Add violation handling instructions (what to do at each severity level)
6. Add gate condition (pass/fail criteria before next phase can start)
7. Validate the overhead fits within budget (~25,000 tokens per phase)

## Outputs

Fully protocol-injected phases where checkpoints are EMBEDDED inline in the build order, not bolted on as a separate step.

## Per-Phase Overhead Budget

```
PER-PHASE OVERHEAD (fixed costs):
├── Build rules preamble:          ~8,000 tokens
├── File sandbox declaration:      ~2,000 tokens
├── Build order with pulse points: ~3,000 tokens
├── Seam check definitions:        ~2,000 tokens
├── Full checkpoint at end:        ~5,000 tokens
├── Pattern verification prompt:   ~3,000 tokens
├── Violation handling instructions:~2,000 tokens
└── TOTAL OVERHEAD PER PHASE:      ~25,000 tokens
```

## Tier 1 vs Tier 2 Protocol Differences

From the synthesis (component-by-component tier analysis):

| Protocol | Tier 2 (Full) | Tier 1 (Stripped) |
|----------|---------------|-------------------|
| Pulse Check | Full | "Run lint && build" |
| Seam Check | Tag-triggered integration testing | Generic integration advice |
| Full Protocol | 3-investigation method | Basic QA checklist |
| Alignment Protocol | All 10 checks | 5 obvious checks |
| GPS Tracking (git diff) | Auto + rollback | Manual review suggestion |

## Rules & Constraints

1. Protocols are EMBEDDED inline, not separate documents
2. Pulse checks happen after EVERY file (not just end of phase)
3. Seam checks go at CONNECTION POINTS between mechanisms
4. Full checkpoint is a GATE — next phase cannot start until it passes
5. Pattern verification uses git diff, not agent self-reporting
6. Overhead is predictable (~25K tokens) because it's templated
7. Stages 7 and 8 are "tightly coupled" but separate: 7 = structure, 8 = enforcement

## Connections to Other Stages

**Receives from Stage 7:** Phases with file sandboxes and build orders already defined. Stage 8 adds the enforcement layer on top of Stage 7's structure.

**Feeds into Stage 9 (Verification Agent Setup):** Stage 9 sets up the independent checker that audits whether the protocols from Stage 8 were actually followed. Stage 8 defines WHAT to check; Stage 9 defines WHO checks it and what happens when violations are found.

**Feeds into Stage 10 (Output):** The protocol-injected phases are what get rendered into the final phase files. In the output, Stages 7 and 8 merge into single integrated phase blocks.

**Relationship between 7 and 8:** "They're separate because 8 is about STRUCTURE (what goes where, in what order) and 9 is about ENFORCEMENT (how do we verify it was followed). But in the final output document, they merge into a single phase spec."

## Edge Cases & Debates

1. **Can't physically sandbox:** "We can't physically PREVENT it from touching other files (that would require actual OS-level sandboxing which is overkill). But we've told it clearly: these files only." Detection, not prevention.

2. **When to do the math:** The user asked if you can split phases before knowing the protocol overhead. Answer: Yes, because the overhead is templated and predictable (~25K tokens). You calculate with it in advance: 350,000 target - 25,000 overhead = 325,000 available for build content.

3. **Stage 8 and 9 relationship:** "Stages 8 and 9 are tightly coupled. Practically, what happens is: Stage 8 does rough split, Stage 9 injects protocols, quick validation confirms fit. It's a single forward pass."
