let
  hosts = {
    potato = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgR71zVVWbULtG4z8OjZw2yciYt6Bcwlk10xPzDALCg";
    taro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYuoVF9nudJeyM/4XYAvY2XwA7GuPYfo8ta9NrNyZrr";
  };
in {
  "ditto-bot.env.age".publicKeys = [hosts.potato hosts.taro];
  "eggdar-bot.env.age".publicKeys = [hosts.potato hosts.taro];
}
