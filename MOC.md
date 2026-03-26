# Map of Contents — Claude Code Knowledge Base

> このファイルが全体の地図。ここから辿れば全知識にアクセスできる。

## 🏗️ Architecture（設計原則）
- [[Model Selection]] — Opus / Sonnet / Codex の使い分け設計
- [[Two-Phase Execution]] — 「Opusが考える→Sonnetが実行する」パターン
- [[Agent Teams]] — リーダー/メンバー構成・並列実行
- [[Fallback Design]] — 障害時のフォールバック設計
- [[Token Budget]] — 週間リミット管理・ターン数最適化
- [[CLAUDE.md Design]] — プロジェクトCLAUDE.mdの設計原則
- [[Skill Architecture]] — スキル（SKILL.md）の設計原則

## 🔧 Patterns（実証済みパターン）
- [[Chrome MCP]] — ブラウザ操作のベストプラクティス
- [[Typefully API]] — X投稿のAPI経由パターン
- [[Threads API]] — Threads投稿・エンゲージメント取得
- [[File Operations]] — ファイル操作パターン
- [[Git Workflow]] — Git操作のパターン
- [[Quality Scoring]] — 7項目採点・品質管理
- [[Feedback Loop]] — エンゲージメント→プロンプト改善ループ
- [[Content Generation]] — コンテンツ生成の最適パターン
- [[Self Critique]] — 作成→自己批判→修正の3フェーズ

## 🔥 Troubleshooting（障害対応）
- [[Auth Expiry]] — OAuth切れの検知・復旧・予防
- [[MCP Crash]] — MCP不調パターンと対処法
- [[Version Bugs]] — バージョン別の既知バグ
- [[Timeout Patterns]] — タイムアウト設計・SIGTERM対策
- [[npx Cache]] — npxキャッシュ問題と解決策

## ⚙️ Operations（運用）
- [[HEARTBEAT Design]] — スケジュール設計の原則
- [[Security Rules]] — セキュリティルール
- [[Memory Management]] — MEMORY.md運用・auto-memory設計
- [[Tab Management]] — Chromeタブ管理
- [[Monitoring]] — 死活監視設計

## 📝 Skills（スキル設計ガイド）
- [[Skill Anatomy]] — スキルの構造・書き方
- [[SNS Posting Skills]] — SNS投稿スキルの設計パターン
- [[Research Skills]] — リサーチスキルの設計パターン
- [[Analysis Skills]] — 分析スキルの設計パターン

## 📋 Decisions（意思決定ログ）
- [[2026-03-26 Model Split]] — Opus/Sonnet構造分離
- [[2026-03-26 Threads API]] — Threads API導入
- [[2026-03-17 Typefully]] — Chrome MCP→Typefully移行
- [[2026-03-15 CW Exit]] — CrowdWorks撤退

## 📚 Sources（情報ソース）
- `Sources/official/` — Anthropic公式ドキュメント・ブログ
- `Sources/community/` — X投稿・コミュニティのTips
- `Sources/articles/` — テック記事・ブログ

---

> 💡 新しい知識を追加する時: まず該当カテゴリのファイルに追記 → MOC.mdにリンク追加 → git push
