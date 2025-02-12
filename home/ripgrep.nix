{ pkgs, ... }: {
  enable = true;

  arguments = [
    "--glob '!.git'"
    "--line-number"
    "--colors 'path:style:intense'"
    "--colors 'line:style:intense'"
    "--colors 'match:style:intense'"
    "--smart-case"
    "--hidden"
  ];
}
