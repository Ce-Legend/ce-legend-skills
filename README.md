# Ce-Legend Skills

Ce-Legend 的个人 Codex skill 集。

目标是把常用工作流沉淀成可复用、可安装、可版本管理的 skill：描述清楚触发场景，正文只保留执行所需的关键步骤，复杂资料放进 `references/`，可重复操作放进 `scripts/`。

## Skills

- `web-access`: Codex 的外部事实访问层，用于实时联网检索、来源核验、页面读取、动态网站检查、浏览器自动化、登录态网站操作，以及带证据链的回答。

## Install

从仓库根目录复制单个 skill 到 Codex 本地技能目录：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R skills/web-access "${CODEX_HOME:-$HOME/.codex}/skills/web-access"
```

也可以直接把整个仓库保留为个人 skill 源，后续新增 skill 时继续放在 `skills/<skill-name>/`。
