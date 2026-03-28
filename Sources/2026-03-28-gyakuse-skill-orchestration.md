# skill-creatorから学ぶSkill設計と、Orchestration Skillの作り方

- **URL:** https://nyosegawa.com/posts/skill-creator-and-orchestration-skill/
- **著者:** 逆瀬川ちゃん (@gyakuse)
- **日付:** 2026-03
- **検証状態:** ✅ 読了・KB反映済み（2026-03-28）

## 要約

Anthropic公式skill-creatorの構造分析と、著者のagentic-benchとの比較を通じて、
Orchestration型Skillの2つのアーキテクチャ（Sub-agent型/Skill Chain型）を体系化した記事。

## KBへの反映箇所

| 反映先 | 追加内容 |
|--------|---------|
| Skills Reference.md | Progressive Disclosure(3層) / Description最適化 / Why-driven設計 / 確定的処理オフロード判断 |
| 新規: Orchestration Patterns.md | Sub-agent型 vs Skill Chain型 / Schema契約 / SKILL.mdオーケストレーター設計 |

## 核心的な洞察

1. **Progressive Disclosure**: L1(~100tok常時) → L2(<5000tokトリガー時) → L3(参照時)の3層
2. **SKILL.mdはオーケストレーター**: 自分では処理せず「いつ・誰に・何を」だけ記述
3. **Sub-agent型 vs Skill Chain型**: 並列→Sub-agent / 直列→Skill Chain
4. **Schema契約**: AI⇔スクリプトの接続点をreferences/に厳密定義
5. **Why-driven**: ALWAYSやNEVERの連発は黄信号。理由を説明する
6. **Description**: Claudeはundertrigger傾向。押し強めに書く
7. **確定的処理のオフロード**: 「AIがゼロからできるか？」で判断
8. **環境別フォールバック**: Claude.ai/Claude Code/Coworkで実行方法を切り替え
