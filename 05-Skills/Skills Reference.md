# Skills Reference — 公式仕様まとめ

> Skills = 再利用可能なプロンプト + バンドルファイル。
> `/skill-name` で呼び出し。Claude も自動で呼び出し可能。

## ディレクトリ構造

```
.claude/skills/
  └── security-review/
      ├── SKILL.md          ← エントリポイント（必須）
      ├── checklist.md      ← サポートファイル（任意）
      └── templates/        ← テンプレート等（任意）
```

## SKILL.md の構成

```markdown
---
description: Reviews code changes for security vulnerabilities
disable-model-invocation: true
argument-hint: <branch-or-path>
---

## Diff to review

!`git diff $ARGUMENTS`

Audit the changes above for:
1. Injection vulnerabilities
2. Authentication gaps
3. Hardcoded secrets

Use checklist.md in this skill directory for the full review checklist.
```

## Frontmatter フィールド

| フィールド | 型 | デフォルト | 説明 |
|-----------|-----|----------|------|
| `description` | string | — | Claude が自動呼び出しの判断に使う |
| `disable-model-invocation` | bool | false | `true` = ユーザーのみ呼び出し可能 |
| `user-invocable` | bool | true | `false` = `/` メニューに表示しない（Claude自動専用） |
| `argument-hint` | string | — | `/` メニューに表示されるヒント |

## 引数の受け取り

| 変数 | 説明 |
|------|------|
| `$ARGUMENTS` | コマンド名の後の全テキスト |
| `$0` | 最初の引数 |
| `$1` | 2番目の引数 |
| `${CLAUDE_SKILL_DIR}` | スキルディレクトリの絶対パス |

例: `/deploy staging` → `$ARGUMENTS` = "staging", `$0` = "staging"

## シェルコマンド注入

`!` + バッククォートでシェルコマンドの出力をプロンプトに注入:

```markdown
!`git diff $ARGUMENTS`
```

→ `git diff main` の出力がプロンプトに埋め込まれた状態でClaudeに渡る。

## バンドルファイルの参照

SKILL.md の本文で「checklist.md を参照して」と書くだけでOK。
Claude はスキルディレクトリのパスを知っているので、ファイル名で読める。

スクリプトから参照する場合は `${CLAUDE_SKILL_DIR}/checklist.md` を使う。

## Commands との関係

| | Skills | Commands |
|--|--------|---------|
| 構造 | フォルダ + SKILL.md | 単一mdファイル |
| バンドル | 可能 | 不可 |
| 呼び出し | `/name` | `/name` |
| 同名時 | **Skillsが優先** | — |

**新規作成は Skills を推奨。** Commands も引き続きサポートされる。

## 配置場所

| パス | スコープ |
|------|---------|
| `.claude/skills/` | プロジェクト固有（チーム共有・committed） |
| `~/.claude/skills/` | 全プロジェクト（個人） |

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)
