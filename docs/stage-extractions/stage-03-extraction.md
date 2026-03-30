# Stage 3: AGENT OS STRUCTURING -- Extraction Dossier

## Purpose

Stage 3 takes the complete raw information produced by Stage 1 (Idea Capture) and Stage 2 (Gap Analysis) combined and FORMATS it into organized sections. It transforms messy human language into a structured concept document. The explicit analogy used is: "raw clay into a shaped block. Not the sculpture yet."

This stage is the normalization step. It does NOT break the idea into mechanisms (that is Stage 4). It does NOT evaluate approaches or apply the 7-question scaffolding. It strictly organizes and structures the gap-filled concept so downstream stages can process it cleanly.

The stage is derived from a framework called "AgentOS" (also written "Agent OS"), created by the user's mentor -- a 15-year software veteran. The mentor reported that when he started putting ideas into the Agent OS framework, his builds went from a day and a half down to half a day, with significantly fewer bugs. The framework serves as a "guardrailing kind of system" -- in essence, a way of adding walls and doors that helps the agent center itself on the concept and context if it starts to drift during building.

## Inputs

- **Raw concept** from Stage 1 (Idea Capture): The user's rant, their idea, their 3-4 sentences describing what they want to build. Unstructured, stream-of-consciousness, potentially rambling.
- **Gap-filled information** from Stage 2 (Gap Analysis): Answers to the intelligent gap-filling questions that identified holes in the original idea. These are specific answers about things the user failed to mention -- e.g., payments, user roles, edge cases.
- The combined raw material from Stages 1+2 represents "complete raw information" -- everything the system knows about the user's idea, but in disorganized form.

## Process

The Agent OS structuring process takes the combined raw input and formats it through the mentor's framework. The framework addresses the idea from multiple angles:

### What the Agent OS Framework Covers

As described explicitly in the source (line 2696-2718, line 2709-2714):

The mentor's framework processes these questions:
- **What's the product?** -- Name and identify the core thing being built
- **What's it solving?** -- The problem or pain point
- **Market feasibility** -- Is this viable in the marketplace
- **Who's it for?** -- Target users/customers
- **What exists already?** -- Competitive landscape

The output is described as a "Structured concept document" -- specifically "the 'what' and 'why.' No 'how' yet. That's important."

### What the Structuring Does

From line 5831-5833:

> "Now you have complete raw information (Stage 1 + 2 combined). This is where you FORMAT it -- context, market positioning, feasibility assessment. You're turning messy human language into organized sections. But you're NOT breaking it into mechanisms yet -- you're just making it readable and structured."

The structuring resolves ambiguity. From line 5837:

> "You can't do this [mechanism extraction] before Stage 3 because unstructured ideas have overlapping concepts that look like separate things but aren't (or vice versa). The structuring step resolves ambiguity so extraction is clean."

### The Agent OS "3-Layer Format"

Referenced at line 5342:

> "Agent OS 3-layer format -> phase sequencing -> dependency graph -> Martin's module knowledge baked in -> protocol checkpoints injected"

The "3-layer format" is how the Agent OS structures its output. While the exact three layers are not explicitly enumerated in a single definition in the source, they correspond to the three perspectives the framework applies: context/concept, market/user, and technical feasibility. This format becomes the input that Stage 4 (Mechanism Extraction) operates on.

### How It Functions in the Pipeline

From line 3342:

> "LAYER 3: AGENT OS (structures it into context, market, feasibility)"

This is positioned as Layer 3 in the unified architecture, taking the output of Layer 1 (raw rant) and Layer 2 (gap analysis) and producing the structured intermediate format.

The Agent OS structuring also serves a persistent role beyond Stage 3. From line 2696:

> "while the agents building it if the agent ever gets you know starts to drift a little bit it has a very clear understand it has a way to go back and like center itself in the concept and the context and everything can help center it"

This means the structured document from Stage 3 serves as an anchor throughout the entire build process -- agents can refer back to it when they lose direction.

### Relationship to Planning Mode

From line 726 (user speaking):

> "he uses Claude code, I think his daily driver, and that was before planning mode was in Claude code, so I remember him... he was saying that he didn't use agent OS as much anymore because of planning mode... Planning mode basically kind of took over the agent OS system."

This indicates that Claude Code's built-in planning mode serves a similar function to the Agent OS framework -- both structure thinking before building. However, in this pipeline, the Agent OS structuring is formalized as an explicit stage rather than relying on an IDE feature.

## Outputs

The output of Stage 3 is a **Structured Concept Document** containing:

1. **Concept & Context** -- What the product is, framed clearly (referenced as "Section 1" in the PRD maker flow at line 2814)
2. **Target User & Market** -- Who it is for and market positioning (referenced as "Section 2" at line 2815)
3. **Feasibility Assessment** -- Market viability, competitive landscape
4. **Problem Statement** -- What the product solves, stated clearly

The output is explicitly described as containing "the what and why" but NOT "the how" -- that distinction is critical. The structured concept document tells you what is being built and why, but the mechanical details of how each piece works are deferred to Stages 4 and 5.

The structured document must be:
- Readable and organized (not stream-of-consciousness)
- Free of ambiguity (overlapping concepts resolved)
- Complete (all gap-filled information incorporated)
- Mechanism-neutral (not yet broken into discrete parts)

## Rules & Constraints

1. **No mechanism extraction in this stage.** Stage 3 structures; Stage 4 extracts. Attempting to identify discrete mechanisms during structuring leads to premature decomposition before ambiguities are resolved.

2. **No "how" -- only "what" and "why."** The structured document describes what the product does and why it matters. Technical implementation is deferred.

3. **Must resolve ambiguity.** Unstructured ideas contain overlapping concepts that look like separate things but are not (or vice versa). Stage 3 must clarify these before Stage 4 can cleanly extract mechanisms.

4. **The structured output serves as a persistent anchor.** The document produced here is not consumed and discarded. It remains available throughout the entire build so agents can re-center themselves when they drift.

5. **Must incorporate ALL gap-filled information.** Everything from Stage 2 must be woven into the structured format. If a gap was identified and answered, it must appear in the structured output.

6. **Format must be standardized.** The "Agent OS format" is a consistent structure that the rest of the pipeline expects. Downstream stages (particularly Stage 4: Mechanism Extraction) depend on receiving input in this standardized format.

7. **The structuring reduces the information but does not add to it.** Stage 3 organizes and formats what exists from Stages 1+2. It does not generate new ideas, features, or assumptions. It is a normalization step, not a creative step.

## Examples

### Example: Early 9-Stage Pipeline (before final 10-stage refinement)

From line 2707-2718, Stage 2 was called "CONTEXT FRAMING (AgentOS)" in an early version of the pipeline:

```
STAGE 2: CONTEXT FRAMING (AgentOS)
  Input: Raw concept
  Process: Your mentor's framework
    - What's the product?
    - What's it solving?
    - Market feasibility
    - Who's it for?
    - What exists already?
  Output: Structured concept document

  This is the "what" and "why."
  No "how" yet. That's important.
```

Note: In this earlier version, it was numbered as Stage 2 because the gap analysis was not yet separated out as its own stage. In the final 10-stage pipeline, the gap analysis became Stage 2 and Agent OS structuring became Stage 3.

### Example: How the PRD Maker Flow References Stage 3 Output

From line 2813-2815, the PRD maker flow shows what Stage 3 produces as sections:

```
PRD MAKER FLOW (updated):
  Section 1: Concept & Context (you have this -- AgentOS)
  Section 2: Target User & Market (you have this)
  Section 3: Mechanism Inventory (you have this -- extraction)
  Section 4: Mechanism Decisions (you have this -- 10-step eval)
```

Sections 1 and 2 are the direct output of Stage 3. Sections 3 and 4 are produced by subsequent stages.

### Example: The Funnel Metaphor

From line 5865-5878, the entire pipeline is described as a funnel, and Stage 3's position in it is clear:

```
WIDE    -> Capture everything
         -> Fill gaps in everything
          -> Structure everything         <-- STAGE 3
           -> Break into parts
            -> Define each part precisely
             -> Arrange parts visually
              -> Style them
               -> Sequence the build
                -> Tag quality checks
NARROW   -> Output the document
```

"Each stage REDUCES ambiguity. By Stage 10, there are ZERO open questions."

### Example: Mentor's Experience With Agent OS

From line 2696:

The mentor -- a 15-year veteran -- reported that adding the Agent OS framework to his process cut build time from a day and a half to half a day, with fewer bugs. The framework provides guardrailing that keeps agents centered on the concept and context.

## Edge Cases & Debates

### Agent OS vs. Planning Mode

The user's mentor indicated he stopped using Agent OS as much once Claude Code got planning mode, suggesting overlap in function. The pipeline retains Agent OS structuring as an explicit stage because: (a) it produces a persistent document that agents reference throughout the build, and (b) planning mode is tool-specific and not available in all builders (Bolt, Lovable, etc.).

### Where Does Agent OS Structuring End and Mechanism Extraction Begin?

The boundary is explicitly defined: Stage 3 produces a shaped block, not a sculpture. If you find yourself identifying discrete moving parts (auth system, payment flow, notification engine), you have crossed into Stage 4. Stage 3 should produce a document where someone reading it understands the full concept but has not yet decomposed it into buildable units.

### Was Stage 3 Originally a Separate Stage?

In the earliest version of the pipeline (the 9-stage version at line 2701-2792), what became Stage 3 was called "CONTEXT FRAMING (AgentOS)" and was numbered as Stage 2. Gap Analysis did not have its own stage -- it was implicit in the raw capture. When the pipeline was refined to 10 stages (line 5777-5786), Gap Analysis was separated out as Stage 2, pushing Agent OS Structuring to Stage 3.

### The "Adding Context" Description

The user described Agent OS as "just adding context to it" (line 2696), framing it as a context-enrichment step rather than a transformation. This is consistent with its role: it does not change the idea, it surrounds the idea with structured context (market, users, feasibility, problem framing) so that downstream stages have a complete picture to work from.

### Role as a Drift Anchor

One of the less obvious but critical functions of Stage 3's output is serving as a drift anchor throughout the entire build process. When a building agent starts to wander from the original concept (as happened in the session where an agent built a "fake toy engine" instead of the intended feature), the Stage 3 document provides a reference point to re-center. This is not a one-time-use document -- it persists as long as the app is being built or modified.

## Connections to Other Stages

### Stage 2 (Gap Analysis) -> Stage 3

Stage 3 receives the gap-filled raw information from Stage 2. The gap analysis ensures that the raw input is complete; Stage 3 then formats that complete input into structured sections. Without Stage 2, Stage 3 would be structuring incomplete information, leading to gaps that only surface during building.

### Stage 3 -> Stage 4 (Mechanism Extraction)

Stage 4 depends on Stage 3's structured output to cleanly identify discrete mechanisms. From line 5837: "You can't do this [mechanism extraction] before Stage 3 because unstructured ideas have overlapping concepts that look like separate things but aren't (or vice versa). The structuring step resolves ambiguity so extraction is clean."

### Stage 3 -> Stage 5 (7-Question Scaffolding)

While not directly adjacent, Stage 3's structured concept informs the context for the 7-question scaffolding. When the scaffolding asks "what must be true before this step can start?" or "what are all possible outcomes?", the answers draw from the concept and context established in Stage 3.

### Stage 3 -> Stage 7 (Phase Sequencing)

From line 6099: "Take the full Agent OS document from Stage 3-5" -- the phase sequencing stage uses the Agent OS document (combined with mechanism and scaffolding outputs) to calculate how to split the build into phases.

### Stage 3 -> Build Process (Persistent Anchor)

The Stage 3 output travels with the project throughout the build. It appears in the final output package as part of the context that building agents reference. If an agent drifts during Phase 3 of a 4-phase build, the Stage 3 document is what it uses to re-center on the original concept.

### Stage 3 -> Stage 10 (Output)

The output stage renders the final PRD document. Sections 1 and 2 of the PRD (Concept & Context, Target User & Market) are directly sourced from Stage 3's structured output.

### Stage 3 and Martin's Build Rules

From line 5901-5907: Martin's 1,500-line build rules are described as "the LENS through which every scaffolding answer gets written" in Stage 5. However, Stage 3 also draws on Martin's knowledge indirectly -- the Agent OS format itself was derived from the mentor's (Martin's) framework, making Stage 3 the first place where Martin's systematic thinking manifests in the pipeline.

### Relationship to the Unified Architecture

In the unified architecture (line 3338-3371), Stage 3 corresponds to:

```
LAYER 3: AGENT OS (structures it into context, market, feasibility)
```

It sits between Layer 2 (Gap Analysis) and Layer 4 (Mechanism Extraction + 10-Step Evaluation), serving as the normalization bridge between raw human input and structured machine-processable specifications.
