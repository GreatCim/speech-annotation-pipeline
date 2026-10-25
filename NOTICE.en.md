# Project Scope, Contributions, and Development Statement

[中文](NOTICE.md) | [Installation and usage](README.en.md) | [Citation guide](CITATIONS.en.md)

This project is an **open-source tool integration workflow** for Mandarin and English speech annotation. It is not a speech recognition, phone recognition, or forced-alignment model developed from scratch, and does not claim that the underlying methods are entirely original.

## Contributions of This Repository

- Orchestrating tools, inputs, outputs, and error handling around the research workflow.
- Implementing version-isolated installation, hardware inspection, configuration validation, and launcher rollback.
- Combining existing methods into repeated-reading grouping rules, neighboring-context constraints, syntax-assisted merging, and review flags. MFCC, DTW, and syntactic parsing themselves are established methods and upstream implementations.
- Adding supplied-text alignment without ASR, pronunciation-candidate validation, and derived dictionaries.
- Organizing WAV/TextGrid exports, transcripts, subtitles, audit records, provenance, and review reports, and writing regression tests.

These are workflow and supporting-code contributions, not claims of a new underlying learning algorithm or unmeasured universal accuracy.

## Upstream Contributions

Whisper and faster-whisper/CTranslate2 provide recognition and inference. Silero provides VAD. MFA and Kaldi provide forced alignment. The MFA model maintainers provide acoustic models, phone inventories, and pronunciation dictionaries. HanLP provides parsing and other NLP capabilities. SpeechBrain/ECAPA provides speaker representations. AST provides audio-event classification. Praatio, librosa, NumPy/SciPy, SoundFile, PyAV, OpenCC, pypinyin, and other dependencies provide supporting functionality. Pinned dependency versions are listed under `locks/`.

This version does not pretrain these models itself. MFA selects an alignment path among permitted dictionary pronunciations; it must not be described as an original unrestricted accent-to-phone recognizer developed by this project. This statement implies no affiliation, partnership, or endorsement by upstream teams.

## AI-Assisted Development

The project initiator supplied the requirements and research constraints. AI coding assistance was used to generate, modify, and debug portions of the integration code and documentation. The entire codebase should not be described as wholly handwritten or independently invented by the initiator. Actual maintainers and researchers remain responsible for code review, data permissions, research design, manual annotation, and final scholarly conclusions.

## Hardware and Output-Quality Limitations

Transcription quality may be indirectly constrained by hardware resources and the configurations they permit. RAM, VRAM, drivers, and backend support can limit model size, numerical precision, and workload. Smaller or quantized configurations may produce different results, but this project has not established a universal degradation rate. Higher numerical precision or more expensive hardware is not guaranteed to improve accuracy. When the same model and settings can complete, weaker hardware generally affects speed more directly; CPU execution is not inherently inferior in accuracy to GPU execution. Bitwise-identical results across devices are not guaranteed.

The default research profile fixes large-v3; the adaptive profile permits resource-dependent model/precision choices. Record the actual choice in the research methods. Memory exhaustion, interruptions, and partial exports are not evidence of valid annotation. More powerful hardware cannot replace recording-quality control, dictionary-coverage checks, manual correction, or independent evaluation. This project does not guarantee gold-standard transcription, speaker identity, or phone boundaries. See the [hardware disclaimer](README.en.md#hardware-and-quality-disclaimer) and [validation scope](TESTING.en.md).

## Citation and Licensing

Cite the upstream work for the modules actually used, not only this repository. Consult [CITATIONS.en.md](CITATIONS.en.md), [THIRD_PARTY.md](THIRD_PARTY.md), and each task's `CITATIONS_USED.md`. The latter is a method checklist; execution logs determine which stages completed successfully.

The MIT license in [LICENSE](LICENSE) covers only integration code and documentation that this project has the right to license. It does not relicense dependencies, pretrained weights, dictionaries, training data, speech recordings, or third-party media. Citing a paper does not replace license compliance, and an open-source code license does not automatically apply to associated models or datasets.

Before publication, verify the collective-author placeholder in [CITATION.cff](CITATION.cff) against the actual contributors and add the final repository URL. No personal names, affiliations, DOIs, or peer-review status are invented here.
