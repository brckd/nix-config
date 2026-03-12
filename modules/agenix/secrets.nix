let
  hosts = {
    taro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYuoVF9nudJeyM/4XYAvY2XwA7GuPYfo8ta9NrNyZrr";
  };
in {
  "ditto-bot.env.age".publicKeys = [hosts.taro];
}
