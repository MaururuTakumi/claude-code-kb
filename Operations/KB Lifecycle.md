# KB Lifecycle — 知識ベースの継続的改善と配布の仕組み

> タクミが改良 → Git push → 全環境に自動反映。
> これがこのKBの運用サイクルの全体像。

## 全体フロー

```
┌─────────────────────────────────────────────────┐
│                 情報ソース                        │
│  X(@trq212等) / Anthropic公式 / テック記事 /      │
│  実運用で発見した教訓 / クライアントからのFB       │
└──────────────┬──────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────┐
│            収集・検証（たくみん + タクミ）         │
│                                                   │
│  1. たくみんが自動収集（HEARTBEAT）               │
│     - X監視: @trq212, @AnthropicAI, @claudeai    │
│     - Anthropicブログ巡回                         │
│     - 実運用中のエラー・教訓を自動記録            │
│                                                   │
│  2. タクミが手動追加                              │
│     - 読んだ記事・見つけたTips                    │
│     - クライアント導入時の気づき                  │
│     - 自分で試して検証した結果                    │
│                                                   │
│  3. 検証ステータス管理                            │
│     - ⚠️ unverified: 未検証（Sources/に格納）     │
│     - ✅ verified: 検証済み（Architecture/等に昇格）│
│     - 🚫 deprecated: 古くなった情報               │
└──────────────┬──────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────┐
│            編集・構造化（タクミ or たくみん）       │
│                                                   │
│  - Obsidianで編集（Mac mini or MacBook Pro）      │
│  - [[ウィキリンク]]で知識を相互接続               │
│  - タグで分類（#verified #pattern #troubleshoot） │
│  - Dataviewで自動集計・一覧化                     │
└──────────────┬──────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────┐
│            Git Push（自動 or 手動）               │
│                                                   │
│  Obsidian Git プラグイン:                         │
│  - 5分ごとに自動push（Mac mini）                  │
│  - 5分ごとに自動pull（全デバイス）                │
│                                                   │
│  or 手動:                                         │
│  - git add -A && git commit -m "..." && git push  │
│                                                   │
│  → GitHub (MaururuTakumi/claude-code-kb)          │
└──────────────┬──────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────┐
│            自動配布（全環境に反映）               │
│                                                   │
│  ① タクミのMacBook Pro                           │
│     Obsidian Git: 5分ごとに自動pull              │
│     → 開くたびに最新版                            │
│                                                   │
│  ② タクミのMac mini（たくみん環境）              │
│     Obsidian Git: 5分ごとに自動pull              │
│     → Claude Codeが参照するKBが自動更新           │
│                                                   │
│  ③ クライアント環境                              │
│     Obsidian Git: pull on startup                │
│     → Obsidianを開くだけで最新のベストプラクティス │
│                                                   │
│  ④ 新規導入先                                    │
│     git clone → Obsidianで開く → 即最新版         │
└─────────────────────────────────────────────────┘
```

## 自動収集ワークフロー（たくみんのHEARTBEATに組み込み）

### 週次: Claude Code情報スカウト
```
毎週月曜 04:00（HEARTBEATタスクとして追加）

1. Grok x-search で以下を検索:
   - "Claude Code" tips OR best practices min_faves:100
   - @trq212 の新規投稿
   - "CLAUDE.md" OR "agent skills" OR "prompt caching" min_faves:50

2. Anthropicブログをチェック:
   - https://www.anthropic.com/blog の新着確認
   - Claude Code関連があれば要約

3. 結果を Sources/ に保存:
   - Sources/community/YYYY-MM-DD-*.md
   - Sources/official/YYYY-MM-DD-*.md

4. git commit && git push
```

### 日次: 実運用教訓の自動記録
```
毎日 22:50（auto-memoryと同時）

1. 今日のClaude Code実行ログを確認
2. エラー・バグ・新発見があれば:
   - Troubleshooting/ に追記
   - or Patterns/ に新パターン追加
3. git commit && git push
```

### トリガーベース: 障害発生時
```
Claude Codeで障害が発生したら:

1. 原因と対処法を Troubleshooting/ に即記録
2. 関連する Architecture/ や Patterns/ にリンクを追加
3. git commit && git push
→ 他の全環境にも同じ障害対策が即反映
```

## クライアント向け配布フロー

### 初回導入
```bash
# クライアントのMacで実行
git clone https://github.com/MaururuTakumi/claude-code-kb.git
# → Obsidianで開く → Gitプラグイン入れる → 完了
```

### 継続更新
```
タクミがKBを改良 → git push
  ↓ 自動（Obsidian Gitプラグイン）
クライアントのObsidian → pull on startup
  ↓
クライアントは何もしなくても最新版が手元にある
```

### クライアント固有の設定
```
claude-code-kb/          ← タクミが管理（read-only for clients）
  ↓ 参照
client-project/
├── CLAUDE.md            ← テンプレートから生成（クライアント固有設定）
├── .claude-kb -> claude-code-kb/  ← シンボリックリンク
└── .claude/skills/      ← クライアント固有スキル
```

クライアントは `claude-code-kb/` を編集しない。
自分のプロジェクト固有の設定だけ `CLAUDE.md` に書く。
**ベストプラクティスはKBから自動で流れてくる。**

## バージョン管理

### タグ運用
```bash
# メジャーな改善があったらタグを打つ
git tag v1.0 -m "Initial release: Architecture + Troubleshooting"
git tag v1.1 -m "Add Thariq tips + Quality Scoring pattern"
git push --tags
```

### クライアントが特定バージョンに固定したい場合
```bash
git checkout v1.0  # 安定版に固定
```

### Changelog
`CHANGELOG.md` で何が変わったかを追跡:
```markdown
## v1.1 (2026-03-26)
- Thariq @trq212 の6本のClaude Code Tips追加
- Model Selection にTwo-Phase Execution パターン追加
- Troubleshooting にVersion Bugs, Auth Expiry, MCP Crash追加
```

## 品質管理

### 定期レビュー（月1回）
1. 全ファイルの最終更新日を確認（Dataview）
2. 3ヶ月以上更新のないファイル → `#review-needed` タグ
3. Claude Code本体のアップデートで変わった情報 → `#deprecated` タグ
4. 新しいベストプラクティスが出てないか確認

### Dataviewクエリ例
```dataview
TABLE file.mtime as "最終更新", file.tags as "タグ"
FROM ""
WHERE date(now) - file.mtime > dur(90 days)
SORT file.mtime ASC
```
→ 90日以上更新のないファイルを自動検出

## まとめ

```
タクミが改良する → 5分以内に全環境に反映
たくみんが障害対策を記録 → 5分以内に全環境に反映
新しい記事・Tipsを発見 → Sources/に格納 → 検証後に昇格 → 全環境に反映
クライアントが導入 → git clone一発 → 以降は自動更新
```

**誰かが1回改良すれば、全員の環境が良くなる。** これがこのKBの本質。
