<div align="center">

# Ce-Legend Skills

#### 我自己长期使用、会反复调用、值得沉淀成 Agent 能力的 Skill 集

[![License](https://img.shields.io/badge/License-MIT-3B82F6?style=for-the-badge)](./LICENSE)
[![Skills](https://img.shields.io/badge/Skills-1-10B981?style=for-the-badge)](#skills)
[![Codex](https://img.shields.io/badge/Codex-Skill-111827?style=for-the-badge)](https://github.com/openai/codex)

</div>

这里放的是我希望 Agent 长期带着走的工作流：能触发、能执行、能验证、能复用，而非临时 prompt 或一次性脚本。

每个 Skill 都尽量回答四件事：

- 它解决什么真实问题
- 什么时候应该触发
- Agent 具体要怎么做
- 产出如何确认可信

## 目录

| 名字 | 一句话 | 入口 |
|---|---|---|
| [web-access](#web-access) | Codex 的外部事实访问层，让 Agent 能严谨地查实时信息、读网页、操作浏览器、保留证据链 | [SKILL.md](./skills/web-access/SKILL.md) |

## 安装方式

在 Codex、Claude Code、OpenCode、OpenClaw 等支持 `SKILL.md` 的 Agent 里，可以直接说：

```text
帮我安装这个 skill：https://github.com/Ce-Legend/ce-legend-skills/tree/main/skills/web-access
```

如果需要手动安装：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R skills/web-access "${CODEX_HOME:-$HOME/.codex}/skills/web-access"
```

## Skills

<a id="web-access"></a>

### web-access

> "只要问题碰到真实世界，Agent 就不能只靠记忆回答。它要能查、能读、能点、能验证。"

`web-access` 是 Codex 的外部事实访问层。它处理的是 Agent 最容易失真的那一类任务：实时信息已经变化、搜索结果需要核验、网页由 JavaScript 渲染、证据藏在交互之后，或者任务必须在登录态浏览器里完成。

它的核心价值在于让 Agent 形成一套稳定的联网判断流程：先明确成功条件，再选择最轻的访问层；搜索只是发现线索，打开原始来源才算证据；页面读不到就升级浏览器；浏览器还不够时再进入本机 Chrome 登录态；每一步都留下来源、时间、页面状态或完成信号。

**它能做什么**

- 实时检索和核验当前事实：价格、政策、产品文档、公司信息、发布时间、日程、新闻
- 读取具体 URL，提取标题、日期、正文片段、来源链接和关键字段
- 处理动态网页：点击、输入、等待、截图、DOM 检查、上传、下载
- 处理登录态任务：在确实需要时使用本机 Chrome CDP，不导出 cookie、密码、token
- 给出带证据的回答：说明来源、时间、是否是一手资料、哪些地方仍不确定
- 完成网页动作后做二次验证：确认页、URL、状态码、保存文件、页面文字或截图

**怎么触发**

```text
查一下最新价格
帮我确认这个页面现在写的是什么
打开这个链接并总结重点
核对官网和文档的说法
帮我在网页里下载这个文件
这个后台页面现在是什么状态
用浏览器操作一下这个网站
这个新闻/政策/产品信息是不是最新的
```

**使用原则**

- 凡是可能过期的事实，必须查证后再回答
- 凡是用户要链接、引用、证据，必须打开来源页
- 凡是页面依赖交互或渲染，升级到浏览器工具
- 凡是涉及登录态，只在必要时使用本机 Chrome，且不读取或保存敏感凭证
- 凡是执行了网页动作，必须验证动作后的状态

→ [SKILL.md](./skills/web-access/SKILL.md)
