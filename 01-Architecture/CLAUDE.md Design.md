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

## 200行ルール

**CLAUDE.md は200行以内を目指す。**
200行を超えても全文読み込まれるが、遵守度が下がる。

### 200行に近づいたら
1. タスク固有の指示 → `.claude/skills/` に移動
2. パス固有の指示 → `.claude/rules/` にpath-scoped ruleとして移動
3. 全セッション不要な情報 → skill or ruleに分離

### Path-Scoped Rules（条件付きルール読み込み）

`.claude/rules/` にmdファイルを置くと、CLAUDE.mdから分離した指示を管理できる。

**常時読み込み:** frontmatter なし → セッション開始時にCLAUDE.mdと一緒に読み込み
**条件付き読み込み:** `paths:` frontmatter付き → 該当ファイルがコンテキストに入った時だけ読み込み

```markdown
---
paths:
  - "**/*.test.ts"
  - "**/*.test.tsx"
---

# Testing Rules
- Use descriptive test names: "should [expected] when [condition]"
- Mock external dependencies, not internal modules
```

**ポイント:**
- サブディレクトリもOK: `.claude/rules/frontend/react.md`
- globパターン対応: `src/api/**/*.ts`
- CLAUDE.mdの肥大化を防ぐ核心機能

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)

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
