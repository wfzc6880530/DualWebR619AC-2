# DualWeb R619AC 128M

基于 DualWeb 上游项目，为 P&W R619AC 128M（`p2w_r619ac-128m`）构建 ImmortalWrt 24.10 固件。

## 构建原则

- 底层源码固定使用 ImmortalWrt `openwrt-24.10`，不混用 25.12 的内核或软件包路径。
- 保留 ImmortalWrt 24.10 源码自带的 `feeds.conf.default`，不在本仓库维护或覆盖另一份 feeds 配置。
- 完整源码编译需要准备 feeds：执行 `./scripts/feeds update -a`，并安装 LuCI、packages、routing feeds 中的包索引；具体 feed 地址和分支以 ImmortalWrt 24.10 上游文件为准。
- DualWeb 上游当前的 `build.sh` 使用 ImageBuilder，并没有执行 `scripts/feeds update/install`；本仓库因为需要为 R619AC 从源码构建固件，才保留源码编译所需的 feeds 步骤，不复制上游不存在的 feeds 配置。
- 构建前验证设备 profile 和 TLS 后端选择，避免同时选择多个 `libustream` TLS 后端。
- 固件必须包含 R619AC 128M 的 factory 和 sysupgrade 镜像，否则工作流失败。
- DualWeb 的 UI/API/overlay 从上游项目获取，Go API 按 ARMv7 编译。

## 使用

GitHub → Actions → **Build DualWeb R619AC 128M (ImmortalWrt 24.10)** → Run workflow。

固件及 SHA256 校验文件保存在 Actions Artifacts 中，保留 14 天。

> 首次构建用于验证工具链、设备 profile 和包依赖。若失败，请查看 Actions 中最先出现的实际错误，而不是只看最后的 make 退出码。
