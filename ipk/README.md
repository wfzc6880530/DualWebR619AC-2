# DualWeb 可选端口 IPK（实验版）

> **实验分支：** `experiment/dualweb-port-ipk-24.10`  
> **目标：** P&W R619AC 128M / ImmortalWrt 24.10 / ARMv7  
> **状态：** 首次构建验证版，不是稳定发行版；未在实体路由器上验证。

## 设计说明

- 包含 DualWeb 静态页面、ARMv7 API 和 Zashboard 静态文件。
- 安装时若存在可交互终端，会提示输入端口；默认使用 **8081**。
- 不自动更改 LuCI/uhttpd 的监听端口，避免误改系统管理入口。
- 安装后可通过 `dualweb-port 8081` 修改端口，例如 `dualweb-port 8888`。
- API 服务由 procd 管理；Nginx 配置会在修改端口后执行 `nginx -t` 检查。
- IPK 构建产物通过 GitHub Actions Artifacts 提供，保留 14 天。

## 安装

先从 Actions 下载 `dualweb-port-ipk-immortalwrt-24.10-armv7` artifact 并解压，再在路由器上执行：

```sh
opkg install ./dualweb-port_0.1.0_arm_cortex-a7_neon-vfpv4.ipk
```

默认访问：`http://路由器LAN地址:8081/`

## 修改端口

```sh
dualweb-port 8888
```

## 注意

1. 此包面向 ImmortalWrt 24.10 的 ARMv7 R619AC 构建，不承诺兼容 ImmortalWrt 25.12。
2. 端口选择只控制 DualWeb Nginx 监听端口，不会把 OpenClash API 的 9090 端口暴露到 WAN。
3. 若已有服务占用目标端口，先换用其他端口。安装前请备份配置。
4. 本次只编译 IPK，不刷写固件，不修改 `main` 分支。
