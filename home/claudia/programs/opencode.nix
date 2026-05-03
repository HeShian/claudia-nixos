# =============================================================================
# 文件名:   home/opencode.nix
# 功能描述: OpenCode AI 编码助手配置
# 说明:     配置 OpenCode 全局设置、oh-my-openagent 插件和 MCP 服务器
#           - nixos-mcp：通过 uvx 运行，提供 NixOS 系统管理能力
#           - oh-my-openagent：OpenCode 插件系统，提供专业子 agent
# =============================================================================
{ config, pkgs, ... }:

let
  # OpenCode 全局配置文件
  opencodeConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = "anthropic/claude-sonnet-4-6";
    plugin = [ "oh-my-openagent@latest" ];
    mcp = {
      nixos = {
        type = "local";
        command = [
          "uvx"                  # 使用 uvx 运行（通过 uv 安装的 Python 工具）
          "mcp-nixos"            # NixOS MCP 服务器包名（PyPI: mcp-nixos）
        ];
        enabled = true;
      };
    };
    permission = {
      bash = "allow";
      edit = "allow";
      read = "allow";
      write = "allow";
      grep = "allow";
      glob = "allow";
    };
    autoupdate = true;
  };

  # oh-my-openagent 插件配置文件
  # 为不同场景配置专用的子 agent，使用 gpt-5-nano 作为轻量辅助模型
  ohMyOpenagentConfig = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json";
    # =========================================================================
    # 专业子 agent：每个 agent 有特定职责领域
    # =========================================================================
    agents = {
      hephaestus.model = "opencode/gpt-5-nano";       # 代码生成与实现
      oracle.model = "opencode/gpt-5-nano";            # 代码审查与建议
      librarian.model = "opencode/gpt-5-nano";         # 文档与知识检索
      explore.model = "opencode/gpt-5-nano";           # 代码库探索
      multimodal-looker.model = "opencode/gpt-5-nano"; # 多模态内容分析
      prometheus.model = "opencode/gpt-5-nano";        # 测试与质量保证
      metis.model = "opencode/gpt-5-nano";             # 架构与设计
      momus.model = "opencode/gpt-5-nano";             # 代码质量与规范
      atlas.model = "opencode/gpt-5-nano";             # 项目管理
      sisyphus-junior.model = "deepseek/deepseek-chat";   # 重复任务自动化
    };
    # =========================================================================
    # 分类模型：不同复杂度/领域的任务使用不同配置
    # =========================================================================
    categories = {
      visual-engineering.model = "opencode/gpt-5-nano";  # 视觉/UI 工程
      ultrabrain.model = "opencode/gpt-5-nano";          # 复杂推理
      deep.model = "opencode/gpt-5-nano";                # 深度分析
      artistry.model = "opencode/gpt-5-nano";            # 创意设计
      quick.model = "opencode/gpt-5-nano";               # 快速简单任务
      unspecified-low.model = "opencode/gpt-5-nano";     # 低复杂度通用
      unspecified-high.model = "opencode/gpt-5-nano";    # 高复杂度通用
      writing.model = "opencode/gpt-5-nano";             # 文档与写作
    };
  };
in
{
  # --- 安装 OpenCode ---
  home.packages = with pkgs; [
    opencode
  ];

  # --- OpenCode 配置文件 ---
  # 注意：OpenCode 的配置目录是 ~/.opencode/（非 XDG 标准的 ~/.config/opencode/）
  # 因此使用 home.file 直接写入
  #
  # 由 home-manager 管理的文件（可复现）：
  #   opencode.json          → 主配置（模型、MCP、插件列表、权限）
  #   oh-my-openagent.json   → 子 agent 模型配置
  #   .gitignore             → 忽略 node_modules 等自动生成文件
  #
  # 由 OpenCode 自动生成的文件（无需管理，首次启动自动重建）：
  #   node_modules/          → npm 插件包（由 plugin 列表自动安装）
  #   package.json           → npm 依赖声明（opencode 内部管理）
  #   package-lock.json      → npm 锁文件（opencode 内部管理）
  home.file = {
    ".opencode/opencode.json" = {
      text = opencodeConfig;
      force = true;
    };
    ".opencode/oh-my-openagent.json" = {
      text = ohMyOpenagentConfig;
      force = true;
    };
    ".opencode/.gitignore" = {
      text = ''
        node_modules
        package.json
        package-lock.json
        bun.lock
        .gitignore
      '';
      force = true;
    };
  };
}
