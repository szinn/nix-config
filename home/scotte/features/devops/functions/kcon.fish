if count $argv > /dev/null
  set -e KUBECONFIG
  switch $argv
    case main
      talosctl config context main
      kubectl config use-context admin@main
    case staging
      talosctl config context staging
      kubectl config use-context admin@staging
  end
else
  echo "kcon main | staging"
end
