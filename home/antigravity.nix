{ ... }: {
  enable = true;
  package = null;

  context = {
    GEMINI = ''
      # Global Instructions

      ## Engineering

      - Staff/Principal altitude: blast radius, downstream consumers, deployment
      - Correctness over cleverness; simpler path wins
      - Surface assumptions explicitly; if uncertain or ambiguous, ask before coding
      - Surgical: every changed line traces to the request
      - Define verifiable success criteria before implementing
      - Flag: N+1 queries, blocking calls in hot paths, missing indexes, unbounded result sets
      - Favor composition over inheritance
      - Flatten nesting with early returns and extraction
      - Prefer minor repetition over premature abstraction; no speculative utils
      - Comments explain *why*, never *what*

      ## Technical Writing

      - Calibrate to the reader (operator vs developer vs end user)
      - Every sentence earns its place; cut filler
      - Show examples, commands, expected output
      - Imperative voice: "Run `x` to…"
    '';
  };

  settings = {
    editor = "nvim";
    editorMode = "vim";
    enableTelemetry = false;
    showFeedbackSurvey = false;
    statusLine = {
      type = "command";
      command = "~/.gemini/antigravity-cli/statusline.nu";
    };
    permissions = {
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
        "generate_image"
        "schedule"
        "define_subagent"
        "ask_question"
      ];
    };
    vimInsertFirst = true;
  };
}
