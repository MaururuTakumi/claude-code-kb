# 新プロジェクト初期化手順

> 新しいプロジェクトを作る時、このチェックリストに従う。
> KBのベストプラクティスが最初から適用された状態でスタートできる。

## Step 1: プロジェクトディレクトリ作成
```bash
mkdir -p /path/to/project
cd /path/to/project
git init
```

## Step 2: KBをリンク
```bash
# シンボリックリンクでKBを参照可能にする
ln -s /path/to/claude-code-kb .claude-kb
```

## Step 3: CLAUDE.md をテンプレートから生成
```bash
cp .claude-kb/_templates/CLAUDE.md.template CLAUDE.md
# → {PROJECT_NAME} 等のプレースホルダを埋める
```

CLAUDE.md の冒頭に以下を追記:
```markdown
## ベストプラクティス参照
このプロジェクトは claude-code-kb のベストプラクティスに従う。
速習: .claude-kb/QUICK-REF.md
詳細: .claude-kb/MOC.md
```

## Step 4: スキルディレクトリ作成
```bash
mkdir -p .claude/skills
```

## Step 5: 初期チェック
- [ ] CLAUDE.md にモデル使い分けルールがある
- [ ] CLAUDE.md にプロジェクト固有のアカウント/MCP設定がある
- [ ] .claude-kb/ へのシンボリックリンクが張られている
- [ ] .gitignore に .claude-kb を追加（サブモジュールでない場合）

## クライアント向けの場合
```bash
# クライアントのMacで実行
git clone https://github.com/MaururuTakumi/claude-code-kb.git
ln -s claude-code-kb .claude-kb

# CLAUDE.md テンプレートから生成
cp .claude-kb/_templates/CLAUDE.md.template CLAUDE.md
# → クライアント固有の設定を記入
```
