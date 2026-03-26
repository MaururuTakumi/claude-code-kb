# Thariq (@trq212) — Claude Code活用Tips集

> Claude Code内部の人間（Anthropic）による実践的なClaude Code活用知見。
> 全てのポストはClaude Code Knowledge Baseの各セクションに反映すべき。

## 1. Why even non-coding agents need bash
🔗 https://x.com/trq212/status/1982869394482139206
📊 ❤️985 🔖779 👁287.5K
📅 Oct 28, 2025

### 内容
Why even non-coding agents need bash

I've done dozens of calls with companies making general agents over the past few weeks and my advice generally boils down to: "use the bash tool more"

Here's a concrete example from my email agent:

(ブラウザ上では画像付き。画像内テキストは取得対象外のため省略)

### 知見
- 一般用途のエージェントでも、bash は単なる補助ではなく主戦力のツールになりうる。
- 大量の情報をそのままモデルに読ませる前に、bash で抽出・集計・整形してから渡す設計が有効。

---

## 2. Your Agent should use a File System
🔗 https://x.com/trq212/status/1970243253061783669
📊 ❤️1004 🔖1137 👁165.5K
📅 Sep 23, 2025

### 内容
Your Agent should use a File System

This is a hill I will die on. Every agent can use a file system.

The file system is an elegant way of representing state that your agent could read into context & allowing it to verify its work.

🧵 on why and examples

(ブラウザ取得範囲ではスレッド本文の続きは未展開。親ポスト本文は上記を正確に取得。)

### 知見
- エージェントの状態管理を会話コンテキストだけに閉じず、ファイルシステム上に外部化するべきという主張。
- ファイルを中間状態・作業記録・検証対象として使うことで、長時間タスクの再開性と自己検証性が上がる。

---

## 3. Making Playgrounds using Claude Code
🔗 https://x.com/trq212/status/2017024445244924382
📊 ❤️2641 🔖— 👁—
📅 Jan 30, 2026

### 内容
ブラウザ/公開API上のポスト本文は記事URLのみ。添付記事タイトルは「Making Playgrounds using Claude Code」。

記事プレビュー: "We've published a new Claude Code plugin called playground that helps Claude generate HTML playgrounds. These are standalone HTML files that let you visualize a problem with Claude, interact with it ..."

### 知見
- Claude Code の出力を静的テキストで終わらせず、HTML playground として可視化・操作可能な成果物に落とし込む発想。
- 複雑な状態遷移やUI/レイアウト問題は、playground 化して人間とエージェントの共有作業面を作るのが有効。

---

## 4. Lessons from Building Claude Code: Prompt Caching Is Everything
🔗 https://x.com/trq212/status/2024574133011673516
📊 ❤️5375 🔖14048 👁2.1M
📅 Feb 20, 2026

### 内容
ブラウザ/公開API上のポスト本文は記事URLのみ。記事タイトルは「Lessons from Building Claude Code: Prompt Caching Is Everything」。

ブラウザで取得できた記事冒頭:
- "It is often said in engineering that "Cache Rules Everything Around Me", and the same rule holds for agents."
- "Long running agentic products like Claude Code are made feasible by prompt caching ..."
- "At Claude Code, we build our entire harness around prompt caching."
- "Prompt caching works by prefix matching ... the order you put things in matters enormously."
- "The best way to do this is static content first, dynamic content last."
- Claude Code の並び例: 1) Static system prompt & Tools 2) CLAUDE.md 3) 以降により動的な情報

### 知見
- 長時間エージェントのコストと速度は prompt caching の設計で決まる。
- 静的→半静的→動的の順にプロンプトを並べ、prefix 共有率を最大化するのが実運用の要点。

---

## 5. Lessons from Building Claude Code: Seeing like an Agent
🔗 https://x.com/trq212/status/2027463795355095314
📊 ❤️10935 🔖— 👁—
📅 Feb 28, 2026

### 内容
ブラウザ/公開API上のポスト本文は記事URLのみ。記事タイトルは「Lessons from Building Claude Code: Seeing like an Agent」。

取得できた記事プレビュー/検索スニペット:
- "One of the hardest parts of building an agent harness is constructing its action space."
- "Claude acts through Tool Calling ..."
- "As Claude gets smarter, it becomes increasingly good at building its context if it's given the right tools."
- Agent Skills は progressive disclosure を形式化し、探索しながら関連コンテキストを見つけられるようにする。

### 知見
- 賢いモデルほど「何を見るか」を自分で探索できるので、最重要なのは行動空間と観測面の設計。
- 一気に全部見せるより、progressive disclosure で必要な情報へ段階的に到達させるほうが強い。

---

## 6. Lessons from Building Claude Code: How We Use Skills
🔗 https://x.com/trq212/status/2033949937936085378
📊 ❤️15980 🔖— 👁—
📅 Mar 18, 2026

### 内容
ブラウザ/公開API上のポスト本文は記事URLのみ。記事タイトルは「Lessons from Building Claude Code: How We Use Skills」。

取得できた記事プレビュー/検索スニペット:
- "Skills have become one of the most used extension points in Claude Code."
- "They're flexible, easy to make, and simple to distribute."
- 実運用では skills はいくつかの recurring categories に分かれ、良い skill はそのどれか1つにきれいに収まる。
- 例として reference/library、verification、data fetching、automation、scaffolding、code quality、CI/CD などの系統が言及されている。

### 知見
- Skill は単なるプロンプト断片ではなく、再利用可能な拡張点として設計・配布・運用するもの。
- 良い skill は責務が明確で、複数カテゴリをまたがず、呼び出し条件と成果物がはっきりしている。
