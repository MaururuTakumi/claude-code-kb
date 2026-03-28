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

## Progressive Disclosure（3層遅延読み込み）

**「コンテキストウィンドウは公共財」** — Anthropic Engineering Blog

Skillは3層に分かれ、必要な時に必要な分だけ読み込まれる:

| 層 | 内容 | トークン目安 | 読み込みタイミング |
|----|------|------------|------------------|
| L1 | name + description | ~100 | **常時**（システムプロンプトに注入） |
| L2 | SKILL.mdボディ | <5,000推奨 | **トリガーされた時** |
| L3 | scripts/ references/ assets/ | 必要分 | **参照された時のみ** |

**設計原則:** L1はできるだけ短く。L2は5,000トークン以内。重い処理はL3に押し出す。

## Description最適化

**Skillが呼ばれるかどうかはdescriptionで決まる。**

Claudeは「スキルを使わなすぎる」傾向がある（undertrigger）。対策:

### 書き方
```
❌ "How to build a simple fast dashboard"
✅ "Make sure to use this skill whenever the user mentions dashboards, 
    data visualization, internal metrics, analytics pages..."
```

**構成:** [What] + [When] + [Key capabilities]
- 少し「押し強め」に書く
- トリガーすべき文脈を列挙する
- 類似スキルとの区別がつく表現にする

## Why-driven Prompt Design

**ALWAYSやNEVERを大文字で並べるのは黄信号。**

基本は「なぜそれが必要か」を説明する:

| Must-driven（従来） | Why-driven（推奨） |
|-------------------|------------------|
| "ALWAYS validate before submission" | "Validation prevents API errors that waste tokens and frustrate users" |
| "NEVER skip the formatting step" | "Consistent formatting ensures the viewer can parse results correctly" |

**例外:** スキーマのフィールド名一致やセキュリティなど、本当にクリティカルな箇所だけMust-driven。

**判断基準:** "Would Claude do this anyway if it were smart enough?" → Yes なら書かなくていい

## 確定的処理のオフロード判断

**「Coding Agentがゼロからできるか？」が判断基準。**

| 処理 | スクリプト必須 | 理由 |
|------|-------------|------|
| 統計計算・集計 | ✅ 必須 | AIは数値計算が苦手 |
| 並列実行・ループ | ✅ 必須 | AIのループは不安定 |
| ファイル操作・ZIP | ✅ 必須 | 確定的処理 |
| 情報取得・検索 | ❌ オプション | AIでもWeb検索でフォールバック可 |
| フォーマット変換 | ❌ オプション | AIでも対応可能 |

オプションの場合は「スクリプト成功→結果使う / 失敗→AIがフォールバック」設計にする。

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory), [逆瀬川 skill-creatorから学ぶSkill設計](https://nyosegawa.com/posts/skill-creator-and-orchestration-skill/)
