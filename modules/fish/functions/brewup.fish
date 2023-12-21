if type -q brew
    brew update
    brew upgrade
    brew cleanup --prune=all
    brew doctor
end
if type -q mas
    mas upgrade
end
