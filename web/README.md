# DualWeb + Zashboard 集成

这些文件由 `.github/workflows/build.yml` 在构建时覆盖到 DualWeb overlay，不需要直接修改上游 DualWeb 仓库。

## 入口与工作方式

- DualWeb 首页：`http://192.168.5.254/`
- 登录后点击“OpenClash 代理面板”，Zashboard 将内嵌显示。
- Zashboard 静态文件：`/www/dualweb/zashboard/`
- Clash API 同源代理：`/clash/` -> `127.0.0.1:9090`
- LuCI 继续使用 TCP/8080。

## 首次连接

1. 确认 OpenClash 已启动，Mihomo Clash API 在本机 9090 端口监听。
2. 进入 Zashboard 的连接设置，API 地址为当前路由器地址的 `http://主机IP:80/clash`，Secret 填 OpenClash 当前配置的 `secret`。
3. 不要把密钥写进 URL、HTML 或 GitHub。
4. 不要将 9090 端口直接开放到 WAN。Nginx 的 `/clash/` 仅允许 `192.168.5.0/24` 来源访问。
5. 若 OpenClash API 端口不是 9090，请同步修改 `web/dualweb-nginx.conf` 的 upstream。

## 独立更新 Zashboard

SSH 登录路由器后执行：

```sh
/usr/sbin/dualweb-update-zashboard
```

脚本从官方 Release 下载并校验 ZIP，采用目录切换方式更新，不需要重编译或刷写固件；若 Nginx 配置检查失败会恢复旧面板。确认新版本工作正常后，可手动删除 `/www/dualweb/zashboard.previous`。
