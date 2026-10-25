# Validation Record and Limits

[中文详细记录](TESTING.md) | [Installation and usage](README.en.md)

Version: **0.7.1**. Validation date: **2026-10-25**. This is an English summary of the recorded tests, not a claim that all platforms or research conditions have been validated. Earlier-version results are labeled separately and must not be treated as new runs of every later release.

## Version 0.7.1: Automatic Hardware Selection by Default

- Windows first-use UI, command-line setup, Mac setup and the hardware-selection function now default to adaptive. Fixed large-v3 remains an explicit Research choice; existing validated configuration and saved task snapshots are unchanged.
- 151 tests: 148 passed, 3 native POSIX tests skipped on Windows. Added default-policy, preserved-choice, available-RAM tiers, GPU large-model eligibility and unknown-memory safeguards. Unconfigured default loading and the unselected download helper no longer assume large-v3.
- Windows first-use component tests ran against a fresh empty project directory. Chinese/English screenshots were inspected; automatic selection is the default, language switches preserve it, missing language disables installation, and synthetic failure offers retry. No models were installed by this UI test.
- Low-memory and GPU scenarios are simulations, not physical integrated-GPU benchmarks. No full model redownload or new real-speech accuracy evaluation was performed. Native Mac installation/transcription still needs real-hardware acceptance.

## Version 0.7.0: Apple Silicon Preview

- The local Windows suite ran 141 tests: 138 passed and 3 native POSIX process tests were skipped. The original 121 Windows tests remain, with new installation-plan, ARM/OS guards, previous-configuration protection, memory-estimate, player/Praat argument and ZIP executable-mode checks.
- The bundled local Bash parser accepted the Mac launcher syntax. This was not execution under macOS's bundled Bash. AppleScript has not been compiled on a real Mac.
- Official PyPI/conda-forge metadata confirms key ARM artifacts for CTranslate2, PyAV, PyTorch/torchaudio, ONNX Runtime, PySide6, MFA/Kaldi/kalpy and Python. Artifact availability is not a complete resolver or installation test.
- Separate direct-version constraints avoid Windows package URLs; they are not presented as tested full Mac locks. The installer resolves remaining dependencies, records actual versions/explicit Conda lists and checks dependencies, models and MFA before switching configuration.
- Added macos-14 ARM GitHub Actions coverage, Bash/AppleScript parsing, and native process-group/parent-disconnect cleanup tests. Remote CI has not been pushed/run and cannot be reported as passing; it does not install all models.
- No real Mac was available. No fresh Mac installation, Mac speech end-to-end run or full-corpus rerun was performed. Whisper uses native ARM CPU, without Metal/MPS/MLX. Language models, segmentation, alignment and output methodology remain unchanged. Existing Windows models and recordings were not replaced.
- The [Mac guide](MACOS.en.md) and [Chinese guide](MACOS.md) document native acceptance, OS/memory/model limits, logs and permission/security handling. Source archives include executable launchers but no recordings, weights, environments or private configuration.

## Version 0.6.1: Single Start Entry

- 121 automated tests pass (106 existing plus 15 bootstrap/configuration/package tests): missing installation, preserved corrupt configuration, missing runtime, text-only configuration, Unicode/space paths, language arguments, pre-download failure stages, and exclusion of private state from the source ZIP.
- Windows PowerShell 5.1 success/failure GUI probes verify exit-code handling. Keeping the process handle fixes a null-exit-code issue; installer processes retain their handle in the same way.
- WinForms component tests render English/Chinese screens, toggle languages, disable installation with no language selected, and exercise the synthetic failure/retry state and bilingual log. The simulated failure is not an actual network installation.
- The new entry was run against the existing environment and opened the Qt workspace, retaining language/history without starting a recording task.
- No complete fresh-machine installation or full-corpus rerun was performed in this round. The existing installer and locked dependencies are reused; the first-run window itself uses Windows PowerShell / WinForms. Missing Python standard-library source files in the temporary local test environment were restored from an exact-version, SHA256-verified cached archive, without modifying recordings or model configuration.

Component-only check (no installation): `powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File scripts/start.ps1 -SmokeTestDirectory outputs/launcher-preview`. Logs under `synthetic-failure` are test fixtures, not evidence of installation success or annotation quality.

## Version 0.6.0: Bilingual Desktop GUI

- Native Windows and Qt offscreen checks; 106 automated tests pass (93 existing plus 13 GUI/task-contract tests). Switching interface language preserves audio language, transcript path, task mode and padding; preferences persist.
- Tests cover argument boundaries, unique output folders, configuration snapshots, interrupted-state recovery, corrupt-state preservation, refusing partial-ASR resume, refusing resume over an existing package, manifest path traversal, and requiring file checks before reporting success.
- A Windows Job Object test starts dedicated parent/child test processes and verifies both exit on cancellation. It does not kill arbitrary Python processes by name. Reopening does not automatically start queued tasks.
- Real GUI-submitted smoke tasks: supplied English text with VAD exports 4 pairs; Whisper large-v3 / CUDA FP16 repeated words yields apple twice, window three times, garden once and 11 pairs (6 readings, 3 groups, 2 edge-review clips); continuous English with Whisper, HanLP, AST and MFA exports 4 pairs. All pass structural checks.
- These synthetic recordings test execution, not natural-speech/accent accuracy or research-grade phonetic boundaries. No new real-interview speaker-verification accuracy study was performed; those algorithms remain unchanged from 0.5.0.
- Chinese/English screenshots cover 1440×980 and 1060×720 task, form, environment and results views. The native Windows language menu was clicked to switch into English. Shorter windows scroll the form/inspector.
- PySide6-Essentials/shiboken6 are pinned to 6.8.3. The project was upgraded to 0.6.0 in the existing validated runtime; pip check passed and packaged icons/license loaded. This is not a fresh-machine, full-model-download installation test.
- Optional real integration check: `scripts/validate_gui.py --audio TEST.wav --transcript TEST.txt --output NEW_FOLDER`. The text check maps one line per VAD region; supply a matching transcript. Use `--mode words` or `--mode monologue` for other paths. This runs actual models, unlike unit tests.

## Version 0.5.0: Mandarin and English Selection

- All 93 automated tests passed, including prior regressions and new language tests. These are not phone-boundary accuracy measurements.
- Created a new full Windows environment using `-Languages zh,en -DefaultLanguage zh`. Pinned dependencies were installed; Miniforge, download caches and verified model assets were reused. This was not a cache-empty new-computer test. The launcher switched only after validation, retaining the previous 0.4.1 configuration for rollback.
- On RTX 5080, Whisper selected large-v3 / CUDA / FP16. Both language-specific MFA models passed synthetic-signal execution checks. Both HanLP models loaded and performed syntax inference; AST/ECAPA loaded. English HanLP and the pinned ModernBERT tokenizer ran offline. These checks do not establish boundary accuracy.
- English continuous speech: four sentences synthesized locally with Windows Microsoft Zira. VAD, Whisper, English HanLP, AST and MFA ran offline and exported four WAV/TextGrid pairs, all with alignment output. No pinyin SRT was produced. No manually verified phone boundaries were available; this is not a transcription/alignment accuracy benchmark.
- English repeated words: the same synthetic voice read apple twice, window three times and garden once. Detection found three groups and six readings, without a fixed repetition count. `--expect-groups 3` was only a post-hoc check. Exports include six individual pairs, three grouped pairs and two edge-review pairs, eleven total. This is not a natural-accent or minimal-pair benchmark.
- English supplied text: the four-sentence sample with its synthesis transcript used `from-text --language en --mapping vad`. Whisper was skipped, and four WAV/TextGrid pairs were exported. Reports disclose skipped ASR and retain transcript/pronunciation review flags.
- The full gzc recording and real multi-speaker English interviews were not rerun in this release. Regression tests cover Mandarin compatibility, legacy task language, English tokens/contractions/OOV handling, model routing, subtitles and bilingual reports. English-only and TextOnly fresh-directory installers have not been separately exercised; the tested installation is the full bilingual one, including its supplied-text path.
- PowerShell syntax checks passed. Source releases exclude recordings, models, environments and private research data. Unit tests use small fixtures without model downloads; integration artifacts remain in the local validation folder.

Passing these checks does not establish manually verified annotation quality. English uses a US pronunciation dictionary; cross-accent and within-sentence bilingual alignment remain unbenchmarked.

## Version 0.4.1: Bilingual Runtime Summaries

- `summary.log` now contains Chinese followed by English, using the same statistics for both sections. Completed, review-needed, partially failed, interrupted, and abbreviated reporting-failure cases are covered. Technical identifiers, paths, transcripts, and upstream errors retain their original text rather than being automatically translated.
- **76 automated tests passed**. Seven new report tests and expanded failure tests cover bilingual statuses, consistent counts/configuration, skipped Whisper, original errors, interruption, matching packaged reports, repeated generation without duplicated sections, and unchanged WAV/TextGrid artifacts. Tests support Windows CRLF and check UTF-8 BOM encoding.
- Updated only the installed workflow package from 0.4.0 to 0.4.1 on the test machine, without changing dependencies, downloading models, or reinstalling the complete environment. Installed-version checks and `pip check` passed. This is not a from-empty full installation test of 0.4.1.
- Used the normal launcher script and installed package to regenerate a bilingual report from a copy of an existing single-sentence task's records. It reports that earlier task, not new recognition or alignment. The original task's WAVs, TextGrids, and reports were unchanged.
- Both usage guides describe the bilingual scope. For older tasks, `report` updates folder-level reports but does not rebuild an existing `annotation.zip`. New task exports include the bilingual summary in the ZIP.

## Version 0.4.0: Bilingual Documentation Update

- Added Chinese/English hardware-quality disclaimers and English installation/usage, contribution, citation, and validation documents. The wording distinguishes speed, configuration changes, and unmeasured accuracy effects.
- Changes at that stage were limited to documentation and the source-release allowlist; the version remained 0.4.0. No environment was reinstalled, no real audio was reprocessed, and recognition/alignment logic was unchanged. Runtime summaries were still Chinese at that point; 0.4.1 subsequently made them bilingual in one file.
- Re-ran all **69 automated tests** successfully. Checked **53 local Markdown links and anchors**, all valid, and checked English command examples against the actual CLI options.

## Version 0.4.0: Supplied Text

- Tested `from-text` with whole-recording TXT, one line per VAD detection, and timestamped TSV. This path does not initialize Whisper. Word groups use consecutive identical supplied labels, not a fixed repetition count or automatic semantic identity detection.
- Ran real VAD and MFA on a derived 2/4/1-reading sample with seven supplied lines: seven readings aligned and ten WAV/TextGrid pairs were exported. Reports recorded that ASR was not used. Labels were inherited from earlier candidate transcriptions for integration testing, not treated as a manually established transcript gold standard.
- Tested alternatives `ɕ i˥` and `s i˥` for the token `西`; real MFA alignment selected `ɕ i˥` in the first output. This was not an accented-speech benchmark and does not establish candidate-selection accuracy.
- Confirmed original transcript/method tiers, an unchanged base dictionary, and audit records for model/dictionary hashes, candidates, derived dictionary, and OOV items. Untouched entries preserve base probabilities; overrides use explicitly recorded equal priors and silence parameters.
- **69 automated tests passed**, including no-Whisper execution, count-mismatch rejection, overlapping-time rejection, explicit word tokenization, unknown-phone rejection, base-dictionary preservation, candidate replacement, empty text, variable repetitions, appropriate citations, and refusal of ASR in a TextOnly configuration. The previous 56 tests remain included.
- Completed a full version-isolated 0.4.0 installation while reusing cached models. Dependency checks, GPU large-v3 inference on a real short recording, MFA, and analysis-model checks passed. The older 0.3.0 environment was preserved. The reduced `-TextOnly` branch was **not separately installed from an empty directory**; full-install tests are not evidence of that branch's fresh-install behavior.
- After installation, used the normal `run.bat from-text` launcher without a development `PYTHONPATH`. A whole-sentence example produced one WAV/TextGrid pair and passed structural validation.
- Added project/contribution statements, citation guidance, `CITATION.cff`, and path-specific citation checklists. Unknown personal authors and repository details were not invented.

## Version 0.3.0: Installation, Hardware, and Reports

- Test machine: Windows 11, RTX 5080 with approximately 16 GB VRAM, NVIDIA driver 610.88. New isolated ASR/MFA/analysis environments reused previously downloaded model caches. This was not a second clean computer or a complete redownload test.
- The new environment supplied its own CUDA 12.8 and cuDNN 9.10.2.21 packages, without borrowing an older research environment's PyTorch DLLs. large-v3/CUDA/FP16 completed inference on a real 22-second recording.
- Dependency validation initially found missing MFA `seaborn` and refused to switch the prior launcher. After correcting and re-locking the dependency set, all three environments passed `pip check`. Failure protection and installation recovery were exercised.
- MFA produced a TextGrid in a synthetic-signal execution test; HanLP ELECTRA BASE, AST, and ECAPA loaded. Synthetic tests do not measure transcription or boundary accuracy.
- Re-ran real VAD/Whisper on the derived variable-count sample: seven readings in groups of 2/4/1. All seven aligned and ten WAV/TextGrid pairs passed structural validation. This was not an independent generalization dataset; the full 80-word recording was not rerun in that round.
- A 20-second monologue passed through Whisper, HanLP, AST, and export, producing five pairs. Two segments received Mandarin MFA results; three had unsupported transcript content and retained empty phone tiers with review flags. Four received possible-music flags, not verified BGM labels.
- Integration testing exposed MFA working-database collisions between concurrent corpora. Per-task mutable state was separated from the shared model cache. Repeated-word and monologue alignments then ran concurrently successfully; an isolation regression test was added.
- Successful, review-needed, and missing-input cases produced summaries with configuration/provenance, timings, and errors. Output ZIPs included reports. Prior failed-stage records were retained.
- Launcher rollback and switching back to the new environment succeeded without changing recordings or annotations.
- **56 automated tests passed** in that release, including hardware selection, no silent model shrinkage in research mode, CPU-only selection, task isolation, error reporting, partial-batch status, checksums, grouping, and export rules. Python compilation and PowerShell syntax checks passed.
- Low-VRAM adaptive ordering was simulated, not tested on each physical GPU. The new CPU FP32 selection path was not validated by a full real transcription run in that round.

## Version 0.2.0: Automatic Repetition Grouping

- Removed the default assumption of three readings. Expected word/repetition counts are post-hoc checks and are not passed to the detection algorithm.
- Processed the full 621.463-second known-design recording with large-v3/CUDA FP16. VAD found 243 segments; automatic grouping found 80 groups of three readings, totaling 240 readings. Three initial preparation-speech segments entered review. No 80-word list, manual start time, or fixed skip-three rule was supplied.
- A derived 2/4/1 sample, including one duplicated reading, was reprocessed by VAD/Whisper and grouped accordingly without expected-count input. This was not a new naturally recorded generalization sample.
- Real MFA aligned 234 readings. Six readings in two groups had unsupported ASR content such as digits and retained audio with empty phone tiers; they were not counted as aligned.
- Twenty-six groups had automatic review flags. Unflagged groups were not independently confirmed either. **80/80 group-count agreement does not mean 100% transcript, segmentation, or phone-boundary accuracy.**
- Exported 325 WAV/TextGrid pairs: 80 groups, 240 individual readings, three preparation-speech segments, and two complete head/tail regions. Pairing, duration, and interval checks passed. All 325 WAVs matched the corresponding source intervals sample-for-sample. Word groups did not overlap, with approximately 480 ms or more of group-edge context relative to VAD boundaries in this sample.
- Preserved head and tail audio separately, without deletion or denoising. VAD-excluded content was not declared pure noise.
- **36 tests passed** in that release. Its GPU test used existing local CUDA/cuDNN DLLs; it was not a fresh installer GPU-library test. The later 0.3.0 installation addressed that distinction.

## Earlier Integration Checks

- An earlier CPU installation created isolated environments in an empty directory and loaded Whisper large-v3, Mandarin MFA resources, HanLP, AST, and ECAPA. Loading success does not establish full transcription performance for every later CPU configuration.
- Synthetic and mocked-MFA export tests checked structure, samples, durations, failure retention, and non-overwrite behavior; they were not acoustic-accuracy tests.
- Real repeated-word and 20-second monologue samples completed the relevant pipelines. Unsupported mixed-language content was not forced into Chinese-only phones.
- The reference-speaker workflow was exercised on repeated-word audio, not a real interview. Short detections were conservatively marked uncertain. This validated model invocation and partitioning, not real-world target-speaker accuracy.
- Windows PowerShell 5.1 launchers, argument passing, MFA environment checks, and script syntax were checked.

Installation fixes included versioned Miniforge checksum assets and retries, runtime-path length checks, direct model downloads without symlink requirements, avoiding repeated MFA index requests for cached resources, HanLP's author-hosted backup after a primary-server 502, and loading ECAPA through public SpeechBrain interfaces instead of an attempted copy of missing `custom.py`.

## Not Yet Established

- Installation on another clean physical computer or virtual machine, or compatibility with every Windows, driver, GPU generation, and network combination.
- Controlled transcription-accuracy comparisons across hardware, model sizes, and precisions. Do not infer that CPU, quantization, or smaller models have a measured degradation rate in this project.
- Independent accented-speech candidate-selection or boundary-accuracy evaluation.
- Real interview diarization error rate, target-speaker false-acceptance rate, BGM-label accuracy, or phone-boundary error. Speaker and event scores have not been calibrated as probabilities for the research corpus.
- Comprehensive large-batch, subtitle-encoding, and network-failure coverage.
- A separate from-empty installation of the reduced TextOnly branch.

Passing automated tests, smoke tests, or count checks does not establish gold-standard transcripts, speaker identities, or syllable boundaries. Manual correction and independent evaluation remain necessary. The earlier bilingual documentation update and the 0.4.1 summary-generation changes do not alter recognition/alignment behavior and are not new acoustic benchmarks.

## Reproduce Lightweight Tests

With the test dependencies installed (`numpy`, `scipy`, `soundfile`, `praatio`, `pypinyin`, and `librosa`), run from the project directory:

```powershell
$env:PYTHONPATH = "src"
python -m unittest discover -s tests -v
```

GitHub Actions includes lightweight tests. Private recordings, reference audio, model weights, installation logs, and local runtime configuration are not included in the source release. Therefore private-audio integration results are documented here but cannot be reproduced from the source ZIP alone.
