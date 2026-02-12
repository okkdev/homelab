{
  config,
  name,
  pkgs,
  ...
}:
{
  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    environmentFile = config.sops.templates."beszel-agent.env".path;
  };

  # until https://github.com/NixOS/nixpkgs/pull/461327 is merged
  services.dbus.packages = [
    (pkgs.writeTextDir "share/dbus-1/system.d/beszel-agent.conf" ''
      <?xml version="1.0" encoding="UTF-8"?> <!-- -*- XML -*- -->

      <!DOCTYPE busconfig PUBLIC
                "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
                "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">

      <busconfig>
        <policy user="beszel-agent">
          <allow
            send_destination="org.freedesktop.systemd1"
            send_type="method_call"
            send_path="/org/freedesktop/systemd1"
            send_interface="org.freedesktop.systemd1.Manager"
            send_member="ListUnits"
          />
        </policy>
      </busconfig>
    '')
  ];
  users.groups.beszel-agent = { };
  users.users.beszel-agent = {
    isSystemUser = true;
    group = "beszel-agent";
  };

  sops.secrets."beszel-token-${name}" = { };
  sops.templates."beszel-agent.env" = {
    content = ''
      KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXHE/75uA6Qk08PDCcxBiXcbvmx4RNEpMtqNiO3LkN3"
      TOKEN="${config.sops.placeholder."beszel-token-${name}"}"
      HUB_URL="10.0.0.11"
      SKIP_GPU=true
    '';
  };
}
