---
name: slides-maker-pro
description: Create high-quality editable PowerPoint slides (.pptx) from almost any topic (business, research, strategy, product, operations, education) with consistent consulting-grade structure and design. Trigger whenever the user asks to create slides, PowerPoint, deck, presentation, proposal deck, report slides, training slides, or to convert text/notes/article/URL into slides. Also trigger for Japanese requests like 「スライド作成」「パワポ作成」「資料作成」「プレゼン資料」 and English requests like "make slides", "build a deck", "PowerPoint", "pptx", "presentation".
---

# slides-maker-pro

Generate **editable** high-quality `.pptx` decks with stable quality across topics.

## Required preload
Before authoring slides, read:
1. `/mnt/skills/public/pptx/SKILL.md`
2. `/mnt/skills/public/pptx/pptxgenjs.md`
3. `slides-maker-pro/references/design-system.md`
4. `slides-maker-pro/references/slide-archetypes.md`
5. `slides-maker-pro/references/qa-checklist.md`

If any preload file is unavailable, continue with available files and explicitly apply the same principles.

## Core operating principle
Do not start by drawing slides.
Always run this sequence:

1. **Intent framing** (why this deck exists)
2. **Audience framing** (who decides / who consumes)
3. **Message pyramid** (one-line conclusion + 3 supporting claims)
4. **Slide blueprint** (page-by-page purpose)
5. **PPTX implementation**
6. **QA + fix pass**

## Quality contract (must satisfy)
- Editable `.pptx` output (no image-only slides)
- Action-title on every content slide
- 1 slide = 1 key message
- Clear visual hierarchy (title > key stat > support detail)
- At least one meaningful visual object per content slide (chart/table/framework/timeline/process)
- Source line for factual or numeric content
- Overflow-free layout (no clipped text)
- Consistent design tokens

## Default deck lengths
- If user does not specify length:
  - Quick brief: 6 slides
  - Standard: 8 slides
  - Deep analysis: 10–12 slides

## Universal slide blueprint (default 8)
1. Title + context
2. Executive summary (3 findings)
3. Current state / background
4. Analysis 1 (data chart)
5. Analysis 2 (framework or comparison)
6. Options / scenarios
7. Recommendation + roadmap
8. Risks / next actions

Use archetype-specific alternatives from `references/slide-archetypes.md` when needed.

## Content ingestion rules
When user provides URLs/files/notes:
- Extract facts, numbers, claims, and uncertainties
- Distinguish fact vs assumption
- If data is missing, use clearly marked assumptions: `（試算・仮定）`
- Preserve user terminology when domain-specific

## Writing rules (Japanese-first, works bilingual)
- Prefer short business sentences
- Use action-title style, not topic labels
- Avoid abstract slogans without operational implication
- Add “so what” statement for each slide
- For Japanese text, allocate wider text boxes and slightly larger type

## Visual composition rules
- Use charts for trends/comparisons
- Use tables for exact values
- Use 2x2/process/timeline for strategic structure
- Do not overload a single slide with >3 primary visual zones
- Use accent color sparingly to direct attention

## Required production workflow

### Step 1: Plan JSON (internal)
Create a compact internal plan with:
- audience
- objective
- chosen archetype
- slide_count
- per-slide: title, purpose, visual_type, required_data

### Step 2: Author pptx
- Implement deck with design tokens from `design-system.md`
- Keep title and body styles consistent
- Add footer page number
- Add source lines where relevant

### Step 3: QA gate
Run checklist from `qa-checklist.md`.
If any critical failure exists (overflow, unreadable contrast, broken hierarchy), fix before final output.

### Step 4: Deliver
Return:
1. `.pptx` file
2. short summary of structure (slide 1..N)
3. assumptions list

## Fallback behavior
If user request is vague (“スライド作って” only):
- Assume standard 8-slide executive deck
- Theme from provided materials
- If no materials: create a robust draft deck and explicitly mark assumptions

## Anti-patterns (never)
- Image-only slide exports
- Generic titles like 「概要」「まとめ」 without insight
- Dense paragraphs as main content blocks
- Inconsistent fonts/colors every slide
- Decorative visuals with no decision value

## Fast trigger phrases (examples)
- 「この内容でスライド作って」
- 「パワポ化して」
- 「提案書デッキ作って」
- 「このURLを資料化して」
- "make a deck from this"
- "create powerpoint"
- "turn this article into slides"
