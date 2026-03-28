# Explore the .claude directory（公式ドキュメント）

- **URL:** https://code.claude.com/docs/en/claude-directory
- **著者:** Anthropic（公式）
- **日付:** 2026-03（最新版）
- **検証状態:** ✅ 読了・KB反映済み（2026-03-28）

## 要約

Claude Code の `.claude/` ディレクトリと `~/.claude/` の全ファイル構造を網羅した公式リファレンス。
CLAUDE.md、settings.json、rules/、skills/、agents/、agent-memory/、output-styles/、worktreeinclude の
役割・読み込みタイミング・優先順位・使い分けを解説。

## KBへの反映箇所

| 反映先 | 追加内容 |
|--------|---------|
| CLAUDE.md Design.md | 200行ルール、Path-Scoped Rules |
| Subagent Orchestration.md | Agent Memory 3スコープ（project/local/user） |
| 新規: Output Styles.md | カスタムシステムプロンプト |
| 新規: Worktree Management.md | .worktreeinclude と並列セッション |
| 新規: Memory Architecture.md | Auto Memory の公式仕様（200行/25KBキャップ等） |
| 新規: Settings Precedence.md | settings の4層優先順位・Array結合/Scalar上書き |
| 新規: Skills Reference.md | Skillsの公式仕様（frontmatter/引数/バンドル/Commands比較） |

## 核心的な知見

1. CLAUDE.md は200行以内推奨。超えたらrules/に分割
2. Path-Scoped Rules でファイル種別ごとにルールを出し分けできる
3. Settings は global < project < local < CLI の4層。Arrayは結合、Scalarは上書き
4. Subagent Memory は project/local/user の3スコープ
5. Output Styles でClaude Codeをコーディング以外にも適応可能
6. Auto Memory の MEMORY.md は先頭200行(max 25KB)だけ読み込まれる
7. Skills が Commands の上位互換。新規はSkills推奨
