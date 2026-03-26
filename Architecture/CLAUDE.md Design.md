# CLAUDE.md Design — プロジェクトCLAUDE.mdの設計原則

> CLAUDE.mdはClaude Codeセッションの「憲法」。  
> ここに書かれたことが全ての判断基準になる。

## 階層構造

```
~/.claude/CLAUDE.md          ← グローバル（全プロジェクト共通）
  ↓ 継承
/project/CLAUDE.md           ← プロジェクト固有
  ↓ 参照
/project/.claude/skills/     ← タスク固有のスキル
  ↓ 参照
claude-code-kb/              ← 知識ベース（ベストプラクティス）
```

## グローバルCLAUDE.mdに書くべきこと
- [[Model Selection]] ルール
- [[Two-Phase Execution]] パターン
- セキュリティルール（rm禁止、機密情報保護）
- [[Self Critique]] の3フェーズ
- auto-memory実行ルール
- Chrome タブ管理ルール

## プロジェクトCLAUDE.mdに書くべきこと
- プロジェクト固有のアカウント情報
- 使用するMCPサーバーとポート
- デプロイ方法
- プロジェクト固有の禁止事項

## 書いてはいけないこと
- APIキー・トークン（.envに書く）
- 一時的な作業メモ（memory/に書く）
- 他プロジェクトの情報（混入防止）

## テンプレート
→ [[_templates/CLAUDE.md.template]] を使用
