# Claude Code Knowledge Base

> Claude Codeを最大限活用するための構造的知識ベース。  
> Obsidian Vault + GitHub で管理。全プロジェクト・全デバイスから参照可能。

## 使い方

### 新プロジェクトに導入
```bash
# リポジトリをクローン
git clone https://github.com/takumihayashi/claude-code-kb.git

# プロジェクトから参照（シンボリックリンク）
ln -s /path/to/claude-code-kb /your/project/.claude-kb

# CLAUDE.md テンプレートをコピー
cp claude-code-kb/_templates/CLAUDE.md.template /your/project/CLAUDE.md
```

### Obsidianで閲覧・編集
1. Obsidianで「Open Vault」→ `claude-code-kb/` を選択
2. ウィキリンク `[[]]` で知識が相互参照される
3. 編集したら `git commit && git push` で全環境に反映

### AIエージェントに渡す
```bash
# Claude Codeセッション開始時に読み込ませる
claude -p "$(cat claude-code-kb/MOC.md) を参照して作業せよ"

# or CLAUDE.md からリンク
# → CLAUDE.md に「参照: .claude-kb/Architecture/Model Selection.md」と書く
```

## 構造

```
claude-code-kb/
├── MOC.md                    ← 全体の地図（ここから辿る）
├── Architecture/             ← 設計原則・構造
├── Patterns/                 ← 実証済みパターン集
├── Troubleshooting/          ← 障害対応・教訓
├── Operations/               ← 運用ルール
├── Skills/                   ← スキル設計ガイド
├── Decisions/                ← 意思決定ログ
├── Sources/                  ← 情報ソース（公式/コミュニティ/記事）
└── _templates/               ← 新プロジェクト用テンプレート
```

## 情報の鮮度
- X・テック記事から最新のClaude活用情報を継続収集
- Sources/ に原文・要約を格納
- 検証済みのものを Architecture/ や Patterns/ に昇格
- 古くなった情報には `⚠️ deprecated` タグを付与

## ライセンス
Private — honkoma internal use + クライアント導入時に提供
