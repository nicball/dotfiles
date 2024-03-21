{ pkgs, ... }:

{
  imports = [ ./private/wireless-networks.nix ];

  # Clash
  systemd.services.clash = {
    description = "Clash Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.clash-meta}/bin/clash-meta -f ${./private/clash.yaml} -d /var/clash > /dev/null 2>&1";
    };
  };

  # Network
  networking = {
    hostName = "nixos-laptop";

    proxy.httpProxy = "http://127.0.0.1:7890";
    proxy.httpsProxy = "http://127.0.0.1:7890";
    proxy.noProxy = "127.0.0.1,localhost";

    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
    interfaces.wlo1.useDHCP = true;

    # Disable IPV6 temp address
    # tempAddresses = "disabled";

    # DNS
    # nameservers = [ "8.8.4.4" "8.8.8.8" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
    # hosts = {
    #     "202.38.64.59" = [ "wlt.ustc.edu.cn" "wlt" ];
    # };
    dhcpcd.extraConfig = ''
        # nohook resolv.conf
        release
    '';

    # Wireless
    wireless.enable = true;
    wireless.userControlled.enable = true; # allow wpa_cli to connect
  };

  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [ "8286ac0e47b1e8e6" ];
  # };

  # services.samba = {
  #   enable = true;
  #   openFirewall = true;
  #   shares = { aria2d = {
  #     path = "/var/aria2d";
  #     writable = "yes";
  #   }; };
  # };

  networking.firewall.allowedTCPPorts = [ 16363 ];
  #   25565 8123 # mc
  #   # 1935 # owncast
  #   9090 # clash
  #   # 3001 3005 # shapez
  #   2344 2345 # arma3
  #   # 7500 # frps dashboard
  #   5900 # vnc
  #   10308 # dcs
  #   8088 # dcs web
  #   # 5201 # iperf
  #   # 7890 7891 # clash
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   2302 2303 2304 2305 2306 2344 # arma3
  #   # 27015 27016 # barotrauma
  #   10308 # dcs
  #   # 7890 7891 # clash
  # ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
