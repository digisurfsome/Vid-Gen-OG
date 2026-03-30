# Stage 2: GAP ANALYSIS — Extraction Dossier

## Purpose

Gap Analysis is the second stage of the 10-stage PRD maker pipeline. Its job is to take the raw idea captured in Stage 1 and identify everything that is missing, ambiguous, or incomplete — then generate intelligent questions to fill those gaps BEFORE the information enters any structuring or processing system downstream.

The core rationale stated directly in the source:

> "Why second: Before you can structure ANYTHING, you need complete information. If someone says 'I want a marketplace' but doesn't mention payments, you need to catch that NOW — not after you've scaffolded 50 mechanisms that are all missing a payment layer. Gap analysis prevents rework. You're filling holes in the raw input before it enters the machine."

Gap Analysis exists because the downstream stages (Agent OS Structuring, Mechanism Extraction, 7-Question Scaffolding, etc.) all assume the input they receive is COMPLETE. If holes pass through Stage 2 undetected, they compound. A missing payment concept means Stage 4 extracts no payment mechanism, Stage 5 builds no scaffolding for it, Stage 6 generates no wireframe for it, and the entire output PRD is structurally deficient.

The funnel metaphor from the source describes Stage 2's position:

```
WIDE    → Capture everything (Stage 1)
         → Fill gaps in everything (Stage 2)
          → Structure everything (Stage 3)
           → Break into parts (Stage 4)
            → Define each part precisely (Stage 5)
             → Arrange parts visually (Stage 6)
              → Style them (Stage 7)
               → Sequence the build (Stage 8)
                → Tag quality checks (Stage 9)
NARROW   → Output the document (Stage 10)
```

Each stage REDUCES ambiguity. By Stage 10, there are ZERO open questions. Stage 2 is the first major ambiguity-reduction pass.

## Inputs

- **Raw idea capture from Stage 1**: This is the user's "rant" — their unstructured brain dump describing what they want to build. It can range from 2-3 sentences (the average user) to 40-50 sentences (a power user who gives detailed context, describes things multiple ways, and has some engineering background).
- Stage 1 output has NO filtering, NO structure. It is raw input. The MORE the user says in Stage 1, the LESS work Stage 2 has to do.

## Process

### What Gap Analysis Does

Gap Analysis receives the raw capture and runs it through an intelligent questioning process. The system identifies:

1. **Missing entire concepts** — e.g., user described a marketplace but never mentioned payments, authentication, or user roles.
2. **Ambiguous descriptions** — e.g., user says "I want it to look nice" but gives no wireframing, layout, or style direction.
3. **Incomplete mechanisms** — e.g., user mentions "video generation" but doesn't specify duration, format, model, or what triggers it.
4. **Unstated assumptions** — things the user takes for granted that the system cannot infer.

### The Question Engine

The source discusses the question engine as the core of Stage 2. A key design question was raised during the pipeline design session:

> "The question engine — When a user describes their idea, how many questions should the system ask? Is it adaptive (fewer questions if they gave lots of detail, more if they were vague)? Or is it always the same set? And is it conversational (chat-style, one question at a time) or a form (all questions on one page)?"

This question was posed as one of the 7 gap analysis questions the system architect asked the user, but the user deflected to first understand the stage ordering before answering. The user never provided an explicit final answer in the source material to these specific design questions. However, the user's broader philosophy is clear from their own description:

> "I rant, so I describe the app I want to make... I say things in two to three different ways to give context so my rants get long but they're very detailed and the context is really great. The average person probably, like, five sentences, sometimes two sentences... Well I'm writing like 40 to 50 sentences... What we're trying to build in is a gap analysis where it's going to ask questions back to fill in all the gaps of what the rest of the app should look like."

The user's concept: Gap Analysis is a question-and-answer exchange where the system reads what the user provided, identifies what's missing, and asks intelligent questions to fill those gaps.

### Adaptive vs. Fixed Questioning

The user's philosophy strongly implies ADAPTIVE questioning. Evidence:

1. The user explicitly noted that some people give 2-3 sentences while others give 40-50. A fixed question set would be redundant for detailed users and insufficient for vague ones.
2. The user discussed how the system should try to match up against "already known frameworks" rather than asking "a thousand questions" — the system should recognize patterns in what the user described and ask only what's missing.
3. The user stated: "Nobody's gonna sit there and answer a thousand questions, right? What the questions need to be doing is identifying something that's already put together and scaled out as an idea or system."

The user's vision for how this works:

> "It's like if you can just clarify the model, because it's not like any of these software ideas are doing anything brand new and brilliant. They're just creating formats or just creating pages. They're just creating areas that you do things in, so it's really just determining which are these areas of this, like where does this fit into within the history of the way, and then the same thing. The UI is pretty much the same. You've got X amount of pages. You've got this stuff on a page that's organized in this way, so it's really just trying to fit it in."

In other words: the gap analysis should be smart enough to recognize the TYPE of app being described, know what that type typically requires, and only ask about the parts the user didn't cover.

### Types of Gaps to Detect

From the source material, the 7 specific gap analysis questions that were posed (representing the kinds of holes the system needs to catch) were:

1. **The question engine design** — how many questions, adaptive vs. fixed, conversational vs. form
2. **The mechanism evaluation** — when multiple approaches exist within 15% of each other, does the user see that decision or does Developer's Choice handle it?
3. **The graphic packs** — are they AI image generation (DALL-E/Midjourney) or CSS/SVG/code-based?
4. **Save/load PRDs** — does the system re-read codebase via GitHub URL or work from saved PRD?
5. **The bash script output** — literal .sh file for CLI, markdown for copy-paste, or both?
6. **Credit costs** — what should each operation cost (basic PRD, graphic pack, feature addition, style sheet)?
7. **The wireframing step** — visual wireframes the user approves, or just text descriptions in the PRD?

These questions illustrate what a gap analysis produces: specific, targeted questions about the parts of the idea that were described conceptually but not operationally.

### How Questions Get Generated

The system generates questions by comparing what the user said against what a complete app specification requires. The source describes a pattern where the system:

1. Reads the raw capture
2. Identifies what TYPE of application is being described
3. Knows what that type typically requires (auth, payments, database, pages, etc.)
4. Compares what was described vs. what's needed
5. Generates questions ONLY for the gaps

This is described in the broader context of the "universal deterministic builder" concept: use a systematic set of questions to cover every possible what, when, how, where, who. The user described it this way:

> "What would be the questions for the context? What would be a universal deterministic builder? What would be the questions that would be asked that cover every possible what, when, how, where, who? Right? What are those questions for creating deterministic?"

### How Answers Get Integrated Back

Once the user answers the gap analysis questions, the answers get combined with the original Stage 1 capture to form a COMPLETE raw information set. This combined set then flows into Stage 3 (Agent OS Structuring) where it gets formatted into a proper structure.

The flow described in the unified architecture:

```
LAYER 1: YOUR RANT (raw idea, mechanisms, vision)
    ↓
LAYER 2: GAP ANALYSIS (questions that fill in what you missed)
    ↓
LAYER 3: AGENT OS (structures it into context, market, feasibility)
```

And stated more explicitly:

> "Stage 3: AGENT OS STRUCTURING — Why third: Now you have complete raw information (Stage 1 + 2 combined). This is where you FORMAT it — context, market positioning, feasibility assessment. You're turning messy human language into organized sections."

The key distinction: Stage 2 does NOT structure anything. It only fills gaps. The structuring happens in Stage 3. Stage 2 output is STILL messy human language — it's just MORE COMPLETE messy human language.

### The Relationship Between Gap Analysis and "Preformed Scaffolding"

The user had a critical insight about how gap analysis should work efficiently:

> "What we really need to do is have preformed scaffolding, and the questions need to be about which is the scaffolding we're doing here, which is the way we're doing this, right, and then it already knows what to do based upon. You're now breaking it down to the fewest amount of questions needed."

This means gap analysis shouldn't be a dumb checklist. It should:
- Recognize the app TYPE from the raw capture
- Load a "preformed scaffolding" of what that app type needs
- Ask only about the DELTA between what was provided and what the scaffolding requires
- Someone who describes things in great detail gets fewer questions
- Someone who gives 2 sentences gets more questions
- But neither gets irrelevant questions

## Outputs

- **Complete raw information set**: Stage 1 capture + Stage 2 answers combined. This is the raw material that Stage 3 (Agent OS Structuring) formats into organized sections.
- The output is NOT structured. It is comprehensive but messy. Structuring is explicitly Stage 3's job.
- The standard of "complete" means: every concept needed for the subsequent stages to function has been at least mentioned. No major blind spots remain.

## Rules & Constraints

1. **Gap Analysis MUST come before structuring.** You cannot structure incomplete information. If you try to structure an idea that's missing payments, you get a structured spec with no payments — and everything downstream inherits that gap.

2. **Gap Analysis does NOT structure.** It only fills holes. The output is still raw human language, just more complete. Structuring is Stage 3's responsibility.

3. **Questions must be adaptive.** A detailed rant needs fewer questions. A vague description needs more. Nobody will answer a thousand questions, so the system must be intelligent about what to ask.

4. **Questions should leverage known patterns.** Most apps fit known archetypes (dashboard, marketplace, chat, wizard, tool, etc.). The system should recognize the archetype and only ask about deviations from the standard pattern.

5. **The fewer questions, the better** — as long as completeness is achieved. The user was explicit: "You're now breaking it down to the fewest amount of questions needed."

6. **The MORE the user says in Stage 1, the LESS work Stage 2 has to do.** This is stated directly in the source as a design principle.

7. **Gap Analysis prevents rework.** Its primary function is catching missing concepts early, before they propagate through all downstream stages.

## Examples

### Example: Marketplace App Missing Payments
- User says: "I want a marketplace where people can buy and sell crafts"
- Gap Analysis detects: No mention of payment processing, seller payouts, transaction fees, dispute handling
- Questions generated: "How will buyers pay? Will you take a percentage? How do sellers get paid out? What happens if a buyer disputes?"

### Example: The PRD Maker Itself
The source contains a live example of gap analysis being performed on the PRD maker product. The 7 questions asked were:

1. Question engine — adaptive vs. fixed, conversational vs. form?
2. Mechanism evaluation — user sees 15% decisions or Developer's Choice?
3. Graphic packs — AI images or code-based?
4. Save/load — re-read codebase or work from saved PRD?
5. Bash script — .sh file, markdown, or both?
6. Credit costs — pricing per operation?
7. Wireframing — visual approval or text descriptions?

Each question targets a specific ambiguity in the user's description. The user had described the concept extensively but left these operational details unstated.

### Example: Matching to Known Patterns
The user described wanting a "video platform" — gap analysis would recognize:
- Video platforms need: upload/storage, transcoding, player UI, permissions
- The user mentioned: text-to-video generation, social posting
- Gaps: video storage strategy, supported formats, duration limits, model selection

## Edge Cases & Debates

### How Many Questions Is Too Many?
The user was clear that "nobody's gonna sit there and answer a thousand questions." But the system must ensure completeness. The tension is:
- Too few questions → gaps pass through to Stage 3+ → broken specs
- Too many questions → users abandon the process → no specs at all

The resolution proposed: adaptive questioning that leverages known app archetypes. Match the user's description to a template, ask only about the gaps.

### What If the User Doesn't Know the Answer?
This was not explicitly addressed in the source material. However, the mechanism evaluation process (Stage 4) includes a "Developer's Choice" pattern where the system picks the 92% solution when the user doesn't have a preference. A similar pattern could apply here: if the user says "I don't know" to a gap analysis question, the system could note it and use the standard default for that app type.

### When Is Gap Analysis "Done"?
The source says Stage 2's goal is "complete information" — but complete is relative. The practical standard appears to be: every concept needed for Stage 3 to structure and Stage 4 to extract mechanisms must be at least mentioned. If the mechanism extractor would hit a dead end because something was never described, that's a gap that Stage 2 should have caught.

The funnel principle states: "Each stage REDUCES ambiguity. By Stage 10, there are ZERO open questions." Stage 2 doesn't need to eliminate ALL ambiguity — it needs to ensure enough information exists for Stage 3 to organize. Stage 4, 5, and later stages will continue reducing ambiguity through their own processes.

### The Conversion Funnel Impact
In the context of the product being built (the PRD maker SaaS), the gap analysis stage has direct impact on conversion rates. The source material discusses:

```
100 users start the PRD process
 90 get through idea capture
 85 get through gap analysis
 80 approve their mockups
```

This suggests about 5% drop-off at the gap analysis stage — people who start but don't finish answering questions. The design must balance thoroughness with user friction.

### Gap Analysis vs. Agent OS Structuring
There was some discussion about whether gap analysis and structuring could be combined. The answer is NO — they are deliberately separate because:
1. Structuring incomplete information produces structured GAPS (worse than unstructured gaps, because they look legitimate)
2. Gap analysis needs to see the raw, messy description to understand what the user ACTUALLY meant, not a sanitized version
3. Stage 3 needs COMPLETE input to produce good structure. Combining the stages would mean structuring while simultaneously discovering what's missing.

## Connections to Other Stages

### Stage 1 → Stage 2
Stage 1 (Idea Capture) provides the raw input. The quality and detail of Stage 1 output directly determines how much work Stage 2 must do. A 50-sentence rant may need only 2-3 gap-filling questions. A 3-sentence description may need 15+.

### Stage 2 → Stage 3
Stage 2's output (raw capture + gap answers) feeds directly into Stage 3 (Agent OS Structuring). Stage 3 assumes its input is COMPLETE — it formats what it receives without checking for gaps. If Stage 2 missed something, Stage 3 will structure around the hole without noticing.

### Stage 2 ↔ Stage 4 (Indirect)
Stage 4 (Mechanism Extraction) breaks structured information into discrete mechanisms. If Stage 2 failed to surface a concept (like payments), Stage 4 will never extract a payment mechanism. The entire downstream pipeline inherits the gap.

### Stage 2 ↔ The 7-Question Scaffolding (Stage 5)
The 7 questions applied in Stage 5 are conceptually related to the gap analysis questions in Stage 2, but serve different purposes. Stage 2 asks "what is your app?" questions to fill conceptual gaps. Stage 5 asks "how does this mechanism work?" questions to classify each piece as Wall/Door/Room. Stage 2 operates on the whole idea. Stage 5 operates on individual extracted mechanisms.

### Stage 2 in the Unified Architecture
In the 12-layer unified architecture described in the source:

```
LAYER 1: YOUR RANT (raw idea, mechanisms, vision)
    ↓
LAYER 2: GAP ANALYSIS (questions that fill in what you missed)
    ↓
LAYER 3: AGENT OS (structures it into context, market, feasibility)
```

Gap Analysis is Layer 2 — positioned between raw capture and structured processing. It is the bridge that ensures the raw human input is complete enough for machine processing.

### Stage 2 in the End-to-End Flow
The source describes the end-to-end flow as:
```
You describe your idea
  → PRD Maker (create-spec) asks questions, fills gaps
  → Phase 4V silently tags every feature and injects checkpoints
  → app_spec.txt comes out with verification baked in
```

The "asks questions, fills gaps" portion is Stage 2 in operation.

### What Happens Without Stage 2
The source provides a concrete example of what happens when gap analysis is skipped: the AI "went rogue" and "built a toy" because the prompt was "open-ended" and the AI was "in a big empty room and just started building whatever." Without gap analysis forcing completeness, the downstream builder makes assumptions — and those assumptions are often wrong.

### Stage 2 Referenced in System A vs. System B Comparison
When comparing the Agent OS approach (System A) against the sequential 13-prompt approach (System B), gap analysis was cited as one of the key differentiators:

> "The 13-prompt approach treats each concern as a separate session. Scaffold → done. Auth → done. Data layer → done. But it doesn't have: The gap analysis (what's missing from the original idea?)"

This positions gap analysis as a unique capability of the full pipeline that simpler approaches lack entirely.
