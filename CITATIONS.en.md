# Academic Citation and Methods Reporting

[中文](CITATIONS.md) | [Installation and usage](README.en.md) | [Project statement](NOTICE.en.md)

Reference check date: **2026-10-24**. This is an integration workflow; its contribution boundaries are described in [NOTICE.en.md](NOTICE.en.md). Cite the tools, models, and workflow version actually used. Do not list every component below as though every experiment used it.

## Select Citations by Execution Path

| Function actually used | Report and cite |
| --- | --- |
| Whisper transcription | Radford et al. (2023), faster-whisper, CTranslate2, and the actual model/precision |
| VAD | Silero Team and actual model/software versions; identify the faster-whisper wrapper when used |
| MFA alignment | MFA software, Kaldi, the acoustic model, and the pronunciation dictionary, not merely "MFA" |
| HanLP syntax assistance | He and Choi (2021), HanLP, and the selected Mandarin ELECTRA BASE or English ModernBERT BASE multitask model |
| Speaker verification | SpeechBrain, the ECAPA-TDNN paper, and the pretrained model; do not call this full diarization |
| Audio-event labels | AST paper and AudioSet-finetuned model; do not treat labels as ground truth for BGM or film-source audio |
| Automatic repetition grouping | This repository version and its combination rules; MFCC/DTW implementations are from librosa, not invented here |
| TextGrid input/output | Praatio; separately cite the actual Praat version if used for manual review |
| Supplied-text alignment | Transcript provenance and checking procedure; **do not claim Whisper transcription when Whisper was not run** |

The task's `CITATIONS_USED.md` is a path-specific checklist, not proof that every configured stage finished. Confirm actual execution and failures in the logs. Merely installing a dependency is not evidence of using it in an experiment.

## English-Path Resources

Version 0.5.0 English tasks use [English MFA acoustic model v3.0.0](https://mfa-models.readthedocs.io/en/latest/acoustic/English/English%20MFA%20acoustic%20model%20v3_0_0.html) and [English (US) MFA dictionary v3.0.0](https://mfa-models.readthedocs.io/en/latest/dictionary/English/English%20%28US%29%20MFA%20dictionary%20v3_0_0.html). Cite McAuliffe and Sonderegger (2024) as specified on those version-specific pages, not the Mandarin resources for an English experiment. The MFA IPA inventory is not validated narrow phonetic transcription.

English syntax uses `EN_TOK_LEM_POS_NER_SRL_UDEP_SDP_CON_MODERNBERT_BASE`. In addition to HanLP, identify the [specific multitask checkpoint](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html) and follow the [ModernBERT model card and paper citation](https://huggingface.co/answerdotai/ModernBERT-base). The tokenizer revision is pinned in `models.lock.json`. `CITATIONS_USED.md` follows the task language. Installed but unused models do not belong in the experiment's methods.

## Core References

1. Radford, A., Kim, J. W., Xu, T., Brockman, G., McLeavey, C., and Sutskever, I. (2023). *Robust Speech Recognition via Large-Scale Weak Supervision*. ICML, PMLR 202, 28492-28518. [Published paper](https://proceedings.mlr.press/v202/radford23a.html). Also identify the implementation: [faster-whisper](https://github.com/SYSTRAN/faster-whisper) and [CTranslate2](https://github.com/OpenNMT/CTranslate2).
2. McAuliffe, M., Socolof, M., Mihuc, S., Wagner, M., and Sonderegger, M. (2017). *Montreal Forced Aligner: Trainable Text-Speech Alignment Using Kaldi*. Interspeech, 498-502. [DOI](https://doi.org/10.21437/Interspeech.2017-1386). At the reference check date, [MFA upstream](https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner#citation) also recommends the MFA 3 reference: McAuliffe, M., Gunter, K., Wagner, M., and Sonderegger, M. (2026). *Montreal Forced Aligner and the state of speech-to-text alignment in 2026*. Interspeech 2026. Page numbers and a DOI not supplied by upstream are not invented here.
3. McAuliffe, M., and Sonderegger, M. (2024). *Mandarin MFA acoustic model v3.0.0*. [Model release and recommended citation](https://mfa-models.readthedocs.io/en/latest/acoustic/Mandarin/Mandarin%20MFA%20acoustic%20model%20v3_0_0.html).
4. McAuliffe, M., and Sonderegger, M. (2024). *Mandarin (China) MFA dictionary v3.0.0*. [Dictionary release and recommended citation](https://mfa-models.readthedocs.io/en/latest/dictionary/Mandarin/Mandarin%20%28China%29%20MFA%20dictionary%20v3_0_0.html). This workflow pins these two v3.0.0 resources, not similarly named newer releases.
5. Povey, D., et al. (2011). *The Kaldi Speech Recognition Toolkit*. IEEE ASRU. [Author-hosted paper](https://www.danielpovey.com/files/2011_asru_kaldi.pdf).
6. Silero Team (2024). *Silero VAD* [software]. Follow the [upstream CITATION.cff](https://github.com/snakers4/silero-vad/blob/master/CITATION.cff) and additionally record the version actually used. A citation year is not a model version.
7. He, H., and Choi, J. D. (2021). *The Stem Cell Hypothesis: Dilemma behind Multi-Task Learning with Transformer Encoders*. EMNLP, 5555-5577. [DOI](https://doi.org/10.18653/v1/2021.emnlp-main.451). This is the [citation specified by HanLP upstream](https://github.com/hankcs/HanLP/blob/doc-zh/CITATION.cff). The workflow uses `CLOSE_TOK_POS_NER_SRL_DEP_SDP_CON_ELECTRA_BASE_ZH`, not a model called "HanLP large."
8. Ravanelli, M., et al. (2021). *SpeechBrain: A General-Purpose Speech Toolkit*. [arXiv:2106.04624](https://arxiv.org/abs/2106.04624). Record the actual [ECAPA pretrained model](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb) as well. Architecture reference: Desplanques, B., Thienpondt, J., and Demuynck, K. (2020). *ECAPA-TDNN: Emphasized Channel Attention, Propagation and Aggregation in TDNN Based Speaker Verification*. Interspeech, 3830-3834. [DOI](https://doi.org/10.21437/Interspeech.2020-2650).
9. Gong, Y., Chung, Y.-A., and Glass, J. (2021). *AST: Audio Spectrogram Transformer*. Interspeech. [DOI](https://doi.org/10.21437/Interspeech.2021-698). Also record the [AudioSet-finetuned model](https://huggingface.co/MIT/ast-finetuned-audioset-10-10-0.4593) and its commit.

For Praatio, librosa, and supporting software, use the official repositories in [THIRD_PARTY.md](THIRD_PARTY.md) and the actual versions. Prefer an upstream CITATION file or version DOI when provided. Do not invent papers for tools that do not have them. Cite this workflow using verified metadata in [CITATION.cff](CITATION.cff); the collective author and final repository location need publisher verification before release.

## Information to Retain in Research Methods

- Workflow version, runtime environment, model names/commits/SHA256 values, inference precision, and execution device.
- Whether hardware resources affected model or precision selection, and whether `research` or `adaptive` was used. For cross-device/model/quantization comparisons, report configuration differences and evaluate against an independent manually corrected sample. An upgrade or successful run is not evidence of improved accuracy; see the [hardware limitations](NOTICE.en.md#hardware-and-output-quality-limitations).
- Whether transcripts came from ASR or a user, and how they were checked by listening. Record actual omissions, repetitions, slips, and fillers; an elicitation prompt is not necessarily a transcript.
- Dictionary, tokenization units, candidate pronunciations, and modifications. New candidates must use the existing acoustic-model inventory. MFA output is a constrained alignment hypothesis, not narrow-IPA ground truth. See the [official dictionary format](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/dictionary.html).
- `--pronunciations` replaces original candidates for the specified tokens. This implementation uses equal pronunciation priors and explicitly recorded neutral silence parameters for overrides; it does not preserve every original probability for those tokens.
- Manual-correction scope, sampling procedure, and boundary-error evaluation. Alignment success or likelihood is not an accent-recognition accuracy measure. No cross-hardware accuracy benchmark has been completed for this workflow.

For stronger accents, [MFA acoustic adaptation](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/workflows/adapt_acoustic_model.html) may warrant investigation, but this release does not automatically train an accent model. Phones outside the model, subtle voice-quality differences, coarticulation, and gradient variants cannot be recovered by merely adding an IPA character. Develop candidates and rules on a development set and validate them on an independent manually annotated set, rather than repeatedly tuning on the study data and treating the output as independent evidence.

Citation is separate from permission to use or distribute software, models, dictionaries, or recordings. Check [THIRD_PARTY.md](THIRD_PARTY.md) and the original licenses for the artifacts you actually use.
