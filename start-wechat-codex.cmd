@echo off
setlocal
set WECHAT_ACP_TELEMETRY=0
set CODEX_PATH=C:\Users\Administrator\AppData\Local\OpenAI\Codex\bin\110b3d66a02d864e\codex.exe
set BRIDGE_DIR=C:\Users\Administrator\Documents\Codex\wechat-codex-bridge
set NODE_BIN=C:\Users\Administrator\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe
set NODE_PATH=%BRIDGE_DIR%\node_modules\.pnpm\wechat-acp@0.8.0_zod@4.4.3\node_modules\wechat-acp\node_modules;%BRIDGE_DIR%\node_modules\.pnpm\wechat-acp@0.8.0_zod@4.4.3\node_modules;%BRIDGE_DIR%\node_modules\.pnpm\node_modules
"%NODE_BIN%" "%BRIDGE_DIR%\node_modules\.pnpm\wechat-acp@0.8.0_zod@4.4.3\node_modules\wechat-acp\dist\bin\wechat-acp.js" --config "%BRIDGE_DIR%\bridge-config.json" --instance codex-main --cwd "C:\Users\Administrator\Documents\Codex" --agent codex-local --daemon --idle-timeout 0
