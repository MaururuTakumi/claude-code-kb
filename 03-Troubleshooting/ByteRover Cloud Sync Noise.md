# ByteRover Cloud Sync Noise — auth / push失敗をローカル作業停止と混同しない

> ByteRover は `query` / `curate` のローカル利用と、`push` / `pull` の cloud sync が別系統。  
> auth や cloud sync の失敗が出ても、ローカル knowledge 運用まで止まったとは限らない。

## 症状
- `Not authenticated`
- `Token has expired` / `Token is invalid`
- cloud sync (`push` / `pull`) だけ失敗する
- 同じ日に何度も auth / cloud sync エラーが出て、夜間運用のノイズになる

## 切り分け

### 1. 状態確認
```bash
brv status
```

### 2. 何が失敗しているか分ける
- `brv query` / `brv curate` が動く → **ローカル運用は継続可能**
- `brv push` / `brv pull` だけ失敗する → **cloud sync 側の問題**
- provider 未接続 → `brv providers connect byterover`

## 対処

### ローカル利用を優先する
cloud sync が不安定でも、まず `query` / `curate` でローカル knowledge を維持する。

```bash
brv query "What patterns matter for this task?"
brv curate "Today we learned ..."
```

### cloud sync の再認証が必要な場合
```bash
brv login --help
```

### provider 未接続の場合
```bash
brv providers connect byterover
```

## 運用ルール
- ByteRover の **auth / cloud sync エラーは即「全停止」とは扱わない**
- まず `query` / `curate` が生きているか確認する
- 夜間タスクでは、cloud sync 失敗を高優先度障害と混同しない
- KBやmemoryへの記録自体はローカルで先に完了させる

## 教訓
- 2026-04-06: auth / cloud sync の失敗が複数タスクで再発したが、作業自体はローカル継続で完了した
- 2026-04-22: この環境では provider 接続後でも `Authentication required for cloud sync` が `brv query` / `brv curate` 側に混ざることがあった。heartbeat の必須経路に ByteRover 成功を置かず、失敗時は memory / KB ローカル記録へ即フォールバックする
- 2026-05-01: `brv query` は使えても、`curate` / cloud sync 系の認証エラーが再発した。同期成功を待たず、local 成果物・memory・KBへの保存を優先する運用が実務的。
- ノイズ源は「ByteRover全停止」ではなく「cloud sync 系の不安定さ」だった
- 障害分類を誤ると、不要なエスカレーションや運用停止を招く

関連: [[03-Troubleshooting/Auth Expiry]]
