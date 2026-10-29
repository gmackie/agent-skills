#!/usr/bin/env bash
set -euo pipefail

script_repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
repo_root="$(cd "${1:-$script_repo_root}" && pwd)"
cd "$repo_root"

violations="$(perl -Mutf8 -CSDA -ne '
  sub strip_inline_code {
    my ($line) = @_;
    my $output = ""; my $cursor = 0; my $length = length($line);
    while ($cursor < $length) {
      my $opener_start = index($line, "`", $cursor);
      if ($opener_start < 0) { $output .= substr($line, $cursor); last; }
      my $opener_end = $opener_start;
      $opener_end++ while $opener_end < $length && substr($line, $opener_end, 1) eq "`";
      my $delimiter_length = $opener_end - $opener_start;
      my $search = $opener_end; my $closer_end = -1;
      while ($search < $length) {
        my $run_start = index($line, "`", $search); last if $run_start < 0;
        my $run_end = $run_start;
        $run_end++ while $run_end < $length && substr($line, $run_end, 1) eq "`";
        if ($run_end - $run_start == $delimiter_length) { $closer_end = $run_end; last; }
        $search = $run_end;
      }
      if ($closer_end < 0) { $output .= substr($line, $cursor); last; }
      $output .= substr($line, $cursor, $opener_start - $cursor);
      $cursor = $closer_end;
    }
    return $output;
  }
  if (!$fence_length && /^\s*(`{3,}|~{3,})/) {
    $marker = $1; $fence_character = substr($marker, 0, 1); $fence_length = length($marker); next;
  }
  if ($fence_length) {
    if (/^\s*(`+|~+)\s*$/) {
      $marker = $1;
      if (substr($marker, 0, 1) eq $fence_character && length($marker) >= $fence_length) {
        $fence_character = ""; $fence_length = 0;
      }
    }
    next;
  }
  {
    $prose = strip_inline_code($_);
    print "$ARGV:$.:$_" if $prose =~ /—|[“”‘’]/;
  }
  if (eof) { close ARGV; $fence_character = ""; $fence_length = 0; }
' skills/*/SKILL.md || true)"

# H1 skill titles are canonical names and may contain proper nouns. Content
# headings from H2 through H6 follow sentence case.
heading_violations=""
if ! heading_check_output="$(node "$script_repo_root/scripts/unslop-headings.mjs" --check "$repo_root" 2>&1)"; then
  heading_violations="$heading_check_output"
fi

if [[ -n "$violations" ]]; then
  printf '%s\n' "$violations"
  printf 'Unslop style check failed: em dashes or curly quotes remain in SKILL.md files.\n' >&2
  exit 1
fi

if [[ -n "$heading_violations" ]]; then
  printf '%s\n' "$heading_violations"
  printf 'Unslop style check failed: title-case headings remain in SKILL.md files.\n' >&2
  exit 1
fi

skill_count="$(find skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')"
printf 'Unslop style check passed for %s skills (H2-H6 sentence case; H1 titles exempt).\n' "$skill_count"
