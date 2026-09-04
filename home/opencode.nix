{ ... }: {
  enable = true;
  package = null;

  context = ''
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

    # Technical Writing

    - Calibrate to the reader (operator vs developer vs end user)
    - Every sentence earns its place; cut filler
    - Show examples, commands, expected output
    - Imperative voice: "Run `x` to…"
  '';

  settings = {
    model = "anthropic/claude-sonnet-4-5";
    autoupdate = false;

    permission = {
      edit = "ask";
      webfetch = "ask";
      bash = {
        "gh pr diff*" = "allow";
        "gh pr view*" = "allow";
        "gh pr list*" = "allow";
        "gh pr checks*" = "allow";
        "gh pr status*" = "allow";
        "gh issue view*" = "allow";
        "gh issue list*" = "allow";
        "gh repo view*" = "allow";
        "gh run list*" = "allow";
        "gh run view*" = "allow";
        "gh workflow list*" = "allow";
        "gh workflow view*" = "allow";
        "gh release list*" = "allow";
        "gh release view*" = "allow";
        "gh search*" = "allow";
        "gh api*" = "allow";
        "*" = "ask";
      };
    };
  };

  tui = {
    theme = "rose-pine";
  };

  themes = {
    rose-pine = {
      defs = {
        base = "#191724";
        surface = "#1f1d2e";
        overlay = "#26233a";
        muted = "#6e6a86";
        subtle = "#908caa";
        text = "#e0def4";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ea9a97";
        pine = "#3e8fb0";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
        highlightLow = "#21202e";
        highlightMed = "#403d52";
        highlightHigh = "#524f67";
      };

      theme = {
        primary = "iris";
        secondary = "foam";
        accent = "pine";
        error = "love";
        warning = "gold";
        success = "foam";
        info = "pine";
        text = "text";
        textMuted = "muted";
        selectedListItemText = "text";
        background = "base";
        backgroundPanel = "surface";
        backgroundElement = "overlay";
        border = "muted";
        borderActive = "iris";
        borderSubtle = "highlightLow";

        diffAdded = "foam";
        diffRemoved = "love";
        diffContext = "muted";
        diffHunkHeader = "subtle";
        diffHighlightAdded = "pine";
        diffHighlightRemoved = "rose";
        diffAddedBg = "highlightLow";
        diffRemovedBg = "highlightLow";
        diffContextBg = "base";
        diffLineNumber = "muted";
        diffAddedLineNumberBg = "highlightLow";
        diffRemovedLineNumberBg = "highlightLow";

        markdownText = "text";
        markdownHeading = "iris";
        markdownLink = "iris";
        markdownLinkText = "foam";
        markdownCode = "gold";
        markdownBlockQuote = "subtle";
        markdownEmph = "rose";
        markdownStrong = "love";
        markdownHorizontalRule = "highlightMed";
        markdownListItem = "iris";
        markdownListEnumeration = "iris";
        markdownImage = "pine";
        markdownImageText = "foam";
        markdownCodeBlock = "surface";

        syntaxComment = "muted";
        syntaxKeyword = "pine";
        syntaxFunction = "rose";
        syntaxVariable = "text";
        syntaxString = "gold";
        syntaxNumber = "rose";
        syntaxType = "foam";
        syntaxOperator = "subtle";
        syntaxPunctuation = "subtle";
      };
    };
  };
}
