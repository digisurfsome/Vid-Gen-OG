# Stage 7: PHASE SEQUENCING -- Extraction Dossier

## Purpose

Takes the complete spec (mechanisms scaffolded, wireframes approved, style selected) and splits it into build phases using math-based calculations. Each phase becomes a self-contained "containment unit" with its own file sandbox, build order, and dependency mapping. Stage 7 does the rough split; Stage 8 (Protocol Injection) then injects enforcement protocols into each phase; a quick validation confirms everything still fits within the token budget.

## Token Budget Math

```
TOTAL BUDGET: 500,000 tokens (50% of 1M context)

PER-PHASE OVERHEAD (fixed costs):
├── Bookend: Build rules preamble          ~8,000 tokens
├── File sandbox declaration               ~2,000 tokens
├── Build order with pulse points          ~3,000 tokens
├── Seam check definitions                 ~2,000 tokens
├── Full checkpoint at end                 ~5,000 tokens
├── Pattern verification prompt            ~3,000 tokens
├── Violation handling instructions        ~2,000 tokens
└── TOTAL OVERHEAD PER PHASE:             ~25,000 tokens

AVAILABLE FOR ACTUAL BUILD CONTENT:
500,000 - 25,000 = 475,000 tokens per phase MAX

TARGET (with buffer):
35% of context = 350,000 tokens per phase
350,000 - 25,000 overhead = 325,000 tokens for actual build instructions
```

**Phase count calculation process:**

1. Take the full Agent OS document from Stages 3-5.
2. Estimate its total token count.
3. Divide by 325,000 to get number of phases needed.
4. Find natural break points (mechanism boundaries) near those division points.
5. Verify each phase chunk fits within budget WITH overhead added back.

**Worked example:**

```
Total PRD content: 900,000 tokens
900,000 / 325,000 = 2.77 --> 3 phases
Phase 1: ~300K content + 25K overhead = 325K (35% of context)
Phase 2: ~300K content + 25K overhead = 325K
Phase 3: ~300K content + 25K overhead = 325K
```

The overhead is predictable because it is templated. The preamble is the same text every time (with project-specific file lists swapped in). The checkpoint protocol is the same structure every time. This allows advance calculation -- account for overhead BEFORE splitting, not after.

## File Sandbox System

Each phase gets three file classifications:

```
Phase 1: Auth System
├── FILES ALLOWED: [exact list of files this phase can create/modify]
├── FILES READ-ONLY: [files it can reference but NOT change]
├── FILES FORBIDDEN: [everything else]
```

**Concrete example:**

```
SANDBOX RULES:
==============
You may ONLY create or modify files in:
  - api/social-posting.ts (NEW)
  - src/pages/SocialPostingPage.tsx (NEW)
  - src/lib/social-posting.ts (NEW)
  - src/App.tsx (ADD ONE ROUTE ONLY)
  - supabase/migrations/00007_social_posting.sql (NEW)

You may READ but NOT MODIFY:
  - api/generate-video.ts (reference for auth pattern)
  - src/lib/credits.ts (reference for database pattern)
  - CLAUDE.md

You may NOT touch:
  - ANY existing migration files
  - src/lib/supabase.ts
  - src/contexts/AuthContext.tsx
  - api/stripe-webhook-simple.ts
  - ANY files in src/components/ui/
```

The file sandbox and build order are PART of the phase definition. They are what makes a phase a phase. Without them, a phase is just a label. WITH them, a phase is a containment unit.

**Enforcement model -- alarm system, not a fence:**

The agent CAN touch whatever it wants during the build. After it finishes, `git diff --name-only $SNAPSHOT` captures EVERY file that was created, modified, or deleted. This is compared against the allowed list. Unauthorized changes trigger rollback. The agent is not physically prevented from touching files; messed-up work is detected and never survives.

## Build Order System

Each phase specifies a forced linear sequence for file creation/modification:

```
├── BUILD ORDER:
│   1. Create src/lib/auth.ts (core logic first)
│   2. Create src/contexts/AuthContext.tsx (state management second)
│   3. Create src/pages/SignIn.tsx (UI third)
│   4. Create src/pages/SignUp.tsx (UI fourth)
│   5. Wire routes in App.tsx (integration last)
└── DEPENDS ON: nothing (Phase 1)
```

**Why build order matters:** It forces the agent into a pattern. Without it, the agent jumps around -- starts a component, realizes it needs a hook, goes to make the hook, realizes the hook needs a type, goes to make the type, comes back to the component, realizes the route is not set up. That chaos is where drift happens. A forced sequence means the agent does ONE thing, finishes it, does the NEXT thing, finishes it. Linear. Predictable. Auditable.

The build order follows Martin's patterns: core logic --> state --> UI --> integration.

## Inputs

- Complete Agent OS document from Stages 3-5 (all mechanisms scaffolded with walls/doors/rooms)
- Approved wireframes from Stage 6a/6b (arrangement selection and page mockups)
- Applied style set from Stage 6c (style selection)
- Martin's build rules (already embedded as the lens in Stage 5, manifesting in build order as core logic --> state --> UI --> integration)
- Total token count estimate of the full spec

## Process

1. **Estimate total token count** of the full Agent OS document (Stages 3-5 output).
2. **Divide by 325,000** to determine the number of phases needed.
3. **Find natural break points** at mechanism boundaries near the mathematical division points.
4. **Assign each phase** its file sandbox (ALLOWED / READ-ONLY / FORBIDDEN lists).
5. **Define build order** within each phase (forced linear sequence).
6. **Define dependencies** between phases (Phase 2 DEPENDS ON Phase 1, etc.).
7. **Verify fit** -- each phase chunk must fit within 350,000 tokens (325,000 content + 25,000 overhead).

Stage 7 does a ROUGH split based on estimated overhead. Stage 8 then injects the actual protocols (pulse/seam/checkpoints). A quick validation confirms it still fits. If not, adjust the split point. This is a single pass, not a back-and-forth loop.

## Outputs

Per-phase specifications, each containing:

```
Phase [N]: [Feature/System Name]
├── FILES ALLOWED: [exact list]
├── FILES READ-ONLY: [exact list]
├── FILES FORBIDDEN: [everything else]
├── BUILD ORDER:
│   1. [file] (rationale)
│   2. [file] (rationale)
│   ...
├── DEPENDS ON: [previous phase(s)]
└── [Content: the actual build instructions, ~325,000 tokens max]
```

These phase specs then flow into Stage 8 (Protocol Injection) where pulse checks, seam checks, full checkpoints, and violation handling get embedded inline.

## Rules & Constraints

1. **500,000 token total budget** -- 50% of the 1M context window. Never exceed this.
2. **~25,000 tokens per-phase overhead** is fixed and predictable (build rules preamble ~8K, file sandbox ~2K, build order with pulse ~3K, seam check ~2K, full checkpoint ~5K, pattern verification ~3K, violation handling ~2K).
3. **Target 35% of context = 350,000 tokens per phase** (325,000 for build content + 25,000 overhead).
4. **Split at mechanism boundaries** -- never cut a mechanism in half across phases.
5. **Every phase must have all three sandbox tiers** -- ALLOWED, READ-ONLY, FORBIDDEN.
6. **Build order is mandatory** -- no phase ships without a forced linear sequence.
7. **Dependencies between phases must be explicit** -- Phase N states what must be complete before it starts.
8. **The overhead is templated** -- the preamble, sandbox format, checkpoint protocol are reused across all phases with project-specific values swapped in.
9. **Stage 7 does rough split; Stage 8 injects protocols; validation confirms fit** -- this is a single forward pass, not iterative.
10. **Buffer zone** -- the 35% target (vs. the theoretical ~47.5% max) provides significant headroom. No reason to push right up to the wall.

## Examples

**Three-phase split for a 900,000-token spec:**

```
Total PRD content: 900,000 tokens
900,000 / 325,000 = 2.77 --> 3 phases

Phase 1: Auth System (~300K content + 25K overhead = 325K)
├── FILES ALLOWED: src/lib/auth.ts, src/contexts/AuthContext.tsx,
│   src/pages/SignIn.tsx, src/pages/SignUp.tsx, src/App.tsx (route only)
├── BUILD ORDER:
│   1. src/lib/auth.ts
│   2. src/contexts/AuthContext.tsx
│   3. src/pages/SignIn.tsx
│   4. src/pages/SignUp.tsx
│   5. Wire routes in App.tsx
└── DEPENDS ON: nothing

Phase 2: Dashboard + Features (~300K + 25K = 325K)
├── [sandbox lists]
├── [build order]
└── DEPENDS ON: Phase 1

Phase 3: Polish + Integration (~300K + 25K = 325K)
├── [sandbox lists]
├── [build order]
└── DEPENDS ON: Phase 2
```

**Phase structure after Stage 8 (Protocol Injection) enriches it:**

```
Phase 1: Auth System
├── FILES ALLOWED: [list]
├── BUILD ORDER:
│   1. Create src/lib/auth.ts
│      <-- PULSE after this file
│   2. Create src/contexts/AuthContext.tsx
│      <-- PULSE after this file
│   3. Create src/pages/SignIn.tsx
│      <-- PULSE after this file (3 files done = pulse cycle complete)
│      <-- SEAM CHECK: does SignIn.tsx import from AuthContext?
│        Does AuthContext import from auth.ts? Are the doors connected?
│   4. Create src/pages/SignUp.tsx
│      <-- PULSE after this file
│   5. Wire routes in App.tsx
│      <-- PULSE after this file
│      <-- SEAM CHECK: do routes point to actual page components?
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

## Connections to Other Stages

- **Stage 5 (7-Question Scaffolding):** Provides the complete mechanism definitions (walls/doors/rooms) that Stage 7 must split across phases without cutting any mechanism in half.
- **Stage 6a/6b/6c (Wireframing + Style):** Provides the approved visual layout and style that inform which UI files belong in which phase.
- **Stage 5 via Martin's rules:** The build order within phases follows Martin's patterns (core logic --> state --> UI --> integration), which were baked in during Stage 5 as the architectural lens.
- **Stage 8 (Protocol Injection):** Takes the rough phase splits from Stage 7 and injects pulse checks, seam checks, full checkpoints, and violation handling inline within each phase. Stages 7 and 8 are tightly coupled -- separate because 7 is about STRUCTURE (what goes where, in what order) and 8 is about ENFORCEMENT (how do we verify it was followed). In the final output, they merge into a single integrated phase spec.
- **Stage 9 (Verification Agent Setup):** Defines the independent verifier agent that validates each phase's output at runtime using the sandbox lists and build orders defined in Stage 7.
- **Stage 10 (Output):** Renders the final deliverables -- phases/*.md files, build.sh, CLAUDE.md, BUILD_RULES.md. The phase files contain the fully integrated output of Stages 7 + 8 + 9. The build rules preamble (~8,000 tokens) that appears at the top of every phase originates from Martin's rules distilled through Stage 5.

**Note on stage numbering:** In earlier iterations of the pipeline, Phase Sequencing was Stage 8 and UI Style was Stage 7. After Stage 6 was expanded into sub-stages (6a: Arrangement Selection, 6b: Page Mockups, 6c: Style Selection), the style step was absorbed into Stage 6c, and Phase Sequencing moved up to become Stage 7 in the final numbering.
