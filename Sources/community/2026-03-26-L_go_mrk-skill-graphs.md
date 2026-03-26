# AI駆動塾 (@L_go_mrk) — Skill Graphsを知っているか

> ObsidianのWikilinkを活用した、Claude Codeスキルの革新的な構造設計。
> 「1ファイル＝1能力」の限界を超えるグラフ構造。

🔗 https://x.com/L_go_mrk/status/2034974982300979428
📊 ❤️514 🔁46 👁142K
📅 2026-03-21
👤 AI駆動塾 (@L_go_mrk)

元ネタ: @arscontexta の長文投稿
https://x.com/arscontexta/status/2023957499183829467

## 核心コンセプト: Skill Graph

### 従来のSkills（限界あり）
- 1ファイル＝1能力（SKILL.md 単体方式）
- 投資判断、法律解釈、業務フローなど「本当に深い思考パターン」を扱うには限界
- ファイルが肥大化するか、浅い記述で終わるかの二択

### Skill Graph（革新）
- **ObsidianのWikilinkを最大限活用**
- 複数の小さなMarkdownファイルを**ネットワーク状に繋げたグラフ構造**で知識と思考パターンを構築
- AIが自分で**グラフを探索しながら必要な断片だけをピンポイントで引き出す**
- 従来の「浅いスキル」から脱却し、**本物の「第二の脳」として機能**

### 構造イメージ
```
investment-analysis/
├── entry.md                  ← AIが最初に読むエントリポイント
├── fundamentals/
│   ├── valuation.md          ← [[dcf-model]] [[comparable]] にリンク
│   ├── dcf-model.md          ← 具体的な計算パターン
│   └── comparable.md
├── risk/
│   ├── risk-assessment.md    ← [[market-risk]] [[credit-risk]] にリンク
│   └── ...
└── decision/
    └── final-judgment.md     ← 全ノードを統合して判断
```

AIは `entry.md` から始めて、タスクに応じて必要なノードだけを辿る（= [[Progressive Disclosure]]）。

### arscontextaプラグイン
- 投稿者本人が開発した**無料Obsidianプラグイン**
- Skill Graphを効率的に作れるツール
- AIと一緒にグラフ構造のスキルネットワークを構築

## この知識のKBへの反映

### 直接関連するKBセクション
- [[01-Architecture/Skill Architecture]] ← Skill Graph設計を追加すべき
- [[05-Skills/Skill Anatomy]] ← 単体ファイル方式との比較を追加
- [[Sources/community/2026-03-26-thariq-claude-code-tips#6]] ← ThariqのSkills論と接続

### Thariqの「Progressive Disclosure」との接続
Thariqが言う「一気に全部見せず、段階的に情報到達させる」は、
まさにSkill Graphの「AIがグラフを自分で探索する」設計と同じ思想。

- Thariq: ツール設計レベルでProgressive Disclosure
- Skill Graph: スキル内部の知識構造レベルでProgressive Disclosure
- **両方を組み合わせるのが最強**

### 今のclaude-code-kbへの示唆
**このKB自体がSkill Graphの実装例になっている。**
- MOC.md = entry.md（エントリポイント）
- 01-Architecture/ 内の各ファイル = グラフノード
- [[ウィキリンク]] = グラフのエッジ

改善点:
- 各ファイルの冒頭に「このファイルから辿れる関連ノード」を明示する
- entry.md → 2-3ホップで目的のノードに到達できる深さに保つ
- ファイルが肥大化したら分割して、リンクで繋ぐ

## note（有料全文）
https://note.com/l_mrk/n/ne638c6da16f3
メンバーシップ: https://note.com/l_mrk/membership
