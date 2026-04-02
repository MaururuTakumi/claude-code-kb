# Hooks Design

Claude Code の Hooks は、セッションの特定イベントに処理を自動挟み込む仕組み。
品質管理・記憶保持・通知を「人が忘れても自動で動く」状態にできる。

## イベント一覧

| イベント | タイミング | 主な用途 |
|---------|-----------|---------|
| `SessionStart` | セッション開始時 | 前回の文脈読み込み・日次ログ確認 |
| `Stop` | セッション終了時 | サマリー生成・記憶保存・通知送信 |
| `PreToolUse` | ツール実行の直前 | 安全チェック・確認処理 |
| `PostToolUse` | ツール実行の直後 | 後処理の強制・結果記録 |
| `Notification` | Claude が人間を待つ時 | 待機通知 |

---

## 基本設定（settings.json）

```json
{
  "hooks": {
    "Stop": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "bash ~/.claude/hooks/on-stop.sh"
      }]
    }],
    "SessionStart": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "bash ~/.claude/hooks/on-start.sh"
      }]
    }]
  }
}
```

---

## 必須Hook: Stop（セッション完了通知）

```bash
#!/bin/bash
# ~/.claude/hooks/on-stop.sh

# 短命セッションはスキップ（ノイズ除去）
TURNS=$(echo "$CLAUDE_HOOK_DATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('num_turns',0))" 2>/dev/null)
[ "$TURNS" -lt 3 ] 2>/dev/null && exit 0

# 最終メッセージを取得
LAST_MSG=$(echo "$CLAUDE_HOOK_DATA" | python3 -c "
import json,sys
d=json.load(sys.stdin)
msgs=d.get('messages',[])
for m in reversed(msgs):
    if m.get('role')=='assistant':
        content=m.get('content','')
        if isinstance(content,list):
            for c in content:
                if c.get('type')=='text':
                    print(c.get('text','')[:200])
                    exit()
        else:
            print(str(content)[:200])
        break
" 2>/dev/null)

# Telegram通知
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  -d "text=✅ Claude Code完了（${TURNS}ターン）
${LAST_MSG}" > /dev/null
```

---

## 便利Hook: PostToolUse（後処理強制）

重要な操作（外部送信など）の後に必ず処理を強制する。

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "bash ~/.claude/hooks/post-bash.sh"
      }]
    }]
  }
}
```

用途例:
- `git push` 後に通知
- 外部APIコール後にログ記録
- ファイル書き込み後にgit add

---

## 便利Hook: SessionStart（前回文脈読み込み）

セッション開始時に重要なファイルを自動確認させる。

```bash
#!/bin/bash
# ~/.claude/hooks/on-start.sh

TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="/path/to/memory/${TODAY}.md"

if [ -f "$MEMORY_FILE" ]; then
  echo "今日のメモリ: $MEMORY_FILE"
  cat "$MEMORY_FILE" | head -50
fi
```

---

## Hook設計のベストプラクティス

### 1. 失敗しても止まらない設計
Hooksが失敗してもClaude Codeのメインフローを止めない。
```bash
# エラーをキャッチして握りつぶす
some_command 2>/dev/null || true
```

### 2. 軽量に保つ
Hookの実行時間が長いとセッションが遅くなる。
- 重い処理はバックグラウンドで: `some_command &`
- タイムアウトを設ける: `timeout 10 some_command`

### 3. フィルタリングでノイズ除去
全セッションに通知するとうるさい。
```bash
# 3ターン未満はスキップ
[ "$TURNS" -lt 3 ] && exit 0
# 特定プロジェクトのみ処理
[[ "$PROJECT_PATH" != *"auto-sns"* ]] && exit 0
```

### 4. 通知APIは rate limit 前提で設計する
Telegram などの通知面は、全体停止ではなく **HTTP 429** で詰まることがある。
そのため、Hook 側で「送れなかった = 障害」と即断しない。

```bash
RESP=$(mktemp)
HTTP_CODE=$(curl -s -o "$RESP" -w "%{http_code}" \
  -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  --data-urlencode "text=${MSG}")

if [ "$HTTP_CODE" = "429" ]; then
  echo "rate-limited: $(cat "$RESP")" >&2
  # 低優先度通知なら諦める / 重要通知なら後続ジョブで再送
elif [ "$HTTP_CODE" -ge 400 ] 2>/dev/null; then
  echo "notification failed: $(cat "$RESP")" >&2
fi
rm -f "$RESP"
```

ポイント:
- **HTTP status と response body を捨てない**
- 429 とその他の失敗を分けて扱う
- 低優先度通知は間引く（短命セッション・途中経過など）
- 重要通知だけ再送対象にする

### 5. 環境変数でプロファイル制御（ECCパターン）
本番/開発で動作を切り替える。
```bash
# ECC_HOOK_PROFILE=minimal|standard|strict
PROFILE=${ECC_HOOK_PROFILE:-standard}
[ "$PROFILE" = "minimal" ] && exit 0
```

---

## たくみん環境の実装済みHook

| Hook | ファイル | 内容 |
|------|---------|------|
| Stop/SessionEnd | `~/.claude/hooks/on-stop.sh` | Telegram完了通知（3ターン未満スキップ・プロジェクト絵文字付き） |
| Notification | `~/.claude/hooks/on-notification.sh` | 待機通知 |

設定: `~/.claude/settings.json` に Stop/SessionEnd/TaskCompleted/Notification の4イベント登録済み

Source: ECC (affaan-m/everything-claude-code) + honkoma実装
