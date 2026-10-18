# DualWeb R619AC 128M

基于 DualWeb 项目，为 P&W R619AC 128M（`p2w_r619ac-128m`）独立构建 ImmortalWrt 24.10 固件。

## 构建原则

- 固定 ImmortalWrt `openwrt-24.10` 分支，不混用 25.12 的内核文件路径。
- 构建前验证设备 profile、配置结果和 TLS 后端选择。
- 使用 OpenSSL 版 ustream TLS 后端；不同时启用 mbedTLS 版 ustream，避免后端冲突。
- 固件必须包含 R619AC 128M 的 factory 和 sysupgrade 镜像，否则工作流失败。
- DualWeb 的 UI/API/overlay 从上游项目获取，Go API 按 ARMv7 编译。

## 使用

GitHub → Actions → **Build DualWeb R619AC 128M (ImmortalWrt 24.10)** → Run workflow。

固件及 SHA256 校验文件保存在 Actions Artifacts 中，保留 14 天。

> 首次构建用于验证工具链、设备 profile 和包依赖。若失败，请查看 Actions 中最先出现的实际编译错误，而不是只看最后的 make 退出码。
