# TASTE

Owner: `gaofeng`
Purpose: 统一 OPL ScholarSkills 仓库维护判断偏好。
State: `active_preference`
Machine boundary: 本文是人读维护偏好；项目事实、接口约束、验收结论和机器真相以 plugin manifest、SKILL.md、contracts、gallery manifest、验证脚本和 GitHub readback 为准。

## 原则

1. **Skill pack 优先**

   本仓优先服务 Codex/OPL/MAS 能直接发现和同步的 skill pack，而不是复制 OPL runtime 或 MAS domain authority。

2. **Refs-only 边界清晰**

   ScholarSkills 输出是候选 refs、candidate package、human review hint 或 gallery preview。任何 domain truth、publication readiness、publication ready claim、owner receipt、typed blocker、quality verdict 和 artifact body authority 都必须回到 domain owner。

3. **Gallery 只提交发布包**

   人审需要能直接打开 PDF 和阅读 manifest/status/audit；运维不需要把全部渲染中间结果纳入 Git。生成输出、缓存、单图导出和 layout sidecar 默认 ignored。

4. **双语入口保持用户可读**

   根 README 采用 OPL family 风格，英文和中文都先说明用途、边界、快速开始、gallery 与验证命令。

5. **最小充分验证**

   文档和 packaging 变更用 `scripts/verify.sh`、artifact fingerprint 和 GitHub readback 证明；不能用测试通过替代 MAS owner acceptance。
