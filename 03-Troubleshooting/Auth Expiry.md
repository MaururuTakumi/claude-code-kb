# Auth Expiry — OAuth切れの検知・復旧・予防

> Claude CodeのOAuth認証は一定期間で切れる。  
> 切れた瞬間から全Claude Code依存タスクが連鎖停止する。

## 症状
- `OAuth token has expired. Please obtain a new token or refresh your existing token.`
- `claude -p "..."` が無応答（認証切れ + バージョンバグの複合の場合あり）

## 検知方法

### 事前検知（深夜タスク開始前）
```bash
claude auth status --json 2>&1 | python3 -c 'import json,sys; d=json.load(sys.stdin); print("OK" if d.get("loggedIn") else "EXPIRED")'
```

### タスク実行中の検知
- stdoutが空 + returncode 0 → [[Version Bugs]] との複合の可能性
- stderrに `OAuth token has expired` → 認証切れ確定

## 復旧手順

1. **再ログイン**
```bash
claude auth login
# ブラウザで認証完了
```

2. **疎通確認**
```bash
claude -p "say OK"
# → "OK" が返ればOK
```

3. **返らない場合** → [[Version Bugs]] を確認。バージョンダウングレードが必要な場合あり

## 予防策

- **4日以上放置するとセッション切れる可能性あり**
- 深夜タスク開始前（00:00）に `claude auth status` を自動チェック
- 切れていたら即座にTelegramで通知（人間の操作が必要）

## フォールバック

認証切れでClaude Codeが使えない間:
- たくみん（OpenClaw）が直接実行できるタスクは代替実行
- SNS投稿: [[Fallback Design]] のフォールバック投稿を使用
- 分析: Codex で代替（OAuth認証は別系統）

## 教訓
- 2026-03-25夜: OAuth切れ → daily-sync以降全停止 → AM Sweep未送信
- 2026-03-19: OAuth切れ → 複数のHEARTBEATタスクがブロック
- **認証切れは「タスク1つの失敗」ではなく「全系統の停止」を意味する。最優先で対応すべき**

関連: [[Version Bugs]] [[Fallback Design]] [[Monitoring]]
