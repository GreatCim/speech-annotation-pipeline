# 学术引用与方法报告

[English](CITATIONS.en.md) | [使用指南](README.md)

核对日期：2026-10-24。本项目是集成工作流，贡献范围见[NOTICE.md](NOTICE.md)。请引用实际使用的工具、模型和本工作流版本，而不是把以下全部项目无差别写成每次实验都用过。

## 按路径选择

| 实际功能 | 应报告与引用 |
| --- | --- |
| Whisper转录 | Radford等（2023），faster-whisper，CTranslate2，实际模型及精度 |
| VAD | Silero Team及实际模型/软件版本；调用封装为faster-whisper的VAD时也注明 |
| MFA对齐 | MFA软件、Kaldi、实际声学模型和发音词典，不能只写“MFA” |
| HanLP句法辅助 | He与Choi（2021），HanLP及实际使用的中文ELECTRA BASE或英文ModernBERT BASE模型 |
| 声纹核验 | SpeechBrain、ECAPA-TDNN论文及预训练模型；不能称为完整diarization |
| 音频事件标签 | AST论文和AudioSet微调模型；不能将事件标签直接当作BGM或电影原声真值 |
| 自动重复分组 | 本仓库版本及规则；MFCC/DTW实现来自librosa，不宣称发明这些算法 |
| TextGrid读写 | Praatio；人工检查若使用Praat，另外引用实际使用的Praat版本 |
| 使用者提供文本 | 说明文本来源及核对程序；**未运行Whisper时，不写“Whisper转录”** |

## 英文路径的补充引用

0.5.0英文路径使用[English MFA acoustic model v3.0.0](https://mfa-models.readthedocs.io/en/latest/acoustic/English/English%20MFA%20acoustic%20model%20v3_0_0.html)与[English (US) MFA dictionary v3.0.0](https://mfa-models.readthedocs.io/en/latest/dictionary/English/English%20%28US%29%20MFA%20dictionary%20v3_0_0.html)，依各自页面引用McAuliffe与Sonderegger（2024），不要把英文实验写成使用中文模型。声学模型与词典均使用MFA IPA集合；模型输出不等于人工严式转写。

英文句法使用`EN_TOK_LEM_POS_NER_SRL_UDEP_SDP_CON_MODERNBERT_BASE`；除HanLP引用外，记录[具体HanLP模型](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html)及[ModernBERT模型卡与原论文](https://huggingface.co/answerdotai/ModernBERT-base)。固定分词资源revision见`models.lock.json`。任务的`CITATIONS_USED.md`按所选语言生成；只安装但未使用的模型不应写进实验方法。

## 核心文献

1. Radford, A., Kim, J. W., Xu, T., Brockman, G., McLeavey, C., & Sutskever, I. (2023). *Robust Speech Recognition via Large-Scale Weak Supervision*. ICML, PMLR 202, 28492–28518. [正式论文](https://proceedings.mlr.press/v202/radford23a.html)。实现另引[faster-whisper](https://github.com/SYSTRAN/faster-whisper)与[CTranslate2](https://github.com/OpenNMT/CTranslate2)。
2. McAuliffe, M., Socolof, M., Mihuc, S., Wagner, M., & Sonderegger, M. (2017). *Montreal Forced Aligner: Trainable Text-Speech Alignment Using Kaldi*. Interspeech, 498–502. [DOI](https://doi.org/10.21437/Interspeech.2017-1386)。截至核对日期，[MFA上游](https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner#citation)另推荐MFA 3引用：McAuliffe, M., Gunter, K., Wagner, M., & Sonderegger, M. (2026), *Montreal Forced Aligner and the state of speech-to-text alignment in 2026*, Interspeech 2026；上游未列出的页码/DOI不在此补造。
3. McAuliffe, M., & Sonderegger, M. (2024). *Mandarin MFA acoustic model v3.0.0*. [模型发布说明及推荐引用](https://mfa-models.readthedocs.io/en/latest/acoustic/Mandarin/Mandarin%20MFA%20acoustic%20model%20v3_0_0.html)。
4. McAuliffe, M., & Sonderegger, M. (2024). *Mandarin (China) MFA dictionary v3.0.0*. [词典说明及推荐引用](https://mfa-models.readthedocs.io/en/latest/dictionary/Mandarin/Mandarin%20%28China%29%20MFA%20dictionary%20v3_0_0.html)。本仓库锁定的是这两个3.0.0资源，不是当前网站上名称相近的新模型。
5. Povey, D., et al. (2011). *The Kaldi Speech Recognition Toolkit*. IEEE ASRU. [作者提供的论文](https://www.danielpovey.com/files/2011_asru_kaldi.pdf)。
6. Silero Team (2024). *Silero VAD*（软件）。按[上游CITATION.cff](https://github.com/snakers4/silero-vad/blob/master/CITATION.cff)引用，并补记实际调用版本，不能用引用年份代替模型版本。
7. He, H., & Choi, J. D. (2021). *The Stem Cell Hypothesis: Dilemma behind Multi-Task Learning with Transformer Encoders*. EMNLP, 5555–5577. [DOI](https://doi.org/10.18653/v1/2021.emnlp-main.451)。这是[HanLP上游指定的引用](https://github.com/hankcs/HanLP/blob/doc-zh/CITATION.cff)。本项目使用`CLOSE_TOK_POS_NER_SRL_DEP_SDP_CON_ELECTRA_BASE_ZH`，不写成不存在的“HanLP large”。
8. Ravanelli, M., et al. (2021). *SpeechBrain: A General-Purpose Speech Toolkit*. arXiv:2106.04624。与实际使用的[ECAPA模型卡](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb)一并记录。模型结构文献：Desplanques, B., Thienpondt, J., & Demuynck, K. (2020). *ECAPA-TDNN: Emphasized Channel Attention, Propagation and Aggregation in TDNN Based Speaker Verification*. Interspeech, 3830–3834. [DOI](https://doi.org/10.21437/Interspeech.2020-2650)。
9. Gong, Y., Chung, Y.-A., & Glass, J. (2021). *AST: Audio Spectrogram Transformer*. Interspeech. [DOI](https://doi.org/10.21437/Interspeech.2021-698)。另记录[实际AudioSet微调模型](https://huggingface.co/MIT/ast-finetuned-audioset-10-10-0.4593)及commit。

Praatio、librosa等软件按[THIRD_PARTY.md](THIRD_PARTY.md)中的官方仓库及实际版本引用；有上游CITATION或版本DOI时优先使用。这里不为缺少论文的工具杜撰文献。

## 方法部分应保留的信息

- 流水线版本、运行环境、模型名称/commit/SHA256、推理精度与设备。
- 硬件资源是否影响模型或精度选择，使用research还是adaptive策略；跨设备、模型或量化设置比较时应报告配置差异，并使用独立人工校准样本评价，不能把硬件升级或运行成功直接解释为准确率提高。硬件与质量限制见[声明](NOTICE.md#硬件与输出质量限制)。
- 文本来自ASR还是人工提供，是否经听辨修订；录音中实际漏读、重复、口误和语气词应如实处理，不能把提示词表直接视作实际发音转写。
- 使用的词典、分词单位、候选读音和修改记录。新增读音须在模型已有音素集合内；MFA输出是受限对齐假设，不是严式IPA真值。[官方词典格式](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/dictionary.html)。
- 使用`--pronunciations`会替换指定词项的原候选；本实现对这些候选使用等权发音先验和显式记录的中性静音参数，不能声称保留了原词典全部概率。
- 人工校准的范围、抽样方法及边界误差评估。候选选择的对齐成功率或likelihood不是“口音识别正确率”。

需要适应强口音时，可研究[MFA声学适配](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/workflows/adapt_acoustic_model.html)，但本版本没有自动训练口音模型。声学模型之外的新音素、细微音质/共发音、梯度变体不能靠添加一个IPA字符解决。候选和规则应在开发集制定，在独立人工标注集验证，避免在待研究数据上反复调规则后把结果当作独立证据。
