# Stage 5: 7-QUESTION SCAFFOLDING (Wall/Door/Room Classification) — Extraction Dossier

## Purpose

Stage 5 is THE CORE IP of the entire pipeline. It takes each mechanism identified in Stage 4 and runs it through a 7-question framework to classify every aspect as WALL (deterministic — code handles, no AI), DOOR (constrained — AI operates within strict boundaries), or ROOM (creative freedom — AI can be flexible). This is the stage that was MISSING from the original pipeline and is the reason builds kept going off the rails.

As stated in the source: "THIS IS THE STAGE THAT WAS MISSING FROM YOUR PIPELINE. Without it, the PRD describes WHAT but not the mechanical HOW. The build drifts. The AI improvises. You get a toy."

The source also states: "This is the engine. Everything before it is preparation. Everything after it is output formatting."

## The 7 Questions (Exact Text)

For each step/mechanism in any process:

1. **WHAT happens here?** (name the action)
2. **Is there ONLY ONE way to do this, or can it vary?**
   - Only one way = WALL (deterministic, code it)
   - Can vary = DOOR or ROOM (AI might handle it)
3. **What MUST be true before this step can start?** (preconditions — these are walls that prevent skipping ahead)
4. **What are ALL the possible outcomes of this step?**
   - If you can list them ALL = deterministic
   - If they're infinite/unpredictable = AI territory
5. **For each outcome: where do you go next?** (draws the arrows between rooms)
6. **How do you VERIFY this step was done correctly?** (validation — the wall you bounce off if you try to cheat)
7. **Can this step be skipped? Ever? Under any circumstance?**
   - No = WALL
   - Yes, if [condition] = DOOR with a lock

Source: "That's it. Seven questions. Applied to every step of any process."

## Classification Rules (How Answers Map to WALL/DOOR/ROOM)

**WALL (Deterministic):** Code handles these. AI never touches them.
- Must happen exactly this way, no variation
- Session must start with context selection
- Each mechanism has exactly one way to execute
- Possible answers are from a fixed list
- Order follows a set sequence
- Results recorded in structured format
- Cannot be skipped

**DOOR (Constrained AI):** AI operates but within strict rules.
- Can rephrase but MUST contain the core requirement
- Must pick from valid options ONLY
- Can ask follow-up but ONLY to clarify the same topic, cannot drift
- Has boundaries that cannot be crossed

**ROOM (Open Floor / Free AI):** AI can be creative.
- Small talk, rapport building
- Explaining results in accessible language
- Generating summaries
- Any output where the format/content is genuinely unpredictable

## The 3-Step Prompting Process (How to Extract Walls/Doors/Rooms)

### Step 1: Map the process as a human would do it
Prompt: "I'm a [discipline] practitioner running a [session type]. Walk me through EXACTLY what happens, step by step, from the moment the client sits down. For each step, tell me: what I MUST do (non-negotiable), what I'm listening for (specific words/patterns), and what determines which direction I go next. Do NOT generalize. Be mechanical about it."

### Step 2: Separate what's a wall from what's a door from what's open floor
Prompt: "For a [discipline] session, categorize every single action into three buckets:
1. DETERMINISTIC (must happen exactly this way, no variation — these are walls)
2. CONSTRAINED AI (AI can be flexible but within strict boundaries — these are doors)
3. FREE AI (AI can be creative — this is the open room)
Be brutally specific."

### Step 3: Build the blueprint
Prompt: "Given this breakdown, write me the orchestration code that enforces the DETERMINISTIC parts as actual code, calls the AI API for the CONSTRAINED and FREE parts, and validates every AI response before showing it to the user. The AI should NEVER control what happens next — the code decides."

## The Universal Builder Prompt

"I want to build a [discipline] practitioner bot. Before ANY code, I need you to act as an architect. Map out every single step of a real [discipline] session. For each step, tell me: is this a wall (must happen exactly this way), a door (AI has constrained flexibility), or open floor (AI can be creative). Then show me what the deterministic scaffolding looks like in code."

## Inputs

- Each mechanism from Stage 4 with its chosen approach
- Martin's 1,500-line build rules (used as the LENS, not injected at the end)

## Process

1. Take each mechanism from Stage 4's output
2. Apply the 7 questions to each mechanism
3. Classify each aspect as WALL, DOOR, or ROOM
4. Martin's build rules SHAPE the scaffolding answers — "the architect follows building code WHILE designing"
5. Output: Wall/door/room blueprint for each mechanism with entry/exit conditions and validation rules

## Outputs

For each mechanism, a blueprint containing:
- Phases (grouped steps)
- For each phase:
  - Steps (walls): what code handles
  - Steps (doors): what AI handles with constraints
  - Steps (rooms): what AI handles freely
  - Entry condition: what must be true to start
  - Exit condition: what must be true to proceed
  - Validation: how to verify it worked

## Where Martin's Rules Fit

Martin's 1,500 lines are NOT injected at Stage 8 or 9. They are the LENS through which Stage 5 operates.

Source: "The 7-question scaffolding defines walls, doors, rooms for every mechanism. Martin's rules are about HOW to build correctly — separation of concerns, don't over-engineer, keep components focused, test at boundaries. Those rules SHAPE the scaffolding answers. When the system asks 'what are the walls of this mechanism?' Martin's rules inform the answer — the wall is clean, it doesn't leak state, it has a single responsibility."

"Think of it this way: Martin's rules are like building code. You don't inspect for building code after the house is designed — the architect follows building code WHILE designing."

## Related Concepts

### Finite State Machines (FSMs)
"The oldest version of this. Every 'state' is a room. Every 'transition' is a door. You can only go through doors that exist. Been around since the 1950s. Every traffic light, every vending machine, every elevator runs on this."

### Decision Trees
"Exactly your node-with-questions idea. Each node asks one question. Each answer leads to exactly one next node. Doctors use these."

### Workflow Engines
"The software version. Tools like Zapier, n8n, Node-RED, Temporal, AWS Step Functions."

### Business Process Model and Notation (BPMN)
"The corporate name for it. Every big company models their processes this way."

### Stripe Minions Connection
"Stripe didn't invent this. They applied it to AI agents. That's the insight — not the scaffolding itself, but wrapping AI inside scaffolding that already existed."

## Examples

### Example 1: Meta Programs — Toward/Away Elicitation (WALL-heavy)

```
Step: Elicit Toward/Away
1. WHAT: Ask the client what they want in their context
2. ONLY ONE WAY? The core question is fixed. Delivery can vary.
   → The question itself = WALL
   → How you phrase it conversationally = DOOR (AI, constrained)
3. PRECONDITION: Context must already be established. Can't run without it. WALL.
4. POSSIBLE OUTCOMES: Toward, Away, Toward-lean, Away-lean. That's it. Four options. WALL.
5. NEXT: Move to Internal/External elicitation. Always. WALL.
6. VERIFY: Response must contain language matching one of the four patterns. Check keywords. WALL.
7. SKIP? No. Never. WALL.
```

Result: "See how most of it is walls? The only 'door' is how the AI phrases the question conversationally. Everything else is rigid."

### Example 2: Explain Results to Client (ROOM-heavy)

```
Step: Explain results to client
1. WHAT: Summarize their meta program profile in plain language
2. ONLY ONE WAY? No — infinite ways to explain it. OPEN FLOOR.
3. PRECONDITION: All meta programs must be elicited. WALL.
4. POSSIBLE OUTCOMES: Unpredictable — depends on client. AI.
5. NEXT: End session or move to intervention. DOOR.
6. VERIFY: Must reference all identified meta programs. Partial WALL (checklist validation).
7. SKIP? Yes, if client doesn't want explanation. DOOR.
```

### Example 3: The Coding Session Anti-Pattern

"If you'd run those seven questions on today's session, question 2 would have caught it: 'Is there only one way to do this?' Answer: 'No — we could consult OR build.' That's a DOOR. And question 3: 'What must be true before we start?' Answer: 'User must choose consulting vs building, and if building, tech stack must be reviewed.' WALL. I would never have gone rogue."

## Code Examples

### Python Orchestration — Deterministic Scaffolding

```python
# This is the wall. Code. Not AI.
META_PROGRAMS = {
    "toward_away": {
        "question": "What do you want in your {context}?",
        "valid_results": ["toward", "away", "toward_lean", "away_lean"],
        "keywords_toward": ["want", "achieve", "gain", "get"],
        "keywords_away": ["avoid", "don't want", "prevent", "escape"],
    },
    "internal_external": {
        "question": "How do you know you've done a good job at {context}?",
        "valid_results": ["internal", "external", "internal_lean", "external_lean"],
    },
}

# This is the hallway. You walk through in order. No skipping.
SESSION_SEQUENCE = [
    "establish_context",     # deterministic
    "build_rapport",         # free AI
    "elicit_toward_away",    # constrained AI
    "validate_toward_away",  # deterministic
    "elicit_internal_external",  # constrained AI
    "validate_internal_external", # deterministic
]

# The AI can ONLY do what this function allows
def run_elicitation(meta_program, context, conversation_history):
    response = claude_api.call(
        system_prompt=f"""You are eliciting the {meta_program} meta program.
        Context: {context}
        Ask THIS question naturally: {META_PROGRAMS[meta_program]['question']}
        You may rephrase but the CORE question must be asked.
        Do NOT discuss anything else. Do NOT move to another topic.
        Do NOT diagnose. Just ask and listen.""",
        messages=conversation_history
    )

    # WALL: validate before showing to user
    if not contains_core_question(response, meta_program):
        response = re_prompt(meta_program, context)

    return response
```

### The Era 7 Room Prompt Template

"You are inside the [phase name] phase of a [discipline] session. The walls around you are: [list constraints]. You CANNOT leave this phase until [exit condition]. Within these walls, you may [list freedoms]. The client's context is: [structured data from previous phases]. Be natural, be adaptive, be brilliant — but stay in this room."

### The Practitioner Template (Era 4 — Reusable Blueprints)

```
PRACTITIONER TEMPLATE:
  Name: ___________
  Discipline: ___________

  PHASE TEMPLATE (repeat for each phase):
    Phase name: ___________
    Entry condition: ___________ (what must be true to enter)
    Exit condition: ___________ (what must be true to leave)

    STEP TEMPLATE (repeat for each step):
      Step name: ___________
      [Seven questions applied here]
      Wall/Door/Room classification: ___________

  VALIDATION TEMPLATE:
    For each wall: exact check to perform: ___________
    For each door: constraints on AI: ___________
    For each room: topic boundaries: ___________
```

## Key Insights

1. "The seven questions work because every human process — ALL of them — is actually already made of walls and doors. Humans just don't see it because we navigate them unconsciously."

2. "Every 'bot' that works well has this same pattern. The AI is never the architect. The AI is the painter. Code builds the house — the rooms, walls, doors. The AI paints the walls, makes it feel warm, talks like a human. But it can't knock down a wall."

3. "You're not building bots. You're building a bot that builds the walls for other bots. That's the factory."

4. "The universal builder is those seven questions applied to every step. That's it. That's the whole thing."

## The 7-Era Framework (How Stage 5 Fits in the Bigger Picture)

- Era 2: Seven questions → find the walls (THIS IS STAGE 5)
- Era 3: Group steps into phases → organize the rooms (feeds into Stage 7)
- Era 4: Template it → stamp out blueprints for any discipline
- Era 5: Define interfaces → let bots talk to each other
- Era 6: Build the orchestrator → manage the whole client journey
- Era 7: Put AI in the rooms → make it actually intelligent

"What you build FIRST: Era 2-4. That's the meta-bot, the scaffolding builder."

## Stage Numbering Evolution

- In the original 9-stage pipeline, this was "Stage 5: DETERMINISTIC SCAFFOLDING"
- In the unified layer architecture, it appears as "LAYER 5: SEVEN-QUESTION SCAFFOLDING"
- In the final 10-stage pipeline, it is "Stage 5: 7-QUESTION SCAFFOLDING"
- All versions maintain the same position: after mechanism extraction, before wireframing/layout

## Connections to Other Stages

**Receives from Stage 4:** List of mechanisms, each tagged as OBVIOUS or NEEDS_EVALUATION, with chosen approaches for evaluated mechanisms.

**Feeds into Stage 6:** Wall/door/room blueprints that tell the wireframing stage exactly what components exist, how they connect, and what each one does. "Wireframing without Stage 5 is guessing. Wireframing WITH Stage 5 is deterministic — you're just arranging known pieces."

**Martin's rules (from mentor's 1,500 lines):** Baked into Stage 5 as the lens. The scaffolding answers reflect his principles — separation of concerns, single responsibility, test at boundaries.

**Stage 8 (Protocol Injection) depends on Stage 5:** The protocols enforce what Stage 5 defines. Pulse checks verify walls are intact. Seam checks verify doors connect properly. Full checkpoints verify the whole room is correctly built.

## Edge Cases & Debates

1. **Mechanisms that are 100% ROOM:** Some mechanisms (like "generate a marketing tagline") might have no walls at all. This is valid — not everything needs deterministic scaffolding. But the 7 questions should still be asked to confirm there truly are no walls.

2. **Where Martin's rules live:** Explicitly settled — they are the LENS for Stage 5, not injected at Stage 8/9. "You don't inspect for building code after the house is designed — the architect follows building code WHILE designing."

3. **The 15% threshold from Stage 4:** When two approaches score within 15% of each other, both get designed through Stage 5. Both get full scaffolding. The branch test happens during the build phase. Stage 5 doesn't pick winners — it scaffolds whatever Stage 4 gives it.
