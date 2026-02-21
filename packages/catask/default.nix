{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) python313Packages fetchFromGitea;
  version = "2.7.0";
  tag = "v${version}";
in
  python313Packages.buildPythonApplication {
    inherit version;
    pname = "catask";
    pyproject = true;

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "bricked";
      repo = "catask";
      rev = "6923d61bb147f1ec67c95d3d6a92f4b793669426";
      hash = "sha256-mPPPoSg0RraEFfXFyLdToO+iTQKLnrNdiLrauhggh1w=";
    };

    build-system = [
      python313Packages.setuptools
    ];

    dependencies = [
      python313Packages.ago
      python313Packages.authlib
      python313Packages.bleach
      python313Packages.flask
      python313Packages.flask-babel
      python313Packages.flask-compress
      python313Packages.humanize
      python313Packages.lupa
      python313Packages.mistune
      python313Packages.pillow
      python313Packages.psycopg
      python313Packages.python-dotenv
      python313Packages.requests
      python313Packages.sentry-sdk
      python313Packages.typer
      python313Packages.yoyo-migrations
    ];

    optional-dependencies = {
      gunicorn = [python313Packages.gunicorn];
      waitress = [python313Packages.waitress];
    };

    nativeCheckInputs = [
      python313Packages.gunicorn
      python313Packages.waitress
    ];

    meta = {
      mainProgram = "catask";
      changelog = "https://codeberg.org/catask-org/catask/releases/tag/v${tag}";
      homepage = "https://catask.org/";
      description = "A minimal open-source single-user Q&A software";
      license = lib.licenses.agpl3Only;
    };
  }
