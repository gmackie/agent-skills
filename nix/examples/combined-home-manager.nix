{ publicFlake, privateFlake ? null }:
{ lib, ... }:
let
  privateImports =
    if privateFlake == null then
      [ ]
    else
      [ privateFlake.homeManagerModules.default ];
in
{
  imports = [
    publicFlake.homeManagerModules.default
  ] ++ privateImports;

  programs.agent-skills = {
    enable = true;
    skillIds = [
      "expo-build-validation"
      "expo-build-submit"
    ];
    toolIds = [
      "skill-bootstrap"
    ];
    agentIds = [
      "react-frontend"
    ];
  };

  # Private skills can be installed by the private repo's module in the same
  # Home Manager evaluation, with both repos sharing the same metadata contract.
}
