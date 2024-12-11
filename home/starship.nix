{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = true;

  settings = {
    add_newline = true;
    command_timeout = 10000;
    palette = "catppuccin_mocha";

    palettes.catppuccin_mocha = {
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };

    format = ''$directory$git_branch$git_status$nodejs$rust$golang$java$python$ruby$scala$zig$docker_context$lua$elixir$swift$conda$dart$character'';

    character = {
      success_symbol = "[ ❯](bold fg:teal)";
      error_symbol = "[ ❯](bold fg:red)";
    };

    directory = {
      style = "fg:blue";
      format = "[ $path]($style)";
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
      style = "fg:mauve";
      format = "[ $symbol ($version)]($style)";
    };

    git_branch = {
      symbol = "";
      format = "[ $symbol $branch](fg:flamingo)";
    };

    git_status = {
      format = "[($all_status$ahead_behind)](fg:flamingo)";
    };

    nodejs = {
      symbol = "";
      style = "fg:green";
      format = "[ $symbol ($version)]($style)";
    };

    rust = {
      symbol = "";
      style = "fg:maroon";
      format = "[ $symbol ($version)]($style)";
    };

    lua = {
      symbol = "";
      style = "fg:blue";
      format = "[ $symbol ($version)]($style)";
    };

    python = {
      symbol = "";
      style = "fg:rosewater";
      format = "[ $symbol ($version)]($style)";
    };

    ruby = {
      symbol = "";
      style = "fg:sapphire";
      format = "[ $symbol ($version)]($style)";
    };

    golang = {
      symbol = "";
      style = "fg:blue";
      format = "[ $symbol ($version)]($style)";
    };

    swift = {
      symbol = "";
      style = "fg:peach";
      format = "[ $symbol ($version)]($style)";
    };

    zig = {
      symbol = "";
      style = "fg:rosewater";
      format = "[ $symbol ($version)]($style)";
    };

    scala = {
      symbol = "";
      style = "fg:red";
      format = "[ $symbol ($version)]($style)";
    };

    elixir = {
      symbol = "";
      style = "fg:lavender";
      format = "[ $symbol ($version)]($style)";
    };

    conda = {
      symbol = "";
      style = "fg:green";
      format = "[ $symbol ($version)]($style)";
    };

    dart = {
      symbol = "";
      style = "fg:yellow";
      format = "[ $symbol ($version)]($style)";
    };

    docker_context = {
      symbol = "";
      style = "fg:blue";
      format = "[ $symbol ($context)]($style)";
    };
  };
} 
