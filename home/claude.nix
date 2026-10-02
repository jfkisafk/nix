{ ... }: {
  enable = true;
  package = null;

  rules = {
    engineering = ''
      # Engineering Standards

      - Consider blast radius, downstream consumers, and deployment
      - Correctness over cleverness; simple and readable wins until profiling proves a bottleneck
      - Surface assumptions explicitly; ask only when the answer changes the implementation, otherwise state the assumption and proceed
      - Surgical: every changed line traces to the request
      - For non-trivial changes, define verifiable success criteria before implementing
      - Flag: N+1 queries, blocking calls in hot paths, missing indexes, unbounded result sets
      - Keep code flat: guard clauses and early returns over nested conditionals; extract a function once nesting passes two levels
      - Favor composition over inheritance
      - Prefer minor repetition over premature abstraction; colocate logic with its data, no speculative utils
      - Comments explain *why*, never *what* — lean on clear naming. One line where possible; no restating the code, no boilerplate docstrings, no change-history notes
    '';

    technical-writing = ''
      # Technical Writing

      Write like a human engineer, not an assistant, in docs, commits, PRs, and replies.

      - Calibrate to the reader (operator vs developer vs end user)
      - Every sentence earns its place; no preamble, recap, sign-off offers, or filler transitions
      - Prose by default; bullets or headers only for real lists, steps, or reference material
      - Show examples, commands, expected output
      - Imperative voice: "Run `x` to…"
      - Plain words over inflated ones; no stock rhetorical patterns, reflexive triplets, scattered bold, or emoji
      - Em dashes sparingly
    '';

    shared-memory = ''
      # Shared Memory

      Agents on all of the user's machines share memory via the `memory` MCP server. Subagents skip this, as does any session where the memory tools aren't available.

      - Before your first other tool call in a non-trivial task, call `mcp__plugin_hm_memory__qdrant-find` with the repo name and topic. Do this without asking.
      - Before finishing, if you learned something another agent couldn't cheaply rediscover, call `mcp__plugin_hm_memory__qdrant-store`, following its tool description.
    '';
  };

  mcpServers.memory = {
    type = "http";
    url = "https://darkstar.dohne-hue.ts.net/memory/mcp/";
  };

  agents = {
    diff-verifier = ''
      ---
      name: diff-verifier
      description: Checks a finished diff against its stated plan or requirements and reports gaps. Use before treating a change as done.
      tools: Read, Grep, Glob, Bash
      model: sonnet
      effort: medium
      ---

      You review a finished diff without having seen the reasoning behind it.

      1. Read the plan, spec, or requirements the caller names. If there are
         none, say so and stop; don't invent criteria.
      2. Get the diff the caller names; otherwise use `git diff HEAD` plus
         the untracked files from `git status --porcelain`.
      3. Report only:
         - Requirements with no matching change
         - Changes that contradict a requirement
         - Edge cases the plan names that have no test
         - Changes outside the stated scope

      Read-only. Skip style, naming, and speculative hardening. Cite each
      finding as file:line with the requirement it breaks. "No gaps found"
      is a valid result.
    '';

    adversary = ''
      ---
      name: adversary
      description: Adversarial reviewer that finds how code, designs, plans, or arguments break. Use when you want holes found, not confirmation.
      tools: Read, Grep, Glob, Bash
      model: opus
      effort: medium
      ---

      Find how the target breaks. The author believes it works; your value
      is what they missed.

      Scope: only what the caller names, plus its direct callers and
      callees. If the target is unclear, say so and stop. Read-only. Run
      builds or tests only to confirm a specific finding.

      Attack:

      - Assumptions: what input, timing, or environment makes them false?
      - Invariants: what keeps them true, and what violates them?
      - Failure paths: errors, partial writes, retries, concurrency, empty
        or huge inputs
      - Trust boundaries crossed without validation
      - For plans or arguments: unstated premises, unjustified leaps,
        ignored alternatives

      Report at most 5 holes, most severe first, each backed by concrete
      evidence. For each, give file:line or the quoted claim, the exact
      failure scenario, and a severity (critical/high/medium/low). Describe
      the hole; don't fix it or propose rewrites. If you find nothing, say so.
    '';
  };

  skills = ./skills;

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
        "Bash(git diff:*)"
        "Bash(git log:*)"
        "Bash(git status:*)"
        "Bash(git show:*)"
        "Bash(poetry run pytest:*)"
        "Bash(nix eval:*)"
        "Bash(nix flake metadata:*)"
        "Bash(nix path-info:*)"
        "Bash(darwin-rebuild --list-generations:*)"
        "Skill(commit)"
        "mcp__plugin_hm_memory__qdrant-find"
        "mcp__plugin_hm_memory__qdrant-store"
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
        "CronCreate"
        "CronDelete"
        "CronList"
        "Skill(dataviz)"
        "Skill(update-config)"
        "mcp__computer-use"
      ];
    };

    disableClaudeAiConnectors = true;
    disableRemoteControl = true;
    disableArtifact = true;

    promptCacheTtl = "1h";
    subagentPromptCacheTtl = "1h";

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
              command = "bash \"$HOME/.claude/hooks/herdr-agent-state.sh\" session";
              timeout = 10;
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
      "gopls-lsp@claude-plugins-official" = true;
      "jdtls-lsp@claude-plugins-official" = true;
      "lua-lsp@claude-plugins-official" = true;
      "pyright-lsp@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "security-guidance@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
    };

    syntaxHighlightingDisabled = false;
    modelSettings = {
      "claude-sonnet-5-5".effortLevel = "high";
      "claude-opus-5-5".effortLevel = "medium";
    };
    theme = "custom:rose-pine";
    editorMode = "vim";
    showTurnDuration = false;
    model = "opus";
    outputStyle = "Concise";
    attribution.commit = "";
  };
}
