# Apple Silicon 使用指南

[English](MACOS.en.md) | [完整功能说明](README.md) | [验证记录](TESTING.md)

## 先看这三步

1. 使用 **M 系列 Mac、macOS 14 或更新版本**，下载项目发布的 v0.7.1 源码 ZIP 并完整解压。把文件夹放在自己有写入权限的位置，不要在压缩包或只读磁盘内运行。
2. 双击 **`开始使用_START_HERE.command`**。第一次选择界面语言、录音语言，模型策略保持默认的**自动适配硬件**，再确认安装。进度显示在终端窗口，请保持联网，不要关闭窗口。
3. 验证通过后打开中英文工作台。以后仍双击同一入口；正常情况下不会重新安装。先用一段短录音试跑，再处理批量语料。

**0.7.1 仍是 M 系列适配预览版，不是已在真实 Mac 上完整验收的正式版。** 开发电脑是 Windows；Mac 安装器、系统交互与原生进程管理仍需实机检查。下载包是源码与启动脚本，不是签名、公证过的 `.app`。

## 电脑要求与模型

- 仅支持原生 ARM64。Intel Mac、Rosetta 模式和 macOS 13 或更早版本会被拒绝。当前 PyAV ARM 安装包要求 macOS 14；不是所有底层工具都要求这一系统版本。
- 安装前至少预留 **30 GiB 可用磁盘空间**，后续录音、结果、下载缓存及保留的旧环境另计。多选普通话和英语会增加空间，Whisper 权重共用一份。
- **本版 Whisper 使用 M 系列 CPU，不使用苹果 GPU、Metal、MPS 或 MLX。** 原生 ARM 不等于 GPU 加速。沿用 faster-whisper/CTranslate2 后端以减少跨平台算法变化，长录音可能较慢。[后端硬件支持](https://opennmt.net/CTranslate2/hardware_support.html)
- **默认自动适配**：检测当前可用内存，至少 6 GiB 尝试 medium、3 GiB 尝试 small、1.5 GiB 尝试 base，均为 CPU INT8。从符合条件的较大候选开始，试运行失败再尝试较小候选，不默认加载 large-v3。阈值是项目估计，不是成功保证；完整分析流程仍可能受内存和速度限制。内存检测失败或不足会停止提示，不盲选模型。实际模型、精度及选择原因会记录在报告中。
- **手动研究模式**才固定 `large-v3 / CPU FP32`，不静默换小模型。约 10 GiB 当前可用内存是本项目的预筛选阈值，不是官方最低要求；16 GiB 总内存仍可能因其他软件占用而不足。安装后必须实际加载并试运行，失败不会启用该环境。已有环境和任务不会因这次默认值变更自动换模型。
- HanLP、Silero VAD、AST 和 ECAPA 沿用现有 CPU 配置。中文/英文 HanLP 均为指定 **BASE** 模型，不称为 large。MFA 沿用 3.3.9 及各语言声学模型、词典。

不需要预装 Python、Homebrew、Conda 或自行配 CUDA。安装器校验 Miniforge 下载文件，使用用户目录里的独立原生 ARM 环境，不修改系统 Python 或全局 PATH。网络须能访问 GitHub、conda-forge、PyPI、Hugging Face 和 HanLP 模型站。

## 日常操作

界面与 Windows 版共用。右上角可切换中文 / English；录音语言另选，不随界面语言改变。支持重复读词、句子/连续语音、单口、访谈和已有文本对齐；重复次数不是默认三次。访谈需要干净的目标说话人参考音频，自动核验结果仍需复核。已有文本模式跳过 Whisper，不把 MFA 强制对齐称为自由音素识别。

结果保留同名 WAV/TextGrid、独立 TXT/LAB 和报告，切分、复核标签和保留规则与现有流程相同。运行总结仍为**同一个 `summary.log` 先中文后英文**。播放使用系统音频工具；需编辑边界时另行安装 Praat，并在界面选择 `Praat.app`。若系统选择框无法选中应用包，可选择包内 `Contents/MacOS/Praat` 可执行文件。

“停止”只终止该任务拥有的进程组并停止队列，保留已有结果。重新打开不自动开跑。Mac 进程停止、Praat 选择框和播放功能尚待实机验收，不把单元测试当作真实系统行为证明。

在“模型与环境”打开安装器可增装语言或改变策略，安装完成后刷新。请同时选择要保留的全部语言。每次重装建新候选目录，仅验证通过才切换配置；旧环境保留，因此会额外占空间。

## 日志在哪里

Finder 默认隐藏以 `.` 开头的项目，可按 Command + Shift + . 显示，或用“前往文件夹”打开下面路径。

| 位置 | 内容 |
| --- | --- |
| 项目 `.launcher-state/macos-时间-进程号.log` | 启动、下载、安装阶段及失败提示 |
| 项目 `.launcher-state/macos-gui-check.log`、`macos-gui.log` | 界面检查与启动错误 |
| `~/.speech-annotation-runtime/v0.7.1-mac-arm64-编号/summary.log` | 同文件中英双语安装总结；进入候选安装后生成 |
| 同目录 `setup.log`、`validation/` | 依赖解析、模型下载、试运行和 MFA 执行检查 |
| 同目录 `hardware.json`、`runtime.json`、`*-conda-explicit.txt` | 内存估计、实际模型、安装版本与 Conda 包地址/哈希 |
| 项目 `.gui-state/` | 私有任务历史与工作日志 |
| 各任务输出中的 `summary.log`、`summary.json` | 双语运行总结与结构化结果 |

较早的失败可能没有候选目录，请先看启动日志。原始第三方报错、路径和转录原文不会自动翻译。分享日志前检查是否包含私人路径、文本或音频信息，不要将这些本地状态上传 GitHub。

## 无法打开或安装失败

- 只下载并运行可信来源的代码。若 macOS 阻止未知开发者内容，请按 [Apple 官方说明](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unknown-developer-mh40616/mac)核查来源后处理；脚本不会关闭 Gatekeeper、删除隔离标记或绕过系统安全检查。
- 若提示没有执行权限，优先使用项目构建的 Release ZIP，重新完整解压。它带有入口执行权限；网页上传仓库再下载的自动源码 ZIP 不一定保留此权限。高级备用方式：在终端输入 `/bin/bash `，将 `开始使用_START_HERE.command` 拖到终端中，然后回车。
- 若提示 Rosetta，请关闭终端应用的“使用 Rosetta 打开”选项，使用原生 ARM 终端重新打开入口。
- 默认环境在 `~/.speech-annotation-runtime`。若用户名导致该路径含中文或空格，当前安装器会拒绝，而不是装到一半出错。可在终端设置 `SPEECH_PIPELINE_RUNTIME_ROOT` 为有写权限的英文无空格路径后启动；源码/录音路径可含中文或空格，但仍需实机覆盖。
- 网络、内存或依赖检查失败时不切换旧环境。查看日志后重试；研究模式内存不足时，关闭其他大程序或明确选择自动适配。脚本不会偷偷降低模型大小来显示“成功”。

## 验证与维护说明

`locks/macos-*.txt` 固定直接依赖版本，**不是已在 Mac 完整求解并实测的全依赖锁**。Conda/pip 在安装时解析其余依赖，再保存实际版本、Conda 显式包清单和模型指纹。已核对关键原生 ARM 包存在；包存在不等于全套依赖兼容或安装成功。Windows 原有锁文件不变。

本地 151 项测试中 148 项通过、3 项 POSIX 原生进程测试跳过，含自动选型默认值及低内存模拟。已加入 Apple Silicon GitHub Actions 任务，覆盖轻量测试和 Bash/AppleScript 解析；**尚未在远端执行，也不包含完整模型下载或真实语音验收**。

实机验收建议：首次完整安装；中文/英文短录音；重复读词/单口/访谈/已有文本；播放及 Praat；停止长任务并确认子进程退出；重启不自动开跑；检查 WAV/TextGrid 配对、边界和同文件双语报告。全部完成前请将发行版本标为预览。跨平台运行成功也不证明声学准确率等价，研究仍需人工抽查。

维护者构建源码 ZIP：`python scripts/build_release.py --output NEW_RELEASE.zip`。此构建器保留 `.command`/`.sh` 执行权限并排除录音、环境和私有配置。若通过 Git 发布，还须保留可执行位，例如 `git update-index --chmod=+x -- '*_START_HERE.command' scripts/configure_macos.command scripts/start_macos.sh`，并在 Mac 克隆后复查。
