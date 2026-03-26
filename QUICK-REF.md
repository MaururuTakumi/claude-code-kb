# QUICK-REF — Claude Code ベストプラクティス速習

> **このファイルを1つ読めば、Claude Codeの最適な使い方がわかる。**
> CLAUDE.md の冒頭で `cat .claude-kb/QUICK-REF.md` として参照させる。
> 詳細は各リンク先を参照。

---

## 1. モデル使い分け（最重要）

**Opusは考える。Sonnetは実行する。分離せよ。**

| パターン | いつ使う | やり方 |
|----------|---------|--------|
| A: 2段階 | 判断+実行があるタスク | Opus(5-15ターン)で設計→手順書出力→Sonnet(15-30ターン)で実行 |
| B: Sonnet単独 | 完全定型タスク | `--model sonnet` で直接実行 |
| C: Opus単独 | 判断密度が高すぎて分離不可 | デフォルトで実行 |

**迷ったらA。** Opusで考えてSonnetに渡す。
→ 詳細: [[01-Architecture/Model Selection]]

---

## 2. 手順書の品質（Sonnetに渡す時）

Sonnetが**1秒も迷わない**具体性で書く。

```
❌ "適切に分析して保存して"
✅ "weekly-*.md の直近3ファイルを読み、views>10000の投稿を抽出し、/tmp/result.jsonに保存"
```

各ステップに**完了条件**を明記する。
判断が必要なポイントには「ここで停止してOpusに戻す」と書く。
→ 詳細: [[01-Architecture/Two-Phase Execution]]

---

## 3. 品質管理（全出力に適用）

### 3フェーズ
1. **Draft** — まず出す
2. **Critique** — 厳しい批判者として事実・論理・目的・品質をチェック
3. **Revise** — 指摘を反映して改善版

### 7項目スコアリング（SNS投稿用）
自然さ / 具体性 / 感情移入 / ペルソナ一致 / テンポ / 体験語り / 業者臭なし
**平均7.0未満は投稿しない。**
→ 詳細: [[02-Patterns/Quality Scoring]] [[02-Patterns/Self Critique]]

---

## 4. エージェント設計の原則（Thariq @trq212）

- **bashを多用せよ**: データは先にbashで整形してからモデルに渡す
- **ファイルシステムを状態管理に使え**: 会話コンテキストだけに閉じない
- **Prompt Cachingが全て**: 静的コンテンツ→動的コンテンツの順で並べる
- **Progressive Disclosure**: 一気に全部見せず、段階的に情報到達させる
- **Skillは単責務**: 1つのSkillは1つの明確な責務だけ持つ
→ 詳細: [[Sources/community/2026-03-26-thariq-claude-code-tips]]

---

## 5. よくあるトラブルと対処

| 症状 | 原因 | 対処 |
|------|------|------|
| `-p` が無応答 | バージョンバグ | ダウングレード [[03-Troubleshooting/Version Bugs]] |
| OAuth expired | 認証切れ | `claude auth login` [[03-Troubleshooting/Auth Expiry]] |
| MCP接続後に即死 | 複数MCP同時init | 1サーバーずつ [[03-Troubleshooting/MCP Crash]] |
| タイムアウト | ターン数/時間不足 | timeout延長 [[03-Troubleshooting/Timeout Patterns]] |

---

## 6. CLAUDE.md の書き方

```
~/.claude/CLAUDE.md       ← グローバル（全セッション共通ルール）
/project/CLAUDE.md        ← プロジェクト固有（アカウント・MCP設定）
/project/.claude/skills/  ← タスク固有スキル
.claude-kb/QUICK-REF.md   ← このファイル（ベストプラクティス参照）
```

テンプレート: [[_templates/CLAUDE.md.template]]

---

## 7. このKBの使い方

- **知識を追加**: 該当フォルダのmdファイルに追記 → `[[]]` でリンク → git push
- **エラーに遭遇**: 03-Troubleshooting/ に記録 → git push → 全環境に反映
- **新パターン発見**: 02-Patterns/ に追加 → git push
- **古い情報**: `#deprecated` タグを付ける

---

_最終更新: 2026-03-26 | バージョン: v1.0_
