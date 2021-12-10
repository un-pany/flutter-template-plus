Flutter 脚手架

## 依赖包

`flutter packages get` 或 `flutter pub get`

## 分析代码

`flutter analyze`

## 运行项目

`flutter run`

## 如果遇到着色器渲染错误（Shader compilation error），可以运行 clean 后再 run

`flutter clean`

## 安卓真机调试
`flutter devices`
`flutter run`

## 安卓打包
`flutter build apk`

## 开发环境

1. Flutter version 2.5.3
2. Dart version 2.14.4
3. Android SDK version 31.0.0

## Git 提交规范

- `feat` 增加新功能
- `fix` 修复问题/BUG
- `style` 代码风格相关无影响运行结果的
- `perf` 优化/性能提升
- `refactor` 重构
- `revert` 撤销修改
- `test` 测试相关
- `docs` 文档/注释
- `chore` 依赖更新/脚手架配置修改等
- `workflow` 工作流改进
- `ci` 持续集成
- `types` 类型定义文件更改
- `wip` 开发中
- `mod` 不确定分类的修改

## 关于 JSON 转 Dart Model 类

1. 纯手写实体类（不推荐）
2. 用网页自动生成工具：根据 JSON 自动生成实体类，并 copy 到项目中（所有项目都通用）
3. 使用插件 json_serializable（更适合大型项目）

该脚手架采用第二种方案

PS: JSON <——> Map <——> Dart Model 三者之间的转化是常用的技巧
