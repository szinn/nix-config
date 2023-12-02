function git_current_branch --description 'Display the current branch'
  git symbolic-ref -q HEAD | string replace "refs/heads/" ""
end
