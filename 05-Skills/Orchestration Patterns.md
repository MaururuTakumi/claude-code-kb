# Orchestration Patterns — 複数処理をまとめるSkillの設計

> 複雑なSkillは「SKILL.mdに全部書く」のではなく、
> 処理を分離してオーケストレーションする。

関連: [[Skills Reference]] [[Harness Design]] [[Subagent Orchestration]]

## 2つのアーキテクチャ

### Sub-agent型（並列処理向き）

```
SKILL.md（オーケストレーター）
  ├── Spawn → agents/grader.md（評価）
  ├── Spawn → agents/comparator.md（比較）← 並列実行
  └── Spawn → agents/analyzer.md（分析）
  ↓
  集約 → フィードバック → 改善ループ
```

**特徴:**
- SKILL.md 自体は処理しない。「いつ・誰に・何を任せるか」だけ
- サブエージェントが親のコンテキストを継承
- 並列Spawnで時間短縮
- agents/ に専門家プロンプトを分離 → コンテキスト効率が高い

**適するケース:**
- 同じデータに複数の視点で並列に処理する
- 評価・比較・分析を分離したい
- Human-in-the-Loopのフィードバックループ

### Skill Chain型（直列処理向き）

```
trigger-skill（全体制御）
  ↓
skill-A（Phase 1: 調査）
  ↓
skill-B（Phase 2: 実行）
  ↓
skill-C（Phase 3: レポート）
```

**特徴:**
- 各スキルが独立（SKILL.md + scripts/ + references/ を個別に持つ）
- 単体でも使える（skill-Aだけ呼んで調査だけする等）
- 各スキルが自分のドメインだけ保持 → コンテキスト汚染なし

**適するケース:**
- 処理に明確な順序性がある（調査→実行→レポート）
- フェーズごとに責務が全く異なる
- 各フェーズを単体で再利用したい

## 選択基準

| 軸 | Sub-agent型 | Skill Chain型 |
|----|------------|---------------|
| 処理フロー | 並列 | 直列 |
| コンテキスト | 親を継承 | 各スキル独立 |
| 単体利用 | 不可 | 可能 |
| 拡張方法 | agents/ 追加 | references/ 追加 |
| スクリプト | 必須コンポーネント | オプショナルツール |

**両方を融合も可能:** Skill Chainの各フェーズ内でSub-agentを並列Spawnする設計。

## Schema契約（AI⇔スクリプトの接続点）

AIとスクリプトが連携するSkillでは、**references/schemas.md** でデータ形式を厳密に定義する。

### なぜ必要か
AIの出力はフォーマットがブレる。`configuration` を `config` と書いたり、
ネスト構造を変えたりする。スクリプト側がパースに失敗して壊れる。

### パターン
```
SKILL.md: 「references/schemas.md のフォーマットに従え」
  ↓
AI: スキーマ通りにJSON出力
  ↓
scripts/aggregate.py: スキーマを前提にパース
  ↓
viewer/: スキーマを前提にHTML生成
```

### 書き方
```markdown
# schemas.md

## grading.json
{
  "configuration": "with_skill",  ← "config"ではダメ
  "pass_rate": 0.85,              ← ネスト内に置く
  "assertions": [...]
}

⚠️ フィールド名を短縮しないこと。ビューアが空値を表示する。
```

**教訓:** Schema契約はSkillの最初に設計する。後から合わせるのは困難。

## SKILL.mdをオーケストレーターにする設計

SKILL.md に専門処理の詳細を書かない。

```
SKILL.md (~480行): フロー制御のみ
  ├── agents/grader.md (224行): 評価の専門家
  ├── agents/comparator.md (203行): 比較の専門家
  ├── agents/analyzer.md (275行): 分析の専門家
  ├── references/schemas.md: データ契約
  └── scripts/ (8個): 確定的処理
```

全部SKILL.mdに書くと1000行超。
分離すれば、評価フェーズではgrader.mdだけがコンテキストに載る。

**Progressive Disclosureがスキル内部にまで適用される。**

## Building Effective Agents との対応

| Anthropicパターン | Skill実装 |
|------------------|----------|
| Prompt Chaining | Skill Chain型 |
| Routing | descriptionによるスキル選択 |
| Parallelization | Sub-agent型の並列Spawn |
| Orchestrator-Workers | SKILL.md → agents/ への委譲 |
| Evaluator-Optimizer | 改善ループ（grader → improve → 再テスト） |

1つのスキルに複数パターンが共存することもある。

**出典:** [逆瀬川 skill-creatorから学ぶSkill設計](https://nyosegawa.com/posts/skill-creator-and-orchestration-skill/), [Anthropic Building Effective Agents](https://www.anthropic.com/research/building-effective-agents)
