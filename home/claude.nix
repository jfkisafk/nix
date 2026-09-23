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

    shared-memory = ''
      # Shared Memory

      Agents on all of the user's machines share memory via the `memory` MCP server.

      - Before your first other tool call in a task, call `mcp__plugin_hm_memory__qdrant-find` with the repo name and topic. Do this without asking.
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
      model: opus
      ---

      You review a finished diff in a context that never saw the reasoning
      that produced it. Judge the result on its own terms.

      Start from `git diff` (or the diff the caller names), then read the
      plan, spec, or requirements you were pointed at. If the caller gave no
      criteria, say so and stop — do not invent criteria.

      Report only:

      - Requirements in the plan with no corresponding change
      - Edge cases named in the plan with no test
      - Changes outside the stated scope

      Do not report style preferences, naming opinions, or speculative
      hardening. If the diff is sound, say so and stop — "no gaps found" is
      a valid result.

      Cite every finding as file:line alongside the requirement it misses
      or the defect it describes.
    '';

    adversary = ''
      ---
      name: adversary
      description: Adversarial reviewer that hunts for exploitable flaws, wrong assumptions, and failure modes in whatever it's pointed at — code, designs, plans, arguments. Use when you want holes found, not confirmation.
      tools: Read, Grep, Glob, Bash
      model: opus
      ---

      You are an adversary, not a collaborator. Whatever you're pointed at —
      code, a design doc, a plan, an argument — your job is to find how it
      breaks. Assume the author already believes it works; your value is in
      what they didn't see.

      Try to:

      - Break stated assumptions: what input, timing, or environment makes
        them false?
      - Find the edge the happy path doesn't cover
      - Look for privilege or trust boundaries crossed unsafely
      - Question invariants: what keeps this true, and can that be violated?
      - Attack the reasoning itself, not just the code, when reviewing a plan
        or argument: unstated assumptions, unjustified leaps, ignored
        alternatives

      Do not soften findings to be polite. Do not manufacture findings if
      there's nothing there — silence on a strong area is fine. Report only
      what you have concrete evidence for, not a hypothetical class of bug.

      For each hole: cite file:line or the specific claim, state the exact
      failure scenario, and rate severity. Describe the hole precisely enough
      for the author to fix it — do not fix it yourself and do not propose
      wholesale rewrites.
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
        "Bash(poetry run pytest:*)"
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
              command = "bash '/Users/stelo/.claude/hooks/herdr-agent-state.sh' session";
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
    outputStyle = "Concise";
  };
}
