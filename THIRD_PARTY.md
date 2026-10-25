# Third-party software and models

See [NOTICE.md](NOTICE.md) for the integration/AI-assistance declaration and
[CITATIONS.md](CITATIONS.md) for research references. This workflow does not
claim authorship of upstream algorithms, trained weights, phone sets or lexicons.

## Key license distinctions

Checked 2026-10-24; this is a source-and-model attribution inventory, not a
complete legal audit of every transitive binary dependency.

| Component | Upstream license / scope |
| --- | --- |
| Whisper, faster-whisper, CTranslate2, Silero VAD | MIT, per their official repositories linked below |
| Montreal Forced Aligner 3.3.9 | MIT, including the installed conda-forge package metadata; separate from model/data licenses |
| Mandarin MFA acoustic v3.0.0 and Mandarin (China) dictionary v3.0.0 | CC BY 4.0, per the version-specific model pages in CITATIONS.md |
| English MFA acoustic v3.0.0 and English (US) dictionary v3.0.0 | CC BY 4.0, per the version-specific model pages in CITATIONS.en.md |
| HanLP code | Apache-2.0; do not infer all pretrained model/data rights solely from the code license |
| ModernBERT-base tokenizer/config | Apache-2.0 per its model card; HanLP's fine-tuned checkpoint and training corpora have separate provenance |
| SpeechBrain ECAPA model | Apache-2.0, per its model card |
| AST AudioSet model | BSD-3-Clause, per its model card |
| PySide6-Essentials / Shiboken6 6.8.3 | Qt for Python licensing; LGPLv3/GPLv3 or commercial terms as applicable, not this project's MIT license |
| Lucide static icons 0.468.0 | ISC, with MIT terms for Feather-derived icons; full upstream license is retained in `src/speech_pipeline/gui/icons/LICENSE` |

Local pronunciation overrides produce a changed effective dictionary. Reports
identify the base dictionary, hashes and modifications; do not relabel that
resource as wholly original MIT content. The unchanged upstream cache is retained.
The model cards, upstream license files and any accompanying notices govern.
The installer also downloads runtimes and codec dependencies with separate terms,
including NVIDIA libraries and FFmpeg-related packages. A source-only release is
not permission to redistribute all installed binaries under MIT.

## Upstream projects

The MIT license applies to this project's glue code only. Dependencies and
pretrained models retain their own licenses and terms. The source ZIP does not
redistribute model weights or recordings. Check upstream licenses/model cards
before redistribution or commercial use:

- [faster-whisper](https://github.com/SYSTRAN/faster-whisper)
- [CTranslate2](https://github.com/OpenNMT/CTranslate2)
- [Whisper](https://github.com/openai/whisper)
- [MFA](https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner)
- [MFA models](https://mfa-models.readthedocs.io/)
- [Silero VAD](https://github.com/snakers4/silero-vad)
- [HanLP](https://github.com/hankcs/HanLP)
- [HanLP model list](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html)
- [ModernBERT-base model card](https://huggingface.co/answerdotai/ModernBERT-base)
- [SpeechBrain ECAPA](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb)
- [AST AudioSet](https://huggingface.co/MIT/ast-finetuned-audioset-10-10-0.4593)
- [Praatio](https://github.com/timmahrt/praatIO)
- [OpenCC Python](https://github.com/yichen0831/opencc-python)
- [pypinyin](https://github.com/mozillazg/python-pinyin)
- [librosa](https://github.com/librosa/librosa)
- [Miniforge](https://github.com/conda-forge/miniforge)
- [Kaldi](https://github.com/kaldi-asr/kaldi)
- [Kalpy](https://github.com/mmcauliffe/kalpy)
- [PyTorch](https://github.com/pytorch/pytorch)
- [Transformers](https://github.com/huggingface/transformers)
- [ONNX Runtime](https://github.com/microsoft/onnxruntime)
- [NumPy](https://github.com/numpy/numpy), [SciPy](https://github.com/scipy/scipy)
- [SoundFile](https://github.com/bastibe/python-soundfile), [libsndfile](https://github.com/libsndfile/libsndfile)
- [PyAV](https://github.com/PyAV-Org/PyAV), [FFmpeg](https://ffmpeg.org/legal.html)
- [Hugging Face Hub](https://github.com/huggingface/huggingface_hub)
- [srt](https://github.com/cdown/srt)
- [Qt for Python licensing](https://doc.qt.io/qtforpython-6/licenses.html)
- [Lucide licensing](https://lucide.dev/license)

The GUI uses dynamically imported Qt for Python wheels, downloaded separately
by setup, not bundled binaries. The source archive includes a small, unchanged
subset of Lucide SVG assets and its full upstream license. Icons are tinted at
render time. These assets are not original artwork by this workflow's author.

The exact installed dependency inventory is recorded in summary.json; release
pins are in locks/. Python packages and model archives are downloaded from
upstream, not vendored in the source ZIP. If redistributing any of them later,
retain their actual copyright/license/NOTICE material and review those terms.

Official pretrained models are trusted software inputs. Do not replace them
with unknown archives without source review. Rights to training data and
recordings are separate from the source-code license.
