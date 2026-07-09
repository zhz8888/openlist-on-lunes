const { spawn } = require("child_process");

// ============================================================
// 进程管理 — 定义需要守护的子进程列表
// ============================================================
const apps = [
  {
    name: "xy",
    binaryPath: "/home/container/xy/xy",
    args: ["-c", "/home/container/xy/config.json"]
  },
  {
    name: "h2",
    binaryPath: "/home/container/h2/h2",
    args: ["server", "-c", "/home/container/h2/config.yaml"]
  },
  {
    name: "komari-agent",
    binaryPath: "/home/container/komari/agent",
    args: ["-e", "http://localhost:9182", "-t", "default"]
  }
];

/**
 * 启动并守护单个子进程
 * - 使用 spawn 创建子进程，继承父进程的标准输入/输出
 * - 监听 exit 事件，进程退出后自动重启（3 秒延迟）
 */
function runProcess(app) {
  const child = spawn(app.binaryPath, app.args, { stdio: "inherit" });

  child.on("exit", (code) => {
    console.log(`[EXIT] ${app.name} exited with code: ${code}`);
    console.log(`[RESTART] Restarting ${app.name}...`);
    setTimeout(() => runProcess(app), 3000); // 3 秒后重启
  });
}

/**
 * 主程序入口
 * 遍历所有子进程配置并启动守护
 */
function main() {
  try {
    for (const app of apps) {
      runProcess(app);
    }
  } catch (err) {
    console.error("[ERROR] Startup failed:", err);
    process.exit(1);
  }
}

main();
