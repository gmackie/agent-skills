#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  plan-release-readiness.sh --repo /path/to/app [--format text|json]

Options:
  --repo PATH           App repo root. Required.
  --format FORMAT       Output format: text or json. Default: text.
  --help                Show this help.
EOF
}

repo=""
format="text"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="${2:-}"
      shift 2
      ;;
    --format)
      format="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$repo" ]]; then
  echo "--repo is required" >&2
  usage >&2
  exit 1
fi

if [[ ! -d "$repo" ]]; then
  echo "repo not found: $repo" >&2
  exit 1
fi

repo="$(cd "$repo" && pwd)"

has_file() {
  [[ -e "$repo/$1" ]]
}

detect_app_type() {
  if has_file app.json || compgen -G "$repo/app.config.*" >/dev/null; then
    if has_file ios || has_file android; then
      printf 'expo-with-native'
    else
      printf 'expo-managed'
    fi
  elif has_file ios || has_file android; then
    printf 'bare-react-native'
  else
    printf 'unknown'
  fi
}

env_files=()
for env_file in "$repo"/.env "$repo"/.env.*; do
  if [[ -e "$env_file" ]]; then
    env_files+=("${env_file#$repo/}")
  fi
done

app_type="$(detect_app_type)"
expo_config="missing"
if has_file app.json; then
  expo_config="app.json"
elif compgen -G "$repo/app.config.*" >/dev/null; then
  expo_config="$(basename "$(compgen -G "$repo/app.config.*" | head -n 1)")"
fi

emit_text() {
  printf 'repo\t%s\n' "$repo"
  printf 'app_type\t%s\n' "$app_type"
  printf 'expo_config\t%s\n' "$expo_config"
  printf 'eas_json\t%s\n' "$(has_file eas.json && echo present || echo missing)"
  printf 'maestro_flows\t%s\n' "$(has_file .maestro && echo present || echo missing)"
  printf 'eas_workflows\t%s\n' "$(has_file .eas/workflows && echo present || echo missing)"
  printf 'ios_dir\t%s\n' "$(has_file ios && echo present || echo missing)"
  printf 'android_dir\t%s\n' "$(has_file android && echo present || echo missing)"
  if ((${#env_files[@]} > 0)); then
    printf 'env_files\t%s\n' "$(printf '%s,' "${env_files[@]}" | sed 's/,$//')"
  else
    printf 'env_files\t%s\n' "none"
  fi
}

emit_json() {
  jq -cn \
    --arg repo "$repo" \
    --arg appType "$app_type" \
    --arg expoConfig "$expo_config" \
    --arg easJson "$(has_file eas.json && echo true || echo false)" \
    --arg maestroFlows "$(has_file .maestro && echo true || echo false)" \
    --arg easWorkflows "$(has_file .eas/workflows && echo true || echo false)" \
    --arg iosDir "$(has_file ios && echo true || echo false)" \
    --arg androidDir "$(has_file android && echo true || echo false)" \
    --argjson envFiles "$(printf '%s\n' "${env_files[@]:-}" | jq -R . | jq -s 'map(select(length > 0))')" \
    '{
      repo: $repo,
      appType: $appType,
      expoConfig: $expoConfig,
      easJson: ($easJson == "true"),
      maestroFlows: ($maestroFlows == "true"),
      easWorkflows: ($easWorkflows == "true"),
      iosDir: ($iosDir == "true"),
      androidDir: ($androidDir == "true"),
      envFiles: $envFiles
    }'
}

case "$format" in
  text)
    emit_text
    ;;
  json)
    emit_json
    ;;
  *)
    echo "unsupported format: $format" >&2
    exit 1
    ;;
esac
