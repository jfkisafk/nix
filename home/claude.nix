{ ... }: {
  enable = true;
  package = null;

  rules = {
    engineering = ''
      # Engineering Standards

      - Staff/Principal altitude: blast radius, downstream consumers, deployment
      - Correctness over cleverness; simpler path wins
      - Surface assumptions explicitly; if uncertain or ambiguous, ask before coding
      - Surgical: every changed line traces to the request
      - Define verifiable success criteria before implementing
      - Flag: N+1 queries, blocking calls in hot paths, missing indexes, unbounded result sets
      - Favor composition over inheritance
      - Flatten nesting with early returns and extraction
      - Prefer minor repetition over premature abstraction; colocate logic with its data, no speculative utils
      - Comments explain *why*, never *what* — lean on clear naming
      - Optimize for readability until profiling proves a bottleneck
    '';

    technical-writing = ''
      # Technical Writing

      - Calibrate to the reader (operator vs developer vs end user)
      - Every sentence earns its place; cut filler
      - Show examples, commands, expected output
      - Imperative voice: "Run `x` to…"
    '';
  };

  settings = {
    permissions = {
      defaultMode = "default";
      allow = [
        "Bash(gh pr diff:*)"
        "Bash(gh pr view:*)"
        "Bash(gh pr list:*)"
        "Bash(gh pr checks:*)"
        "Bash(gh pr status:*)"
        "Bash(gh issue view:*)"
        "Bash(gh issue list:*)"
        "Bash(gh repo view:*)"
        "Bash(gh run list:*)"
        "Bash(gh run view:*)"
        "Bash(gh workflow list:*)"
        "Bash(gh workflow view:*)"
        "Bash(gh release list:*)"
        "Bash(gh release view:*)"
        "Bash(gh search:*)"
        "Bash(gh api:*)"
      ];
      deny = [
        "EnterPlanMode"
        "ExitPlanMode"
        "DesignSync"
        "NotebookEdit"
        "SendMessage"
        "PushNotification"
        "RemoteTrigger"
        "ReportFindings"
        "ScheduleWakeup"
        "AskUserQuestion"
        "CronCreate"
        "CronDelete"
        "CronList"
        "Skill(dataviz)"
        "Skill(update-config)"
      ];
    };

    disableClaudeAiConnectors = true;
    disableRemoteControl = true;
    disableArtifact = true;

    hooks = {
      PostToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "atuin hook claude-code";
            }
          ];
        }
      ];
      PostToolUseFailure = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "atuin hook claude-code";
            }
          ];
        }
      ];
      PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "atuin hook claude-code";
            }
          ];
        }
      ];
      SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "bash '/Users/stelo/.claude/hooks/herdr-agent-state.sh' session";
              timeout = 10;
            }
          ];
        }
        {
          hooks = [
            {
              type = "command";
              command = "printf '%s' '{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"MCP SERVERS ARE DORMANT BY DEFAULT: Do NOT call any mcp__azure__*, mcp__github__*, or mcp__atlassian__* tools unless the user explicitly asks to use them or names a specific service (Azure, GitHub, Jira, Confluence, etc.). Invoking MCP tools unprompted wastes tokens. Wait for clear user intent before using any MCP tool.\"}}'";
            }
          ];
        }
      ];
    };

    statusLine = {
      type = "command";
      command = "~/.claude/claude-statusline.nu";
    };

    enabledPlugins = {
      "code-review@claude-plugins-official" = true;
      "code-simplifier@claude-plugins-official" = true;
      "csharp-lsp@claude-plugins-official" = true;
      "github@claude-plugins-official" = true;
      "gopls-lsp@claude-plugins-official" = true;
      "jdtls-lsp@claude-plugins-official" = true;
      "lua-lsp@claude-plugins-official" = true;
      "pyright-lsp@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "security-guidance@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
    };

    syntaxHighlightingDisabled = false;
    effortLevel = "high";
    theme = "custom:rose-pine";
    editorMode = "vim";
    showTurnDuration = false;
    model = "sonnet";
  };
}
