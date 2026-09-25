{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = true;

  settings = {
    add_newline = true;
    command_timeout = 10000;
    palette = "rosepine";

    palettes.rosepine = {
      overlay = "#26233a";
      love = "#eb6f92";
      gold = "#f6c177";
      rose = "#ea9a97";
      pine = "#3e8fb0";
      foam = "#9ccfd8";
      iris = "#c4a7e7";
    };

    format = ''$username$directory$git_branch$git_status$character'';
    right_format = ''$c$elixir$elm$golang$haskell$java$julia$nodejs$nim$rust$scala$conda$python''${custom.llm_cost}$time'';

    character = {
      format = "$symbol  ";
      success_symbol = "[◎](fg:foam)";
      error_symbol = "[◎](fg:love)";
    };

    time = {
      disabled = false;
      format = "[](fg:overlay)[ $time 󰴈 ]($style)[](fg:overlay)";
      style = "bg:overlay fg:rose";
      time_format = "%I:%M%P";
      use_12hr = true;
    };

    directory = {
      format = "[](fg:overlay)[ $path ]($style)[](fg:overlay) ";
      style = "bg:overlay fg:pine";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    directory.substitutions = {
      Documents = "󰈙";
      Downloads = " ";
      Music = " ";
      Pictures = " ";
    };

    git_branch = {
      format = "[](fg:overlay)[ $symbol $branch ]($style)[](fg:overlay) ";
      style = "bg:overlay fg:foam";
      symbol = "";
    };

    git_status = {
      disabled = false;
      style = "bg:overlay fg:love";
      format = "[](fg:overlay)([$all_status$ahead_behind]($style))[](fg:overlay) ";
      up_to_date = "[ ✓ ](bg:overlay fg:iris)";
      untracked = "[?\($count\)](bg:overlay fg:gold)";
      modified = "[!\($count\)](bg:overlay fg:gold)";
      renamed = "[»\($count\)](bg:overlay fg:iris)";
      deleted = "[✘\($count\)]($style)";
      staged = "[++\($count\)](bg:overlay fg:gold)";
      ahead = "[⇡\(\${count}\)](bg:overlay fg:foam)";
      diverged = "⇕[\[](bg:overlay fg:iris)[⇡\(\${ahead_count}\)](bg:overlay fg:foam)[⇣\(\${behind_count}\)](bg:overlay fg:rose)[\]](bg:overlay fg:iris)";
      behind = "[⇣\(\${count}\)](bg:overlay fg:rose)";
    };

    username = {
      disabled = false;
      format = "[](fg:overlay)[ 󰧱 $user ]($style)[](fg:overlay) ";
      show_always = true;
      style_root = "bg:overlay fg:iris";
      style_user = "bg:overlay fg:iris";
    };

    c = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    elixir = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    elm = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    golang = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    haskell = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    java = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    julia = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    nodejs = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = "󰎙 ";
    };

    nim = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = "󰆥 ";
    };

    rust = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = "";
    };

    scala = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";

    };

    python = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
      disabled = false;
      symbol = " ";
    };

    conda = {
      style = "bg:overlay fg:pine";
      format = "[](fg:overlay)[$symbol$environment]($style)[](fg:overlay) ";
      disabled = false;
      symbol = "🅒 ";
    };

    custom.llm_cost = {
      command = ''
        let db = $"($env.HOME)/.claude/cost.db"
        let month = (date now | format date '%Y-%m')
        # Real sqlite errors hide the module (exit 1); only "no db yet" is a genuine $0.00.
        let val = if ($db | path exists) {
          # `-cmd ".timeout"`, not `PRAGMA busy_timeout`, so the timeout setting never writes to
          # stdout and gets mistaken for the query result.
          let out = (try { ^sqlite3 -cmd ".timeout 5000" $db $"SELECT cost_usd FROM monthly_cost WHERE month = '($month)';" e> /dev/null | str trim } catch { null })
          if $out == null { null } else if ($out | is-empty) { "0" } else { $out }
        } else { "0" }
        if $val == null { exit 1 }
        let amount = (try { $val | into float } catch { null })
        if $amount == null { exit 1 }
        print ("$" + ($amount | into string -d 2))
      '';
      shell = ["nu" "-c"];
      style = "bg:overlay fg:love";
      format = "[](fg:overlay)[⚡$output]($style)[](fg:overlay) ";
      when = "true";
      disabled = false;
    };

    profiles = {
      "claude-code" = "$claude_model$claude_cost$claude_context";
    };

    claude_model = {
      style = "bold iris";
      symbol = "󰧱 ";
    };

    claude_cost = {
      symbol = "󰴈 ";
      display = [
        { threshold = 0; style = "bold rose"; }
      ];
    };
  };
}
