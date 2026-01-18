{
  lib,
  self,
  system,
  inputs,
  ...
}: let
  inherit (builtins) attrNames;
  inherit (lib) concatMapAttrs genAttrs;
  inherit (inputs.nixos-generators) nixosGenerate;
  formats = attrNames inputs.nixos-generators.nixosModules;
  inherit (self.lib) tree;
  inherit (tree) modules;
  specialArgs = tree.specialArgs.mixed;
  extraSpecialArgs = specialArgs;
in
  concatMapAttrs (
    hostName: hostModule:
      {
        ${hostName} = genAttrs formats (format:
          nixosGenerate {
            inherit lib system specialArgs format;
            modules = [hostModule];
          });
      }
      // concatMapAttrs (
        userName: userHomeModule: let
          hostHomeModule = modules.mixed.hosts.home.${userName} or {};
          homeIntegrationModule = {
            home-manager = {
              inherit extraSpecialArgs;
              users.${userName}.imports = [userHomeModule hostHomeModule];
            };
          };
          autoLoginModule = {
            services.displayManager.autoLogin.user = userName;
          };
        in {
          "${userName}@${hostName}" = genAttrs formats (format:
            nixosGenerate {
              inherit lib system specialArgs format;
              modules = [hostModule homeIntegrationModule autoLoginModule];
            });
        }
      )
      modules.mixed.users.home
  )
  modules.mixed.hosts.nixos
