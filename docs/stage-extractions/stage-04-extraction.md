# Stage 4: MECHANISM EXTRACTION -- Extraction Dossier

## Purpose

Stage 4 breaks a structured app description into its discrete moving parts -- individual mechanisms, features, components, and interactions. Each mechanism is a self-contained unit that will be classified in Stage 5 (7-Question Scaffolding) as walls, doors, and rooms. The purpose is to identify every "moving part" so that nothing is left ambiguous or unaccounted for before the deterministic scaffolding is applied.

Without mechanism extraction, the PRD describes WHAT the app does but not the mechanical HOW. The build drifts. The AI improvises. You get a toy.

The source states this directly:

> "THIS IS THE STAGE THAT WAS MISSING FROM YOUR PIPELINE. Without it, the PRD describes WHAT but not the mechanical HOW. The build drifts. The AI improvises. You get a toy."

## Inputs

Stage 4 receives the **structured concept document** from Stage 3 (Agent OS Structuring). This is the organized, formatted output that includes context, market positioning, and feasibility assessment -- but has NOT yet been broken into individual parts.

The source is explicit about why the input must come from Stage 3 and not earlier:

> "You can't do this before Stage 3 because unstructured ideas have overlapping concepts that look like separate things but aren't (or vice versa). The structuring step resolves ambiguity so extraction is clean."

In the early (pre-refined) pipeline, the input was called "Structured concept" directly from Stage 2 (Context Framing / AgentOS). In the final 10-stage pipeline, Stage 3 (Agent OS Structuring) explicitly precedes extraction.

## Process

### What the AI Does

The AI identifies every mechanism in the structured concept:

```
STAGE 3: MECHANISM EXTRACTION
  Input: Structured concept
  Process: AI identifies every mechanism
    - What are the moving parts?
    - Which are obvious (one clear way)?
    - Which have multiple approaches?
  Output: List of mechanisms, tagged as
          OBVIOUS or NEEDS_EVALUATION
```

(Note: In the earliest pipeline draft this was labeled "Stage 3" before Gap Analysis was inserted as Stage 2 and the numbering shifted. In the final pipeline it is Stage 4.)

### Three Questions Drive Extraction

1. **What are the moving parts?** -- Enumerate every distinct functional unit.
2. **Which are obvious (one clear way)?** -- Tag mechanisms where there is essentially one standard approach.
3. **Which have multiple approaches?** -- Tag mechanisms where two or more viable implementation paths exist.

### Tagging System

Each extracted mechanism is tagged as one of two categories:

- **OBVIOUS** -- There is one clear way to build it. No evaluation needed. Proceeds directly.
- **NEEDS_EVALUATION** -- Multiple approaches exist. Must go through the 10-step criteria evaluation (which was originally part of Stage 4 but later split into its own evaluation step or handled within Stage 4 depending on the pipeline version).

### What Counts as a "Mechanism"

The source provides concrete examples of what constitutes a mechanism:

- **Auth system** -- login, signup, password reset, session management
- **Payment flow** -- Stripe integration, credit system, subscription management
- **Dashboard** -- user-facing main interface with widgets
- **Notification engine** -- alerts, emails, in-app notifications
- **Video generation engine** -- API calls to fal.ai, prompt handling
- **Social media posting** -- integration with external APIs like Late.dev
- **Script engine** -- template system, text-to-video prompt generation
- **Template library** -- CRUD operations for saved templates
- **Style set picker** -- 12 styles + image-to-theme conversion
- **Question engine** -- idea intake for PRD maker
- **Gap analysis module** -- intelligent question generation
- **Phase sequencer** -- splitting PRD into build phases
- **Email engine** -- Resend integration, per-user settings
- **Credit system** -- balance tracking, deduction, purchase

The user's own description of granularity:

> "What's a mechanism, you know, so one little dashboard thing that is like a thing like video, like, 'Okay, what's the platform? Is it along? Is it short? Is it? What type of video? What's this? What's that?' There are so many jumping-off points from one spot, and each one of them needs this framework."

A mechanism is a **functional unit with its own internal logic, its own inputs and outputs, and its own set of decisions about how to implement it.** It is not a single button or a single database column -- it is a coherent feature area.

### The Mentor's MVP Principle Applied to Mechanisms

The mentor's guidance on MVP thinking informs mechanism identification:

> "Go back once, find out where the step is where you don't even have anything to sell, because you took out the main mechanism that actually makes it special or work."

This means mechanisms have different weights. Some are the **core mechanism** (the one thing that makes the app worth using), and others are supporting mechanisms. Extraction should identify which is which.

### How Mechanisms Relate to Pre-Existing Patterns

The source emphasizes that mechanism extraction should match against known patterns rather than treating everything as novel:

> "What the questions need to be doing is identifying something that's already put together and scaled out as an idea or system. It's like if you can just clarify the model, because it's not like any of these software ideas are doing anything brand new and brilliant. They're just creating formats or just creating pages. They're just creating areas that you do things in."

> "What we really need to do is have preformed scaffolding, and the questions need to be about which is the scaffolding we're doing here, which is the way we're doing this, right, and then it already knows what to do based upon."

This means the extraction process should recognize standard patterns (auth, CRUD, dashboard, settings page, admin panel) and match mechanisms to them, rather than describing each mechanism from scratch.

## Outputs

The output of Stage 4 is a **list of mechanisms, each tagged as OBVIOUS or NEEDS_EVALUATION**.

For each mechanism in the list:

- **Name** -- descriptive label (e.g., "Auth System," "Payment Flow," "Video Generation Engine")
- **Classification** -- OBVIOUS or NEEDS_EVALUATION
- **Brief description** -- what this mechanism does
- **If NEEDS_EVALUATION** -- the multiple approaches that exist and need to be weighed

### What Happens to NEEDS_EVALUATION Mechanisms

NEEDS_EVALUATION mechanisms go through a **10-step criteria evaluation** from an engineer's perspective:

```
STAGE 4: MECHANISM EVALUATION (your 10-step criteria)
  Input: Each NEEDS_EVALUATION mechanism
  Process:
    - Engineer perspective scoring
    - Pros/cons for each approach
    - 92% developer-choice routing
    - If within 15% -> design BOTH -> branch test later
  Output: Chosen approach for each mechanism
```

The evaluation process:

1. Each mechanism is judged from the standpoint of an engineer using a 10-step criteria.
2. Pros and cons are generated for each approach.
3. Because each evaluation follows a standardized listing format, the system can determine: "an engineer would use this, 92% of the time it would go this route, and here's why."
4. **Developer's Choice routing**: If one approach clearly wins, it is selected automatically.
5. **15% threshold rule**: If two approaches are within 15% of each other in scoring, BOTH get designed and placed in the PRD. The rationale: "What if you come across something on the first one unforeseen? You already have the designs made for the second one."
6. Both versions can be built on separate git branches and tested via AI to find the real-world winner.
7. The user can override with "go with developer's choice on all of it" to accept the top-scoring approach for every mechanism.

### The Combined Output (Extraction + Evaluation)

After both extraction and evaluation, the output is: a complete list of mechanisms, each with a chosen implementation approach (or two approaches if within 15%), ready to be fed into Stage 5 (7-Question Scaffolding).

In the unified architecture, these are combined as a single layer:

```
LAYER 4: MECHANISM EXTRACTION + 10-STEP EVALUATION
```

And in the PRD maker flow, the corresponding sections are:

```
Section 3: Mechanism Inventory (extraction)
Section 4: Mechanism Decisions (10-step eval)
```

## Rules & Constraints

1. **Extraction cannot happen before structuring.** The structured concept from Stage 3 must exist first. Unstructured ideas have overlapping concepts that look like separate things but aren't (or vice versa). Structuring resolves ambiguity so extraction is clean.

2. **Every moving part must be identified.** Nothing can be left implicit. If a mechanism is missed at this stage, it will not get scaffolded in Stage 5, will not appear in wireframes in Stage 6, and will be improvised by the builder agent -- exactly the failure mode the pipeline exists to prevent.

3. **Mechanisms must be discrete.** Each mechanism is a self-contained unit. If two things are entangled, they need to be separated here. If two things that look separate are actually the same mechanism, they need to be merged here.

4. **Tag every mechanism.** Every single mechanism must receive either OBVIOUS or NEEDS_EVALUATION. No mechanism can proceed untagged.

5. **Match against known patterns first.** Most mechanisms in most apps are standard patterns (auth, CRUD, dashboard, settings). The extraction should recognize these rather than treating them as novel.

6. **The 15% rule for evaluation.** If two approaches score within 15% of each other, design both. Do not force a single choice when the data does not clearly favor one.

7. **Developer's Choice is the default.** When the user does not want to make granular decisions, the system picks the engineer-recommended approach automatically ("92% of the time it would go this route").

8. **Martin's 13 modules inform extraction.** The source states: "Martin's 13 modules are NOT a layer. They're a knowledge base that gets REFERENCED by layers 4, 5, 8, and 9. The auth module informs Layer 4 when auth is a mechanism." When auth is identified as a mechanism, Martin's auth module provides the pattern knowledge for how that mechanism should be structured.

## Examples

### Example: Video Production App (VidAi)

Mechanisms extracted from the VidAi app concept:

- Video generation engine (API calls to fal.ai) -- OBVIOUS (one provider, one pattern)
- Video extension to 15-30 seconds -- NEEDS_EVALUATION (stitching approach vs. native long-form vs. scene chaining)
- Script engine + templates -- OBVIOUS (database CRUD + LLM prompt generation)
- Social media posting via Late.dev -- OBVIOUS (REST API integration)
- Credit system -- OBVIOUS (already built, standard deduction pattern)
- Payment abstraction (Stripe/Square) -- NEEDS_EVALUATION (wrapper approach vs. parallel implementation vs. replacement)
- Admin dashboard -- OBVIOUS (standard sidebar + content pattern)
- User settings / API key management -- OBVIOUS (key-value store pattern)

### Example: PRD Maker App

From the PRD maker description, mechanisms would include:

- Question engine (idea intake)
- Gap analysis module
- Agent OS formatter
- Mechanism extraction engine (this stage itself as a feature)
- 7-question scaffolding engine
- Wireframe generator
- Style set picker (12 styles + image-to-theme)
- Phase sequencer with protocol injection
- Bash script generator
- Save/load PRDs per user
- Credit system for generation costs
- Graphic pack generator (logos, icons, social cards)

### Example: Practitioner Bot (Meta Programs)

In the practitioner bot context, mechanisms were identified as:

- Context establishment (work/relationship/health selection)
- Individual meta program elicitation (toward/away, internal/external, options/procedures, etc.)
- Response classification (keyword matching against valid outcomes)
- Profile compilation
- Results delivery to client
- Session logging

Each meta program elicitation is its own mechanism with its own question, its own valid outcomes, and its own validation rules.

### Example: Combined Sales + NLP Bot

Two scaffoldings stacked as layers:

- **Layer 1 (outer scaffold)**: Jeremy Miner's 8 Steps -- each step is a mechanism
- **Layer 2 (inner scaffold)**: Meta Programs -- adjusts language within each step mechanism

The 8 steps do not change. The meta programs change the LANGUAGE used inside each step. The source describes this as: "Same wall. Same door. Different paint on the walls."

## Edge Cases & Debates

### Mechanism Granularity: When Is Something Too Small or Too Big?

The source does not give a strict formula but provides guidance through examples:

- **Too small**: A single button, a single database column, a single CSS class. These are implementation details, not mechanisms.
- **Too big**: "The whole dashboard" if it contains multiple independent functional areas (e.g., a dashboard that has a video preview widget, a recent-generations list, and a credit balance display -- these might be separate mechanisms).
- **Right size**: Auth system, payment flow, video generation engine, template library, notification engine. Each has its own internal logic, its own inputs/outputs, and its own implementation decisions.

The user's description suggests mechanisms correspond roughly to what would be a "feature" in product terms or a "module" in engineering terms.

### Mechanisms with Multiple Approaches (the 15% Rule)

The debate around the 15% threshold:

> "If it was within 15% of each other, then we would just build out or we would design out both mechanisms. We'd put that in the PRD, right? Because what if you come across something on the first one unforeseen? You already have the designs made for the second one."

This creates additional work but provides a safety net. The tradeoff is explicitly acknowledged: more design effort upfront, but recovery from a bad choice is instant because the alternative is already designed.

The user can bypass this with "go with developer's choice on all of it."

### Gap Analysis Question About Mechanism Evaluation

The gap analysis stage raised this as an open question:

> "The mechanism evaluation -- When there are multiple ways to build something and they're within 15% of each other, you said design both. Does the USER see this decision, or does the system just pick Developer's Choice and move on? What's the default behavior?"

This was identified as needing a user answer before the PRD maker could be finalized.

### Where Does Extraction End and Scaffolding Begin?

The source is clear that extraction (Stage 4) identifies WHAT the mechanisms are, and scaffolding (Stage 5) defines HOW each mechanism works internally:

> "NOW you break the structured idea into individual moving parts. Auth system, payment flow, dashboard, notification engine -- each one gets identified as a discrete mechanism."

Stage 4 = identify and list mechanisms + evaluate approaches.
Stage 5 = apply 7 questions to each mechanism to define walls/doors/rooms.

The boundary is: if you are asking "what are the parts?" you are in Stage 4. If you are asking "how does each part work mechanically?" you are in Stage 5.

### Evolution of Stage Numbering

In the earliest pipeline draft (before Gap Analysis was added as Stage 2), mechanism extraction was "Stage 3." In the early pipeline, extraction and evaluation were separate stages (Stage 3 and Stage 4). In the final 10-stage pipeline, extraction is Stage 4, and the evaluation (10-step criteria, Developer's Choice scoring) is folded into the same stage. In the unified layer architecture, it appears as:

```
LAYER 4: MECHANISM EXTRACTION + 10-STEP EVALUATION
```

The final 10-stage pipeline:

```
Stage 1:   IDEA CAPTURE
Stage 2:   GAP ANALYSIS
Stage 3:   AGENT OS STRUCTURING
Stage 4:   MECHANISM EXTRACTION
Stage 5:   7-QUESTION SCAFFOLDING
Stage 6a:  ARRANGEMENT SELECTION
Stage 6b:  PAGE MOCKUPS
Stage 6c:  STYLE SELECTION
Stage 7:   PHASE SEQUENCING
Stage 8:   PROTOCOL INJECTION
Stage 9:   VERIFICATION AGENT SETUP
Stage 10:  OUTPUT
```

## Connections to Other Stages

### Stage 3 (Agent OS Structuring) -> Stage 4

Stage 3 provides the structured, organized concept document. Without this structuring, extraction would be working with raw, potentially ambiguous input where overlapping concepts might look like separate mechanisms or vice versa.

### Stage 4 -> Stage 5 (7-Question Scaffolding)

Stage 4 provides the list of discrete mechanisms that Stage 5 applies the seven questions to. Stage 5 cannot operate without this list -- "you need the list of mechanisms to apply the questions TO."

Each mechanism from Stage 4 becomes a unit that gets the deterministic treatment in Stage 5: walls, doors, rooms defined for each one.

### Stage 4 -> Stage 6 (Layout + Mockups + Style)

The wireframing stage needs to know what mechanisms exist to lay out pages:

> "Now you know every mechanism, every wall, every door, every room. So NOW you can lay out pages. You know the auth system has 3 screens. You know the dashboard has 5 widgets."

The wireframing stage also analyzes mechanisms to present layout options:

> "The system analyzes the mechanisms from Stage 4-5 and presents options: Your app has: Auth, Dashboard, Settings, User Management, Reports"

### Stage 4 -> Stage 7 (Phase Sequencing)

Phase sequencing splits the build at mechanism boundaries. The source describes the math:

> "Find natural break points (mechanism boundaries) near those division points"

Mechanisms from Stage 4 define where phases can be split -- you do not split in the middle of a mechanism.

### Stage 4 + Martin's 13 Modules

Martin's modules are a knowledge base referenced during extraction:

> "The auth module informs Layer 4 when auth is a mechanism. The CRUD module informs Layer 9 when building entity pages."

When the extraction process identifies "auth" as a mechanism, Martin's auth module provides pattern knowledge about what a proper auth implementation looks like, which informs whether the mechanism is OBVIOUS or NEEDS_EVALUATION and what the evaluation criteria should be.

### Stage 4 and the Mentor's MVP Principle

The extraction stage is where the core mechanism (the one thing that makes the app special) gets identified. The mentor's principle -- "find where the step is where you don't even have anything to sell, because you took out the main mechanism" -- means extraction should distinguish between the core mechanism and supporting mechanisms. This distinction affects phase sequencing later (core mechanism gets built first).
