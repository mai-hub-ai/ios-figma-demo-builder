# 贡献指南

感谢您对HotelBookingDemo项目的关注！我们欢迎各种形式的贡献。

## 🎯 贡献方式

### 代码贡献
1. Fork项目到您的GitHub账户
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

### 问题报告
- 使用GitHub Issues报告bug
- 请提供详细的复现步骤
- 包含环境信息（iOS版本、设备型号等）

### 功能建议
- 在Issues中提出新功能建议
- 描述功能的价值和使用场景
- 欢迎提供设计思路

## 📝 开发规范

### 代码风格
- 遵循Swift官方编码规范
- 使用SwiftLint进行代码检查
- 保持代码简洁易读

### 提交信息
遵循[Conventional Commits](https://www.conventionalcommits.org/)规范：
```
feat: 新功能
fix: Bug修复
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建过程或辅助工具变动
```

### 分支命名
- `feature/功能名称` - 新功能开发
- `bugfix/问题描述` - Bug修复
- `hotfix/紧急修复` - 紧急修复
- `refactor/重构内容` - 代码重构

## 🧪 测试要求

### 单元测试
- 新增功能必须包含相应的单元测试
- 保持测试覆盖率不低于80%
- 测试代码应具有良好的可读性

### 集成测试
- 涉及多个模块的功能需要集成测试
- UI组件需要进行界面测试

## 🔄 Pull Request流程

1. **代码审查**
   - 至少需要一名团队成员审查
   - 通过所有自动化检查
   - 解决所有审查意见

2. **质量检查**
   - SwiftLint检查通过
   - 所有测试用例通过
   - 代码覆盖率达标

3. **合并条件**
   - PR描述清晰完整
   - 相关文档已更新
   - 符合项目架构设计

## 📚 学习资源

- [Swift官方文档](https://docs.swift.org/)
- [iOS开发指南](https://developer.apple.com/documentation/)
- [项目架构文档](./Documentation/ARCHITECTURE_NOTES.md)

## 💬 社区交流

- 加入我们的[Discussions](../../discussions)
- 关注项目[Twitter](https://twitter.com/project)
- 阅读我们的[博客](https://blog.project.com)

## 📄 许可证

本项目采用MIT许可证，详情请查看[LICENSE](LICENSE)文件。

---

再次感谢您的贡献！让我们一起打造更好的酒店预订体验。✨