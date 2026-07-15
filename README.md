# codex-pet-acgn

面向 Codex Desktop 的 ACGN 主题自定义宠物合集。宠物采用 Codex v2 精灵图规范，包含标准状态动画和鼠标方向响应。

## 当前宠物

### 八云蓝

以《东方Project》八云蓝为原型制作的 Q 版九尾狐式神宠物，保留金色九尾、蓝白服饰、白帽与红色缎带等主要形象特征。

![八云蓝 Codex 宠物动画预览](pets/yakumo-ran/preview.gif)

| 项目 | 内容 |
| --- | --- |
| 宠物 ID | `yakumo-ran` |
| 精灵图版本 | Codex v2 |
| 图集尺寸 | `1536 × 2288` |
| 单帧尺寸 | `192 × 208` |
| 图集布局 | `8 × 11` |
| 标准动画 | 待机、左右移动、挥手、跳跃、失败、等待、工作中、审阅 |
| 方向动画 | 顺时针 16 个视线方向，每次间隔 22.5° |

文件位于 [`pets/yakumo-ran`](pets/yakumo-ran)：

- `pet.json`：宠物元数据与 Codex v2 配置。
- `spritesheet.webp`：可直接安装的透明动画图集。
- `preview.gif`：README 使用的轻量动画预览。
- `preview.png`：完整动画接触表，供制作与检查使用。
- `work/qa`：图集验证、方向检查和动画预览等 QA 产物。

### 帕秋莉·诺蕾姬

以《东方Project》帕秋莉·诺蕾姬为原型制作的 Q 版七曜魔法使宠物，保留紫色长发、月牙软帽、粉紫睡衣式长裙和随身魔导书等标志性元素。

![帕秋莉·诺蕾姬 Codex 宠物动画预览](pets/patchouli-knowledge/preview.gif)

| 项目 | 内容 |
| --- | --- |
| 宠物 ID | `patchouli-knowledge` |
| 精灵图版本 | Codex v2 |
| 图集尺寸 | `1536 × 2288` |
| 单帧尺寸 | `192 × 208` |
| 图集布局 | `8 × 11` |
| 标准动画 | 待机、抱书左右跑步、挥手、跳跃、失败、等待、开书工作、开书审阅 |
| 魔导书状态 | 移动与方向动画使用合书；工作与审阅动画使用开书 |
| 方向动画 | 双臂抱合书的顺时针 16 个视线方向，每次间隔 22.5° |

文件位于 [`pets/patchouli-knowledge`](pets/patchouli-knowledge)：

- `pet.json`：宠物元数据与 Codex v2 配置。
- `spritesheet.webp`：可直接安装的透明动画图集。
- `preview.gif`：README 使用的轻量动画预览。
- `preview.png`：完整动画接触表，供制作与检查使用。
- `work/qa`：透明度、图集结构、方向语义和动画连续性等 QA 产物。

### 东风谷早苗

以《东方Project》东风谷早苗为原型制作的 Q 版现人神风祝宠物，保留绿色长发、青蛙与白蛇发饰、青白巫女服和御币等标志性元素。等待、工作与审阅动画使用祝祷和神事动作，突出她以信仰引发奇迹的现人神设定。

![东风谷早苗 Codex 宠物动画预览](pets/kochiya-sanae/preview.gif)

| 项目 | 内容 |
| --- | --- |
| 宠物 ID | `kochiya-sanae` |
| 精灵图版本 | Codex v2 |
| 图集尺寸 | `1536 × 2288` |
| 单帧尺寸 | `192 × 208` |
| 图集布局 | `8 × 11` |
| 标准动画 | 待机、左右移动、挥手、跳跃、失败、等待、祝祷工作、神事审阅 |
| 角色标识 | 绿色长发、青蛙与白蛇发饰、青白巫女服、御币 |
| 方向动画 | 顺时针 16 个视线方向，每次间隔 22.5° |

文件位于 [`pets/kochiya-sanae`](pets/kochiya-sanae)：

- `pet.json`：宠物元数据与 Codex v2 配置。
- `spritesheet.webp`：可直接安装的透明动画图集。
- `preview.gif`：README 使用的轻量待机动画预览。
- `preview.png`：完整动画接触表，供制作与检查使用。
- `work/character-research.md`：现人神风祝设定与视觉锚点研究。
- `work/qa`：透明度、图集结构、方向盲检和动画连续性等 QA 产物。

## 安装

### 远程一键安装（推荐）

不需要克隆整个仓库。安装器只下载所选宠物的两个运行文件和一个校验清单，验证 SHA-256 后只将 `pet.json` 与 `spritesheet.webp` 写入 Codex：

```powershell
# Windows PowerShell
$installer = Join-Path $env:TEMP "codex-pet-install.ps1"
Invoke-WebRequest -UseBasicParsing `
  -Uri "https://raw.githubusercontent.com/Earmo/codex-pet-acgn/main/scripts/install-pet.ps1" `
  -OutFile $installer
& $installer kochiya-sanae # 或 patchouli-knowledge、yakumo-ran
```

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Earmo/codex-pet-acgn/main/scripts/install-pet.sh \
  | bash -s -- kochiya-sanae
```

列出可用宠物：

```powershell
& (Join-Path $env:TEMP "codex-pet-install.ps1") -List
```

```bash
curl -fsSL https://raw.githubusercontent.com/Earmo/codex-pet-acgn/main/scripts/install-pet.sh \
  | bash -s -- --list
```

默认安装到 `~/.codex/pets/<pet-id>`（Windows 为 `%USERPROFILE%\\.codex\\pets\\<pet-id>`）。可以通过 `CODEX_HOME` 指定其他 Codex 主目录；测试分支或镜像源时可通过 `CODEX_PET_RAW_BASE` 覆盖 Raw 根地址。

完成后重新启动 Codex，或在宠物选择界面重新选择对应宠物。

### 仓库内手动安装

如果已经克隆本项目，也可以将所需宠物的 ID 填入 `$petId`，再复制到 Codex 的个人宠物目录：

```powershell
$petId = 'kochiya-sanae' # 或 'patchouli-knowledge'、'yakumo-ran'
$target = Join-Path $HOME ".codex\pets\$petId"
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item "pets\$petId\pet.json" $target -Force
Copy-Item "pets\$petId\spritesheet.webp" $target -Force
```

## Codex v2 规范

本项目中的新宠物遵循以下基础约定：

- `pet.json` 必须包含 `"spriteVersionNumber": 2`。
- 精灵图为带透明通道的 WebP，尺寸为 `1536 × 2288`。
- 图集固定为 8 列、11 行，每格 `192 × 208`。
- 前 9 行承载标准状态动画，最后 2 行承载 16 个视线方向。
- 未使用的单元格保持完全透明。

## 版权说明

本项目是非官方同人创作，与 ZUN、上海爱丽丝幻乐团及《东方Project》官方无隶属或合作关系。《东方Project》及八云蓝、帕秋莉·诺蕾姬、东风谷早苗等相关角色设定的权利归其原权利人所有。
