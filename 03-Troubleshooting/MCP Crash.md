# MCP Crash — MCP不調パターンと対処法

> Chrome DevTools MCPはClaude Codeを殺すことがある。  
> パターンを知っておけば事前回避できる。

## 既知のクラッシュパターン

### パターン1: 複数MCPサーバー同時初期化
- **原因**: .mcp.json に5つ以上のMCPサーバーが定義されていて、全部同時に初期化しようとする
- **症状**: Claude Codeが起動直後に即死
- **対処**: .mcp.json を1サーバーだけにする → 作業に応じて切り替え
- **恒久対策**: `swap-mcp.sh` でタスクに応じてMCP設定を入れ替え + sleep 5

### パターン2: npxキャッシュ腐敗
- **原因**: npx経由でchrome-devtools-mcpを実行する際、キャッシュが壊れる
- **症状**: MCP接続後にClaude Codeが即死
- **対処**: `rm -rf ~/.npm/_npx` してから再実行
- **恒久対策**: `npm install -g chrome-devtools-mcp` でグローバルインストール（npx排除）

### パターン3: 重いページでのMCP操作
- **原因**: バズ投稿のリプ欄、大量要素のページでスナップショット取得
- **症状**: タイムアウトまたはメモリ不足でClaude Codeが停止
- **対処**: 直接URLを開かず、/notifications/mentions 等の軽量ページから取得

## MCP健全性チェック

```bash
# 各ポートが生きてるか確認
for port in 9222 9224 9227; do
  curl -s --connect-timeout 2 http://127.0.0.1:$port/json/version > /dev/null && echo "$port OK" || echo "$port DOWN"
done
```

## Chrome MCP vs 代替手段

| 操作 | Chrome MCP | 代替 |
|------|-----------|------|
| X投稿 | ❌ 不安定 | ✅ Typefully API |
| Threads投稿 | △ 動くが重い | ✅ Threads API（導入中）|
| note投稿 | ✅ 必要 | ❌ API なし |
| データ取得 | △ 重い | ✅ API優先 |
| アカウント検証 | ✅ 必要 | ❌ 代替なし |

**原則: APIがあるならAPIを使う。Chrome MCPはAPIがない場合の最終手段。**

関連: [[Auth Expiry]] [[Chrome MCP]] [[Fallback Design]]
