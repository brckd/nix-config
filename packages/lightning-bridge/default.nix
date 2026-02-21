{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) buildGo125Module fetchFromGitea;
in
  buildGo125Module rec {
    pname = "lightning-bridge";
    version = "0.8.5";
    subpackages = ["lightning"];

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "jersey";
      repo = "lightning";
      rev = "8ba87f7610f55b7a24af25d9cf98b6acceef2d7a";
      hash = "sha256-CVN+NmjrQK4liwc7c95IexYghJjtHEiO6SiqO24w0/8=";
    };

    vendorHash = "sha256-JshOSmSKqbFkA+EZ0OZP5g1EnD589bvoTDvUWzV1uBQ=";

    meta = {
      mainProgram = "lightning";
      changelog = "https://codeberg.org/jersey/lightning/releases/v${version}";
      homepage = "https://williamhorning.dev/lightning/";
      description = "A cross-platform chat bot connecting your communities";
      license = lib.licenses.mit;
    };
  }
