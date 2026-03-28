# Worktree Management — 並列作業のためのgit worktree活用

> Claude Code は git worktree を使って並列セッションを実現する。
> `.worktreeinclude` で gitignored ファイルの自動コピーを制御。

## .worktreeinclude

プロジェクトルートに置く。worktree 作成時に、gitignored ファイルのうちパターンにマッチするものを自動コピーする。

```
# Local environment
.env
.env.local

# API credentials
config/secrets.json
```

### ルール
- `.gitignore` 構文（glob対応）
- gitignored かつパターンにマッチするファイルだけがコピーされる
- tracked ファイルは重複コピーされない
- `#` コメント、空行は無視

## worktree が作られるタイミング

| トリガー | 説明 |
|---------|------|
| `--worktree` CLI フラグ | セッション開始時にworktreeで起動 |
| `EnterWorktree` ツール | セッション中にworktreeに移行 |
| subagent `isolation: worktree` | サブエージェントをworktreeで実行 |
| Desktop App 並列セッション | 複数セッションの同時実行 |

## なぜ必要か

worktree は git checkout の独立コピーなので、`.env` などの untracked ファイルが存在しない。
`.worktreeinclude` がないと:
- 環境変数が読めない → ビルド失敗
- API キーがない → MCP 接続失敗
- secrets がない → テスト不能

## 注意
- git 専用。他VCS では `WorktreeCreate` hookでファイルコピーを自前実装する必要あり
- プロジェクトルートに配置（`.claude/` 内ではない）

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)
