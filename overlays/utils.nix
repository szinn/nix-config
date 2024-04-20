{
  pickLatest = newp: oldp:
    if newp == null
    then
      if oldp != null
      then oldp
      else throw "pickLatest: both packages can't be null at the same time."
    else if oldp == null
    then newp
    else if (builtins.compareVersions newp.version oldp.version) > 0
    then newp
    else
      (
        if (newp.version == oldp.version)
        then builtins.trace "deprecated: override of ${newp.pname} (${newp.version}) has reached version parity in upstream. Consider removing it."
        else builtins.trace "deprecated: override of ${newp.pname} (${newp.version}) is outdated, current version is ${oldp.version}. Consider removing it."
      )
      oldp;
}
