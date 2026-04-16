# Memory Architecture — Claude Code のメモリ設計

> Claude Code は 3層のメモリを持つ。
> CLAUDE.md（ルール）、Auto Memory（学習）、Daily/Topic Memory（詳細）。

## 3層構造

| 層 | ファイル | 読み込み | 用途 |
|----|---------|---------|------|
| ルール層 | `CLAUDE.md` + `.claude/rules/` | 毎セッション全量 | 行動規範・プロジェクト規約 |
| メモリ層 | `~/.claude/projects/<proj>/memory/MEMORY.md` | 毎セッション先頭200行(max 25KB) | 蓄積された知識のインデックス |
| 詳細層 | `~/.claude/projects/<proj>/memory/*.md` | オンデマンド（関連タスク時） | トピック別の詳細知識 |

## Auto Memory

Claude Code が自動で作成・更新する記憶システム。人間が書く必要なし。

### 運用原則
- **収集と抽出を分離する**: 日次ログ、heartbeat-state、session logs などの決定論的なコンテキスト収集と、Claude/LLM による要約・学習抽出は別フェーズにする。
- **後段だけ壊れても復旧可能にする**: LLM抽出が失敗しても、前段で集めた素材が残っていれば、その日の memory へ手動反映して完了扱いにできる。
- **手動復旧したら状態も補正する**: 日次ログへの反映が終わった後は、heartbeat-state や task state を `failed` のまま放置しない。`done-manual-recovery-*` のような明示的な完了状態に直し、朝レポートや監視で false negative を出さない。
- **壊れやすい部分を特定して監視する**: Auto Memory では前段のファイル収集より、ワンショットの LLM 抽出フェーズが失敗点になりやすい。

### MEMORY.md（インデックス）
- 先頭200行 or 25KB がセッション開始時に読み込まれる
- Claude が作業中に学んだことを自動記録
  - ビルドコマンド
  - デバッグで発見したパターン
  - アーキテクチャの決定事項
- `/memory` コマンドで直接編集可能

### トピックファイル（*.md）
- MEMORY.md が長くなると Claude が自動で分割
- `debugging.md`, `architecture.md`, `build-commands.md` 等
- 関連タスクの時にオンデマンドで読み込まれる（常時ではない）
- frontmatter に `name`, `description`, `type` を含む

### 例
```markdown
# Memory Index

## Project
- [build-and-test.md](build-and-test.md): npm run build (~45s), Vitest, dev server on 3001
- [architecture.md](architecture.md): API client singleton, refresh-token auth

## Reference
- [debugging.md](debugging.md): auth token rotation and DB connection troubleshooting
```

## 保存場所

```
~/.claude/projects/
  └── <project-path-hash>/
      └── memory/
          ├── MEMORY.md          ← インデックス（毎回読み込み）
          ├── debugging.md       ← トピック（オンデマンド）
          ├── architecture.md    ← トピック（オンデマンド）
          └── build-commands.md  ← トピック（オンデマンド）
```

## 設定
- デフォルトON
- `/memory` コマンドで編集
- `autoMemoryEnabled` in settings でOFF可能

## Subagent Memory との違い

| | Auto Memory | Subagent Memory |
|--|------------|-----------------|
| 対象 | メインセッション | サブエージェント |
| 保存先 | `~/.claude/projects/` | `.claude/agent-memory/` |
| スコープ | プロジェクト固定 | project / local / user 選択可 |
| 読み書き | Claude が自動 | サブエージェントが自動 |
| 共有 | 個人のみ | team共有可（project scope） |

関連: [[Subagent Orchestration]]

**出典:** [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)
