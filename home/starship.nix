{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = true;

  settings = {
    add_newline = true;
    command_timeout = 10000;

    format = ''[  ](bg:#1d2230 fg:#a0a9cb)[](bg:#4942e4 fg:#1d2230)$directory[](fg:#4942e4 bg:#394260)$git_branch$git_status[](fg:#394260 bg:#212736)$nodejs$rust$golang$java$python$ruby$scala$zig$docker_context$lua$elixir$swift$conda$dart[](fg:#212736 bg:#191825)$aws[](fg:#191825)$character'';

    character = {
      success_symbol = "[❯](bold fg:#769ff0)";
      error_symbol = "[❯](bold fg:#ff5353)";
    };

    directory = {
      style = "fg:#e3e5e5 bg:#4942e4";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "";
      read_only = " 󰌾";
    };

    directory.substitutions = {
      "Downloads" = " ";
      "Music" = " ";
      "Pictures" = " ";
    };

    java = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    git_branch = {
      symbol = "";
      style = "bg:#394260";
      format = "[ $symbol $branch ](fg:#dde8ff bg:#394260)";
    };

    git_status = {
      style = "bg:#394260";
      format = "[($all_status$ahead_behind )](fg:#dde8ff bg:#394260)";
    };

    nodejs = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    rust = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    lua = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    python = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    ruby = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    golang = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    swift = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    zig = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    scala = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    aws = {
      format = "[ $symbol$profile ]($style)";
      style = "fg:#ff6d60 bg:#191825";
      symbol = " ";
    };

    elixir = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    conda = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    dart = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($version) ](fg:#769ff0 bg:#212736)";
    };

    docker_context = {
      symbol = "";
      style = "bg:#212736";
      format = "[ $symbol ($context) ](fg:#769ff0 bg:#212736)";
    };
  };
} 