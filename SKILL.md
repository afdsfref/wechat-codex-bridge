---
name: wechat-codex-bridge
description: Set up, start, link (QR login), relink, or troubleshoot the WeChat-to-Codex bridge daemon so the user can chat with Codex through WeChat.
---

# Wechat Codex Bridge

Run and maintain the `wechat-acp` daemon that bridges a WeChat channel to a local Codex instance. The channel is already linked when a valid saved token exists; do not force a new QR login unless the user asks or the token is missing.

## Architecture

- `start-wechat-codex.cmd` launches the daemon with `--instance codex-main` and `--agent codex-local`.
- `bridge-config.json` maps `codex-local` to the local Codex ACP adapter.
- `watchdog.ps1` restarts the daemon when `daemon.pid` is stale; schedule it or run it periodically.
- `package.json` and `pnpm-lock.yaml` pin `wechat-acp` (WeChat side) and `@agentclientprotocol/codex-acp` (Codex side).
- Runtime state lives under `%USERPROFILE%\.wechat-acp\instances\codex-main\`:
  - `token.json` - valid WeChat login; presence means the channel is linked.
  - `daemon.pid` - live daemon PID.
  - `wechat-acp.log` - daemon and conversation logs.
  - `state.json` - linked users with `lastSeenAt`.

## This Machine

The live bridge on this machine is at:

```text
C:\Users\Administrator\Documents\Codex\wechat-codex-bridge
```

Runtime paths already embedded in the scripts:

```text
Node:   C:\Users\Administrator\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe
Codex:  C:\Users\Administrator\AppData\Local\OpenAI\Codex\bin\110b3d66a02d864e\codex.exe
```

On another machine, edit `NODE_BIN`, `CODEX_PATH`, and `BRIDGE_DIR` in `start-wechat-codex.cmd`, plus the paths in `bridge-config.json`.

## Operations

### Check whether it is linked

1. Read `daemon.pid` and verify the process is alive with `Get-Process`.
2. Confirm `token.json` exists. If it does, the channel is already logged in and no QR scan is needed.
3. Tail `wechat-acp.log` and check `state.json` for recent user activity.

### Link or relink

1. If a saved token exists and the user simply asks to connect, report that it is already linked and show the recent log activity.
2. Force a fresh login only when the user explicitly wants to switch accounts or the token is missing: add `--login` to the daemon command and send the fresh login URL/QR to the user. The QR expires in about 5 minutes.
3. After scanning, confirm `token.json` appears, `daemon.pid` is alive, and the log stops showing login timeouts.

### Start or restart

Start hidden from a terminal or another agent:

```powershell
Start-Process -FilePath "C:\Users\Administrator\Documents\Codex\wechat-codex-bridge\start-wechat-codex.cmd" -WindowStyle Hidden
```

Or run `watchdog.ps1`, which starts the bridge only when it is dead.

### Troubleshooting

- `Login timeout (5 minutes)`: an old QR expired; start with `--login` to produce a new one.
- `Loaded saved token`: already linked; do not force re-login.
- Watchdog reports `bridge restarted`: the daemon died and was restarted; inspect `wechat-acp.log` for the fatal error.
- A single failed agent tool call does not mean the link is broken; the channel stays healthy while the process is up and the token exists.
