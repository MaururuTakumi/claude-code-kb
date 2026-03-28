# Subagent Orchestration

## 核心原則
**メインエージェントが「設計と指揮」、サブエージェントが「実行」を担う。**

メインエージェントに全作業を詰め込まない。
コンテキストウィンドウは有限で、複雑なタスクほど途中でコンテキストが汚染される。

---

## 基本パターン

### 1. Planner/Executor分離

```
Main Agent (Opus)
  ↓ 計画書を作成 → /tmp/plan.md
Sub Agents (Sonnet × N)
  ↓ plan.mdを読んで実行
  ↓ 結果をファイルに書き出す
Main Agent
  ↓ 結果を集約 → 最終判断
```

メインが「何をどう実行するか」を計画書に落とし、サブは計画書通りに動く。
サブには判断を求めない。判断が必要な場面は計画書に分岐を明示しておく。

### 2. 専門家委任パターン

タスクの性質によってサブエージェントを使い分ける。

```
Main Agent
  ├── 調査タスク → Research Agent (Codex/Sonnet)
  ├── コード生成 → Coding Agent (Sonnet)
  ├── 評価タスク → Evaluator Agent (Opus)
  └── 外部操作  → Executor Agent (Sonnet)
```

例：
```bash
# 並列で別々のサブエージェントに投げる
claude -p "/analyze-competitors" &
claude -p "/generate-draft" &
wait
# メインで結果を統合
```

### 3. Cascade（直列）パターン

前のエージェントの出力が次の入力になる場合。

```
Planner → Generator → Evaluator → Publisher
```

各ステップはファイルで受け渡し。
```
/tmp/plan.md → /tmp/draft.md → /tmp/approved.md → published/
```

---

## サブエージェントへの指示設計

### 良い指示の4要素
1. **成果物の定義** — 何をどこに出力するか（ファイルパス・フォーマット）
2. **判断の境界** — どこまで自律判断してよく、何を止まって報告するか
3. **失敗時の挙動** — 失敗したら何をするか（リトライ/スキップ/報告）
4. **完了の証跡** — 完了後に何を記録するか

```markdown
【タスク】
成果物: /tmp/analysis.json にフォロワー数・エンゲージメント率を書き出す
判断境界: データが取得できない場合はnullで記録してスキップ（止まらない）
失敗時: エラーを /tmp/errors.log に追記してスキップ
完了証跡: /tmp/done.txt に完了時刻を記録
```

---

## コンテキスト汚染の防止

長いタスクでは途中でコンテキストが汚染されて品質が劣化する。

### 対策
- サブエージェントは**短いタスク単位**で起動する（1ファイル or 1機能）
- 大きなタスクは**ファイルで受け渡す**（エージェント間でコンテキストを共有しない）
- 各サブエージェントは**新しいセッション**で起動する（前の文脈を引き継がない）

### 並列実行時の独立性
```bash
# 依存関係がないタスクは並列OK
agent_a &
agent_b &
wait
# 依存関係があるタスクは直列
agent_a && agent_b
```

---

## よくある失敗パターン

| アンチパターン | 問題 | 対策 |
|-------------|------|------|
| メインに全作業を詰め込む | コンテキスト汚染・品質劣化 | 役割を分けてサブに委任 |
| サブに判断を求める | サブが止まる・誤判断 | 判断はメインがやる。サブには成果物定義のみ渡す |
| 口頭で完了確認 | 確認できない | ファイルに完了証跡を残す |
| タイムアウトを短くする | SIGTERM→出力消失 | 十分なタイムアウトを設定 |

---

## Agent Memory（3スコープ）

サブエージェントに永続メモリを持たせることで、セッションを跨いで学習が蓄積される。

### メモリスコープ

| frontmatter | 保存先 | 共有範囲 | git |
|------------|--------|---------|-----|
| `memory: project` | `.claude/agent-memory/<name>/` | チーム共有 | committed |
| `memory: local` | `.claude/agent-memory-local/<name>/` | 個人のみ | gitignored |
| `memory: user` | `~/.claude/agent-memory/<name>/` | 全プロジェクト横断 | local |

### 仕組み
- サブエージェント起動時に MEMORY.md の先頭200行（最大25KB）が読み込まれる
- サブエージェントが自動で書き込み・更新する（人間が書く必要なし）
- メインセッションの auto memory とは完全に分離

### 使い分け
- `project`: コードレビューのパターン蓄積（チームで共有したい知見）
- `local`: 個人的な学習ログ（他メンバーに見せなくていい）
- `user`: 全プロジェクトで共通のレビュー基準・判断パターン

### 例
```markdown
---
name: code-reviewer
description: Reviews code for correctness, security, and maintainability
tools: Read, Grep, Glob
memory: project
---

You are a senior code reviewer...
```

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)

## 参考実装
- ECC: `agents/planner.md` — 詳細な計画書フォーマット
- ECC: `agents/architect.md` — アーキテクチャ設計の委任パターン
- AGENTS.md: Claude Code + Codex の分担ルール

Source: Anthropic hackathon winner ECC (affaan-m/everything-claude-code) + honkoma実運用
