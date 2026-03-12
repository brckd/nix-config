{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) mkIf singleton;

  cfg = config.programs.librewolf;

  firefoxAddons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in {
  config = mkIf cfg.enable {
    programs.librewolf = {
      profiles = {
        default = {
          name = "Default";
          extensions = {
            force = true;
            packages = [
              firefoxAddons.ublock-origin
              firefoxAddons.bitwarden
              firefoxAddons.darkreader
            ];
          };
          search = {
            default = "ddg";
            force = true;
            engines = {
              "bing".metaData.hidden = true;
              "google".metaData.hidden = true;
              "perplexity".metaData.hidden = true;
              "reddit".metaData.hidden = true;
              "wikipedia".metaData.hidden = true;
              "policy-DuckDuckGo Lite".metaData.hidden = true;
              "policy-MetaGer".metaData.hidden = true;
              "policy-Mojeek".metaData.hidden = true;
              "policy-SearXNG - searx.be".metaData.hidden = true;
              "policy-StartPage".metaData.hidden = true;

              "AlternativeTo" = {
                urls = singleton {template = "https://alternativeto.net/browse/search/?q={searchTerms}";};
                icon = "https://alternativeto.net/static/icons/a2/favicon.svg";
                definedAliases = ["@alternativeto" "@at"];
              };
              "Brave" = {
                urls = singleton {template = "https://search.brave.com/search?q={searchTerms}";};
                icon = "https://cdn.search.brave.com/serp/v3/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
                definedAliases = ["@brave" "@br"];
              };
              "Codeberg" = {
                urls = singleton {template = "https://codeberg.org/explore/repos?q={searchTerms}";};
                icon = "https://codeberg.org/assets/img/favicon.svg";
                definedAliases = ["@codeberg" "@cb"];
              };
              "Custom Wikipedia" = {
                _id = "custom-wikipedia";
                _name = "Wikipedia";
                urls = singleton {template = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}";};
                icon = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
                definedAliases = ["@wikipedia" "@wp"];
              };
              "Custom Wikipedia (de)" = {
                _id = "custom-wikipedia-de";
                _name = "Wikipedia (de)";
                urls = singleton {template = "https://de.wikipedia.org/wiki/Special:Search?search={searchTerms}";};
                icon = "https://de.wikipedia.org/static/favicon/wikipedia.ico";
                definedAliases = ["@wikipediade" "@wpd"];
              };
              "Fancade Wiki" = {
                urls = singleton {template = "https://www.fancade.com/wiki/Special:Search?search={searchTerms}";};
                icon = "https://www.fancade.com/favicon.ico";
                definedAliases = ["@fancadewiki" "@fcw"];
              };
              "Flathub" = {
                urls = singleton {template = "https://flathub.org/apps/search?q={searchTerms}";};
                icon = "https://flathub.org/favicon.png";
                definedAliases = ["@flathub" "@fh"];
              };
              "Flake Parts Docs" = {
                urls = singleton {template = "https://flake.parts/?search={searchTerms}";};
                icon = "https://flake.parts/favicon.svg";
                definedAliases = ["@flakepartsdocs" "@fpd"];
              };
              "GitHub" = {
                urls = singleton {template = "https://github.com/search?q={searchTerms}";};
                icon = "https://github.githubassets.com/favicons/favicon.png";
                definedAliases = ["@github" "@gh"];
              };
              "GitLab" = {
                urls = singleton {template = "https://gitlab.com/search?search={searchTerms}";};
                icon = "https://gitlab.com/assets/favicon-72a2cad5025aa931d6ea56c3201d1f18e68a8cd39788c7c80d5b2b82aa5143ef.png";
                definedAliases = ["@gitlab" "@gl"];
              };
              "Home Manager Options" = {
                urls = singleton {template = "https://home-manager-options.extranix.com/?query={searchTerms}";};
                icon = "https://home-manager-options.extranix.com/images/favicon.png";
                definedAliases = ["@homemmanageropts" "@hmo"];
              };
              "Lib.rs" = {
                urls = singleton {template = "https://lib.rs/search?q={searchTerms}";};
                icon = "https://lib.rs/logo.svg";
                definedAliases = ["@librs" "@lr"];
              };
              "MDN Web Docs" = {
                urls = singleton {template = "https://developer.mozilla.org/search?q={searchTerms}";};
                icon = "https://developer.mozilla.org/favicon.svg";
                definedAliases = ["@mdnwebdocs" "@mdn"];
              };
              "MediaWiki" = {
                urls = singleton {template = "https://www.mediawiki.org/wiki/Special:Search?search={searchTerms}";};
                icon = "https://www.mediawiki.org/static/apple-touch/mediawiki.png";
                definedAliases = ["@mediawiki" "@mw"];
              };
              "Nix Documentation" = {
                urls = singleton {template = "https://nix.dev/search.html?q={searchTerms}";};
                icon = "https://nix.dev/_static/favicon.png";
                definedAliases = ["@nixdocs" "@nxd"];
              };
              "Nix Manual" = {
                urls = singleton {template = "https://nix.dev/manual/nix/latest/?search={searchTerms}";};
                icon = "https://nix.dev/manual/nix/latest/favicon.svg";
                definedAliases = ["@nixmanual" "@nxm"];
              };
              "Nix Packages" = {
                urls = singleton {template = "https://search.nixos.org/packages?query={searchTerms}";};
                icon = "https://search.nixos.org/favicon.png";
                definedAliases = ["@nixpackages" "@nxp"];
              };
              "NixOS Options" = {
                urls = singleton {template = "https://search.nixos.org/options?query={searchTerms}";};
                icon = "https://search.nixos.org/favicon.png";
                definedAliases = ["@nixosoptions" "@noo"];
              };
              "NixOS Wiki" = {
                urls = singleton {template = "https://wiki.nixos.org/wiki/Special:Search?search={searchTerms}";};
                icon = "https://wiki.nixos.org/favicon.ico";
                definedAliases = ["@nixoswiki" "@now"];
              };
              "Noogle" = {
                urls = singleton {template = "https://noogle.dev/q?term={searchTerms}";};
                icon = "https://noogle.dev/favicon.png";
                definedAliases = ["@noogle" "@ng"];
              };
              "Porkbun" = {
                urls = singleton {template = "https://porkbun.com/checkout/search?q={searchTerms}";};
                icon = "https://porkbun.com/images/favicons/favicon-96x96.png";
                definedAliases = ["@porkbun" "@pb"];
              };
              "Rust Book" = {
                urls = singleton {template = "file://${config.programs.fenix.package}/share/doc/rust/html/book/index.html?search={searchTerms}";};
                icon = "https://rust-lang.org/static/images/favicon-32x32.png";
                definedAliases = ["@rustbook" "@rsb"];
              };
              "Rust Reference" = {
                urls = singleton {template = "file://${config.programs.fenix.package}/share/doc/rust/html/reference/index.html?search={searchTerms}";};
                icon = "https://rust-lang.org/static/images/favicon-32x32.png";
                definedAliases = ["@rustreference" "@rsr"];
              };
              "Rust Standard Library" = {
                urls = singleton {template = "file://${config.programs.fenix.package}/share/doc/rust/html/std/index.html?search={searchTerms}";};
                icon = "https://rust-lang.org/static/images/favicon-32x32.png";
                definedAliases = ["@ruststandardlibrary" "@rsl"];
              };
              "Rustnomicon" = {
                urls = singleton {template = "file://${config.programs.fenix.package}/share/doc/rust/html/nomicon/index.html?search={searchTerms}";};
                icon = "https://rust-lang.org/static/images/favicon-32x32.png";
                definedAliases = ["@rustnomicon" "@rsn"];
              };
              "Searchix" = {
                urls = singleton {template = "https://searchix.ovh/?query={searchTerms}";};
                icon = "https://searchix.ovh/favicon.ico";
                definedAliases = ["@searchix" "@sx"];
              };
              "Stylix Documentation" = {
                urls = singleton {template = "https://nix-community.github.io/stylix/?search={searchTerms}";};
                icon = "https://nix-community.github.io/stylix/favicon-de23e50b.svg";
                definedAliases = ["@stylixdocs" "@sld"];
              };
              "StartPage" = {
                urls = singleton {template = "https://noogle.dev/q?term={searchTerms}";};
                icon = "https://noogle.dev/favicon.png";
                definedAliases = ["@startpage" "@sp"];
              };
              "TLD-List" = {
                urls = singleton {template = "https://tld-list.com/?q={searchTerms}";};
                icon = "https://tld-list.com/favicon.ico";
                definedAliases = ["@tldlist" "@tl"];
              };
            };
          };
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Bricked";
                tags = ["bricked"];
                url = "https://bricked.dev";
              }
              {
                name = "Codeberg";
                tags = ["git"];
                url = "https://codeberg.org";
              }
              {
                name = "Deepl";
                tags = ["translator"];
                url = "https://deepl.com";
              }
              {
                name = "Fancade Web";
                tags = ["fancade" "game"];
                url = "https://play.fancade.com";
              }
              {
                name = "GitHub";
                tags = ["git"];
                url = "https://github.com";
              }
              {
                name = "GitLab";
                tags = ["git"];
                url = "https://gitlab.com";
              }
              {
                name = "GNOME GitLab";
                tags = ["gnome" "git"];
                url = "https://gitlab.gnome.org";
              }
              {
                name = "Home Manager Repository";
                tags = ["homemanager" "git"];
                url = "https://github.com/nix-community/home-manager";
              }
              {
                name = "Monkeytype";
                tags = ["typing"];
                url = "https://monkeytype.com";
              }
              {
                name = "Nixpkgs Repository";
                tags = ["nixpkgs" "git"];
                url = "https://github.com/nixos/nixpkgs";
              }
              {
                name = "Nushell Book";
                tags = ["nushell" "docs"];
                url = "https://www.nushell.sh/book";
              }
              {
                name = "Proton Mail";
                tags = ["proton" "mail"];
                url = "https://mail.proton.me";
              }
              {
                name = "Purelymail";
                tags = ["mail"];
                url = "https://www.purelymail.com";
              }
              {
                name = "Stylix Repository";
                tags = ["stylix" "git"];
                url = "https://github.com/nix-community/stylix";
              }
            ];
          };
          settings = {
            "extensions.autoDisableScopes" = 0; # Enable extensions
            "browser.aboutConfig.showWarning" = false;
            "browser.tabs.closeWindowWithLastTab" = false;

            # Privacy
            "privacy.sanitize.sanitizeOnShutdown" = false; # Keep history
            "privacy.resistFingerprinting.letterboxing" = true;

            # Blank homepage
            "browser.newtabpage.enable" = false;
            "browser.startup.homepage" = "about:newtab";
            "browser.startup.page" = 3;
            "browser.toolbars.bookmarks.visibility" = "never";

            # UI customization
            "browser.uiCustomization.state" = readFile ./toolbar.json;
            "layers.acceleration.force-enabled" = true; # Rounded window corners on Wayland

            # Gnome Theme
            "gnomeTheme.bookmarksToolbarUnderTabs" = true;
            "gnomeTheme.dragWindowHeaderbarButtons" = true;
            "gnomeTheme.symbolicTabIcons" = true;
          };
        };
      };
      policies = {
        Cookies.Allow = map (d: "https://${d}") [
          "bricked.dev"
          "cachix.org"
          "codeberg.org"
          "fancade.com"
          "feddit.org"
          "github.com"
          "gitlab.com"
          "gitlab.gnome.org"
          "monkeytype.com"
          "nope.chat"
          "purelymail.com"
          "tilde.zone"
        ];
      };
    };
  };
}
