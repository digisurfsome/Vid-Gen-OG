# Stage 1: IDEA CAPTURE — Extraction Dossier

## Purpose

Stage 1 takes raw, unstructured input — a user's "rant," voice transcript, scattered notes, or stream-of-consciousness description of an app idea — and captures it as raw material for the pipeline. Its job is NOT to structure, filter, or organize. It simply gets everything out of the user's head. The MORE the user says here, the LESS work Stage 2 (Gap Analysis) has to do.

As stated explicitly in the source:

> "Why first: You can't analyze what you don't have. This is just raw input — the user's brain dump. No filtering, no structure. Let them talk."

## Inputs

- A user's raw idea description. Could be:
  - A voice transcript (rant)
  - Typed notes
  - As little as 3-4 sentences from an average person
  - As much as 40-50 sentences from a detailed/serious user
  - Stream-of-consciousness with contradictions, tangents, and repetition
- No prior structure or format is required
- No specific fields to fill in at this stage

The user (the pipeline creator) describes his own intake style: "I rant, so I describe the app I want to make and I do, probably I'd say I do better than most people, just because I can see it and so therefore I go and I try. I say things in two to three different ways to give context so my rants get long but they're very detailed and the context is really great. The average person probably, like, five sentences, sometimes two sentences, right? Well I'm writing like 40 to 50 sentences, right, because I'm trying to describe it because I'm serious about this and then I'm trying to give context about it. Plus I have a little bit of an engineering background so I'm kind of trying to frame it in that way as well."

## Process

### Core Principle: Let Them Talk

Stage 1 is deliberately unstructured. There is no questionnaire, no form, no template at this stage. The user dumps everything they have. The system's only job is to capture it faithfully.

### What Gets Captured

Everything the user says, including:
- The core idea/concept
- Mechanisms they envision (features, workflows, behaviors)
- Context about who it's for
- Comparisons to existing products
- Technical preferences or constraints they mention
- Business context (though this is not the focus)
- Contradictions and corrections (the user often says something, then corrects it — both versions get captured)
- Repetitions and re-framings (the user often describes the same thing 2-3 different ways to provide context)

### What Gets Deferred

Stage 1 does NOT attempt to:
- Fill in gaps (that's Stage 2: Gap Analysis)
- Structure or organize the information (that's Stage 3: Agent OS Structuring)
- Identify mechanisms (that's Stage 4: Mechanism Extraction)
- Classify walls/doors/rooms (that's Stage 5: 7-Question Scaffolding)
- Determine page layouts or UI (that's Stage 6)
- Apply any styling (that's Stage 7)

### The Rant-to-PRD Spec Reference

A separate document (`rant-to-prd-spec.md`) describes a 7-stage pipeline with specialized agents. The first agent in that pipeline is a "Transcriber" whose job maps to Stage 1: taking the raw rant and producing an initial capture. The full 7-stage sub-pipeline described there is: Rant -> Transcriber -> Classifier -> Gap Analyst -> Decision Facilitator -> Mechanism Analyst -> PRD Compiler -> AutoForge Bridge. The Transcriber role is the Stage 1 equivalent in that formulation.

### Dashboard Intake Context

When Stage 1 is implemented as a dashboard experience (the SaaS product), it takes the form of the beginning of a guided process. But even in the dashboard version, Stage 1 itself remains open-ended — it's the "describe your idea" step before any structured questions begin.

The full dashboard intake process has 10 steps total (Stages 1-7+ of the pipeline correspond to these steps), but Stage 1 is specifically the initial free-form capture. It was established that the dashboard intake would be the SAME for both the Tier 1 (subscription/exported PRD) and Tier 2 (internal build) product tiers — the intake is the funnel, not the sauce.

### Three-Tier Free/Paid Intake Variants

The source discusses three product tiers with different intake experiences:

**Free Tier ("The Taste"):**
- Simple 3-5 question form (idea, audience, core feature, platform preference)
- Kicks out ONE prompt they can paste into any AI
- That prompt is decent but flat — not phased, not structured, no safety, no testing
- Purpose: demonstrate the concept, show them AI can build apps from prompts, but output is messy/incomplete
- Restriction: One free generation, tied to email verification

**Tier 1 ("The Engine" — $29-49/mo):**
- Full dashboard intake process (all 10 steps)
- The "prompt engine" — guided, iterative, deep
- Outputs a multi-phase PRD with stripped-down components

**Tier 2 ("The Build" — $199-349 per app):**
- Same dashboard intake as Tier 1
- Full internal build with all layers, all protocols
- User never sees the PRD

An unresolved question from the source: "The Tier 1 intake — is it truly identical to Tier 2? Same 10 steps? Or does Tier 1 get a shorter intake since the output is simpler anyway? Because if Tier 1 goes through the same deep process but gets a worse output, that feels like a bait-and-switch."

## Outputs

Stage 1 produces a **raw concept capture** — the unprocessed brain dump in whatever form it was given. This feeds directly into Stage 2 (Gap Analysis).

Specifically, the output contains:
- The user's raw description in their own words
- No imposed structure
- All contradictions preserved (later statements override earlier ones when they conflict, but this resolution happens in Stage 3, not Stage 1)
- All context and tangential information preserved (it may prove relevant in later stages)

From the pipeline overview:
```
STAGE 1: CAPTURE (what you do naturally)
  Input: Your rant, your idea, your 3-4 sentences
  Output: Raw concept captured

  This is just you talking. No structure yet.
  Just get it out of your head.
```

And from the later, refined 10-stage version:
```
Stage 1:  IDEA CAPTURE          <- Raw input
```

The output feeds into Stage 2 where questions are asked to fill holes in the raw capture.

## Rules & Constraints

1. **No filtering at this stage.** Everything the user says gets captured. Filtering, organizing, and structuring happen in later stages.

2. **No structure imposed.** The user talks however they want. There is no template, no required fields, no form to fill out during Stage 1 itself.

3. **More is better.** The MORE the user says here, the LESS work Stage 2 has to do. The system should encourage verbosity, not constrain it.

4. **Contradictions are preserved, not resolved.** If the user says "I want X" and then later says "actually, not X, I want Y" — both statements are captured. Resolution of contradictions follows the rule: later statements override earlier ones, but this resolution is applied in Stage 3 (Agent OS Structuring), not in Stage 1.

5. **No mechanism extraction yet.** Even if the user describes mechanisms clearly, Stage 1 does not attempt to identify or classify them. That's Stage 4's job.

6. **No architectural decisions.** Stage 1 does not decide on tech stack, database design, authentication patterns, etc. It just captures whatever the user mentions about these topics.

7. **The funnel principle.** The overall pipeline follows a funnel shape:
```
WIDE    -> Capture everything
         -> Fill gaps in everything
          -> Structure everything
           -> Break into parts
            -> Define each part precisely
             -> Arrange parts visually
              -> Style them
               -> Sequence the build
                -> Tag quality checks
NARROW   -> Output the document
```
Stage 1 is the widest point. Each subsequent stage REDUCES ambiguity. By Stage 10, there are ZERO open questions.

8. **Stage 1 is the same across product tiers.** The decision was made that the intake experience is shared — both Tier 1 and Tier 2 get the same dashboard intake. "The intake isn't sauce — it's the funnel. The value is in what happens AFTER the intake."

## Examples

### Example of raw capture (from the source — the user describing the PRD maker itself):

"The PRD maker takes a user's rough idea (even just a few sentences), asks intelligent gap-filling questions, runs the idea through mechanism extraction with the 7-question deterministic scaffolding, generates a complete Agent OS formatted PRD broken into phases with testing protocols baked in at every seam, and outputs either a downloadable bash script for CLI builders or a structured PRD document. It includes a style set picker (12 styles + image-to-theme) and optional graphic pack generation (logos, icons, social cards, page layouts). Users save PRDs for future feature additions. Monetized via credits and tiered subscriptions."

This is an example of what a Stage 1 capture looks like AFTER the agent reflects it back as confirmation. The original rant was much longer and more scattered — it spanned multiple sessions and contained tangents about sales processes, meta programs, boilerplate decisions, and competitive strategy. Stage 1 captures ALL of that raw material.

### Example of a minimal capture (average user):

The source notes that average users might give only "five sentences, sometimes two sentences." Even this minimal input is valid Stage 1 output — Stage 2 will simply have more gaps to fill.

### Example of the free-tier capture:

For the free tier, the capture is compressed into a 3-5 question form: idea, audience, core feature, platform preference. This produces a much thinner Stage 1 output that feeds into a simplified single-prompt generation rather than the full pipeline.

## Edge Cases & Debates

### How adaptive should the question engine be?

An unresolved question from Gap Analysis (Stage 2) that impacts Stage 1's output requirements: "When a user describes their idea, how many questions should the system ask? Is it adaptive (fewer questions if they gave lots of detail, more if they were vague)? Or is it always the same set? And is it conversational (chat-style, one question at a time) or a form (all questions on one page)?"

This question was posed but never fully answered in the source. It was asked as one of the "7 gap analysis questions" the agent needed answered before proceeding.

### The question of pre-formed scaffolding during intake

The user raised an important design consideration about Stage 1's relationship to subsequent stages: "What the questions need to be doing is identifying something that's already put together and scaled out as an idea or system. It's like if you can just clarify the model, because it's not like any of these software ideas are doing anything brand new and brilliant. They're just creating formats or just creating pages... The questions: you could ask a bazillion questions. You could do those seven questions times a thousand times to paint it all out, right? What we really need to do is have preformed scaffolding, and the questions need to be about which is the scaffolding we're doing here."

This suggests Stage 1 capture should be rich enough to allow the system to pattern-match against known app archetypes, reducing the need for extensive questioning in Stage 2.

### Three-stage intake sub-process mentioned

The source references a "question engine (idea intake)" as a component to be built into the PRD maker dashboard (line 5585). The PRD maker's Session 2 plan lists these as sequential components:
1. Question engine (idea intake) -- corresponds to Stage 1
2. Gap analysis -- corresponds to Stage 2
3. Mechanism extraction + 7-question scaffolding -- corresponds to Stages 4-5
4. Agent OS formatter -- corresponds to Stage 3
5. Phase sequencer with protocol injection -- corresponds to Stages 8-9
6. Save/load PRDs per user
7. Bash script download

The "question engine (idea intake)" is the Stage 1 implementation in dashboard form.

### The rant-to-prd-spec.md 7-stage sub-pipeline

A separate document describes a more granular breakdown of the intake-to-PRD process as a 7-stage pipeline with specialized agents: Transcriber, Classifier, Gap Analyst, Decision Facilitator, Mechanism Analyst, PRD Compiler, AutoForge Bridge. The Transcriber stage maps to Stage 1, handling raw rant capture. An addendum document (`rant-to-prd-addendum.md`) adds Verification agents, Developer's Choice scoring, Feature Addition Engine, and Codebase Reality Engine.

### Free tier quality floor debate

A significant unresolved debate: "The free tier prompt quality floor — how bad is too bad? If the free output is total garbage, it reflects poorly on the brand. If it's too good, nobody upgrades. Where's the line? My instinct: it should produce something that runs but is obviously missing major pieces (no auth, no payments, basic UI, no error handling). Functional but clearly incomplete."

The user's resolution: The free prompt is positioned not as a gift but as a "reality check" — an educational tool that demonstrates why "just a prompt" doesn't work. "The free prompt IS the education. It's not a gift. It's a lesson. They experience firsthand why 'just a prompt' doesn't work."

### Voice transcription as input

The source mentions speech-to-text technology (Whisper, Deepgram, AssemblyAI) in the context of a different product (the sales coaching bot), but the PRD maker's Stage 1 is clearly designed to accept voice rant transcripts as a primary input mode, given that the user consistently describes his input process as "ranting" via voice.

## Connections to Other Stages

### What comes before Stage 1
Nothing. Stage 1 is the entry point of the pipeline. The user comes in with an idea in their head.

### What Stage 1 outputs to Stage 2 (Gap Analysis)
Raw concept capture — the unprocessed brain dump. Stage 2 then identifies what's MISSING from this capture and asks questions to fill those holes. "Before you can structure ANYTHING, you need complete information. If someone says 'I want a marketplace' but doesn't mention payments, you need to catch that NOW — not after you've scaffolded 50 mechanisms that are all missing a payment layer."

The relationship is: Stage 1 (raw) + Stage 2 (gap-filling questions + answers) = complete raw information. This combined output then feeds into Stage 3 (Agent OS Structuring) which formats it into organized sections.

### The complete pipeline for reference
```
Stage 1:   IDEA CAPTURE
Stage 2:   GAP ANALYSIS (questions)
Stage 3:   AGENT OS STRUCTURING
Stage 4:   MECHANISM EXTRACTION
Stage 5:   7-QUESTION SCAFFOLDING (Martin's rules = the lens)
Stage 6a:  ARRANGEMENT SELECTION (layout structure options)
Stage 6b:  PAGE MOCKUPS (visual preview of each page, iterative)
Stage 6c:  STYLE SELECTION (curated styles on YOUR mockups)
Stage 7:   PHASE SEQUENCING (math split + sandboxes + build order)
Stage 8:   PROTOCOL INJECTION (pulse/seam/checkpoints + violation handling)
Stage 9:   VERIFICATION AGENT SETUP (separate agent, decision authority)
Stage 10:  OUTPUT (phases/ + build.sh + CLAUDE.md + BUILD_RULES.md)
```

Note: The stage numbering shifted during the conversation. Earlier versions had the pipeline as 9 stages with wireframing and UI style as stages 6 and 7. The final version (shown above) expanded Stage 6 into sub-stages (6a, 6b, 6c), merged UI style into 6c, and renumbered the remaining stages. The Verification Agent Setup was added as a new Stage 9 in the later version after the user raised the point about not trusting the builder agent to check its own work.

### Earlier 11-stage formulation

An earlier formulation described it as an "11-stage pipeline with gap analysis, mechanism evaluation, Developer's Choice scoring." The layers listed there were:
```
LAYER 1: IDEA CAPTURE
  Your rant -> gap analysis questions -> refined concept
  (Agent OS structures this)
```

In this formulation, Layers 1-3 (Idea Capture, Gap Analysis, Agent OS structuring) are collapsed together as "IDEA CAPTURE" at the layer level, even though they are distinct pipeline stages. This shows that at the architectural level, Stages 1-3 are seen as a single conceptual unit: getting the idea fully captured and organized.

### The "Rant -> PRD" shorthand

Throughout the source, the pipeline is frequently summarized as: "Your idea rant -> gap analysis questions -> refined spec." This three-step shorthand maps to Stages 1-3 of the full pipeline and represents the human-facing intake portion before the system begins its automated analysis work (Stages 4+).
