# Settings Precedence — 設定の優先順位

> Claude Code の設定は4層で管理される。
> Array設定は結合、Scalar設定は上位が勝つ。

## 優先順位（低→高）

```
~/.claude/settings.json          ← グローバル（最低）
  ↓
.claude/settings.json             ← プロジェクト
  ↓
.claude/settings.local.json       ← 個人ローカル（gitignored）
  ↓
CLI flags / managed settings      ← 最高優先
```

## 結合ルール

| 設定タイプ | 動作 | 例 |
|-----------|------|-----|
| Array | **全スコープの値を結合** | `permissions.allow` → global + project + local の全ルールが有効 |
| Scalar | **最も具体的な値が勝つ** | `model` → local に書いてあればそれが使われる |

## 各ファイルの役割

### ~/.claude/settings.json（グローバル）
全プロジェクトのデフォルト。git, diff, ls 等の基本コマンド許可を書く。

### .claude/settings.json（プロジェクト）
チームで共有。npm test, lint, build 等のプロジェクト固有コマンド。hooks もここ。
**committed**（gitで共有される）。

### .claude/settings.local.json（ローカル）
個人のオーバーライド。Docker やデバッグツール等、自分だけ必要な権限。
**gitignored**（Claude Code が自動で `~/.config/git/ignore` に追加）。

## 主要な設定キー

| キー | 型 | 結合 | 説明 |
|-----|-----|------|------|
| `permissions.allow` | Array | 結合 | ツール/コマンドの自動許可 |
| `permissions.deny` | Array | 結合 | ツール/コマンドの拒否 |
| `hooks` | Object | 結合 | イベントフック |
| `model` | Scalar | 上書き | デフォルトモデル |
| `env` | Object | マージ | 環境変数 |
| `outputStyle` | Scalar | 上書き | 出力スタイル |

## permissions の書き方

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test *)",
      "Bash(npm run *)",
      "Bash(git log *)"
    ],
    "deny": [
      "Bash(rm -rf *)"
    ]
  }
}
```

ワイルドカード `*` 対応。`Bash(npm test *)` は `npm test --watch` もマッチする。

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)
