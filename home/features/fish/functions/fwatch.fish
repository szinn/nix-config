if count $argv > /dev/null
  command watch -x (which fish) -c "$argv"
end
