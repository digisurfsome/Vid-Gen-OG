#!/bin/bash
# =============================================================================
# PRD MAKER — Stage Extraction Script
# Reads master-source.md (7,084 lines) and extracts information about each
# of the 10 pipeline stages into individual files.
#
# Usage: bash docs/extract-stages.sh
# Output: docs/stage-extractions/stage-XX-extraction.md (10 files)
# =============================================================================

set -e

SOURCE="docs/master-source.md"
SYNTHESIS_CONTEXT="docs/synthesis-context.md"
OUTPUT_DIR="docs/stage-extractions"
SKILLS_DIR="docs/skills"

# Verify source file exists
if [ ! -f "$SOURCE" ]; then
    echo "ERROR: $SOURCE not found. Place your master source file there first."
    exit 1
fi

mkdir -p "$OUTPUT_DIR" "$SKILLS_DIR"

echo "============================================"
echo "PRD MAKER — Stage Extraction Pipeline"
echo "Source: $SOURCE ($(wc -l < "$SOURCE") lines)"
echo "Output: $OUTPUT_DIR/"
echo "============================================"

# ---------------------------------------------------------------------------
# SYNTHESIS CONTEXT — shared across all extractions
# This gives each agent the big picture so it knows how its stage fits
# ---------------------------------------------------------------------------
cat > "$SYNTHESIS_CONTEXT" << 'SYNTHESIS_EOF'
# PRD Maker Pipeline — 10 Stage Overview

This is a 10-stage pipeline that takes a raw app idea and produces a complete,
phased build package. Each stage has specific inputs and outputs.

Stage 1:  IDEA CAPTURE — Raw rant/description → structured concept document
Stage 2:  GAP ANALYSIS — Structured concept → filled gaps via intelligent questions
Stage 3:  AGENT OS STRUCTURING — Raw organized info → standardized format for pipeline
Stage 4:  MECHANISM EXTRACTION — Structured app description → discrete moving parts/mechanisms
Stage 5:  7-QUESTION SCAFFOLDING — Mechanisms → Wall/Door/Room classification using 7 questions
Stage 6:  LAYOUT + MOCKUPS + STYLE — Classified mechanisms → visual structure (pages, navigation, style)
Stage 7:  PHASE SEQUENCING — Complete spec → math-based phase split with file sandboxes and build order
Stage 8:  PROTOCOL INJECTION — Phases → checkpoints (pulse/seam/full) and violation handling
Stage 9:  VERIFICATION AGENT SETUP — Protocols → independent checker with decision authority
Stage 10: OUTPUT GENERATOR — Everything → phase files + bash script + CLAUDE.md + BUILD_RULES.md

The core IP is the Wall/Door/Room classification system:
- WALL: Deterministic, must happen exactly one way, enforced by code
- DOOR: Constrained choice, AI can operate but within strict boundaries
- ROOM: Creative freedom, AI can be flexible

The 7 questions applied to every mechanism:
1. What happens here?
2. Is there only one way to do this, or can it vary?
3. What must be true before this step can start?
4. What are all possible outcomes?
5. For each outcome, where do you go next?
6. How do you verify this step was done correctly?
7. Can this step be skipped?
SYNTHESIS_EOF

# ---------------------------------------------------------------------------
# EXTRACTION FUNCTION
# ---------------------------------------------------------------------------
run_extraction() {
    local STAGE_NUM="$1"
    local STAGE_NAME="$2"
    local STAGE_DESCRIPTION="$3"
    local OUTPUT_FILE="$OUTPUT_DIR/stage-$(printf '%02d' $STAGE_NUM)-extraction.md"

    echo ""
    echo ">>> Extracting Stage $STAGE_NUM: $STAGE_NAME..."

    claude -p "$(cat << PROMPT_EOF
You are extracting information about ONE specific stage of a 10-stage PRD maker pipeline.

CONTEXT (read this first for big picture):
$(cat "$SYNTHESIS_CONTEXT")

YOUR TASK: Read the source document below (7,084 lines of conversation). Extract EVERY piece of information related to:

**Stage $STAGE_NUM: $STAGE_NAME**
$STAGE_DESCRIPTION

EXTRACTION RULES:
1. Include: definitions, examples, diagrams, rules, edge cases, corrections, debates about how this stage should work
2. Include any code snippets, data structures, or format specifications related to this stage
3. Include any corrections where the user said "no that's wrong, it's actually like this"
4. When the user and agent disagree, note BOTH positions and which was the final resolution
5. Preserve specifics — exact questions, exact formats, exact field names, exact rules
6. If information about this stage appears in multiple places, include ALL instances
7. Note where this stage connects to adjacent stages (what it receives, what it outputs)
8. DO NOT include business model discussion (pricing tiers, marketing, monetization) unless it directly affects the MECHANISM of this stage
9. DO NOT summarize. Preserve the detail. More is better than less.
10. Organize the extracted information under clear headings

OUTPUT FORMAT:
# Stage $STAGE_NUM: $STAGE_NAME — Extraction Dossier

## Purpose
[What this stage does in one paragraph]

## Inputs
[What this stage receives from the previous stage]

## Process
[Step-by-step: what happens during this stage, with all detail preserved]

## Outputs
[What this stage produces for the next stage]

## Rules & Constraints
[Every rule, constraint, or requirement mentioned for this stage]

## Examples
[Any examples given in the source material]

## Edge Cases & Debates
[Any edge cases discussed, disagreements, or unresolved questions]

## Connections to Other Stages
[How this stage relates to what comes before and after]

SOURCE DOCUMENT:
$(cat "$SOURCE")
PROMPT_EOF
)" > "$OUTPUT_FILE" 2>/dev/null

    if [ $? -eq 0 ] && [ -s "$OUTPUT_FILE" ]; then
        echo "    ✓ Stage $STAGE_NUM complete ($(wc -l < "$OUTPUT_FILE") lines)"
    else
        echo "    ✗ Stage $STAGE_NUM FAILED — check $OUTPUT_FILE"
    fi
}

# ---------------------------------------------------------------------------
# RUN ALL 10 EXTRACTIONS
# ---------------------------------------------------------------------------

echo ""
echo "Starting extractions..."
echo "(Each takes 2-5 minutes. Total estimated: 20-50 minutes)"
echo ""

# Stage 1
run_extraction 1 "IDEA CAPTURE" \
"The first stage of the pipeline. Takes raw, unstructured input (a 'rant' — voice transcript, scattered notes, stream-of-consciousness description of an app idea) and produces a structured concept document. Look for: how the intake works, what format the output takes, any multi-step intake process, how contradictions are handled, what gets captured vs what gets deferred to later stages. There was discussion of a three-stage intake sub-process for this step."

# Stage 2
run_extraction 2 "GAP ANALYSIS" \
"Takes the structured concept from Stage 1 and identifies gaps — missing information, unanswered questions, ambiguities. Generates intelligent questions to fill those gaps. Look for: what kinds of gaps it looks for, how questions are generated, how answers get integrated back, what 'complete enough' means to move to Stage 3."

# Stage 3
run_extraction 3 "AGENT OS STRUCTURING" \
"Takes the gap-filled concept and restructures it into a standardized format that the rest of the pipeline can process. This is the normalization step. Look for: what the standardized format looks like, what fields are required, how unstructured information gets mapped to structured fields."

# Stage 4
run_extraction 4 "MECHANISM EXTRACTION" \
"Breaks the structured app description into discrete moving parts — individual mechanisms, features, components, interactions. Each mechanism is a unit that will be classified in Stage 5. Look for: what counts as a 'mechanism', how they're identified, what granularity level, how they're listed and described."

# Stage 5
run_extraction 5 "7-QUESTION SCAFFOLDING (Wall/Door/Room Classification)" \
"THE CORE IP. Takes each mechanism from Stage 4 and runs it through the 7-question framework to classify it as WALL (deterministic), DOOR (constrained), or ROOM (creative freedom). This is the most important stage. Look for: the exact 7 questions, how classification works, examples of Wall vs Door vs Room, the meta programs example, the house analogy, finite state machines discussion, decision trees, any code examples showing deterministic scaffolding, the Stripe Minions connection."

# Stage 6
run_extraction 6 "LAYOUT + MOCKUPS + STYLE" \
"Takes the classified mechanisms and arranges them into visual structure: page layouts, navigation patterns, UI mockups, and style selection. Includes arrangement selection (sidebar, top-nav, tabs), page mockups that user approves, and style selection from curated options. Look for: the 3 layout options, how mockups are presented, the style selection process (12 predefined styles), the Style Set system, screenshot-to-theme engine, how style integrates with the pipeline."

# Stage 7
run_extraction 7 "PHASE SEQUENCING" \
"Takes the complete spec and splits it into build phases using math-based calculations. Each phase gets a file sandbox (allowed/read-only/forbidden files) and build order. Look for: the token budget math (500K tokens, 35% per phase, 25K overhead), how phases are split, file sandbox definitions, build order within phases, the phase math calculations."

# Stage 8
run_extraction 8 "PROTOCOL INJECTION" \
"Injects testing and verification checkpoints into each phase. Three tiers: pulse checks (quick), seam checks (integration), full protocol (comprehensive). Also includes violation handling and git diff verification. Look for: pulse/seam/full definitions, when each triggers, the violation decision tree (LOW/MEDIUM/HIGH/CRITICAL), git diff verification, how protocols are embedded inline within phases."

# Stage 9
run_extraction 9 "VERIFICATION AGENT SETUP" \
"Sets up an independent verification agent that audits the builder agent's work. The checker is NOT the same agent as the builder. Look for: how the verifier works, fresh context vs shared context, the bash/CLI automated approach vs manual/web approach, 2-strike retry then human review, how Phase N+1 agent checks Phase N's output."

# Stage 10
run_extraction 10 "OUTPUT GENERATOR" \
"Produces the final deliverable package. Look for: what files are generated (phase-1.md through phase-N.md, build.sh, CLAUDE.md, BUILD_RULES.md, README.md), the format of each file, how the bash script works, what goes in CLAUDE.md vs BUILD_RULES.md, the distinction between quick-reference guardrails and deep playbook."

echo ""
echo "============================================"
echo "EXTRACTION COMPLETE"
echo "============================================"
echo ""
echo "Output files:"
ls -la "$OUTPUT_DIR"/ 2>/dev/null
echo ""
echo "Next step: Run docs/build-skills.sh to convert extractions into SKILL.md files"
