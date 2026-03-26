#!/bin/bash
# Claude Code Knowledge Base — ワンコマンドインストーラー
#
# 使い方:
#   bash <(curl -s https://raw.githubusercontent.com/MaururuTakumi/claude-code-kb/main/install.sh)
#
# やること:
#   1. claude-code-kb をホームディレクトリにclone
#   2. ~/.claude/CLAUDE.md にグローバル設定を注入（既存設定は保持）
#   3. Obsidianで開くだけで使える状態にする

set -euo pipefail

KB_REPO="https://github.com/MaururuTakumi/claude-code-kb.git"
KB_DIR="$HOME/claude-code-kb"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

echo "🧠 Claude Code Knowledge Base インストーラー"
echo "============================================"
echo ""

# 1. KBをclone
if [ -d "$KB_DIR" ]; then
    echo "📂 KB already exists at $KB_DIR — pulling latest..."
    cd "$KB_DIR" && git pull --rebase
else
    echo "📥 Cloning Knowledge Base..."
    git clone "$KB_REPO" "$KB_DIR"
fi

# 2. ~/.claude/ ディレクトリ作成
mkdir -p "$CLAUDE_DIR"

# 3. CLAUDE.md にグローバル設定を注入
MARKER="# === Claude Code KB Global Settings ==="

if [ -f "$CLAUDE_MD" ] && grep -q "$MARKER" "$CLAUDE_MD"; then
    echo "✅ CLAUDE.md already has KB settings — updating..."
    # マーカー以降を削除して再注入
    sed -i.bak "/$MARKER/,\$d" "$CLAUDE_MD"
fi

cat >> "$CLAUDE_MD" << 'GLOBAL_EOF'

# === Claude Code KB Global Settings ===
# Auto-injected by claude-code-kb/install.sh
# Do not edit below this line manually — re-run install.sh to update

## 📚 ベストプラクティス参照（必ず確認）
Knowledge Base: ~/claude-code-kb/QUICK-REF.md
全体地図: ~/claude-code-kb/MOC.md
**タスク開始前にQUICK-REF.mdの該当セクションを確認すること。**

## 🎯 モデル使い分け（Opus節約）
Opusは「考える」。Sonnetは「実行する」。この役割分担を絶対に崩さない。

| パターン | いつ使う | やり方 |
|----------|---------|--------|
| A: 2段階 | 判断+実行 | Opus(5-15t)で設計→手順書→Sonnet(15-30t)で実行 |
| B: Sonnet単独 | 完全定型 | `--model sonnet` で直接実行 |
| C: Opus単独 | 判断密度が高すぎる | デフォルトで実行 |

迷ったらA。詳細: ~/claude-code-kb/01-Architecture/Model Selection.md

## ✅ 品質管理（全出力に適用）
1. Draft — まず出す
2. Critique — 厳しく事実・論理・目的・品質をチェック
3. Revise — 指摘を反映して改善版

## 📋 基本ルール
- `rm` 禁止。`trash` を使う
- APIキー・トークンをファイルに平文で書かない
- 新しいタブを極力開かない（メモリ管理）
- エラー・教訓は ~/claude-code-kb/03-Troubleshooting/ に記録

## 🔧 トラブル時
~/claude-code-kb/03-Troubleshooting/ を参照
- Auth切れ: Auth Expiry.md
- MCP不調: MCP Crash.md
- バージョンバグ: Version Bugs.md
GLOBAL_EOF

echo ""
echo "============================================"
echo "✅ インストール完了！"
echo ""
echo "📂 Knowledge Base: $KB_DIR"
echo "📝 Global CLAUDE.md: $CLAUDE_MD"
echo ""
echo "次のステップ:"
echo "  1. Obsidian で ~/claude-code-kb を Vault として開く"
echo "  2. Community plugins → 'Git' をインストール → 有効化"
echo "  3. プロジェクトで使う:"
echo "     ln -s ~/claude-code-kb /your/project/.claude-kb"
echo ""
echo "KBは自動更新されます（Obsidian Git or git pull）"
