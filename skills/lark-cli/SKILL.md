---
name: lark-cli
description: "飞书 / Lark / Feishu 统一入口（lark-cli）：消息群聊、云文档、知识库、云空间、表格、多维表格、幻灯片、画板、日历、视频会议与妙记、邮箱、任务、OKR、审批、考勤、妙搭应用、原生 OpenAPI。任务涉及飞书，或给出 feishu.cn / larksuite.com / doubao.com 的链接或 token 时使用，链接内容经由它读取而非 WebFetch。"
metadata:
  requires:
    bins: ["lark-cli"]
---

# lark-cli

飞书 / Lark 能力的路由入口：先按下表选定子域，再按子域的 `GUIDE.md` 操作。命令直接用本地的 `lark-cli`。子域说明位于 `references/subskills/lark-<域>/GUIDE.md`，彼此间的相对引用（如 `../lark-shared/GUIDE.md`）均可直接解析。

## Steps

1. 在路由表中选定子域；同一任务跨多个子域时（如先按姓名查 open_id 再发消息）逐个选定。
2. 执行该子域的任何命令前，Read 它的 `GUIDE.md` 及其中指向的 references，命令名、参数与注意事项以其为准；仍有疑问时查 `--help`，需要机器可读输出时加 `--json`。
3. 认证、身份、scope 类报错转 `lark-shared`，修复后重试原命令。
4. 所有子域都覆盖不到的需求转 `lark-openapi-explorer`。

## Route by task

| 子域 | 触发场景 |
| --- | --- |
| [lark-shared](./references/subskills/lark-shared/GUIDE.md) | 安装配置与认证：auth login/status/logout、用户 vs 机器人身份、`--domain` 权限域、缺 scope、撤销授权、`_notice` JSON 处理 |
| [lark-contact](./references/subskills/lark-contact/GUIDE.md) | 通讯录：姓名/邮箱 ↔ open_id 反查，查姓名/部门/联系方式/个人状态，搜索可见机器人与 agent |
| [lark-im](./references/subskills/lark-im/GUIDE.md) | 即时通讯：收发回复消息、搜索聊天记录、群成员管理、图片文件上传下载、表情回复、加急、交互卡片发送与按钮回调监听、群置顶/标签 |
| [lark-event](./references/subskills/lark-event/GUIDE.md) | 实时事件订阅消费：IM 消息/表情/群变更、审批状态、任务更新、会议开始结束等事件流（bot、长驻订阅、webhook handler） |
| [lark-doc](./references/subskills/lark-doc/GUIDE.md) | 云文档内容：Docx / Wiki 文档读取、创建、编辑，插入或下载图片附件，思维笔记；`/docx/`、`/wiki/` URL/token |
| [lark-wiki](./references/subskills/lark-wiki/GUIDE.md) | 知识库结构：知识空间管理、空间成员、节点层级组织、快捷方式；`/wiki/` URL/token 的空间结构操作 |
| [lark-drive](./references/subskills/lark-drive/GUIDE.md) | 云空间：Drive 文件/文件夹上传下载、复制移动删除、元数据、权限、评论、订阅、版本、密级标签，Word/Excel/PPTX/.base 等本地文件导入为在线格式，链接类型判断 |
| [lark-markdown](./references/subskills/lark-markdown/GUIDE.md) | Markdown 文件：查看、创建、上传、编辑、局部 patch、比较差异（导入为在线文档走 lark-drive） |
| [lark-base](./references/subskills/lark-base/GUIDE.md) | 多维表格 Base/bitable：建表、字段、记录、视图、统计、公式/lookup、表单、仪表盘、BaseApp/AppMode、模板中心、workflow、角色权限；`/base/`、`/app/` URL（BaseApp 归这里，不归 lark-apps） |
| [lark-sheets](./references/subskills/lark-sheets/GUIDE.md) | 电子表格：工作表与行列结构、单元格读写（值/公式/样式/批注/图片）、查找替换、批量更新、图表、透视表、条件格式、筛选器 |
| [lark-slides](./references/subskills/lark-slides/GUIDE.md) | 幻灯片：创建演示文稿、读取内容、页面增删改查；`/slides/` URL/token |
| [lark-whiteboard](./references/subskills/lark-whiteboard/GUIDE.md) | 画板：导出预览图或原始节点结构、多种格式更新画板内容 |
| [lark-calendar](./references/subskills/lark-calendar/GUIDE.md) | 日历：查看/搜索/创建/更新日程、管理参会人、查询忙闲与推荐时段、预定会议室、预约会议 |
| [lark-meeting](./references/subskills/lark-meeting/GUIDE.md) | 视频会议、妙记、智能纪要的总入口：历史会议记录与产物（纪要/逐字稿/妙记）、妙记搜索/上传/下载/编辑、进行中会议与会中内容、会中聊天/表情、机器人入会；meeting_id / meeting_no / event_id / note_id / minute_token / 妙记 URL（预约会议、忙闲、会议室归 lark-calendar） |
| lark-minutes / lark-note / lark-vc / lark-vc-agent | 旧名，仅在用户显式点名时读对应 `references/subskills/<名>/GUIDE.md`；其余情况走 lark-meeting |
| [lark-mail](./references/subskills/lark-mail/GUIDE.md) | 邮箱：起草/发送/回复/转发邮件、查阅搜索邮件、文件夹、标签、联系人、收信规则、监听新邮件 |
| [lark-task](./references/subskills/lark-task/GUIDE.md) | 任务：创建待办、更新状态、子任务拆分、清单组织、协作成员、附件、任务智能体注册与主页数据 |
| [lark-okr](./references/subskills/lark-okr/GUIDE.md) | OKR：周期、目标、关键结果、对齐关系、量化指标、进展记录的查看与编辑 |
| [lark-approval](./references/subskills/lark-approval/GUIDE.md) | 审批：查询处理待办/已办/实例、搜索可发起的定义、查看定义详情并发起原生审批实例（审批待办归这里，任务待办归 lark-task） |
| [lark-attendance](./references/subskills/lark-attendance/GUIDE.md) | 考勤打卡：查询自己的打卡记录 |
| [lark-workflow-meeting-summary](./references/subskills/lark-workflow-meeting-summary/GUIDE.md) | 工作流·会议纪要汇总：汇总指定时间范围的会议纪要，生成结构化报告/周报 |
| [lark-workflow-standup-report](./references/subskills/lark-workflow-standup-report/GUIDE.md) | 工作流·日程待办摘要：编排 calendar + task，生成指定日期的日程与未完成任务摘要 |
| [lark-apps](./references/subskills/lark-apps/GUIDE.md) | 妙搭 Spark/Miaoda：应用创建、全栈开发、云端部署发布、UI mockup/原型/deck 设计、日志监控、环境变量、协作者与角色管理、自动化触发器 |
| [lark-skill-maker](./references/subskills/lark-skill-maker/GUIDE.md) | 把飞书 API 操作封装成可复用的自定义 Skill（包装原子 API 或编排多步流程） |
| [lark-openapi-explorer](./references/subskills/lark-openapi-explorer/GUIDE.md) | 兜底：以上子域都覆盖不到时，从官方文档库挖掘并调用未封装的原生 OpenAPI |
