# 普通话与英语语音转录标注流水线

[English installation and usage guide](README.en.md) | [English project statement](NOTICE.en.md) | [English citation guide](CITATIONS.en.md)

## 第一次用？只认这一个文件

1. 下载项目发布的 ZIP 并完整解压，不要在压缩包内直接运行。
2. **Windows** 双击 **`开始使用_START_HERE.bat`**；**M 系列 Mac** 双击 **`开始使用_START_HERE.command`**。
3. 首次打开时选择普通话、英语或两者，确认安装。以后仍然双击同一个文件，直接进入软件。

**Mac 需要 macOS 14+，当前 0.7.1 仍为适配预览版，尚未完成真实 Mac 端到端验收。** 使用原生 ARM CPU，不使用苹果 GPU；至少预留 30 GiB 空间。请先看[Mac 三步指南](MACOS.md)。Windows 使用说明继续见下文。

不用先读完说明，也不用自行安装 Python。首次使用窗口与工作台均支持中文 / English。**默认自动检测硬件，按可用内存与受支持 GPU 的空闲显存选择模型和精度，并实际试运行验证。** 只有核显或没有受支持 GPU 时使用 CPU，自动从 medium/small/base 中选型，不默认加载 large-v3。固定 large-v3 是需要主动选择的研究选项。后面的说明供查阅，`setup.bat` / `run.bat` 是高级或旧版入口，`gui.bat` 与新入口相同。

Windows 首次安装需要联网，单语言至少预留 25 GiB、双语言 28 GiB 磁盘空间。安装期间显示实际阶段；失败后窗口保留，可打开日志并重试。Windows 安装日志与同文件中英双语简要总结在 `.launcher-state/install-时间/`；Mac 日志位置见[Mac 指南](MACOS.md)。**不要把本地状态目录上传 GitHub**。入口不会替换系统 Python，也不要求关闭安全软件或使用管理员权限。

本地处理重复读词实验、单口和访谈，输出 Praat 可打开的同名 WAV + TextGrid，另存 TXT/LAB、字幕和复核日志。**自动结果是待人工校准的候选，不是金标准，不直接承诺训练数据量或边界准确率。**

**运行总结为中英双语：同一个`summary.log`内先中文、后英文。** 正常完成、待复核、部分失败和异常简要总结均提供两种语言。技术标签、路径、转录文本及第三方原始报错不自动翻译，便于核查。

**这是开源工具集成工作流，不是完全原创的识别/对齐模型。** 本项目主要编写安装、调用编排、切分与复核规则、文本入口、导出和报告代码，开发中使用AI编码助手；底层算法、预训练模型和词典来自上游团队。详见[贡献与开发声明](NOTICE.md)、[引用指南](CITATIONS.md)和[第三方许可说明](THIRD_PARTY.md)。

## Windows 一键安装

支持 Windows 10/11 x64。下载源码ZIP并完整解压，双击 **`开始使用_START_HERE.bat`**。安装器自动下载并校验 Miniforge，创建独立的 Whisper、MFA、分析环境，安装锁定依赖、下载指定模型并验证推理和对齐。不需要预装 Python、Conda、FFmpeg 或手工配置 DLL，不修改系统 Python 和全局 PATH。

### 选择目标语言（0.5.0）

首次使用窗口中勾选普通话、英语或两者，只下载所选语言的资源。旧版 `setup.bat` 仍使用 **1=普通话、2=英语、3=两者**。多语Whisper权重共用一份；MFA声学模型、词典和完整安装中的HanLP模型按语言分别安装。VAD、AST和ECAPA共用。也可直接指定：

```powershell
.\setup.bat -Languages en
.\setup.bat -Languages "zh,en" -DefaultLanguage zh
# 只使用英文文本对齐，不下载Whisper/HanLP等权重。
.\setup.bat -Languages en -TextOnly
```

只安装一种语言时，运行向导自动使用它；安装两种时，增加一次语言选择，回车使用安装时的默认语言。命令行用`--language zh`或`--language en`；`run.bat languages`查看已安装语言，不下载模型。增加语言时重新运行安装，列出需要保留的全部语言；验证通过后切换入口，旧环境仍可回退。

**多选会增加下载量及磁盘占用，但不会再下载一份Whisper。** 在已有中文模型的完整安装上，英文新增MFA约92MB、词典约4MB、HanLP压缩包约603MB（解压权重约650MB）及约2MB分词资源；临时压缩包、解压缓存和安装包会影响实际占用。安装器按单语言完整安装25GiB、双语言28GiB空闲空间检查；读词/纯文本安装分别预留12GiB/12.5GiB。这些是含环境与临时文件的保守空间预算，不是最终模型体积。升级保留旧环境还会额外占空间。

**每个录音或批次选一种目标语言，不是自动混合语言对齐。** 英文使用`english_mfa`与`english_us_mfa`（均为3.0.0，MFA IPA音素体系，不是ARPAbet，也不是严式IPA真值）。词典偏向美式英语，英式或其他口音需要复核及必要的候选读音；不会自动判断并安装某种英语口音模型。中文任务中出现英文，不会自动改用英文模型。

```powershell
.\run.bat run "D:\recordings\words.wav" --language en --output outputs\english_words
.\run.bat continuous "D:\recordings\speech.wav" --language en --output outputs\english_speech
.\run.bat from-text "D:\recordings\read.wav" --language en --transcript "D:\recordings\read.txt" --output outputs\english_text
.\run.bat phones --language en --output outputs\english_phones.txt
```

英文不做繁简转换或拼音转换，按单词查词典，保留缩写中的撇号，连字符拆分；数字、未覆盖人名或其他文字不自动猜读音，作为OOV保留并标记。请把数字、缩略语等校正为实际读出的词。英语重复组使用文字词项证据与声学距离，不把拼写称为音标。连续语音只导出英文`transcript.srt`，不生成`pinyin.srt`。任务记录语言、词典和声学模型，后续`align`遵循任务原语言；没有语言字段的旧任务仍按普通话处理。

0.6.1 将首次安装和日常启动合并到 **`开始使用_START_HERE.bat`**；原生 Windows 桌面 GUI、`gui.bat`、原有 `run.bat` 向导和命令行保持可用。运行总结始终在同一文件内提供中英双语，与音频语言和界面语言无关。

### 桌面界面（中文 / English）

1. 右上角选择 **简体中文 / English**，立即切换并记住选择。界面语言与“录音语言”相互独立，不改变已填写参数或任务队列。系统文件选择框可能沿用操作系统自身语言。
2. “新建任务”中添加文件或文件夹，选择录音语言、任务类型和输出根目录。只显示已安装语言。重复读词与已有文本模式需要 WAV；连续语音可接收支持的音视频格式。
3. 访谈需要 10–60 秒的干净目标说话人参考音频。已有文本模式一次处理一份录音及其对应文本，支持全文、逐 VAD 段和带时间戳 TSV 映射。重复次数不是固定三次，高级参数中的次数/组数仅用于事后核验。
4. 加入队列后串行处理，避免同时加载多份 GPU 模型。右侧显示真实阶段、可获得的段数和原始日志，没有虚构的总百分比或剩余时间。模型配置只读。
5. “检查导出结果”可筛选带复核标记的片段、播放音频，并将 WAV/TextGrid 打开到另行安装的 Praat 中；GUI 本身不是边界编辑器。播放使用临时 PCM16 副本，不改写导出的音频。总结在同一个 `summary.log` 中提供中英文。

停止任务会停止该任务的子进程及队列，保留已生成文件。重新打开 GUI 不会自动开跑队列。仅当准备完成且没有 `package/` 时，才开放继续分析/对齐；不支持任意位置恢复 Whisper。已有导出、人工改过的文件不覆盖，重新处理使用新目录。导入已有结果只读查看，不自动将旧任务迁移为可重跑任务。

“模型与环境”可查看安装时硬件检测结果，并打开原有安装程序来增装语言；这不是后台自动下载。重装后刷新环境，新任务使用新配置，旧任务保留自己的配置快照。GUI 额外下载约 74 MB 的固定版本 Qt/PySide6 包，安装后占用更多磁盘空间。源代码中的 GUI 依赖为可选项，Windows 一键安装默认包含它。

任务历史、设置、配置快照、GUI 工作日志位于项目 `.gui-state/`，可能含路径和转录内容，**不要上传 GitHub**。该目录已加入忽略规则且不进入源码 ZIP。终止早期任务时可能还没有流水线总结，GUI 日志和中断记录仍保留。第三方日志、技术标识和原文不自动翻译。

| 模块 | 默认配置 |
| --- | --- |
| 转录 | 默认自动适配模型与精度，安装时实测；手动研究模式可固定 `large-v3` |
| 语音检测 | Silero VAD |
| 对齐 | MFA 3.3.9；中文`mandarin_mfa` + `mandarin_china_mfa`，英文`english_mfa` + `english_us_mfa`；资源均3.0.0 |
| 句法 | 中文HanLP ELECTRA **BASE**；英文HanLP ModernBERT **BASE**；含依存与成分句法 |
| 说话人核验 | SpeechBrain ECAPA，使用用户提供的目标参考录音 |
| 音质标签 | AST AudioSet，多标签 sigmoid 分数 |

这里选择并验证的HanLP模型都是BASE，不冒称large。英文模型为`EN_TOK_LEM_POS_NER_SRL_UDEP_SDP_CON_MODERNBERT_BASE`，不是用中文模型解析英文。HanLP、声纹和音质模型使用独立CPU环境，Whisper可使用GPU，减少显存竞争和依赖冲突。[HanLP官方模型表](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html)

首次建议预留 **25GB以上磁盘、16GB以上内存**。需要访问 GitHub、conda-forge、PyPI、PyTorch、Hugging Face 和 HanLP 模型服务器。HanLP主站不可用时自动尝试作者的`ftp.hankcs.com`同模型备用地址；两个源都失败会明确报错，不会静默换用小模型或规则。重跑安装可复用缓存。CPU可以运行large-v3，但较慢。

GPU需已有可工作的 NVIDIA 驱动；本版本锁定CUDA 12.8/cuDNN 9.10运行库，不会替换系统驱动。新安装的任务只使用安装时验证过的配置；运行中失败会记录错误，不会悄悄切换模型、设备或精度。旧版配置须重新安装才能获得这项保证。

Windows 环境默认在 `%LOCALAPPDATA%\SpeechAnnotationRuntime\v0.7.1-配置编号-语言`，模型缓存在同一根目录的`models-v1`。源码可放中文目录，MFA中间文件在英文目录运行。中文/空格用户名优先尝试Windows短路径；系统禁用短路径时需要指定可写英文路径：`setup.bat -RuntimeRoot D:\SpeechRuntime`。

`setup.bat -CpuOnly`不装GPU库；`setup.bat -WordsOnly`只装读词模式。默认完整安装。不需要关闭安全软件或使用管理员权限。

仅使用自己提供的文本时，可选`setup.bat -TextOnly`：只装运行/VAD依赖与MFA，不下载或加载Whisper权重，也不装GPU库、HanLP、声纹和AST。完整安装也包含文本路径，已有完整环境无需为了跳过Whisper重新安装。文本路径不要求GPU。

### 兼容性与自动选型

- `locks/`固定Windows x64、Python 3.11的完整依赖组合。Conda包锁定下载地址及SHA256；pip包锁定版本，但本版尚未逐个锁定wheel哈希。不要自行混装“最新版”。
- Whisper、AST、ECAPA锁定模型仓库commit；主要权重及指定配置文件校验SHA256。MFA使用指定发布版；HanLP使用同一具名模型并检查文件哈希。完整标识随任务写入报告。
- 安装前检查CPU、可用内存、磁盘、显卡型号、当前空闲显存和驱动版本。按资源选择候选后，在独立子进程中实际加载并推理，不能只凭显卡名字判断。
- 安装还执行三个环境的依赖检查、MFA对齐运行测试及完整安装的分析模型加载检查。失败时不切换`.runtime.json`；旧环境和已有标注保留。同版重复安装也另建目录，避免损坏当前可用环境。
- 每次MFA对齐使用独立工作数据库，多个任务不共用临时状态；仅共享只读模型缓存。
- 仅为本版本支持平台提供固定组合，不代表任意操作系统、旧驱动或网络都能自动修好。GPU测试失败时可明确选择`-CpuOnly`，或安装合适驱动后重试。

| 安装策略 | 行为 |
| --- | --- |
| `setup.bat` 或 `setup.bat -Profile adaptive` | 默认自动适配：按资源尝试受支持 GPU 的 large-v3/medium/small/base 配置；没有可用 GPU 时尝试 CPU INT8 medium/small/base；失败候选、最终选择和原因均记录 |
| `setup.bat -Profile research` | 手动固定研究配置：固定large-v3；显存充裕时GPU FP16，否则评估CPU FP32；选中的配置实测失败就停止，不缩小模型 |

CPU 自动候选按**当前可用内存**预筛选：至少 6 GiB 尝试 medium，至少 3 GiB 尝试 small，至少 1.5 GiB 尝试 base；先尝试符合条件的较大候选，验证失败再尝试更小候选。这些是项目估计阈值，不是成功保证；检测不到可用内存且没有 GPU 候选时停止并提示，不盲选大模型。核显共享内存不按 NVIDIA 独立显存处理。自动适配仅调整 Whisper；HanLP、AST、ECAPA、MFA 仍需各自通过安装验证。已安装环境及保存任务不会因升级入口自动换模型，实际选择随报告记录。

资源门槛是工程估计，不是官方最低要求。空闲显存会变化；短音频通过不能保证任意批量或长音频都不溢出。便捷模式可能改变研究结果，不应把不同配置混用而不记录。HanLP、声纹、音质和MFA模型不随显卡大小替换。

默认Whisper测试使用合成信号，只验证运行兼容性，不验证识别准确率。可指定自己的短录音做真实测试：

```powershell
.\setup.bat -Profile research -ProbeAudio "D:\recordings\test.wav"
.\run.bat hardware
# 保留了上一套配置时，恢复上一个入口；不删除任何环境和录音。
.\setup.bat -Rollback
```

新版本使用新环境目录，安装成功后切换入口，模型缓存可复用。旧环境不会自动删除，因此升级或重装需额外磁盘空间。新电脑首次仍需联网下载；源码ZIP不包含环境和模型。

### 硬件与质量声明

**转录质量可能受到硬件资源及其允许的运行配置的间接制约，但不等于“硬件越强，转录越准”。** 内存、显存、驱动和后端支持会限制可运行的模型、精度及任务规模；便捷模式因此选择较小模型或量化配置时，结果可能变化。本项目没有完成各硬件、模型与精度之间的准确率对照评测，不保证量化必然降低质量，也不保证FP32必然优于FP16。

在相同模型和处理设置能够完整运行的前提下，较弱硬件通常主要影响速度；CPU运行不天然比GPU更不准确。不同设备或数值后端仍不保证逐位一致。默认自动适配可能在不同电脑选择不同模型或精度，研究比较须记录并控制这些差异。手动研究模式固定large-v3、不静默缩小模型，但GPU FP16与CPU FP32仍是不同配置。资源不足导致的中断或不完整输出不能视为有效标注。

更强硬件不能自动修复录音噪声、口音、文本错误、说话人误判或词典音素覆盖不足，也不保证MFA边界更准。使用者提供文本的路径跳过Whisper，不受Whisper模型选型影响，但仍需足够资源完成VAD和对齐。研究比较应记录`summary.json`中的实际模型、精度、硬件与版本，并在统一配置及独立人工校准样本上评价；硬件检测或短音频运行成功不是质量认证。相关原理见[CTranslate2量化说明](https://opennmt.net/CTranslate2/quantization.html)；本项目实测范围见[TESTING.md](TESTING.md)。

## 一键使用

双击 **`run.bat`**，选择音频和模式：1=读词、2=单口、3=访谈、4=使用者提供文本（不经过ASR）。访谈另选目标说话人的参考录音。输出在 `outputs/时间戳/`，不覆盖已有结果。

### 重复读词

输入WAV，**自动检测连续重复组，不预设读几遍**，输出“每词含全部重复”和“每遍单独”两套文件。先VAD、逐段Whisper，再以MFCC+DTW声学距离和连续文字证据分组；中文另用带调拼音，英文使用单词序列。不把声纹相似当作词语相同。组内还会与第一段比较，限制连续误合并。

```powershell
.\run.bat run "D:\recordings\experiment.wav" --output outputs\experiment01
# 已知实验设计时，可附加事后检查；这些数字不会传给分组算法。
.\run.bat run "D:\recordings\experiment.wav" --output outputs\experiment02 --repeats 3 --expect-groups 80
```

词表可选（`--wordlist`），UTF-8，每行一个词项，不按朗读次数重复。先独立分组，组数与词表一致才采用词表；不一致时停止，不强行顺移标签。没有词表时使用ASR候选。词表目前不参与解码或解决同音词分界，同音词不能单靠多数投票解决。

`--start`指定范围开始秒数，`--end`限制结束时间，`--skip-leading`跳过用户指定的检测段，`--silence-ms 400`调整停顿阈值。默认检查整个文件，不固定跳过开头几段。`--repeats`现在仅表示期望次数，不再控制分组；检查不符会保留输出并记入`expectation_check.json`。

头尾出现明确录音准备话语、且与重复朗读区之间有较大间隔时，标记为准备对话候选。没有这些证据的单次朗读不视为噪声。主读词范围以外的头尾原音另存`edge_review/`，不直接删除，也不进行会改变声学特征的降噪。VAD未覆盖区间不等于纯噪声，仍记录在日志中。

DTW阈值按本次录音的距离分布估计；样本不足或分布不可分时使用保守阈值并标记。**这些分数不是正确率或概率**。跨词稳定转录发生变化时即使声音相近也保留分界；不稳定转录、近阈值边界等标为待复核。最小对立词、同音词和方言读音仍可能误分，不能保证通用自动准确率。

默认VAD边界外前后各最多保留480毫秒原录音，相邻段受间隙中点约束，不互相重叠。VAD本身仍可能错判；留白不代表边界已经可靠。没有停顿的重复若合在同一VAD段，本版保留整段；识别文本有内部重复时标记`possible_internal_repetition`，不按时长平均硬切，也不声称识别出了每一次。

### 单口、访谈与批处理

接受WAV、MP3、M4A、FLAC、MP4等PyAV支持的媒体。对齐和导出使用16kHz单声道标准化副本；原文件不改动。

```powershell
.\run.bat continuous "D:\recordings\monologue.mp4" --output outputs\monologue01
.\run.bat continuous "D:\recordings\interview.wav" --mode dialogue --reference "D:\recordings\target.wav" --output outputs\interview01
# 输入目录时递归批处理；输出目录必须在输入目录之外。
.\run.bat continuous "D:\interviews" --mode dialogue --reference "D:\target.wav" --output outputs\interviews
```

参考录音应为**10–60秒同一目标说话人的清晰独白**，无其他人和BGM，检测语音至少5秒。不从访谈开头猜测目标说话人。

先VAD找真实停顿，Whisper识别发声单元，HanLP用句法辅助合并不完整单元。**不按字符数伪造时间戳，不强切紧密连读**。超长连读段保留并标记，不承诺每段都是理想小句。连续段默认留白最多250毫秒，受相邻段中点限制。可调`--padding`、`--silence-ms`（默认250）、`--max-merge-duration`（默认30秒，仅限制合并）。

中文任务输出中文及拼音SRT，英文任务只输出英文SRT。输入旁有同名SRT时自动生成`subtitle_diff.log`，也可用`--subtitle`指定。日志包括分行差异，不是转录正确率；拼音来自文字词典，不替代音素或声调标注。

声纹阈值默认0.65，存疑区0.05，可用`--speaker-threshold`调整；分数不是概率，需用自己的已知样本校准。**本版是声纹核验，不是完整diarization或重叠语音分离。** 无停顿换人、同时讲话等仍会误判。`target_candidate`仅是目标候选，人工确认后才能作为“仅目标说话人”的样本。

AST的BGM、原声标签也是风险提示，不能证明声音来自电影。所有检测到的发声段均保留，不自动降噪或删除低音质语音。VAD以外区间在`outside_vad_regions.json`记录，完整原音频与标准化副本可回查。

## 提供文本：口音普通话与朗读实验

`from-text`接受WAV和UTF-8文本，**不初始化Whisper、不改写成标准普通话文本**。提供的是实际说出的内容，不应把有漏读/口误的提示词表直接当作转录。当前文本路径不运行HanLP、AST或声纹核验，不承诺从多人访谈中挑出目标说话人；需事先分好说话人。原录音不降噪、不覆盖。

```powershell
# 一段音频配一段实际文本，不在连续语流内部硬切；适合已分段词/句。
.\run.bat from-text "D:\recordings\read.wav" --transcript "D:\recordings\read.txt" --output outputs\text01
# 每次朗读一行，VAD检测出的段数必须与行数一致。连续相同标签组成一个词组。
.\run.bat from-text "D:\recordings\words.wav" --transcript "D:\recordings\readings.txt" --mapping vad --mode words --output outputs\text02
# 明确给定时间范围，适合VAD段数不匹配或自然语流。
.\run.bat from-text "D:\recordings\read.wav" --transcript "D:\recordings\segments.tsv" --mapping timed --output outputs\text03
```

`whole`默认使用选定范围内的整段音频，TXT各行合成该段的全文；`--start/--end`可避开已确认的头尾噪声，不自动判断噪声。超长段标记复核，不假装已经按小句切好。`vad`要求每次读词/读句一行，读三遍就提供三行，**不预设三遍**；数量不匹配时保留检测结果并停止，不强行顺移。数量一致也不能证明每一行对应正确，需要核对。

`timed`使用制表符分隔，时间单位为原始录音的秒，表头如下。非空文本、时间范围及不重叠都会检查。

```tsv
start	end	text
0.5	1.4	今天下雨了
2.0	3.2	我想回家
```

默认`--tokenization auto`：中文按汉字查词典，英文按英语单词查词典；`--tokenization space`则按使用者的空格分词（小写化），每个词必须有词典条目。未覆盖的语言内容不会被静默删除；只有所选词典和声学模型覆盖其发音时才可对齐，中文模型不会因此自动变成英语模型。下方候选读音方法也适用于英文，但必须使用英文模型的音素集合。

### 候选读音，不是自由音素识别

默认词典主要给出其允许的常见读音。口音的偏离如果不在词典候选内，MFA仍可能把它硬套为已有读音。可通过`--pronunciations variants.dict`指定有研究依据的候选，MFA依据声学证据和解码约束选择路径，而不是仅选几何意义上“最接近的IPA”。

候选文件是两列：词项、音素序列，中间必须为TAB；音素之间为空格。同一词项多行即多个候选。下例仅演示格式，**不表示任何特定说话人有该变体**：

```text
你	n i˨˩˦
你	l i˨˩˦
```

此例会替换“你”在基础词典中的所有原读音，而非自动追加；需保留的标准读音也应列入。候选使用等权发音先验（1.0）及固定静音参数（0.5/1.0/1.0），未覆盖词项保留原词典概率；全部记录在`pronunciation_audit.json`。原始词典不修改。候选音素必须精确属于声学模型的集合，不能随意填写拼音、IPA变音符或新音素。

```powershell
.\run.bat phones --output outputs\allowed_phones.txt
.\run.bat from-text "D:\recordings\read.wav" --transcript "D:\recordings\read.txt" --pronunciations "D:\recordings\variants.dict" --output outputs\accent01
```

输出中保留原文本层和方法说明层；`phones`是自动候选路径，**不是经确认的严式IPA或口音真值**。口音可能改变时长、音质、共发音和韵律，不一定能离散为现有音素。不能为了提高对齐成功率无限加入变体，然后把系统选中的候选当作研究发现。应以独立人工标注样本评价候选选择和边界误差；强口音可能需要额外声学适配或重新训练，本版本没有自动完成这一步。

`--prepare-only`可先检查`segments.json`再运行`align`。句子输出到`package/audio_textgrid/sentences/`；词模式保留每遍和整组两套。TXT/LAB仍在`texts/`。所有文本驱动片段标为待复核，日志明确Whisper未使用，另有`CITATIONS_USED.md`和发音候选审计。原文、候选文本和路径可能含个人信息，不应直接公开。

## 人工复核后再对齐

```powershell
.\run.bat prepare "D:\recordings\experiment.wav" --output outputs\review01 --start 15
# 连续语音可使用 continuous ... --prepare-only。
# 修改 segments.json 的 start、end、label 后：
.\run.bat align --prepared outputs\review01
.\run.bat verify outputs\review01\package
```

检测数不匹配时需核对顺序、修正范围和`group`/`repeat`，并填写每段`label`。已有`package/`不覆盖，重做需新输出目录或把准备文件复制到新目录。源音频在准备与对齐之间发生变化时，SHA256校验会中止。

若连续模式已经完成Whisper但分析阶段失败，可用`run.bat analyze --prepared outputs\本次任务`继续分析，再运行`align`，不必重做转录。已经存在分析结果时不会覆盖，以保护人工修改。

## 输出

```text
outputs/本次任务/
  run.json / segments.json / alignment_manifest.json
  summary.log / summary.json  # 同文件中英双语总结、机器可读详情
  run.log / run_events.json   # 运行输出、阶段耗时与异常
  mfa.log / analysis.log
  package/
    words_grouped/            # 读词：每词全部重复，WAV+TextGrid
    individual_repetitions/   # 读词：每遍单独，WAV+TextGrid
    edge_review/              # 读词：头尾原音和准备话语候选，保留供核查
    audio_textgrid/           # 连续模式：WAV+TextGrid
      monologue/             # 无参考声纹的单口
      target_candidate/      # 目标候选
      other_candidate/       # 其他说话人候选，保留
      uncertain/             # 说话人存疑，保留
    texts/                   # TXT、LAB另存
    review_log.tsv           # Excel可打开
    summary.log / summary.json / run.log / run_events.json
    file_validation.json     # 文件配对、时长、区间结构检查，不是边界准确率
    manifest.json / run.json
    grouping_audit.json / expectation_check.json / edge_review.json  # 自动分组及事后检查
    transcript.srt / pinyin.srt / subtitle_diff.log  # 连续模式；pinyin仅中文
  annotation.zip
```

TextGrid含words、phones、review层；连续模式另有speaker、quality。读词WAV保留原采样率与声道，PCM24导出；24位封装不会提升原始信息量。

中文词典按字送入。含英文、数字、词典外字或空文本的片段保留音频，phones留空并标记，**不删掉英文再硬对齐中文**。中英混读需要匹配的多语模型和词典，本版未解决。音素是词典约束的自动IPA风格标签，不是严式语音转写。

每次准备、分析、对齐及批处理自动更新**中英双语`summary.log`**：同一文件内依次为`=== 中文 ===`和`=== English ===`，两部分使用同一份任务数据，包含实际模型/精度、计数、未对齐数量、复核项、音质与说话人标签、耗时、失败原因，不另存一份英文总结。`summary.json`保持机器可读结构，另含依赖版本、模型校验值及硬件信息，并以`report_languages`注明双语。技术标签、路径、转录文本及第三方原始异常保留原文，不通过自动翻译改写。运行异常也尽量生成双语报告，完整报告失败时尝试写双语简要错误总结；磁盘不可写、进程被强制终止或输出目录已被占用时无法保证写入，且绝不为写报告覆盖已有标注。批处理部分失败会明确显示，不标成全部成功。

`review_log.tsv`可用Excel打开；本版不额外生成XLSX。新任务成功导出后的`annotation.zip`和`package/summary.log`都包含同一份双语总结。使用新版入口可运行`.\run.bat report --prepared outputs\旧任务`将旧任务的总结重新生成为双语，并同步到已有`package/`，不修改音频或TextGrid；已存在的旧`annotation.zip`不会由此命令重打包，分享新报告时应使用更新后的`summary.log`。旧版未记录的精度等信息会标为未记录，不猜测。双语范围是任务总结，不表示所有控制台输出、安装日志及第三方日志均已翻译。

## 开发、发布与隐私

```powershell
$env:PYTHONPATH = "src"
python -m unittest discover -s tests -v
python scripts/build_release.py --output dist\speech-annotation-pipeline-source.zip
```

GitHub Actions检查规则与语法，实际验证范围见`TESTING.md`。本项目代码MIT许可，第三方模型各有独立许可，见`THIRD_PARTY.md`。

学术使用须按`CITATIONS.md`引用上游；本项目的可归属贡献和AI辅助开发情况见`NOTICE.md`。`CITATION.cff`使用集体署名占位，正式发布前应核实实际贡献者并填写最终仓库地址，不要把上游作者写成本项目作者，也不要省略他们的成果引用。

**只把本目录作为GitHub仓库根目录**，不要上传上级工作目录、录音、结果、模型或`.runtime.json`。`.gitignore`和发布ZIP白名单会排除它们。处理在本地执行，安装联网下载模型；报告含本机路径及转录内容，公开前应检查隐私。

安装排错查看对应版本环境目录的`setup.log`、`validation/`、`hardware.json`及`selection_attempts.json`。成功后有`installation_summary.log`，失败时有`installation_failure.json`（安装开始前的参数/权限错误除外）。任务排错优先看`summary.log`，再看`mfa.log`、`analysis.log`。不要直接公开含个人路径的完整日志。

官方资料：[faster-whisper](https://github.com/SYSTRAN/faster-whisper)、[MFA](https://montreal-forced-aligner.readthedocs.io/en/latest/installation.html)、[Miniforge](https://github.com/conda-forge/miniforge)、[HanLP模型清单](https://hanlp.hankcs.com/docs/api/hanlp/pretrained/mtl.html)、[ECAPA](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb)、[AST](https://huggingface.co/MIT/ast-finetuned-audioset-10-10-0.4593)。
