# Output Styles — システムプロンプトのカスタマイズ

> Claude Code のレスポンススタイルをmdファイルで制御する。
> コーディング以外の用途（教育、レビュー、コンサル）にも対応可能。

## 概要

`~/.claude/output-styles/` or `.claude/output-styles/` にmdファイルを置くと、
システムプロンプトに追加（or 置換）される。

## 配置場所

| パス | スコープ |
|------|---------|
| `~/.claude/output-styles/` | 全プロジェクト（個人） |
| `.claude/output-styles/` | プロジェクト固有（チーム共有） |

プロジェクト配置が同名の場合、プロジェクト側が優先。

## 設定方法

settings.json で指定:
```json
{
  "outputStyle": "teaching"
}
```
→ `teaching.md` が読み込まれる。

`/config` コマンドでも切り替え可能。

## Frontmatter

```markdown
---
description: Explains reasoning and asks you to implement small pieces
keep-coding-instructions: true
---
```

| フィールド | 説明 |
|-----------|------|
| `description` | スタイルの説明 |
| `keep-coding-instructions` | `true` = デフォルトのコーディング指示を維持したまま追加。`false`（デフォルト）= コーディング指示を置換 |

## ユースケース

### 教育モード
```markdown
---
description: Explains reasoning and asks you to implement small pieces
keep-coding-instructions: true
---

After completing each task, add a brief "Why this approach" note.
When a change is under 10 lines, leave a TODO(human) marker instead.
```

### レビューモード
```markdown
---
description: Code review specialist - finds issues, never writes code
---

You are a code reviewer. Never write or edit code directly.
For every finding, include severity, location, and a concrete fix suggestion.
```

### コンサルモード
```markdown
---
description: Business consulting analysis mode
---

Structure all responses as:
1. Current situation assessment
2. Options with trade-offs
3. Recommended action with rationale
```

## 注意
- 変更はセッション開始時に適用（ホットリロードなし）
- ビルトインスタイル: Explanatory, Learning

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)
