# Apple Silicon Guide

[中文](MACOS.md) | [Full feature guide](README.en.md) | [Validation record](TESTING.en.md)

## Three Steps

1. Use an **M-series Mac with macOS 14 or later**. Download the project's v0.7.1 source release ZIP and fully extract it into a writable folder. Do not run inside the archive or a read-only disk image.
2. Double-click **`开始使用_START_HERE.command`**, the Mac file containing **START_HERE**. On first use, select interface and recording languages, keep the default **Automatic hardware selection** profile, then confirm installation. Keep the Terminal progress window open and remain online.
3. Validation opens the bilingual workspace. Reuse the same entry on later launches; a valid installation is not reinstalled. Try a short recording before a large corpus.

**Version 0.7.1 remains an Apple Silicon preview, not a real-Mac end-to-end validated release.** Development and local regression checks used Windows. The native installer, system integration and process management still need Mac acceptance tests. This download contains source and scripts, not a signed or notarized `.app`.

## Hardware and Models

- Native ARM64 only. Intel Macs, Rosetta and macOS 13 or earlier are rejected. The current PyAV ARM wheel requires macOS 14; this is not a claim that every dependency needs that version.
- Allow at least **30 GiB free disk space** before installation. Recordings, results, caches and retained old environments need additional storage. Selecting both Mandarin and English adds resources, but shares one Whisper copy.
- **Whisper uses the native M-series CPU, not the Apple GPU, Metal, MPS or MLX.** ARM-native execution is not GPU acceleration. This port retains faster-whisper/CTranslate2 to limit algorithm changes across platforms; long recordings may be slow. See [backend hardware support](https://opennmt.net/CTranslate2/hardware_support.html).
- **Automatic selection is the default**: measure currently available RAM, then consider CPU INT8 medium at 6 GiB, small at 3 GiB, or base at 1.5 GiB. Test larger eligible candidates first and try smaller ones on failure; do not load large-v3 by default. Thresholds are project heuristics, not guarantees; the full analysis workflow can still face memory/speed limits. Unmeasured or insufficient RAM stops with an error instead of guessing. Reports record the actual model, precision and reason.
- **Explicit Research mode** fixes `large-v3 / CPU FP32` without silent downsizing. Approximately 10 GiB currently available RAM is a project screening heuristic, not an official minimum. Even 16 GiB total RAM may lack headroom when other applications are open. Actual loading/inference must pass before the environment is selected. This default change does not automatically replace models in existing environments or saved tasks.
- HanLP, Silero VAD, AST and ECAPA retain their CPU configurations. The selected Mandarin/English HanLP models are **BASE**, not large. MFA remains 3.3.9 with the existing language-specific acoustic models and dictionaries.

No preinstalled Python, Homebrew, Conda or CUDA setup is required by design. The launcher verifies its Miniforge download and creates independent native ARM environments in the user's folder. System Python and global PATH are not modified. Downloads require access to GitHub, conda-forge, PyPI, Hugging Face and HanLP model servers.

## Daily Use

The workspace is shared with Windows. Switch English / Chinese at the top right; recording language is a separate choice. Repeated words, sentences/continuous speech, monologues, interviews and supplied-text alignment are included. Repetitions are not fixed to three. Interviews need a clean target-speaker reference and review of automatic decisions. Supplied-text mode skips Whisper; MFA forced alignment is not unconstrained phone recognition.

Outputs keep matching WAV/TextGrid pairs, separate TXT/LAB and reports. Segmentation, retention and review rules are unchanged. **The same `summary.log` contains Chinese followed by English.** Audio preview uses the system player. For boundary editing, install Praat separately and select `Praat.app` in the workspace. If the system picker cannot select an application bundle, choose its `Contents/MacOS/Praat` executable.

Stopping terminates only the task's owned process group and stops the queue, retaining output. Reopening does not automatically restart tasks. Native cancellation, Praat selection and playback remain pending real-Mac acceptance; unit tests are not proof of native UI behavior.

Use the installer under **Models and environment** to add languages or change profile, then reload configuration. Include every language you wish to retain. Reinstallation creates a new candidate and switches only after validation; old environments are kept and consume additional space.

## Logs

Finder hides dot-prefixed folders by default. Use Command + Shift + . to show them, or **Go to Folder** to open a path.

| Location | Contents |
| --- | --- |
| Project `.launcher-state/macos-<time>-<pid>.log` | Launch, bootstrap, install stages and failures |
| Project `.launcher-state/macos-gui-check.log`, `macos-gui.log` | GUI validation and startup errors |
| `~/.speech-annotation-runtime/v0.7.1-mac-arm64-<id>/summary.log` | Bilingual installation summary after candidate installation starts |
| Same folder: `setup.log`, `validation/` | Dependency resolution, downloads, inference and MFA execution checks |
| Same folder: `hardware.json`, `runtime.json`, `*-conda-explicit.txt` | Memory estimate, selected models, installed versions and Conda package URLs/hashes |
| Project `.gui-state/` | Private task history and worker logs |
| Task output: `summary.log`, `summary.json` | Bilingual run summary and structured details |

Early failures may not create a candidate folder; check the launcher log first. Original upstream errors, paths and transcripts are not automatically translated. Review logs for private information before sharing; do not upload local state to GitHub.

## Troubleshooting

- Run only trusted code. If macOS blocks unidentified-developer content, verify the source and follow [Apple's official guidance](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unknown-developer-mh40616/mac). The launcher does not disable Gatekeeper, remove quarantine attributes or bypass security controls.
- For execution-permission errors, prefer the project-built Release ZIP and fully extract it again. It carries executable permissions; GitHub's automatic source ZIP may lose them after browser uploads. Advanced fallback: type `/bin/bash ` into Terminal, drag `开始使用_START_HERE.command` into that window, then press Return.
- If Rosetta is detected, disable **Open using Rosetta** for the terminal application and reopen the entry in a native ARM terminal.
- Runtime defaults to `~/.speech-annotation-runtime`. If the username makes that path contain non-ASCII characters or spaces, installation currently refuses it. Set `SPEECH_PIPELINE_RUNTIME_ROOT` to a writable ASCII path without spaces before launching from Terminal. Source and audio paths can contain Unicode/spaces, but still need native coverage.
- Network, memory or dependency failure does not switch the existing environment. Review logs and retry. For insufficient research-mode memory, close other large applications or explicitly choose Adaptive. The installer never silently shrinks the model to claim success.

## Validation and Maintenance

`locks/macos-*.txt` contains direct-version constraints, **not a fully solved, Mac-tested transitive lock**. Installation resolves remaining packages and records actual versions, explicit Conda package lists and model fingerprints. Key native ARM artifacts were found in official metadata; availability alone does not prove complete compatibility or installation success. Windows locks remain unchanged.

The local suite ran 151 tests: 148 passed and 3 native POSIX process checks were skipped on Windows. Coverage includes default-selection and simulated low-memory checks. Apple Silicon GitHub Actions checks were added for lightweight tests and Bash/AppleScript parsing; **they have not been run remotely and do not download all models or validate real speech**.

Native acceptance should cover a fresh full installation; short Mandarin and English recordings; repeated words, monologues, interviews and supplied text; playback/Praat; cancellation and descendant cleanup; restart without auto-running; WAV/TextGrid pairing, boundaries and bilingual reports. Keep releases marked preview until this is complete. Successful execution does not establish cross-platform acoustic accuracy equivalence; manual review remains necessary.

Maintainers: `python scripts/build_release.py --output NEW_RELEASE.zip` creates a source-only archive with executable `.command`/`.sh` modes and no recordings, environments or private configuration. When publishing through Git, preserve executable modes as well, for example `git update-index --chmod=+x -- '*_START_HERE.command' scripts/configure_macos.command scripts/start_macos.sh`, then verify a Mac clone.
