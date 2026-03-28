# Harness design for long-running application development

- **URL:** https://www.anthropic.com/engineering/harness-design-long-running-apps
- **著者:** Prithvi Rajasekaran (Anthropic Labs)
- **日付:** 2026-03（推定）
- **検証状態:** ✅ 読了・KB反映済み（2026-03-28）

## 要約

GANに着想を得たGenerator-Evaluator構造を、フロントエンドデザインと長時間コーディングに適用。
3エージェント構成（Planner/Generator/Evaluator）で数時間の自律コーディングを実現。

## KBへの反映箇所

| 反映先 | 追加内容 |
|--------|---------|
| Harness Design.md | Sprint Contract交渉プロセス、Evaluatorチューニングループ、ファイルベース通信、ハーネス簡素化テスト、Evaluator費用対効果 |
| Two-Phase Execution.md | Context Reset vs Compaction の使い分け |
| Model Selection.md | Opus 4.6固有の最適化（Sprint不要、Compaction十分） |

## 核心的な洞察

1. **Self-Evaluation Bias**: 生成者に評価させると甘くなる。分離が必須
2. **Context Anxiety**: Compactionでは解決しない場合がある（Opus 4.6で解消）
3. **Sprint Contract**: 実装前にGeneratorとEvaluatorが「完了条件」を交渉する
4. **ファイルベース通信**: エージェント間は口頭ではなくファイルで状態を渡す
5. **ハーネス簡素化**: 不要になった工程は惰性で残さない。1つずつ外して検証
6. **Evaluatorの費用対効果**: モデル能力の境界にあるタスクでのみ有効
7. **Rubricの言葉が出力を方向づける**: "museum quality"と書くと本当にそう向かう
