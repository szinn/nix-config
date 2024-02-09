{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.services.k3s;
  k3s-killall = pkgs.writeShellScriptBin "k3s-killall" ''
    [ $(id -u) -eq 0 ] || exec sudo $0 $@

    for bin in /var/lib/rancher/k3s/data/**/bin/; do
        [ -d $bin ] && export PATH=$PATH:$bin:$bin/aux
    done

    set -x

    for service in /etc/systemd/system/k3s*.service; do
        [ -s $service ] && systemctl stop $(basename $service)
    done

    for service in /etc/init.d/k3s*; do
        [ -x $service ] && $service stop
    done

    pschildren() {
        ps -e -o ppid= -o pid= | \
        sed -e 's/^\s*//g; s/\s\s*/\t/g;' | \
        grep -w "^$1" | \
        cut -f2
    }

    pstree() {
        for pid in $@; do
            echo $pid
            for child in $(pschildren $pid); do
                pstree $child
            done
        done
    }

    killtree() {
        kill -9 $(
            { set +x; } 2>/dev/null;
            pstree $@;
            set -x;
        ) 2>/dev/null
    }

    remove_interfaces() {
        # Delete network interface(s) that match 'master cni0'
        ip link show 2>/dev/null | grep 'master cni0' | while read ignore iface ignore; do
            iface=$(echo $iface | sed -e 's/@.*//')
            [ -z "$iface" ] || ip link delete $iface
        done

        # Delete cni related interfaces
        ip link delete cni0
        ip link delete flannel.1
        ip link delete flannel-v6.1
        ip link delete kube-ipvs0
        ip link delete flannel-wg
        ip link delete flannel-wg-v6

        # Remove advertised routes in tailscale
        if [[ -n $(command -v tailscale) ]]; then
            tailscale set --advertise-routes=
        fi
    }

    getshims() {
        ps -e -o pid= -o args= | sed -e 's/^ *//; s/\s\s*/\t/;' | grep -w 'k3s/data/[^/]*/bin/containerd-shim' | cut -f1
    }

    killtree $({ set +x; } 2>/dev/null; getshims; set -x)

    do_unmount() {
        awk -v path="$1" '$2 ~ ("^" path) { print $2 }' /proc/self/mounts | sort -r | xargs -r -t -n 1 umount
    }

    do_unmount '/run/k3s'
    do_unmount '/var/lib/rancher/k3s'
    do_unmount '/var/lib/kubelet/pods'
    do_unmount '/run/netns/cni-'

    remove_interfaces

    rm -rf /var/lib/cni/
    iptables-save | grep -v KUBE- | grep -v CNI- | grep -iv flannel | iptables-restore
    ip6tables-save | grep -v KUBE- | grep -v CNI- | grep -iv flannel | ip6tables-restore
  '';
in
{
  options.modules.services.k3s = {
    enable = mkEnableOption "k3s";
    package = mkPackageOption pkgs "k3s" { };
    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra flags to pass to k3s";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 6443 ];

    services.k3s = {
      enable = true;
      role = "server";
      package = cfg.package;
    };

    services.k3s.extraFlags = toString ([
      "--tls-san=${config.networking.hostName}.zinn.tech"
      "--disable=local-storage"
      "--disable=traefik"
      "--disable=metrics-server"
    ] ++ cfg.extraFlags);

    environment.systemPackages = [
      cfg.package
      k3s-killall
    ];
  };
}
