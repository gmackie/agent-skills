#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  run-maestro-qa-report.sh --repo /path/to/repo [options]

Options:
  --repo PATH               App repo root. Required.
  --flow-path PATH          Flow file or workspace path relative to repo. Default: .maestro
  --output-dir PATH         Artifact output directory relative to repo. Default: build/maestro-results
  --report-format FORMAT    Maestro report format: html, html-detailed, or junit. Default: html-detailed
  --report-file PATH        Report file path relative to repo. Default depends on format.
  --debug-output-dir PATH   Optional debug output directory relative to repo.
  --include-tags TAGS       Optional Maestro include-tags value.
  --dry-run                 Print the Maestro command without executing it.
  --help                    Show this help.
EOF
}

repo=""
flow_path=".maestro"
output_dir="build/maestro-results"
report_format="html-detailed"
report_file=""
debug_output_dir=""
include_tags=""
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="${2:-}"
      shift 2
      ;;
    --flow-path)
      flow_path="${2:-}"
      shift 2
      ;;
    --output-dir)
      output_dir="${2:-}"
      shift 2
      ;;
    --report-format)
      report_format="${2:-}"
      shift 2
      ;;
    --report-file)
      report_file="${2:-}"
      shift 2
      ;;
    --debug-output-dir)
      debug_output_dir="${2:-}"
      shift 2
      ;;
    --include-tags)
      include_tags="${2:-}"
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
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

case "$report_format" in
  html|html-detailed|junit)
    ;;
  *)
    echo "unsupported report format: $report_format" >&2
    exit 1
    ;;
esac

repo="$(cd "$repo" && pwd)"
flow_target="$repo/$flow_path"
artifact_dir="$repo/$output_dir"

if [[ -z "$report_file" ]]; then
  case "$report_format" in
    junit)
      report_file="build/maestro-report.xml"
      ;;
    *)
      report_file="build/maestro-report.html"
      ;;
  esac
fi

report_path="$repo/$report_file"
mkdir -p "$artifact_dir"
mkdir -p "$(dirname "$report_path")"

if [[ -n "$debug_output_dir" ]]; then
  debug_output_dir="$repo/$debug_output_dir"
  mkdir -p "$debug_output_dir"
fi

if [[ ! -e "$flow_target" ]]; then
  echo "flow path not found: $flow_target" >&2
  exit 1
fi

if ! command -v maestro >/dev/null 2>&1; then
  echo "maestro CLI is not installed or not on PATH" >&2
  echo "Install from Maestro docs: https://docs.maestro.dev/getting-started/installing-maestro" >&2
  exit 1
fi

cmd=(
  maestro
  test
  "$flow_target"
  "--format" "$report_format"
  "--output" "$report_path"
  "--test-output-dir=$artifact_dir"
)

if [[ -n "$include_tags" ]]; then
  cmd+=("--include-tags=$include_tags")
fi

if [[ -n "$debug_output_dir" ]]; then
  cmd+=("--debug-output=$debug_output_dir")
fi

printf 'repo\t%s\n' "$repo"
printf 'flow_target\t%s\n' "$flow_target"
printf 'artifact_dir\t%s\n' "$artifact_dir"
printf 'report_path\t%s\n' "$report_path"
if [[ -n "$debug_output_dir" ]]; then
  printf 'debug_output_dir\t%s\n' "$debug_output_dir"
fi
printf 'command\t'
printf '%q ' "${cmd[@]}"
printf '\n'

if [[ "$dry_run" -eq 1 ]]; then
  exit 0
fi

"${cmd[@]}"
