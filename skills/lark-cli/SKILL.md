---
name: lark-cli
description: "飞书 / Lark 能力统一入口（lark-cli）：所有飞书相关任务的单一入口。覆盖认证授权、通讯录 open_id 解析、即时通讯与群聊及交互卡片、实时事件订阅、云文档 Docx/Wiki 与思维笔记、知识库、云空间 Drive 文件管理与格式导入、Markdown、多维表格 Base、电子表格 Sheets、幻灯片 Slides、画板 Whiteboard、日历与会议室、视频会议与会中能力、妙记 Minutes 与会议纪要 Note、邮箱 Mail、任务待办 Task、OKR、审批 Approval、考勤 Attendance、会议纪要汇总与日程待办摘要工作流、妙搭应用开发、以及未封装的原生 OpenAPI 探索和自定义 Skill 制作。当任务涉及飞书 / Lark / Feishu / lark-cli，或给出 doubao.com / feishu.cn / larksuite.com 的文档、Wiki、表格、画板等 URL/token 时使用——按 URL 路径模式与 token 路由，不因域名不是飞书而回退 WebFetch。"
metadata:
  requires:
    bins: ["lark-cli"]
---

# lark-cli

飞书 / Lark 能力的统一路由入口。各子域的完整说明承载在 `references/subskills/lark-*/` 下（与上游目录名一致）。

**入口文件命名约定**：所有子域的说明文件统一叫 `GUIDE.md` 而不是 `SKILL.md`——这是构建时有意为之，避免宿主把每个子域递归发现成独立 skill。找某个子域的详细说明时，读对应目录下的 **`GUIDE.md`**；子域之间的内部引用（如 `../lark-shared/GUIDE.md`）已同步改写，均可解析。

**不要安装 lark-cli，默认请直接使用 `npx @larksuite/cli@latest`。**

## How to use

1. 先在下方路由表中匹配任务所属子域。
2. **执行任何命令前**，Read 对应子域的 `./references/subskills/lark-<域>/GUIDE.md`（及其引用的 references），按其中的命令、参数约定和注意事项操作；不要凭猜测直接拼 `lark-cli` 命令。
3. 不确定命令名或参数时先看 `--help`，需要机器可读输出时加 `--json`。
4. 认证、授权、scope 报错一律走 `lark-shared`。
5. 现有子域都无法满足的需求走 `lark-openapi-explorer` 找原生 OpenAPI。

## Route by task

| 子域 | 触发场景 |
| --- | --- |
| [lark-shared](./references/subskills/lark-shared/GUIDE.md) | lark-cli 安装配置与认证：auth login/status/logout、用户 vs 机器人身份、`--domain` 权限域、缺 scope、撤销授权、`_notice` JSON 处理 |
| [lark-contact](./references/subskills/lark-contact/GUIDE.md) | 通讯录：姓名/邮箱 ↔ open_id 反查，查姓名/部门/联系方式/个人状态，搜索可见机器人与 agent |
| [lark-im](./references/subskills/lark-im/GUIDE.md) | 即时通讯：收发回复消息、搜索聊天记录、群成员管理、图片文件上传下载、表情回复、加急、交互卡片发送与按钮回调监听、群置顶/标签 |
| [lark-event](./references/subskills/lark-event/GUIDE.md) | 实时事件订阅消费：IM 消息/表情/群变更、审批状态、任务更新、会议开始结束等事件流（bot、长驻订阅、webhook handler） |
| [lark-doc](./references/subskills/lark-doc/GUIDE.md) | 云文档内容操作：Docx / Wiki 文档读取、创建、编辑，插入或下载图片附件，思维笔记；`/docx/`、`/wiki/` URL/token |
| [lark-wiki](./references/subskills/lark-wiki/GUIDE.md) | 知识库：知识空间管理、空间成员、节点层级组织、快捷方式；`/wiki/` URL/token 的空间结构操作 |
| [lark-drive](./references/subskills/lark-drive/GUIDE.md) | 云空间：Drive 文件/文件夹上传下载、复制移动删除、元数据、权限设置、评论、订阅、版本、密级标签，Word/Excel/PPTX/.base 等本地文件导入为在线格式，链接类型判断 |
| [lark-markdown](./references/subskills/lark-markdown/GUIDE.md) | Markdown 文件：查看、创建、上传、编辑、局部 patch、比较差异（不含导入为在线文档） |
| [lark-base](./references/subskills/lark-base/GUIDE.md) | 多维表格 Base/bitable：建表、字段、记录、视图、统计、公式/lookup、表单、仪表盘、workflow、角色权限；`/base/` URL |
| [lark-sheets](./references/subskills/lark-sheets/GUIDE.md) | 电子表格：工作表与行列结构管理、单元格读写（值/公式/样式/批注/图片）、查找替换、批量更新、图表、透视表、条件格式、筛选器 |
| [lark-slides](./references/subskills/lark-slides/GUIDE.md) | 幻灯片：创建演示文稿、读取幻灯片内容、页面增删改查；`/slides/` URL/token |
| [lark-whiteboard](./references/subskills/lark-whiteboard/GUIDE.md) | 画板：导出预览图或原始节点结构、多种格式更新画板内容 |
| [lark-minutes](./references/subskills/lark-minutes/GUIDE.md) | 妙记：搜索与查看妙记、上传下载音视频、读取编辑产物内容、替换说话人/关键词、申请妙记权限；本地音视频转纪要/逐字稿 |
| [lark-note](./references/subskills/lark-note/GUIDE.md) | 会议纪要 Note 直查：已知 note_id 时查详情、关联文档 token、读 unified 原始逐字记录 |
| [lark-calendar](./references/subskills/lark-calendar/GUIDE.md) | 日历：查看/搜索/创建/更新日程、管理参会人、查询忙闲与推荐时段、预定会议室 |
| [lark-vc](./references/subskills/lark-vc/GUIDE.md) | 视频会议（已结束）：搜索历史会议、查询会议纪要（总结/待办/章节/逐字稿）、参会人快照 |
| [lark-vc-agent](./references/subskills/lark-vc-agent/GUIDE.md) | 会中能力：让应用机器人真实加入/离开进行中的会议、读取会中事件、发送会中文本消息或表情 |
| [lark-mail](./references/subskills/lark-mail/GUIDE.md) | 邮箱：起草/发送/回复/转发邮件、查阅搜索邮件、文件夹、标签、联系人、收信规则、监听新邮件 |
| [lark-task](./references/subskills/lark-task/GUIDE.md) | 任务：创建待办、更新状态、子任务拆分、清单组织、协作成员、附件、任务智能体注册与主页数据 |
| [lark-okr](./references/subskills/lark-okr/GUIDE.md) | OKR：周期、目标、关键结果、对齐关系、量化指标、进展记录的查看与编辑 |
| [lark-approval](./references/subskills/lark-approval/GUIDE.md) | 审批：查询处理待办/已办/实例、搜索可发起的定义、查看定义详情并发起原生审批实例（注意：审批待办 ≠ 任务） |
| [lark-attendance](./references/subskills/lark-attendance/GUIDE.md) | 考勤打卡：查询自己的打卡记录 |
| [lark-workflow-meeting-summary](./references/subskills/lark-workflow-meeting-summary/GUIDE.md) | 工作流·会议纪要汇总：汇总指定时间范围的会议纪要并生成结构化报告/周报 |
| [lark-workflow-standup-report](./references/subskills/lark-workflow-standup-report/GUIDE.md) | 工作流·日程待办摘要：编排 calendar + task，生成指定日期的日程与未完成任务摘要 |
| [lark-openapi-explorer](./references/subskills/lark-openapi-explorer/GUIDE.md) | 兜底：现有子域和已注册命令都满足不了时，从官方文档库挖掘并调用未封装的原生 OpenAPI |
| [lark-skill-maker](./references/subskills/lark-skill-maker/GUIDE.md) | 把飞书 API 操作封装成可复用的自定义 Skill（包装原子 API 或编排多步流程） |
| [lark-apps](./references/subskills/lark-apps/GUIDE.md) | 妙搭 Spark/Miaoda：应用创建、全栈开发、云端部署发布、UI mockup/原型/deck 设计、日志监控、环境变量、协作者与角色管理、自动化触发器 |
