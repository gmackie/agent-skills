{ self, inputs }:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.agent-skills;
  metadata = self.skillMetadata;
  toolMetadata = self.toolMetadata;
  agentMetadata = self.agentMetadata;

  selectedMetadata =
    if cfg.skillIds == [ "*" ] then
      builtins.attrValues metadata
    else
      map (id: metadata.${id}) cfg.skillIds;

  pkgFromName = name:
    if builtins.hasAttr name pkgs then pkgs.${name} else null;

  selectedToolIds =
    lib.unique
      (cfg.toolIds ++ lib.concatMap (item: item.helperTools or []) selectedMetadata);

  runtimePackages =
    lib.unique
      (lib.filter (pkg: pkg != null)
        (lib.concatMap (item: map pkgFromName (item.runtimePackages or [])) selectedMetadata));

  helperPackages =
    lib.filter (pkg: pkg != null)
      (map
        (toolId:
          if builtins.hasAttr toolId self.packages.${pkgs.system}
          then self.packages.${pkgs.system}.${toolId}
          else null)
        selectedToolIds);

  selectedIds = map (item: item.id) selectedMetadata;

  skillFiles =
    builtins.listToAttrs
      (map
        (id: {
          name = "${cfg.installRoot}/${id}/SKILL.md";
          value = {
            source = self + "/${metadata.${id}.outputs.skillFile}";
          };
        })
        selectedIds);

  selectedAgentIds =
    if cfg.agentIds == [ "*" ] then
      builtins.attrNames agentMetadata
    else
      cfg.agentIds;

  agentFiles =
    builtins.listToAttrs
      (map
        (id: {
          name = "${cfg.agentInstallRoot}/${id}/agent.json";
          value = {
            source = self + "/${agentMetadata.${id}.definitionFile}";
          };
        })
        selectedAgentIds);
in
{
  options.programs.agent-skills = {
    enable = lib.mkEnableOption "agent skills installation from this repo";

    skillIds = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "*" ];
      description = "Skill ids to install. Use [ \"*\" ] to expose all metadata-backed skills.";
    };

    toolIds = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Explicit helper tool ids to install in addition to tools referenced by selected skills.";
    };

    agentIds = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Agent ids to install. Use [ \"*\" ] to expose all metadata-backed agents.";
    };

    installRoot = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.local/share/agent-skills/skills";
      description = "Directory where skill files from this repo are linked.";
    };

    agentInstallRoot = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.local/share/agent-skills/agents";
      description = "Directory where agent definitions from this repo are linked.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.unique (runtimePackages ++ helperPackages);
    home.file = skillFiles // agentFiles;
  };
}
