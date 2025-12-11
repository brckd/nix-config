{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.helix;
in {
  config = mkIf cfg.enable {
    programs.helix = {
      settings = {
        editor = {
          auto-format = false;
          cursor-shape.insert = "bar";
          file-picker.hidden = false;
          line-number = "relative";
          soft-wrap.enable = true;
          whitespace.render.tab = "all";
        };
      };

      languages = {
        language-server = {
          # Astro language server
          astro-ls = {
            command = "${pkgs.astro-language-server}/bin/astro-ls";
            args = ["--stdio"];
            config = {
              typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              environment = "node";
            };
          };

          # Bash language server
          bash-language-server.command = "${pkgs.bash-language-server}/bin/bash-language-server";

          # Fish language server
          fish-lsp.command = "${pkgs.fish-lsp}/bin/fish-lsp";

          # Markdown language server
          marksman.command = "${pkgs.marksman}/bin/marksman";

          # Nix language server
          nixd.command = "${pkgs.nixd}/bin/nixd";

          # Python language server
          pylsp.command = "${pkgs.python313Packages.python-lsp-server}/bin/pylsp";

          # Rust language server
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            # Rust linter
            config.check.command = "${pkgs.clippy}/bin/clippy";
          };

          # TOML language server
          tombi.command = "${pkgs.tombi}/bin/tombi";

          # Typst language server
          tinymist.command = "${pkgs.tinymist}/bin/tinymist";

          # TypeScript language server
          typescript-language-server.command = "${pkgs.typescript-language-server}/bin/typescript-language-server";

          # CSS language server
          vscode-css-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";

          # ESLint language server
          vscode-eslint-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";

          # HTML language server
          vscode-html-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";

          # JSON language server
          vscode-json-language-server = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
            config.json.schemas = [
              {
                fileMatch = ["package.json"];
                url = "https://www.schemastore.org/package.json";
              }
              {
                fileMatch = ["tsconfig*.json"];
                url = "https://www.schemastore.org/tsconfig.json";
              }
            ];
          };

          # YAML language server
          yaml-language-server.command = "${pkgs.yaml-language-server}/bin/yaml-language-server";

          # Zig language server
          zls = {
            command = "${pkgs.zls}/bin/zls";
            # Zig linter
            config.check.command = "${pkgs.zig-zlint}/bin/zlint";
          };
        };

        language = map (name: {
          inherit name;
          language-servers = ["typescript-language-server" "vscode-eslint-language-server"];
        }) ["javascript" "jsx" "typescript" "tsx"];
      };
    };
  };
}
