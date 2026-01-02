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
              "Fancade Wiki" = {
                urls = singleton {template = "https://www.fancade.com/wiki/gollum/search?q={searchTerms}";};
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
              "Home Manager Issues" = {
                urls = singleton {template = "https://github.com/nix-community/home-manager/issues?q={searchTerms}";};
                icon = "https://github.githubassets.com/favicons/favicon.png";
                definedAliases = ["@homemanagerissues" "@hmi"];
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
                urls = singleton {template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";};
                icon = "https://wiki.nixos.org/favicon.ico";
                definedAliases = ["@nixoswiki" "@now"];
              };
              "Nixpkgs Issues" = {
                urls = singleton {template = "https://github.com/nixos/nixpkgs/issues?q={searchTerms}";};
                icon = "https://github.githubassets.com/favicons/favicon.png";
                definedAliases = ["@nixpkgsissues" "@nxi"];
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
              "Searchix" = {
                urls = singleton {template = "https://searchix.ovh/?query={searchTerms}";};
                icon = "https://searchix.ovh/favicon.ico";
                definedAliases = ["@searchix" "@sx"];
              };
              "Stylix Documentations" = {
                urls = singleton {template = "https://nix-community.github.io/stylix/?search={searchTerms}";};
                icon = "https://nix-community.github.io/stylix/favicon-de23e50b.svg";
                definedAliases = ["@stylixdocs" "@std"];
              };
              "Stylix Issues" = {
                urls = singleton {template = "https://github.com/nix-community/stylix/issues?q={searchTerms}";};
                icon = "https://github.githubassets.com/favicons/favicon.png";
                definedAliases = ["@stylixissues" "@sti"];
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
              "Wikipedia" = {
                _id = "custom-wikipedia";
                _name = "Wikipedia";
                urls = singleton {template = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}";};
                icon = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
                definedAliases = ["@wikipedia" "@wp"];
              };
              "Wikipedia (de)" = {
                _id = "custom-wikipedia-de";
                _name = "Wikipedia (de)";
                urls = singleton {template = "https://de.wikipedia.org/wiki/Special:Search?search={searchTerms}";};
                icon = "https://de.wikipedia.org/static/favicon/wikipedia.ico";
                definedAliases = ["@wikipediade" "@wpd"];
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
                name = "Git";
                tags = ["bricked" "git"];
                url = "https://git.bricked.dev";
              }
              {
                name = "Dashboard";
                tags = ["bricked"];
                url = "https://dash.bricked.dev";
              }
              {
                name = "Status";
                tags = ["bricked"];
                url = "https://status.bricked.dev";
              }
              {
                name = "GitHub";
                tags = ["git"];
                url = "https://github.com";
              }
              {
                name = "Codeberg";
                tags = ["git"];
                url = "https://codeberg.org";
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
                name = "Nixpkgs Repository";
                tags = ["nixpkgs" "git"];
                url = "https://github.com/nixos/nixpkgs";
              }
              {
                name = "Home Manager Repository";
                tags = ["homemanager" "git"];
                url = "https://github.com/nix-community/home-manager";
              }
              {
                name = "Stylix Repository";
                tags = ["stylix" "git"];
                url = "https://github.com/nix-community/stylix";
              }
              {
                name = "Deepl";
                tags = ["translator"];
                url = "https://deepl.com";
              }
              {
                name = "Fancade Web";
                tags = ["fancade" "gaming"];
                url = "https://play.fancade.com";
              }
              {
                name = "HypeHype App";
                tags = ["hypehype" "gaming"];
                url = "https://app.hypehype.com";
              }
              {
                name = "HypeHype Learning Hub";
                tags = ["hypehype" "gaming"];
                url = "https://learn.hypehype.com";
              }
              {
                name = "Proton Mail";
                tags = ["proton" "mail"];
                url = "https://mail.proton.me";
              }
              {
                name = "AnonAddy";
                tags = ["mail"];
                url = "https://addy.io";
              }
              {
                name = "SimpleLogin";
                tags = ["mail"];
                url = "https://simplelogin.com";
              }
              {
                name = "Vercel";
                tags = ["hosting"];
                url = "https://vercel.com";
              }
              {
                name = "Netlify";
                tags = ["hosting"];
                url = "https://netlify.com";
              }
              {
                name = "Tailscale";
                tags = ["hosting"];
                url = "https://tailscale.com";
              }
              {
                name = "Monkeytype";
                tags = ["typing"];
                url = "https://monkeytype.com";
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
          "github.com"
          "codeberg.org"
          "gitlab.com"
          "gitlab.gnome.org"
          "proton.me"
          "purelymail.com"
          "addy.io"
          "simplelogin.com"
          "huggingface.co"
          "vercel.com"
          "netlify.com"
          "neon.tech"
          "penpot.app"
          "figma.com"
          "fancade.com"
          "fancade.club"
          "discord.com"
          "spotify.com"
          "epicgames.com"
          "steamcommunity.com"
          "steampowered.com"
          "adventofcode.com"
          "fancade.com"
          "hypehype.com"
          "tilde.zone"
          "feddit.org"
          "nope.chat"
          "monkeytype.com"
          "typst.app"
          "keybr.com"
          "cachix.org"
          "tailscale.com"
        ];
      };
    };
  };
}
