# Stage 6: LAYOUT + MOCKUPS + STYLE — Extraction Dossier

## Purpose

Stage 6 takes the classified mechanisms from Stage 5 (with their Wall/Door/Room blueprints) and arranges them into visual structure: page layouts, navigation patterns, UI mockups, and style selection. In the final 10-stage pipeline, this stage absorbed what were originally two separate stages (Wireframing and UI Style) into one stage with three sub-steps.

Source: "Now you know every mechanism, every wall, every door, every room. So NOW you can lay out pages. You know the auth system has 3 screens. You know the dashboard has 5 widgets. You know which doors connect which rooms. Wireframing without Stage 5 is guessing. Wireframing WITH Stage 5 is deterministic — you're just arranging known pieces."

## Sub-stages

### 6a: ARRANGEMENT SELECTION
Three layout options presented to the user:
- Sidebar navigation
- Top navigation
- Tabbed interface

The app TYPE determines the wireframe pattern. This is a LOOKUP, not AI creativity:

```
APP TYPE → WIREFRAME PATTERN (deterministic — 92% case)
Dashboard app → sidebar + top nav + main content grid + cards
Chat app → conversation list + message thread + input bar
Wizard/form app → step indicator + single form area + next/back
Marketplace → search bar + filter sidebar + product grid
Tool app → toolbar + workspace + properties panel
Landing page → hero + features + testimonials + CTA
Settings → tab list + form sections
```

"The AI identifies the app type from your concept. The wireframe pattern is deterministic — it's the 92% case. The AI then shows you the layout and asks: 'This is the standard. Want to adjust anything?'"

"That question IS deterministic. It's a wall. You can't skip it. The build can't start until you've approved or modified the wireframe."

### 6b: PAGE MOCKUPS
User sees and approves each page layout. Iterative process.

For each page, the output includes:
- Layout pattern (from app type lookup)
- Components (what's on the page)
- Connections (what each component triggers)
- User approved: yes/no — WALL, can't skip

Source: "The wireframe answers: 'What does the user SEE?' The scaffolding answers: 'What does the machine DO?' Both go into the PRD."

### 6c: STYLE SELECTION
3 curated styles rendered on THEIR mockups. Not 12 options — 3 curated ones matched to the app type, plus a "Choose for me" default button.

Key design decisions discussed in the source:
- Don't give 12 choices (decision paralysis). Give 3 curated options.
- The full style catalog is a premium upgrade.
- The upgrade happens AFTER the app is built, not before. Never put an upgrade option between the user and completion.

## Inputs

- Wall/Door/Room blueprints from Stage 5
- Structured concept from Stage 3
- Mechanism list from Stage 4

## Process

1. Identify app TYPE from concept (dashboard, chat, wizard, marketplace, tool, landing)
2. Pull standard wireframe pattern for that type (deterministic lookup)
3. Present 2-3 wireframe/arrangement options
4. User picks or adjusts (WALL — can't skip this approval)
5. For each page: identify components, placement, connections to mechanisms
6. Present 3 curated style options rendered on the user's actual mockups
7. User selects style (or "Choose for me" default)

## Outputs

For each page:
- Layout pattern selected
- Components placed with connections defined
- Style applied (colors, typography, spacing, component styling)
- User approval recorded

## The Style Set System (from AutoForge)

### 12 Predefined Styles

| ID | Name | Best For |
|----|------|----------|
| flat-design | Flat Design | Clarity, scalability, universal appeal |
| minimalism | Minimalism | Premium feel, Apple-style elegance |
| neumorphism | Neumorphism | Finance apps, dashboards, toggles |
| glassmorphism | Glassmorphism | Modern SaaS, trendy products |
| skeuomorphism | Skeuomorphism | Familiarity, older demographics |
| neubrutalism | Neubrutalism | Young/edgy, Gen Z products |
| bauhaus | Bauhaus | Design-forward, artistic |
| claymorphism | Claymorphism | Friendly, approachable products |
| retro-futurism | Retro Futurism | Gaming, entertainment |
| cyberpunk | Cyberpunk | Edgy tech, gaming |
| dark-mode | Dark Mode Elegant | Developer tools, media apps |
| warmer-shades | Warmer Shades | Nostalgic, comfortable feel |

### Style Data Structure
Each style contains complete design tokens:
- Color tokens (brand, surface, text, border, status colors with light/DEFAULT/dark variants)
- Typography (font family, hierarchy with sizes/weights/line-heights)
- Component styling (border radius, shadows, spacing)
- Tailwind config
- Audience/vibe/age recommendation scores

### Live Preview System
- StyleCardPreview: Mini 120-150px tile previews
- StylePreview: Full live preview renderer (~2000 lines), renders 4 sample pages (Landing, Dashboard, Settings, Feed)
- StyleFullPreview: Full-screen overlay with style selector strip, page tabs, modifier toggles, accent selector
- Token resolution system merges base style + accent + accessibility modifiers

### Screenshot-to-Theme Engine
- Sends screenshots to Claude's vision API with production extraction prompt
- Extracts "Visual DNA": color tokens, typography hierarchy, component patterns, Tailwind config
- Classifies into one of the 12 known styles with confidence levels
- Output is platform-agnostic — feeds into any framework
- Uses the mentor's "Idea Code" / 5-page methodology

### Style as Sales Engine (Graphic Pack Pricing)
The style selection integrates into Stage 6c but is also a standalone product:
- FREE: Upload image → get style sheet (costs ~$0.02 in API calls) → captures email
- $9.95: Convert to full theme (all pages styled consistently)
- $49-149: Full graphic pack (logo variants, favicon, app icon, page layouts, social media cards, icon pack, email templates, business card template)
- $19/mo: Membership for serial builders

Every deliverable is a prompt. Logo = prompt. Icons = prompt. All generated from the style sheet. Zero marginal cost. 95%+ margins.

### IP Protection for Style System
The theme switcher does NOT get baked into the user's app code. If it did, they could extract it and become a competitor. Instead:
- Style changes go back through the platform
- Users get a transformation script (CSS variable swaps)
- The intelligence stays on the server
- They can't reverse-engineer the style engine from find-and-replace operations

## Rules & Constraints

1. Wireframe pattern is deterministic — based on app type lookup, not AI creativity
2. User MUST approve layout before build starts (WALL — can't skip)
3. Style is applied AFTER layout, not before: "You don't pick colors before you know how many pages you have"
4. Don't give 12 style choices — give 3 curated options to prevent decision paralysis
5. Style upgrade happens AFTER app is built, never between user and completion

## Stage Numbering Evolution

- In the early pipeline, Wireframing was Stage 6 and UI Style was Stage 7 (separate stages)
- In the final 10-stage pipeline, they were combined: Stage 6 with sub-steps 6a/6b/6c
- This consolidation moved Phase Sequencing from Stage 8 to Stage 7

## Connections to Other Stages

**Receives from Stage 5:** Wall/Door/Room blueprints for all mechanisms. This tells Stage 6 exactly what components exist and how they connect. Without Stage 5, wireframing is "guessing."

**Feeds into Stage 7 (Phase Sequencing):** Complete visual specification — page layouts, component placement, style tokens. Stage 7 needs the FULL picture (mechanisms + scaffolding + wireframes + style) to intelligently split into build phases.

**Receives from AutoForge systems:** The 12 predefined styles, the screenshot-to-theme engine, the live preview renderer, and the dependency graph system are all existing AutoForge components that feed into this stage.

## Edge Cases & Debates

1. **What if the app doesn't fit standard patterns?** The 92% case covers most apps. For the 8% that don't fit, the AI presents the closest match and asks the user to adjust. The adjustment step is still a WALL — it can't be skipped.

2. **Style before vs after wireframe:** Explicitly settled — style comes AFTER layout. "If you did style first, you'd be making aesthetic decisions without knowing the scope of what you're styling."

3. **12 choices vs 3 curated:** The full catalog of 12 is available as a premium feature, but the default flow shows only 3 matched to the app type to prevent decision paralysis.
