# Stage 10: OUTPUT GENERATOR -- Extraction Dossier

## Purpose

Stage 10 is the final stage in the PRD maker pipeline. It is pure serialization, not design. By this point, every decision has been made -- there are ZERO open questions. A builder agent can execute the output without asking anything. The stage renders all preceding work (Stages 1-9) into a deliverable package of files that the user downloads and runs.

Stated plainly: "Everything is defined. You're just rendering the format -- bash script, markdown PRD, downloadable doc. This is serialization, not design."

## The Output Package

The output package has a fixed structure:

```
OUTPUT PACKAGE:
+-- phases/
|   +-- phase-1.md    <-- Full text of Phase 1 (copy-paste ready)
|   +-- phase-2.md    <-- Full text of Phase 2
|   +-- phase-3.md    <-- Full text of Phase N
+-- build.sh          <-- Bash script that feeds phases to Claude Code CLI
+-- CLAUDE.md         <-- Permanent build rules (goes in repo root)
+-- BUILD_RULES.md    <-- Detailed reference (goes in repo root)
+-- README.md         <-- "Here's what was built and how to continue"
```

The user gets EVERYTHING. Multiple consumption paths are supported:
- Run `bash build.sh` and let it rip (fully automated CLI)
- Open `phase-1.md`, copy it, paste it into Claude Code web (manual)
- Read through the phases manually and build it themselves
- If the bash script crashes halfway through Phase 2, open `phase-2.md` and pick up where it left off

The bash script is a convenience wrapper around the text files. The text files are the source of truth.

## CLAUDE.md vs BUILD_RULES.md

### CLAUDE.md -- Quick-Reference Guardrails

CLAUDE.md is the file that **travels with the code forever**. It persists in the repo root after the build is complete. Every app the system builds gets a CLAUDE.md dropped into the root.

CLAUDE.md gets read by EVERY agent interaction -- even a quick "fix this button color" chat. It must be tight and fast.

Contents include distilled build rules:

```markdown
# Build Rules

## Architecture Principles
- Components do ONE thing. If it does two things, split it.
- State lives at the lowest possible level. Don't hoist unless required.
- No file over 300 lines. Split at 250.
- Imports flow downward. Never circular.
- UI components don't contain business logic.

## Modification Rules
- Before editing ANY file, read it completely first.
- Don't refactor code you didn't write unless explicitly asked.
- Don't add features that weren't requested.
- Don't "improve" working code while fixing a bug.
- Keep the existing patterns. Match the style that's there.

## Testing Protocol
- After any change: does it compile? does it render? do existing features still work?
- Don't delete tests. Don't skip tests. Don't modify tests to make them pass.

## File Structure
[Generated map of the app's architecture - what's where and why]
```

CLAUDE.md also acts as a **pointer** to BUILD_RULES.md for deeper protocols:

```markdown
## When Debugging
Follow the debugging protocol in BUILD_RULES.md Section 4.
Do NOT guess at fixes. Trace the actual error path first.

## When Adding Features
Follow the feature addition protocol in BUILD_RULES.md Section 7.
Read all connected files before modifying any of them.
```

Key insight: Even if the user NEVER comes back to the PRD maker platform, their app has permanent guardrails. Any agent opening the project in Cursor, Claude Code, Windsurf, or any other tool reads CLAUDE.md automatically and knows how to behave. The system's reputation is protected because the build rules travel WITH the code.

### BUILD_RULES.md -- Detailed Reference Playbook

BUILD_RULES.md is the full detailed version -- more comprehensive than CLAUDE.md but still organized. It is for a human developer or a more capable agent doing major feature work.

It contains sections derived from Martin's 13 modules (debugging protocol, feature addition protocol, code review checklist, refactoring approach, etc.). CLAUDE.md references these sections; BUILD_RULES.md has the detailed protocols.

**Why two files?** Different depth for different situations:
- CLAUDE.md = quick-reference guardrails for any interaction
- BUILD_RULES.md = detailed playbook for major feature work

## Phase File Format

Each `phase-N.md` file is **copy-paste ready** -- a complete, self-contained build document for one phase. Each phase file contains:

1. **Build Rules Preamble** (~8,000 tokens) -- Martin's rules distilled as the agent's operating manual for HOW to behave while building
2. **File Sandbox Declaration** (~2,000 tokens) -- Files agent CAN modify, CAN read, CANNOT touch
3. **Build Order with Pulse Points** (~3,000 tokens) -- Feature sequence with intermediate check triggers
4. **Seam Check Definitions** (~2,000 tokens) -- Integration verification points
5. **Objective and Feature Requirements** -- The actual implementation instructions
6. **Pattern References** -- Specific file:line references for existing patterns to follow
7. **Violation Handling Instructions** (~2,000 tokens) -- Decision tree for when rules are broken (LOW/MEDIUM/HIGH/CRITICAL severity)
8. **Full Checkpoint at End** (~5,000 tokens) -- Self-report, diff check, violation response, functional verification
9. **Gate Condition** -- "ALL FOUR STEPS MUST PASS BEFORE PHASE [N+1] BEGINS"

Total overhead per phase: ~25,000 tokens (fixed, templated).

## build.sh Structure

The bash script is a deterministic wrapper that chains phases together. It follows the Stripe "Minions" pattern: deterministic steps bookend the AI's creative work.

### Core Flow

```bash
#!/bin/bash
set -e  # Stop on ANY error

# === DETERMINISTIC: Setup ===
git checkout main
git pull origin main
git checkout -b phase-N-feature-name
SNAPSHOT=$(git rev-parse HEAD)

# === DETERMINISTIC: Verify clean state ===
npm run build || { echo "ABORT: Build broken BEFORE phase start"; exit 1; }
npm run lint || { echo "ABORT: Lint broken BEFORE phase start"; exit 1; }

# === AI AGENT: Creative work ===
# Agent runs with the phase PRD (sandbox rules embedded)

# === DETERMINISTIC: Post-build validation ===
npm run build || { echo "FAIL: Build broken"; git reset --hard $SNAPSHOT; exit 1; }
npm run lint || { echo "FAIL: Lint broken"; git reset --hard $SNAPSHOT; exit 1; }

# Check forbidden files weren't modified
FORBIDDEN_CHANGES=$(git diff --name-only $SNAPSHOT | grep -E \
  "^(src/lib/supabase\.ts|src/contexts/AuthContext|api/stripe)" || true)
if [ -n "$FORBIDDEN_CHANGES" ]; then
  echo "FAIL: Agent modified forbidden files:"
  echo "$FORBIDDEN_CHANGES"
  git reset --hard $SNAPSHOT
  exit 1
fi

# Check new API endpoints have auth
for f in $(git diff --name-only $SNAPSHOT -- api/); do
  if ! grep -q "Bearer" "$f" 2>/dev/null; then
    echo "FAIL: $f missing auth token verification"
    exit 1
  fi
done

# Check new migrations have RLS
for f in $(git diff --name-only $SNAPSHOT -- supabase/migrations/); do
  if ! grep -q "ENABLE ROW LEVEL SECURITY" "$f" 2>/dev/null; then
    echo "WARNING: $f may be missing RLS policies"
  fi
done

# === DETERMINISTIC: Commit ===
git add -A
git commit -m "Phase N: [description]"
```

### Phase Chaining

Safe chaining uses `&&` (not `;`):
```bash
phase1.sh && phase2.sh && phase3.sh
# If phase1 fails tests, phase2 never runs
```

### Auto-Retry on Rogue Agents

The build script includes retry logic:
```bash
run_phase_builder "phase-2.md"
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

Two strikes and it stops for human intervention. If TWO agents in a row fail the same phase, the problem is with the phase spec, not the agents.

## Inputs

Stage 10 receives the fully resolved output of all prior stages:
- **Stage 3**: Agent OS structured concept document
- **Stage 4**: Mechanism inventory with chosen approaches
- **Stage 5**: 7-Question scaffolding (wall/door/room blueprints for each mechanism)
- **Stage 6a/6b**: Approved page arrangement and mockups
- **Stage 7**: UI style selection applied to approved layout
- **Stage 8**: Phase sequencing with dependency mapping, file sandboxes, build order, and token math
- **Stage 9**: Protocol injection (pulse/seam/full checkpoints, violation handling, gate conditions, pattern verification rules)

Martin's 1,500-line build rules are also integrated -- not as a separate section but manifested in three places:
1. In the scaffolding answers (Stage 5) -- architecture reflects his principles
2. In the build order (Stage 8) -- sequence follows his patterns (core logic -> state -> UI -> integration)
3. As a preamble in the output (Stage 10) -- the "Build Rules" section agents read before executing any phase

## Process

Stage 10 performs the following:

1. **Render phase files**: Compile each phase's content into standalone `phase-N.md` files, each copy-paste ready with full preamble, sandbox rules, feature requirements, and verification protocols
2. **Generate build.sh**: Create the deterministic bash wrapper with platform-appropriate commands, snapshot/rollback logic, forbidden file detection, auth verification, and RLS checking
3. **Generate CLAUDE.md**: Distill Martin's rules into the permanent quick-reference guardrails file with architecture principles, modification rules, testing protocol, and file structure map
4. **Generate BUILD_RULES.md**: Compile the full detailed reference playbook including debugging protocol, feature addition protocol, and other relevant modules from Martin's 13-module knowledge base
5. **Generate README.md**: Document what was built and how to continue
6. **Platform picker rendering**: Adapt wrapper instructions based on the user's chosen platform

## Outputs

The complete output package as described above:
- `phases/phase-1.md` through `phases/phase-N.md` (copy-paste ready phase files)
- `build.sh` (deterministic bash wrapper for CLI automation)
- `CLAUDE.md` (quick-reference guardrails, lives in repo root forever)
- `BUILD_RULES.md` (detailed reference playbook, lives in repo root)
- `README.md` (documentation of what was built and continuation guide)

## Rules & Constraints

1. **Zero open questions**: By Stage 10, every ambiguity has been resolved. A builder agent executes without asking anything.
2. **Phase files are self-contained**: Each phase-N.md must work independently if copy-pasted into a fresh agent context.
3. **Bash script uses `&&` not `;`**: Ensures phases stop on failure rather than continuing blindly.
4. **CLAUDE.md is distilled, not exhaustive**: It is read by every agent interaction, so it must be tight and fast. BUILD_RULES.md handles depth.
5. **BUILD_RULES.md uses section references**: CLAUDE.md points to specific sections in BUILD_RULES.md so agents know where to look for deeper instructions.
6. **The preamble is the operating manual**: The phase PRD starts with a "Build Rules" section. The rest of the PRD is WHAT to build. The preamble is HOW to behave while building it.
7. **Martin's rules do NOT appear as a separate section**: They manifest through architecture decisions, build order, and the preamble -- never as a standalone "Martin's Rules" block.
8. **Output must support multiple consumption paths**: Automated (bash), manual (copy-paste), and hybrid (bash crashes, user picks up manually).

## Examples

### Martin's 13 Modules and How They Map

Martin's 13 modules are NOT 13 sequential steps. They are a knowledge base referenced by various stages:

| # | Module | Where It Maps |
|---|--------|--------------|
| 01 | Scaffold | Informs Stage 9 (phase PRD structure) |
| 02 | Auth | Informs Stage 4 when auth is a mechanism |
| 03 | Data Layer | Merged into phase PRDs for database work |
| 04 | UI Kit | Already handled by existing component libraries |
| 05 | CRUD Flow | Merged into phase PRDs for entity pages |
| 06 | Polish | Later phases or post-build |
| 07 | Style & Theming | Handled by UI style system (Stage 7) |
| 08 | Bug Fix Protocol | Baked into BUILD_RULES.md, referenced by CLAUDE.md |
| 09 | Feature Add | Core pattern for every phase PRD |
| 10 | Debug Protocol | Baked into BUILD_RULES.md, referenced by CLAUDE.md |
| 11 | Clean Room | PRD maker library (for reverse-engineering existing apps) |
| 12 | PRD Generator | Merged with the PRD maker system itself |
| 13 | Testing Protocol | Merged with MIT protocol + alignment checks in every phase |

Modules 08, 10, and 13 get baked into every phase as safety/quality layers via BUILD_RULES.md. Modules 03, 05, 09 get merged into phase PRDs as "how to build" patterns.

### Platform Picker Output

When someone picks their platform at the end of Stage 10, the wrapper instructions adapt:

| Platform | Execution Method | Automation Level |
|----------|-----------------|-----------------|
| Claude Code CLI | bash build.sh (auto-invokes agent + checks) | Fully automatic, zero manual steps |
| Claude Code Web | Copy-paste phase-N.md per phase | Manual paste, 2-3 min between phases |
| Codex CLI | Platform-specific CLI commands | Fully automatic with adapted syntax |
| Gemini CLI | Platform-specific CLI commands | Fully automatic with adapted syntax |
| Cursor / Windsurf | Has terminal access, semi-automatic | Semi-automatic |
| Bolt / Lovable | No terminal access, manual export | Manual export -> GitHub push -> checks |
| Generic | Copy-paste anywhere | Fully manual |

The phase PRD content stays the same across platforms. Only the execution command and wrapper instructions change.

### Tier 1 vs Tier 2 Bash Wrapper Differences

**Tier 1 (Launchpad -- subscription, user gets the PRD):**
- Basic bash wrapper: snapshot + lint + build chain
- `phase1.sh && phase2.sh && phase3.sh` where each pastes the prompt, runs lint, runs build, continues
- No forbidden file detection
- No auth verification on new endpoints
- No RLS checking on new migrations
- No auto-rollback on violation
- Purpose: Keeps phases moving automatically (critical for completion rates) without exposing the intelligent verification layer

**Tier 2 (Full Build -- internal, user never sees PRD):**
- Smart bash wrapper with full verification
- Forbidden file detection via git diff
- Auth pattern verification on new API endpoints
- RLS policy verification on new migrations
- Automatic rollback on any violation
- Separate verification agent (Agent B) with independent context
- Auto-retry logic (two strikes then human review)

## Connections to Other Stages

- **Stage 8 (Phase Sequencing)**: Provides the phase structure, dependency mapping, sandbox file lists, and build order. Stage 10 renders these into the phase-N.md files and build.sh.
- **Stage 9 (Protocol Injection)**: Provides the pulse/seam/full checkpoint protocols, violation handling decision trees, and gate conditions. Stage 10 embeds these into each phase file at the correct positions.
- **Stages 8 + 9 merge in the output**: The user never sees "here's your phase" and "here's your protocols" separately. They see one integrated phase block with everything in it.
- **Stage 5 (7-Question Scaffolding)**: The wall/door/room classifications from Stage 5 inform the preamble and build rules in the output, ensuring agents know which parts are deterministic and which allow creative freedom.
- **Stage 7 (UI Style)**: The approved style selection feeds into the phase PRDs as explicit style references the builder agent follows.
- **Stage 3 (Agent OS)**: The structured concept document from Stage 3 provides the context section that appears in the preamble of each phase, keeping the agent centered on the original vision.
- **Martin's 1,500-line build prompt**: Distilled and distributed across CLAUDE.md (quick reference), BUILD_RULES.md (full protocols), and phase preambles (operating manual). The original prompt was Firebase/Gemini-specific; the output adapts it to the user's chosen stack (Supabase, Claude Code, etc.).
- **The mentor's build prompt integration**: The 1,500-line prompt from Martin (a 15-year software veteran) was originally for Firebase + Gemini. Another Opus 4.6 agent broke it into 13 separate module prompts. These 13 modules serve as a knowledge base -- not a sequential process -- that Stage 10 references when generating CLAUDE.md and BUILD_RULES.md content.
