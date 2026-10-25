# Mandarin and English Speech Annotation Pipeline

[中文指南](README.md) | [Project statement](NOTICE.en.md) | [Citation guide](CITATIONS.en.md) | [Validation scope](TESTING.en.md) | [Third-party licenses](THIRD_PARTY.md)

## First Time? Start Here

1. Download the project-built release ZIP and fully extract it. Do not run files inside the ZIP.
2. On **Windows**, double-click **`开始使用_START_HERE.bat`**; on an **M-series Mac**, use **`开始使用_START_HERE.command`**.
3. On first use, select Mandarin, English, or both, then confirm installation. Use the same file every time; later launches open the workspace directly.

**Mac requires macOS 14+ and remains a preview in 0.7.1, without real-Mac end-to-end acceptance yet.** It uses the native ARM CPU, not the Apple GPU, and requires at least 30 GiB free disk space. Start with the [Mac three-step guide](MACOS.en.md). The Windows guide continues below.

No need to read the full manual or install Python first. Both the first-run window and workspace offer English / Chinese. **Automatic hardware selection is the default: detect available RAM and supported GPU free memory, select model/precision candidates, then test actual inference.** Computers with only integrated graphics or no supported GPU use CPU medium/small/base candidates, not large-v3 by default. Fixed large-v3 requires explicitly choosing Research. The rest of this guide is a reference. `setup.bat` / `run.bat` remain advanced or legacy entry points; `gui.bat` uses the same new launcher.

Windows installation requires Internet access and at least 25 GiB free for one language or 28 GiB for both. The window displays actual stages, stays open on failure, and offers logs and retry. Windows logs and a **Chinese/English summary in the same file** are saved under `.launcher-state/install-<time>/`; see the [Mac guide](MACOS.en.md) for Mac log locations. **Do not upload local state to GitHub.** The launcher does not replace system Python or require administrator access or disabling security software.

A local workflow for repeated-word recordings, read sentences, monologues, and interviews. It exports matching WAV and Praat TextGrid files, separate TXT/LAB files, and review reports. **Automatic annotations are candidates for manual correction, not a gold standard. No training-data sufficiency or boundary-accuracy guarantee is made.**

**This is an integration of open-source tools, not an entirely original speech recognition or alignment model.** This repository contributes installation, orchestration, segmentation and review rules, supplied-text input, exports, and reports. AI coding assistance was used during development. Algorithms, pretrained models, and dictionaries are credited to their upstream authors in the [project statement](NOTICE.en.md) and [citation guide](CITATIONS.en.md).

This English guide describes version **0.7.1**. **Runtime summaries are bilingual: the same `summary.log` contains Chinese first, followed by English**, regardless of recording or interface language. Completed, review-needed, partially failed, and abbreviated error summaries include both languages. Technical identifiers, paths, transcripts, and original upstream errors are preserved without automatic translation. `summary.json` provides structured details. Not every console or upstream log message is localized.

## Install on Windows

Supported platform: **Windows 10/11 x64**. Download and fully extract the source ZIP, then double-click **`开始使用_START_HERE.bat`**. No existing Python, Conda, or FFmpeg installation is required. The installer downloads and verifies Miniforge, creates separate ASR, MFA, and analysis environments, installs pinned dependencies and models, and checks inference and alignment. It does not replace system Python or modify the global PATH.

### Choose Recording Languages

Select Mandarin, English, or both using the first-run checkboxes. Legacy `setup.bat` still offers **1 = Mandarin, 2 = English, 3 = both**. Only the selected language resources are downloaded. One multilingual Whisper model is shared; MFA acoustic models, dictionaries, and full-install HanLP models are language-specific. VAD, AST and ECAPA are shared. Noninteractive examples:

```powershell
.\setup.bat -Languages en
.\setup.bat -Languages "zh,en" -DefaultLanguage zh
.\setup.bat -Languages en -TextOnly
```

With one installed language, the run wizard uses it automatically. With both, it asks once; Enter keeps the installation default. CLI tasks accept `--language zh` or `--language en`. `run.bat languages` lists installed resources without downloading anything. To add a language, rerun setup with all languages to retain. Switching occurs only after validation, and the old environment remains available for rollback.

**Multiple languages require more storage, but not a second Whisper copy.** Adding English to a full Mandarin model cache downloads approximately 92 MB of MFA weights, a 4 MB dictionary, a 603 MB HanLP archive (approximately 650 MB extracted weights), and 2 MB of tokenizer resources. Temporary archives and caches affect final usage. Setup budgets 25 GiB free for one full language or 28 GiB for both; reduced word/text installations budget 12 GiB or 12.5 GiB. These are conservative installation-headroom estimates, not final model sizes. Retained environments from upgrades require additional space.

**Choose one target language per recording or batch. This does not enable within-sentence code-switch alignment.** English uses `english_mfa` plus `english_us_mfa`, both resource version 3.0.0. They use the MFA IPA phone inventory, not ARPAbet or verified narrow IPA. The dictionary is US English; other accents may need review and explicit pronunciation candidates. Dialect recognition/model selection is not automatic.

```powershell
.\run.bat run "D:\recordings\words.wav" --language en --output outputs\english_words
.\run.bat continuous "D:\recordings\speech.wav" --language en --output outputs\english_speech
.\run.bat from-text "D:\recordings\read.wav" --language en --transcript "D:\recordings\read.txt" --output outputs\english_text
.\run.bat phones --language en --output outputs\english_phones.txt
```

English uses word tokens, preserves apostrophes in contractions, and separates hyphenated parts. There is no Chinese script conversion or pinyin conversion. Numerals, unknown names and other scripts are retained as OOV evidence rather than assigned guessed pronunciations; correct these to the words actually spoken. English repetition grouping combines orthographic token signatures with acoustic distance, not pinyin or claimed phonetic transcription. Continuous English output contains `transcript.srt` but no `pinyin.srt`. Saved tasks retain their language and model identities; `align` follows the saved language, not a newly changed default. Legacy tasks without a language field remain Mandarin.

Version 0.6.1 combines first installation and everyday launch in **`开始使用_START_HERE.bat`**. The native Windows GUI, `gui.bat`, `run.bat` wizard and command-line interface remain available.

### Desktop Interface: English / Chinese

1. Choose **English / 简体中文** at the top right. The choice is applied immediately and remembered. Interface language is independent of **Audio language** and does not change form values or queued tasks. Native file dialogs may retain the operating system's display language.
2. In **New task**, add files or a folder, select the recording language, task type and output root. Only installed languages are offered. Repeated-word and supplied-text modes require WAV; continuous speech accepts supported audio/video formats.
3. Interviews require a clean 10–60 s target-speaker reference. Supplied-text mode accepts one recording/transcript pair at a time, with whole-recording, per-VAD-region or timed TSV mapping. Repetition counts are automatic; optional expected counts in advanced settings are checks only, not a fixed three-readings assumption.
4. Tasks run serially to avoid loading competing GPU models. The inspector shows real stages, available segment counts and original logs, without invented overall percentages or ETAs. Model configuration is read-only.
5. **Inspect results** offers flagged-segment filtering, audio playback and opening a WAV/TextGrid pair in a separately installed Praat. It is not an embedded boundary editor. Playback uses a temporary PCM16 copy and does not rewrite exported audio. **Bilingual run summary** opens the same Chinese/English `summary.log`.

Stopping terminates the owned process tree and stops the queue while retaining output. Restarting the GUI does not automatically start queued work. Resume is offered only when preparation is complete and no `package/` exists; arbitrary Whisper checkpoints cannot be resumed. Existing exports and manual corrections are never overwritten by a retry, which uses a new folder. Imported results are read-only and cannot be directly rerun.

**Models and environment** displays hardware detected during installation and opens the existing installer to add languages. It does not silently download models. Reload after installation; new tasks use the updated configuration while saved tasks retain their own snapshot. The GUI adds about 74 MB of pinned Qt/PySide6 downloads and more installed disk usage. GUI dependencies are optional for source users, but included by default in Windows setup.

Project `.gui-state/` holds task history, preferences, configuration snapshots and GUI worker logs. It may contain private paths/transcripts: **do not upload it to GitHub**. It is ignored and excluded from the source ZIP. Early cancellation may occur before a pipeline summary exists; the GUI log and interruption record are retained. Upstream logs, technical identifiers and transcripts are not automatically translated.

| Component | Default configuration |
| --- | --- |
| Transcription | Automatic model/precision selection by default, tested during installation; optional Research fixes `large-v3` |
| Speech activity detection | Silero VAD |
| Forced alignment | MFA 3.3.9; Mandarin: `mandarin_mfa` + `mandarin_china_mfa`; English: `english_mfa` + `english_us_mfa`; all resources v3.0.0 |
| Syntax | Mandarin HanLP ELECTRA **BASE**; English HanLP ModernBERT **BASE**, with dependency and constituency parsing |
| Speaker verification | SpeechBrain ECAPA with a user-provided target-speaker reference |
| Audio-quality risk labels | AST AudioSet multilabel sigmoid scores |

The selected, tested HanLP models are **BASE**, not "large." English uses `EN_TOK_LEM_POS_NER_SRL_UDEP_SDP_CON_MODERNBERT_BASE`; it is not parsed by the Mandarin model. HanLP, ECAPA, and AST run in a separate CPU environment. Whisper can use the GPU. Models are not automatically enlarged just because a larger GPU is present. See the [official HanLP model list](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html).

Allow approximately **25 GB or more of disk space and 16 GB or more of RAM** for a full installation. These are planning estimates, not universal minimum requirements. First installation needs access to GitHub, conda-forge, PyPI, PyTorch, Hugging Face, and the HanLP model servers. If the primary HanLP server fails, the installer tries the author's `ftp.hankcs.com` backup for the same model. It fails explicitly if neither source works; it does not silently substitute rules or a smaller model. Cached downloads can be reused.

GPU use requires a working NVIDIA driver. This version installs its own pinned CUDA 12.8/cuDNN 9.10 runtime libraries; it does not install or replace the system driver. No administrator access or disabling of security software is required by design. Network policies, permissions, and unsupported drivers can still prevent installation.

The default Windows runtime location is `%LOCALAPPDATA%\SpeechAnnotationRuntime\v0.7.1-<configuration-id>-<languages>`, with a shared `models-v1` cache under the same root. Source files may be in a Chinese-named directory; MFA working files use an ASCII path. If Windows short-path support cannot provide a suitable runtime path, choose a short, writable ASCII path without spaces:

```powershell
.\setup.bat -RuntimeRoot D:\SpeechRuntime
```

Run the following commands from the extracted project directory in PowerShell:

| Installation option | Purpose |
| --- | --- |
| `.\setup.bat` | Full installation, automatic hardware selection by default |
| `.\setup.bat -CpuOnly` | Do not install GPU runtime libraries; automatic CPU medium/small/base selection |
| `.\setup.bat -WordsOnly` | Install the repeated-word workflow without the continuous-speech analysis environment |
| `.\setup.bat -TextOnly` | Install runtime/VAD dependencies and MFA; no Whisper weights, GPU libraries, HanLP, ECAPA, or AST |
| `.\setup.bat -Profile research` | Explicitly fix large-v3; do not shrink the model after a failed probe |

A full installation already supports supplied-text alignment. You do not need to reinstall it to skip Whisper. The text-only path does not require a GPU. The reduced `-TextOnly` installer branch is implemented and covered by focused tests, but has **not** been separately installed from an empty directory on the test machine; see [validation scope](TESTING.en.md).

### Compatibility and model selection

- `locks/` pins the Windows x64/Python 3.11 dependency combinations. Conda package URLs and SHA256 values are pinned. Pip package versions are pinned, but individual wheel hashes are not yet fully locked. Do not mix in arbitrary newer packages.
- Whisper, AST, and ECAPA repository revisions are pinned. Major weights and selected configuration files have SHA256 checks. MFA resources use specified releases; HanLP uses a named model with file-hash checks. Model identifiers are included in task reports.
- The installer inspects CPU, available RAM, disk space, GPU model, free VRAM, and driver version. It then probes the selected inference configuration in a separate process. A GPU name alone is not a compatibility test.
- Dependency checks, an MFA execution test, and full-install analysis-model loading checks must pass before `.runtime.json` is switched. Failed installation leaves the prior launcher configuration and annotations intact. Reinstallation uses a new environment directory, including for the same version.
- Each alignment task has isolated MFA working state. Only model caches are shared.
- This supports a defined platform and configuration, not every operating system, driver, or network. After a GPU failure, explicitly choose `-CpuOnly` or resolve the driver problem before retrying.

| Profile | Behavior |
| --- | --- |
| `adaptive` (default) | Try resource-appropriate GPU large-v3/medium/small/base configurations; without a supported GPU, try CPU INT8 medium/small/base. Record failed attempts, final selection and reason. |
| `research` (explicit choice) | Keep large-v3. Select GPU FP16 when the resource heuristic allows it; otherwise evaluate CPU FP32. If the selected configuration fails its probe, stop rather than shrink the model. |

CPU adaptive screening uses **currently available RAM**: at least 6 GiB for medium, 3 GiB for small, 1.5 GiB for base. Try larger eligible candidates first, then smaller ones if validation fails. These are project heuristics, not guarantees. If RAM cannot be measured and there is no GPU candidate, stop with an error instead of guessing. Shared integrated-GPU memory is not treated as NVIDIA dedicated VRAM. Adaptation changes Whisper only; HanLP, AST, ECAPA and MFA must still pass their own installation checks. Existing environments and saved tasks do not automatically switch models after a launcher update; reports retain actual configuration.

Memory thresholds are engineering heuristics, not official model requirements. Free VRAM can change. Passing a short probe does not prove that every long recording or workload will fit. HanLP, ECAPA, AST, and MFA model choices do not change with GPU size. Tasks using the new validated configuration fail explicitly rather than silently switching model, device, or precision during a run. Older configurations need reinstallation for that guarantee.

The default Whisper probe uses a synthetic signal. It checks execution, **not recognition accuracy**. You may supply a short real recording:

```powershell
.\setup.bat -Profile research -ProbeAudio "D:\recordings\test.wav"
.\run.bat hardware
# Restore the previous launcher configuration, when retained; delete nothing.
.\setup.bat -Rollback
```

Old environments are not automatically removed. Upgrades and reinstallations need additional disk space. A source ZIP does not include environments or model weights, so first installation on another computer still needs internet access.

### Hardware and quality disclaimer

**Transcription quality may be indirectly constrained by hardware resources and the configurations they allow. More powerful hardware does not automatically mean more accurate transcription.** RAM, VRAM, drivers, and backend support can limit model size, numerical precision, and feasible workloads. Adaptive mode may therefore select a smaller or quantized model, which can change results. This project has not performed a controlled accuracy comparison across all hardware, model, and precision combinations. Quantization is not assumed to always reduce quality, and FP32 is not assumed to always outperform FP16.

When the same model and processing settings can finish successfully, less powerful hardware generally affects speed more directly than accuracy. CPU execution is not inherently less accurate than GPU execution. Bitwise-identical results across devices or numerical backends are not guaranteed. Default automatic selection can choose different models/precision on different computers; record and control these differences for research comparisons. Explicit Research mode fixes large-v3 without a silent model downgrade, but GPU FP16 and CPU FP32 are still different configurations. Out-of-memory failures, interruptions, and incomplete outputs must not be treated as validated annotations.

More capable hardware cannot automatically fix noise, accent mismatch, incorrect transcripts, speaker errors, or missing dictionary phones, and does not guarantee better MFA boundaries. The supplied-text path skips Whisper, so Whisper model selection does not affect that path; VAD and alignment still need adequate resources. For research comparisons, preserve the actual model, precision, hardware, and versions recorded in `summary.json`, hold configurations constant where possible, and evaluate against an independent manually corrected sample. A hardware probe is not a quality certification. See the [CTranslate2 quantization documentation](https://opennmt.net/CTranslate2/quantization.html) for the underlying inference options and [our validation scope](TESTING.en.md) for what has actually been tested.

## Quick Start

Double-click **`run.bat`** and choose an audio file and mode: **1** repeated words, **2** monologue, **3** interview, or **4** supplied text without ASR. Interview mode also asks for a target-speaker reference recording. Results go into `outputs/<timestamp>/`. Existing results are not overwritten.

The command-line examples below use placeholder paths. Use your own input paths and a new output directory for each run.

### Repeated words

Input is WAV. **Repetition counts are detected, not assumed to be three.** The workflow exports both one clip per word group containing its repetitions and one clip per individual detected reading. It combines VAD, per-segment Whisper transcription, MFCC/DTW distances, and stable adjacent-text evidence. Mandarin uses tone-bearing pinyin signatures; English uses word-token signatures. Speaker similarity alone is not treated as word identity. Comparison with the first reading in a group limits chains of accidental merges.

```powershell
.\run.bat run "D:\recordings\experiment.wav" --output outputs\experiment01
# Optional checks against a known design; these numbers do not drive grouping.
.\run.bat run "D:\recordings\experiment.wav" --output outputs\experiment02 --repeats 3 --expect-groups 80
```

An optional `--wordlist` is UTF-8, **one target word per group**, without repeating lines for each reading. Grouping happens independently first. The word list is applied only if the group count matches; otherwise processing stops rather than shifting labels. Without a list, ASR candidates are used. The list does not currently bias decoding or resolve homophone boundaries. Majority voting cannot establish the correct spelling of a homophone by itself.

Useful options are `--start` and `--end` in source seconds, `--skip-leading` for an explicitly chosen number of detections, and `--silence-ms` (default 400). The default examines the whole file and does not skip a fixed number of initial segments. `--repeats` and `--expect-groups` are post-hoc expectations only; mismatches are retained in `expectation_check.json`.

Clear recording-preparation speech separated from the repetition sequence by a substantial gap may be flagged for review. A single reading without that evidence is not discarded as noise. Original head/tail audio outside the main word region is preserved in `edge_review/`. There is no automatic denoising that would alter acoustic characteristics. VAD-excluded regions are logged and must not be equated with pure noise.

DTW thresholds are estimated from the current recording. Insufficient or poorly separated evidence triggers conservative thresholds and review flags. Scores are **not correctness probabilities**. Stable transcription changes retain a boundary even when audio is similar. Minimal pairs, homophones, unstable ASR, and accented readings still need review; there is no general accuracy guarantee.

By default, clips retain up to **480 ms of original context on each side** of VAD boundaries, capped at neighboring gap midpoints to avoid overlap. Context padding is not artificial inserted silence, and an erroneous VAD boundary can still cut speech. Repetitions without a detected pause are kept together; repeated text can trigger `possible_internal_repetition`, but the workflow does not divide such audio into equal-duration pieces or claim that every repetition was recovered.

### Monologues, interviews, and batches

This mode accepts WAV, MP3, M4A, FLAC, MP4, and other media supported by PyAV. Alignment and exports use a 16 kHz mono normalized copy; original media is unchanged.

```powershell
.\run.bat continuous "D:\recordings\monologue.mp4" --output outputs\monologue01
.\run.bat continuous "D:\recordings\interview.wav" --mode dialogue --reference "D:\recordings\target.wav" --output outputs\interview01
# A directory input is processed recursively. Keep outputs outside that directory.
.\run.bat continuous "D:\interviews" --mode dialogue --reference "D:\target.wav" --output outputs\interviews
```

Use **10-60 seconds of clean, single-speaker reference speech**, without music or other speakers; at least 5 seconds must be detected as speech. The workflow does not guess the target speaker from the beginning of an interview.

VAD finds pauses, Whisper transcribes speech units, and HanLP helps merge syntactically incomplete units. The workflow does not invent character-level timestamps or forcibly split tightly connected speech. Long uninterrupted units are preserved and flagged; not every export is guaranteed to be an ideal clause. Default context is at most 250 ms per side, constrained by neighboring midpoints. Options include `--padding`, `--silence-ms` (250), and `--max-merge-duration` (30 seconds, a merge limit rather than a forced split length).

Mandarin tasks export Chinese and pinyin SRT files; English tasks export English SRT only. A same-name SRT next to the input is compared automatically, or can be selected with `--subtitle`. `subtitle_diff.log` includes line-level differences; it is not an accuracy score. Dictionary-derived pinyin does not replace phone or tone annotation.

The default speaker threshold is 0.65, with a 0.05 uncertainty margin; `--speaker-threshold` changes the threshold. These are uncalibrated similarity scores, not probabilities. **This is speaker verification, not full diarization or overlap separation.** Speaker changes without pauses and simultaneous speakers can be misclassified. `target_candidate` means a candidate, not a confirmed target-only recording. Calibrate using known examples and manually confirm samples before research use.

AST music/source-audio labels are risk indicators, not proof of music contamination or film origin. All detected speech is retained, including low-quality speech; no automatic denoising or quality-based deletion is performed. Regions outside VAD are listed in `outside_vad_regions.json`; consult the complete original audio and normalized copy when checking omissions.

## Supplied Text: Accented Mandarin and Reading Experiments

`from-text` accepts WAV plus UTF-8 text. It **does not initialize Whisper or rewrite the recording into standard-Mandarin text**. Supply what was actually spoken, not an unchecked prompt that ignores omissions, errors, repetitions, or fillers. This path does not run HanLP, AST, or speaker verification. Separate speakers beforehand; it does not automatically extract one person from an interview. Source recordings are neither denoised nor overwritten.

```powershell
# One supplied transcript for the selected range; useful for an already segmented word or sentence.
.\run.bat from-text "D:\recordings\read.wav" --transcript "D:\recordings\read.txt" --output outputs\text01
# One line per reading. Consecutive identical supplied labels form a word group.
.\run.bat from-text "D:\recordings\words.wav" --transcript "D:\recordings\readings.txt" --mapping vad --mode words --output outputs\text02
# Explicit time ranges when VAD does not match the transcript units.
.\run.bat from-text "D:\recordings\read.wav" --transcript "D:\recordings\segments.tsv" --mapping timed --output outputs\text03
```

| Mapping | Required text and behavior |
| --- | --- |
| `whole` (default) | Join TXT lines into one transcript for the selected audio range. No automatic clause segmentation. `--start`/`--end` can exclude manually confirmed head/tail noise. Long units are flagged. |
| `vad` | One nonempty TXT line per detected reading, including repeated readings. Three readings require three lines, but no count is assumed. A count mismatch preserves detections and stops rather than shifting text. A matching count alone does not prove correct correspondence. |
| `timed` | Tab-separated `start`, `end`, and `text` columns. Times are seconds in the original recording. Nonempty text, valid bounds, and non-overlapping intervals are required. |

Example timed transcript (the separators are tabs):

```tsv
start	end	text
0.5	1.4	今天下雨了
2.0	3.2	我想回家
```

The default mode is `sentences`; `--mode words` groups consecutive identical supplied labels and exports both group and individual files. Unlike automatic repeated-word mode, supplied-text grouping uses the provided labels, not acoustic word-identity detection. `--padding` defaults to 0.48 seconds, subject to neighboring constraints.

Default `--tokenization auto` looks up Chinese characters for Mandarin and word tokens for English. `--tokenization space` uses explicit whitespace-separated tokens, lowercased. Every token needs a dictionary entry. Unsupported language content is not silently removed; both the selected dictionary and acoustic model must cover it. This does not turn a Mandarin model into an English model. The pronunciation-candidate method below also applies to English, using the English model's phone inventory.

### Pronunciation candidates, not unrestricted phone recognition

The default lexicon permits its listed pronunciations. If an accent feature is absent, MFA may still force the speech onto an allowed pronunciation. Use `--pronunciations variants.dict` to provide independently justified alternatives. MFA chooses an alignment path using acoustic evidence and decoding constraints; it is **not** freely transcribing the nearest IPA symbols.

An override file has two tab-separated columns: token and space-separated phones. Multiple rows for the same token provide alternative pronunciations. This example demonstrates syntax only and makes no claim about any speaker:

```text
你	n i˨˩˦
你	l i˨˩˦
```

Overrides **replace all base pronunciations for the listed token**, rather than append to them. Include any canonical pronunciation you want to retain. Overridden tokens use equal pronunciation priors (1.0) and fixed silence parameters (0.5/1.0/1.0); untouched tokens retain their original dictionary probabilities. The original dictionary is not modified. `pronunciation_audit.json` records candidates, parameters, hashes, and out-of-vocabulary items.

Every candidate phone must exactly match the acoustic model's inventory. Arbitrary pinyin, IPA diacritics, or new phones are rejected. Export the installed inventory before constructing candidates:

```powershell
.\run.bat phones --output outputs\allowed_phones.txt
.\run.bat from-text "D:\recordings\read.wav" --transcript "D:\recordings\read.txt" --pronunciations "D:\recordings\variants.dict" --output outputs\accent01
```

TextGrids retain the supplied transcript and method information. The `phones` tier is an automatic lexicon-constrained hypothesis, **not verified narrow IPA or ground truth about accent features**. Accent differences can involve duration, voice quality, coarticulation, and prosody that are not discrete phones in the model. Do not keep adding variants until alignment succeeds and then treat the selected variant as an independent finding. Evaluate candidate selection and boundary error against an independent manually annotated sample. Strong accents may require acoustic adaptation or retraining; this release does not automate those steps.

Use `--prepare-only` to inspect `segments.json` before `align`. Sentence exports go to `package/audio_textgrid/sentences/`; word mode exports both groups and readings. TXT/LAB remain under `texts/`. All text-driven segments require review. Logs explicitly record that Whisper was not used. A method-specific `CITATIONS_USED.md` checklist and pronunciation audit are included. Transcripts and paths may contain private information.

## Review Before Alignment

```powershell
.\run.bat prepare "D:\recordings\experiment.wav" --output outputs\review01 --start 15
# Continuous mode and from-text also support --prepare-only.
# After reviewing start, end, label, and any relevant group/repeat values in segments.json:
.\run.bat align --prepared outputs\review01
.\run.bat verify outputs\review01\package
```

When detections and intended readings do not match, check order and timing, correct `group`/`repeat` where relevant, and supply the actual `label` for each segment. Existing `package/` output is not overwritten. Use a fresh output directory, or copy preparation files to a new directory without the old package, for another export. A SHA256 check stops alignment if the source audio has changed since preparation.

If continuous-mode transcription succeeded but analysis failed, run `run.bat analyze --prepared outputs\<task>` and then `align`; Whisper need not run again. Existing analysis results are protected from overwrite to preserve manual edits.

## Outputs and Reports

Files depend on the selected path; not every mode creates every file below.

```text
outputs/<task>/
  run.json / segments.json / alignment_manifest.json
  summary.log / summary.json       # Chinese + English in one log; structured details
  run.log / run_events.json        # Execution output, stage timing, exceptions
  mfa.log / analysis.log
  package/
    words_grouped/                # WAV + TextGrid: all repetitions of each word
    individual_repetitions/       # WAV + TextGrid: individual detected readings
    edge_review/                  # Preserved head/tail and preparation-speech candidates
    audio_textgrid/
      monologue/                  # Continuous mode without a reference speaker
      target_candidate/           # Candidate target speech, not identity ground truth
      other_candidate/            # Preserved non-target candidates
      uncertain/                  # Preserved uncertain speaker assignments
      sentences/                  # Supplied-text sentence mode
    texts/                        # TXT and LAB stored separately from WAV/TextGrid
    review_log.tsv                # Opens in Excel; no separate XLSX export
    summary.log / summary.json / run.log / run_events.json
    file_validation.json          # Pairing, durations, and interval structure
    manifest.json / run.json
    grouping_audit.json / expectation_check.json / edge_review.json
    transcript.srt / pinyin.srt / subtitle_diff.log  # Continuous; pinyin only for Mandarin
    CITATIONS_USED.md              # Method checklist; check logs for completed stages
  annotation.zip
```

TextGrids include `words`, `phones`, and `review` tiers. Continuous exports add speaker and quality information; supplied-text exports also retain transcript and method information. Repeated-word WAVs preserve source sample rate and channels in PCM24; a 24-bit container does not create additional information.

In ASR-driven paths, segments containing unsupported English, digits, out-of-vocabulary characters, or empty text are preserved with empty phone tiers and review flags. English is not deleted to force-align only the remaining Chinese. General mixed Mandarin/English alignment is not solved by this version. Supplied-text mode offers explicit dictionary coverage but still requires model-compatible phones. Automatic IPA-style lexicon labels are not narrow phonetic transcription.

Preparation, analysis, alignment, and batch processing update **one bilingual `summary.log`**, with `=== 中文 ===` first and `=== English ===` second. Both sections use the same task data: actual model/precision, counts, alignment coverage, review flags, speaker/quality labels where applicable, timing, and failures. No separate English summary file is needed. `summary.json` remains structured data with dependency versions, model identifiers/checksums, recorded hardware information, and a `report_languages` field. Technical identifiers, paths, transcripts, and original upstream errors are not rewritten by automatic translation. Check missing/unrecorded fields rather than assuming provenance is available for old runs. Bilingual reports are also attempted on errors, including an abbreviated bilingual error summary if full reporting fails, but cannot be guaranteed for unwritable storage, forced termination, or occupied output directories. Reporting never overwrites existing annotations. A partially failed batch is not described as wholly successful.

`review_log.tsv` opens in Excel. `file_validation.json` checks file structure, not phonetic accuracy. New successful `annotation.zip` exports and `package/summary.log` include the same bilingual summary. With the updated launcher, regenerate an older task's report in both languages without modifying audio or TextGrid files:

```powershell
.\run.bat report --prepared outputs\older_task
```

Regeneration updates `summary.log` and copies it to an existing `package/`, but does not rebuild a previously created `annotation.zip`; share the updated log separately when refreshing an older task. Information absent from the original records is marked unrecorded, not invented. The bilingual scope is the task summary, not all console output, installation logs, or upstream logs.

## Troubleshooting and Validation

- Installation: inspect `setup.log`, `validation/`, `hardware.json`, and `selection_attempts.json` in the corresponding runtime directory. Successful installations produce `installation_summary.log`; failures produce `installation_failure.json` where setup has progressed far enough to write it.
- GPU failure: check the driver and the recorded probe error. An explicit CPU-only installation is an option; no runtime downgrade is hidden from the user.
- Network or model-download failure: retry with working network access. HanLP has an author-hosted backup, but availability is not guaranteed. Do not bypass checksums or security software.
- Transcript count mismatch: inspect saved detections and actual speech. Correct the mapping or provide timed TSV; do not insert guessed offsets to make counts match.
- Unsupported phones or empty phone tiers: inspect the dictionary coverage and pronunciation audit. Successful file export does not mean every segment aligned.
- Task failure: start with `summary.log`, then inspect `mfa.log` or `analysis.log`. Preserve the original exception and prior outputs when asking for help.

See [TESTING.en.md](TESTING.en.md) for executed tests and remaining gaps. The primary GPU integration tests used Windows 11 and an RTX 5080. Other hardware combinations and accent types have not all been validated. No claim of research-grade acoustic accuracy follows from an installer smoke test or a matching group count.

## Development, Publication, and Privacy

```powershell
$env:PYTHONPATH = "src"
python -m unittest discover -s tests -v
python scripts/build_release.py --output dist\speech-annotation-pipeline-source.zip
```

GitHub Actions checks lightweight tests and syntax. The source-only ZIP builder uses a strict allowlist and refuses to overwrite an existing archive. See [validation scope](TESTING.en.md), [project statement](NOTICE.en.md), and [third-party licenses](THIRD_PARTY.md).

**Use only this project directory as the GitHub repository root**, not its parent working directory. Do not upload recordings, annotation outputs, models, or `.runtime.json`. The `.gitignore` and source ZIP allowlist exclude these artifacts. Processing is local; installation downloads dependencies and models. Transcripts, reports, and installation logs can contain personal paths and sensitive speech. Review them before sharing.

The MIT license covers project-owned integration code and documentation, not all dependencies, models, dictionaries, or recordings. Cite the upstream work actually used, following [CITATIONS.en.md](CITATIONS.en.md), as well as this workflow version. `CITATION.cff` currently uses a collective-author placeholder: verify actual contributors and add the final repository URL before publication. Do not invent names, affiliations, DOIs, or upstream endorsement.

Official resources: [faster-whisper](https://github.com/SYSTRAN/faster-whisper), [MFA installation](https://montreal-forced-aligner.readthedocs.io/en/latest/installation.html), [Miniforge](https://github.com/conda-forge/miniforge), [HanLP models](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html), [ECAPA model](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb), and [AST model](https://huggingface.co/MIT/ast-finetuned-audioset-10-10-0.4593).
