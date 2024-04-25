if count $argv > /dev/null
  set -e KUBECONFIG
  switch $argv
    case main
      talosctl config context main
      kubectl config use-context main
    case staging
      talosctl config context staging
      kubectl config use-context staging
    case titan
      talosctl config context titan
      kubectl config use-context titan
    case nas
      kubectl config use-context nas
    case merge
      pushd ~/.kube 2>&1 >/dev/null
      KUBECONFIG="$(find . -type f -name 'config-*' | tr '\n' ':')" kubectl config view --flatten >all-in-one-kubeconfig.yaml
      mv all-in-one-kubeconfig.yaml config
      cd ~/.talos
      rm config
      find . -type f -name 'config-*' | xargs -L 1 talosctl config merge
      popd 2>&1 >/dev/null
  end
else
  echo "kcon main | staging | titan"
end
