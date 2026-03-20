# 版本管理规范

## 📦 版本号格式

采用语义化版本控制 (SemVer): `主版本号.次版本号.修订号`

**示例**: `1.2.3`

- **主版本号**: 不兼容的API修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正

## 🌿 分支策略

### 主要分支
- **main**: 生产环境代码，始终保持稳定
- **develop**: 开发环境代码，集成所有功能特性
- **release/**: 发布候选分支
- **hotfix/**: 紧急修复分支

### 功能分支
- **feature/**: 新功能开发分支
- **bugfix/**: Bug修复分支
- **refactor/**: 重构分支

## 🔧 发布流程

### 1. 版本规划
```bash
# 在develop分支创建发布分支
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0
```

### 2. 版本冻结
- 冻结功能开发
- 专注Bug修复和优化
- 更新版本号和变更日志

### 3. 发布准备
```bash
# 合并到main分支
git checkout main
git merge --no-ff release/v1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"

# 推送到远程仓库
git push origin main
git push origin --tags

# 合并回develop分支
git checkout develop
git merge --no-ff release/v1.2.0
git push origin develop

# 删除发布分支
git branch -d release/v1.2.0
```

## 📝 提交信息规范

### 格式
```
<类型>(<范围>): <描述>

[可选的正文]

[可选的脚注]
```

### 类型说明
- **feat**: 新功能
- **fix**: Bug修复
- **docs**: 文档更新
- **style**: 代码格式调整
- **refactor**: 代码重构
- **perf**: 性能优化
- **test**: 测试相关
- **chore**: 构建过程或辅助工具变动

### 示例
```
feat(hotel-search): 添加智能推荐功能

实现了基于用户偏好的酒店推荐算法，
支持按价格、距离、评分等多个维度排序。

Closes #123
```

## 🚨 紧急修复流程

当生产环境出现紧急问题时：

```bash
# 从main分支创建hotfix分支
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug-v1.2.1

# 修复问题并提交
git commit -m "fix: 修复关键崩溃问题"

# 合并到main和develop
git checkout main
git merge --no-ff hotfix/critical-bug-v1.2.1
git tag -a v1.2.1 -m "Hotfix v1.2.1"

git checkout develop
git merge --no-ff hotfix/critical-bug-v1.2.1

# 清理分支
git branch -d hotfix/critical-bug-v1.2.1
```

## 📊 版本追踪

每个版本应包含：
- 版本变更日志
- 已知问题列表
- 升级指南
- 兼容性说明