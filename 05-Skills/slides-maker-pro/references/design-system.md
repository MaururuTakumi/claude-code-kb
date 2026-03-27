# Design System (slides-maker-pro)

## 1) Color tokens
```js
const C = {
  bgWhite: "FFFFFF",
  bgSoft: "F6F8FB",
  textMain: "1A1A1A",
  textBody: "333333",
  textMuted: "7A7A7A",

  navy: "0B1F3F",
  blue1: "1B3A6B",
  blue2: "3D6098",
  blue3: "7A9CC6",
  blue4: "B8CCE4",

  line: "D0D6DE",
  accentRed: "C8102E",
  accentGreen: "2E7D32"
};
```

## 2) Typography
- Action title: Yu Mincho / MS Mincho fallback, 18pt, bold, color `navy`
- Section heading: Yu Mincho, 14pt, bold
- Body: Yu Gothic / Meiryo fallback, 10.5–12pt
- Numeric KPI: Calibri, 24–36pt, bold
- Source/footer: Yu Gothic, 8pt, muted

## 3) Canvas and margins
- Standard 16:9 layout
- Margins: 0.5 in all sides
- Content grid: 12-column mental grid
- Keep 6–8% whitespace minimum on each slide

## 4) Required slide chrome
- Thin divider line under action title (`blue1`, 0.5pt)
- Footer with page number right-bottom
- Source line left-bottom for data slides

## 5) Visual rules
- Prefer flat charts (no 3D)
- At most 5 series colors per chart (blue gradient)
- Use red only for risk/downside
- Keep table borders hairline (`line`, 0.5pt)

## 6) Title quality rule
Use declarative insight title:
- Good: 「B2B経由売上は前年比34%増で、成長の主因は大型案件化」
- Bad: 「売上分析」

## 7) Accessibility and readability
- Ensure contrast between text and background
- Avoid light gray text for critical statements
- Avoid lines below 0.5pt for key separators
