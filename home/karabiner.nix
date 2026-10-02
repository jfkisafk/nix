{ pkgs, ... }:
let
  anyMods = {
    optional = [ "any" ];
  };
  rcmdArrow = key: arrow: {
    type = "basic";
    from = {
      key_code = key;
      modifiers = {
        mandatory = [ "right_command" ];
        optional = [ "any" ];
      };
    };
    to = [ { key_code = arrow; } ];
  };
in
pkgs.writeText "karabiner.json" (
  builtins.toJSON {
    global.ask_for_confirmation_before_quitting = false;
    profiles = [
      {
        name = "darkstar";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        devices = [
          {
            identifiers = {
              is_keyboard = true;
              is_pointing_device = true;
              product_id = 591;
              vendor_id = 1452;
            };
            ignore = false;
          }
        ];
        fn_function_keys = [
          {
            from.key_code = "f5";
            to = [ { apple_vendor_top_case_key_code = "illumination_down"; } ];
          }
          {
            from.key_code = "f6";
            to = [ { apple_vendor_top_case_key_code = "illumination_up"; } ];
          }
        ];
        complex_modifications.rules = [
          {
            description = "Caps Lock Modifications";
            manipulators = [
              {
                description = "Caps Lock -> Left Ctrl";
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers = anyMods;
                };
                to = [ { key_code = "left_control"; } ];
                to_if_alone = [ { key_code = "escape"; } ];
              }
            ];
          }
          {
            description = "Left Ctrl Modifications";
            manipulators = [
              {
                description = "Left Ctrl -> Left Command + Left Option";
                type = "basic";
                from = {
                  key_code = "left_control";
                  modifiers = anyMods;
                };
                to = [
                  {
                    key_code = "left_option";
                    modifiers = [
                      "left_option"
                      "left_command"
                    ];
                  }
                ];
              }
            ];
          }
          {
            description = "Hyper Key (⌃⌥⇧⌘)";
            manipulators = [
              {
                description = "Tab -> Hyper Key";
                type = "basic";
                from = {
                  key_code = "tab";
                  modifiers = anyMods;
                };
                to = [
                  {
                    key_code = "left_shift";
                    modifiers = [
                      "left_control"
                      "left_option"
                      "left_shift"
                      "left_command"
                    ];
                  }
                ];
                to_if_alone = [ { key_code = "tab"; } ];
              }
            ];
          }
          {
            description = "Change right_command+hjkl to arrow keys";
            manipulators = [
              (rcmdArrow "h" "left_arrow")
              (rcmdArrow "j" "down_arrow")
              (rcmdArrow "k" "up_arrow")
              (rcmdArrow "l" "right_arrow")
            ];
          }
        ];
      }
    ];
  }
)
