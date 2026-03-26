# Two-Phase Execution — 思考→実行の分離パターン

> **Opusが「考える」。Sonnetが「実行する」。**  
> この分離がClaude Code運用の最も重要な設計原則。

## なぜ分離するのか

1. **Opusのリミットを温存**: Opusは5-15ターンで設計だけして終わる
2. **Sonnetの実行力を活かす**: 手順書があればSonnetは正確に実行できる
3. **品質を落とさない**: 判断部分はOpusが担保する
4. **障害に強い**: Phase2が失敗してもPhase1の設計は残る

## 実装パターン

### 基本形
```bash
# Phase 1: Opus（思考・設計）
claude --dangerously-skip-permissions --max-turns 10 \
  -p "以下のタスクの実行計画を作成し、/tmp/task-plan.md に書き出せ。
      Sonnetが迷わず実行できるレベルの具体性で書くこと。
      タスク: [具体的な指示]"

# Phase 2: Sonnet（実行）
claude --dangerously-skip-permissions --model sonnet --max-turns 30 \
  -p "/tmp/task-plan.md を読んで、その指示通りに実行せよ。
      判断が必要な場面に遭遇したら停止して報告せよ。"
```

### 手順書の品質基準

Opusが出力する手順書は以下を満たすこと:

```markdown
# 実行計画: [タスク名]

## 目的
[1行で。何を達成すべきか]

## 前提条件
- [ファイルパス]
- [必要な環境変数]
- [使用するMCPサーバー]

## 実行ステップ
1. [具体的なアクション] → 完了条件: [何が確認できれば完了か]
2. [具体的なアクション] → 完了条件: [...]
3. ...

## 判断ポイント（Sonnetは自分で判断しないこと）
- もし[条件]なら → [Aをする]
- もし[条件]なら → [停止してOpusに戻す]

## 出力
- 保存先: [ファイルパス]
- 形式: [JSON/Markdown/etc]
```

**NG例（Sonnetが迷う手順書）:**
```
❌ "適切にデータを分析して保存してください"
❌ "伸びている投稿のパターンを見つけてください"
❌ "良さそうなものを選んでください"
```

**OK例（Sonnetが迷わない手順書）:**
```
✅ "niches/main/data/analytics/weekly-*.md の直近3ファイルを読み、
    views > 10000 かつ likes > 100 の投稿を抽出し、
    テーマ・フック・文字数をJSONで /tmp/top-posts.json に保存せよ"
```

## タスク別の適用例

### /main-analytics
```
Phase 1 (Opus, 5ターン):
  Input: posting_rules_v2.md, winning_patterns.md
  Output: /tmp/analytics-plan.md
  → 「今週注目すべき指標3つ」「比較対象の投稿」「分析の切り口」を決定

Phase 2 (Sonnet, 25ターン):
  Input: /tmp/analytics-plan.md
  Output: niches/main/data/analytics/weekly-YYYY-MM-DD.md
  → Chrome MCPでデータ取得 → 計画通りに記録
```

### /main-post
```
Phase 1 (Opus, 10ターン):
  Input: 日記3日分, Values.md, winning_patterns.md, Ideas/Posts/
  Output: drafts/YYYY-MM-DD-*.md（投稿文 + 7項目採点済み）
  → テーマ選定・構成・トーン判断・生成・品質チェックまでOpusが担当

Phase 2 (Sonnet, 10ターン):
  Input: drafts/最新ファイル
  Output: Typefully APIで投稿 + URL記録
  → 投稿実行のみ。判断不要
```

## 3役構成への発展

Two-Phase Execution は最小構成として強いが、
外部公開物や品質要求の高い実装では **Planner → Generator → Evaluator** の3役構成に発展させると安定する。

- **Planner**: Opus が仕様・制約・完成条件を定義
- **Generator**: Sonnet が実装・生成・操作を実行
- **Evaluator**: 別セッションの Opus / Sonnet / 実機検証で品質を採点し、閾値未満なら差し戻し

特に次の条件では Evaluator を追加する:
- 外部公開コンテンツ（X投稿、記事、提案書）
- お金に直結する文面（引用RT、アフィリエイト訴求、営業文）
- 複数ステップの実装で「完成したように見えて未完成」が起きやすいタスク

関連: [[Harness Design]]

## フォールバック

Phase 2（Sonnet）が失敗した場合:
1. エラーログを確認
2. 手順書に問題があれば → Opusで手順書を修正 → Sonnet再実行
3. 環境の問題（認証切れ等）→ [[Auth Expiry]] [[MCP Crash]] を参照
4. Sonnetの能力不足 → Opusで直接実行（パターンC にフォールバック）

参照: [[Fallback Design]] [[Model Selection]]
