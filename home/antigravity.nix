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
        "read_file(/Users/stelo/iso/notes/)"
        "unsandboxed(gh pr diff)"
        "unsandboxed(gh pr view)"
        "unsandboxed(gh pr list)"
        "unsandboxed(gh pr checks)"
        "unsandboxed(gh pr status)"
        "unsandboxed(gh issue view)"
        "unsandboxed(gh issue list)"
        "unsandboxed(gh repo view)"
        "unsandboxed(gh run list)"
        "unsandboxed(gh run view)"
        "unsandboxed(gh workflow list)"
        "unsandboxed(gh workflow view)"
        "unsandboxed(gh release list)"
        "unsandboxed(gh release view)"
        "unsandboxed(gh search)"
        "unsandboxed(gh api)"
        "unsandboxed(git status)"
        "unsandboxed(git diff)"
        "unsandboxed(ls)"
        "unsandboxed(echo)"
      ];
    };
    vimInsertFirst = true;
  };
}
