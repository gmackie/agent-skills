#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

retrospective_skill="$root/skills/llm-session-retrospective/SKILL.md"
retrospective_metadata="$root/skills/llm-session-retrospective/skill.json"
retrospective_script="$root/skills/llm-session-retrospective/scripts/discover-retrospective-context.sh"
retrospective_reference="$root/skills/llm-session-retrospective/references/output-template.md"

x402_skill="$root/skills/x402-smol-agent-workflow/SKILL.md"
x402_metadata="$root/skills/x402-smol-agent-workflow/skill.json"
catalog_skill="$root/skills/agent-skills-catalog-maintenance/SKILL.md"
catalog_metadata="$root/skills/agent-skills-catalog-maintenance/skill.json"
catalog_script="$root/skills/agent-skills-catalog-maintenance/scripts/generate-catalog-snapshot.sh"
context_skill="$root/skills/local-agent-context-discovery/SKILL.md"
context_metadata="$root/skills/local-agent-context-discovery/skill.json"
context_script="$root/skills/local-agent-context-discovery/scripts/discover-local-agent-context.sh"
maestro_skill="$root/skills/maestro-qa-report/SKILL.md"
maestro_metadata="$root/skills/maestro-qa-report/skill.json"
maestro_script="$root/skills/maestro-qa-report/scripts/run-maestro-qa-report.sh"
maestro_reference="$root/skills/maestro-qa-report/references/report-template.md"
maestro_fix_skill="$root/skills/maestro-qa/SKILL.md"
maestro_fix_metadata="$root/skills/maestro-qa/skill.json"
maestro_fix_script="$root/skills/maestro-qa/scripts/run-maestro-qa.sh"
release_skill="$root/skills/react-native-expo-release-readiness/SKILL.md"
release_metadata="$root/skills/react-native-expo-release-readiness/skill.json"
release_script="$root/skills/react-native-expo-release-readiness/scripts/plan-release-readiness.sh"
release_reference="$root/skills/react-native-expo-release-readiness/references/readiness-template.md"
opennext_skill="$root/skills/nextjs-cloudflare-opennext/SKILL.md"
opennext_metadata="$root/skills/nextjs-cloudflare-opennext/skill.json"
opennext_script="$root/skills/nextjs-cloudflare-opennext/scripts/plan-opennext-adoption.sh"
opennext_reference="$root/skills/nextjs-cloudflare-opennext/references/adoption-checklist.md"
bindings_skill="$root/skills/cloudflare-workers-bindings-local-dev/SKILL.md"
bindings_metadata="$root/skills/cloudflare-workers-bindings-local-dev/skill.json"
bindings_script="$root/skills/cloudflare-workers-bindings-local-dev/scripts/inspect-cloudflare-bindings.sh"
bindings_reference="$root/skills/cloudflare-workers-bindings-local-dev/references/local-dev-checklist.md"
d1_skill="$root/skills/cloudflare-d1-development/SKILL.md"
d1_metadata="$root/skills/cloudflare-d1-development/skill.json"
d1_script="$root/skills/cloudflare-d1-development/scripts/inspect-d1-development.sh"
d1_reference="$root/skills/cloudflare-d1-development/references/d1-checklist.md"
vinext_hardening_skill="$root/skills/vinext-cloudflare-hardening/SKILL.md"
vinext_hardening_metadata="$root/skills/vinext-cloudflare-hardening/skill.json"
vinext_hardening_script="$root/skills/vinext-cloudflare-hardening/scripts/inspect-vinext-cloudflare.sh"
vinext_hardening_reference="$root/skills/vinext-cloudflare-hardening/references/hardening-checklist.md"
sentry_skill="$root/skills/sentry-release-triage/SKILL.md"
sentry_metadata="$root/skills/sentry-release-triage/skill.json"
sentry_script="$root/skills/sentry-release-triage/scripts/inspect-sentry-surface.sh"
sentry_reference="$root/skills/sentry-release-triage/references/triage-checklist.md"
posthog_skill="$root/skills/posthog-product-instrumentation/SKILL.md"
posthog_metadata="$root/skills/posthog-product-instrumentation/skill.json"
posthog_script="$root/skills/posthog-product-instrumentation/scripts/inspect-posthog-surface.sh"
posthog_reference="$root/skills/posthog-product-instrumentation/references/instrumentation-checklist.md"
hetzner_skill="$root/skills/hetzner-cloud-ops/SKILL.md"
hetzner_metadata="$root/skills/hetzner-cloud-ops/skill.json"
hetzner_script="$root/skills/hetzner-cloud-ops/scripts/inspect-hetzner-surface.sh"
hetzner_reference="$root/skills/hetzner-cloud-ops/references/ops-checklist.md"
namecheap_skill="$root/skills/namecheap-domain-dns-ops/SKILL.md"
namecheap_metadata="$root/skills/namecheap-domain-dns-ops/skill.json"
namecheap_script="$root/skills/namecheap-domain-dns-ops/scripts/inspect-domain-dns-surface.sh"
namecheap_reference="$root/skills/namecheap-domain-dns-ops/references/dns-ops-checklist.md"

test -f "$retrospective_skill"
test -f "$retrospective_metadata"
test -f "$retrospective_script"
test -f "$retrospective_reference"
test -f "$x402_skill"
test -f "$x402_metadata"
test -f "$catalog_skill"
test -f "$catalog_metadata"
test -f "$catalog_script"
test -f "$context_skill"
test -f "$context_metadata"
test -f "$context_script"
test -f "$maestro_skill"
test -f "$maestro_metadata"
test -f "$maestro_script"
test -f "$maestro_reference"
test -f "$maestro_fix_skill"
test -f "$maestro_fix_metadata"
test -f "$maestro_fix_script"
test -f "$release_skill"
test -f "$release_metadata"
test -f "$release_script"
test -f "$release_reference"
test -f "$opennext_skill"
test -f "$opennext_metadata"
test -f "$opennext_script"
test -f "$opennext_reference"
test -f "$bindings_skill"
test -f "$bindings_metadata"
test -f "$bindings_script"
test -f "$bindings_reference"
test -f "$d1_skill"
test -f "$d1_metadata"
test -f "$d1_script"
test -f "$d1_reference"
test -f "$vinext_hardening_skill"
test -f "$vinext_hardening_metadata"
test -f "$vinext_hardening_script"
test -f "$vinext_hardening_reference"
test -f "$sentry_skill"
test -f "$sentry_metadata"
test -f "$sentry_script"
test -f "$sentry_reference"
test -f "$posthog_skill"
test -f "$posthog_metadata"
test -f "$posthog_script"
test -f "$posthog_reference"
test -f "$hetzner_skill"
test -f "$hetzner_metadata"
test -f "$hetzner_script"
test -f "$hetzner_reference"
test -f "$namecheap_skill"
test -f "$namecheap_metadata"
test -f "$namecheap_script"
test -f "$namecheap_reference"

grep -q '^name: llm-session-retrospective$' "$retrospective_skill"
grep -q '^name: x402-smol-agent-workflow$' "$x402_skill"
grep -q '^name: agent-skills-catalog-maintenance$' "$catalog_skill"
grep -q '^name: local-agent-context-discovery$' "$context_skill"
grep -q '^name: maestro-qa-report$' "$maestro_skill"
grep -q '^name: maestro-qa$' "$maestro_fix_skill"
grep -q '^name: react-native-expo-release-readiness$' "$release_skill"
grep -q '^name: nextjs-cloudflare-opennext$' "$opennext_skill"
grep -q '^name: cloudflare-workers-bindings-local-dev$' "$bindings_skill"
grep -q '^name: cloudflare-d1-development$' "$d1_skill"
grep -q '^name: vinext-cloudflare-hardening$' "$vinext_hardening_skill"
grep -q '^name: sentry-release-triage$' "$sentry_skill"
grep -q '^name: posthog-product-instrumentation$' "$posthog_skill"
grep -q '^name: hetzner-cloud-ops$' "$hetzner_skill"
grep -q '^name: namecheap-domain-dns-ops$' "$namecheap_skill"

jq -e '.id == "llm-session-retrospective" and .kind == "skill"' "$retrospective_metadata" >/dev/null
jq -e '.id == "x402-smol-agent-workflow" and .kind == "skill"' "$x402_metadata" >/dev/null
jq -e '.id == "agent-skills-catalog-maintenance" and .kind == "skill"' "$catalog_metadata" >/dev/null
jq -e '.id == "local-agent-context-discovery" and .kind == "skill"' "$context_metadata" >/dev/null
jq -e '.id == "maestro-qa-report" and .kind == "skill"' "$maestro_metadata" >/dev/null
jq -e '.id == "maestro-qa" and .kind == "skill"' "$maestro_fix_metadata" >/dev/null
jq -e '.id == "react-native-expo-release-readiness" and .kind == "skill"' "$release_metadata" >/dev/null
jq -e '.id == "nextjs-cloudflare-opennext" and .kind == "skill"' "$opennext_metadata" >/dev/null
jq -e '.id == "cloudflare-workers-bindings-local-dev" and .kind == "skill"' "$bindings_metadata" >/dev/null
jq -e '.id == "cloudflare-d1-development" and .kind == "skill"' "$d1_metadata" >/dev/null
jq -e '.id == "vinext-cloudflare-hardening" and .kind == "skill"' "$vinext_hardening_metadata" >/dev/null
jq -e '.id == "sentry-release-triage" and .kind == "skill"' "$sentry_metadata" >/dev/null
jq -e '.id == "posthog-product-instrumentation" and .kind == "skill"' "$posthog_metadata" >/dev/null
jq -e '.id == "hetzner-cloud-ops" and .kind == "skill"' "$hetzner_metadata" >/dev/null
jq -e '.id == "namecheap-domain-dns-ops" and .kind == "skill"' "$namecheap_metadata" >/dev/null

"$retrospective_script" /Volumes/dev/agent-skills >/dev/null
"$catalog_script" /Volumes/dev/agent-skills >/dev/null
"$context_script" /Volumes/dev/agent-skills >/dev/null
"$maestro_script" --help >/dev/null
"$maestro_fix_script" --help >/dev/null
"$release_script" --help >/dev/null
"$opennext_script" --help >/dev/null
"$bindings_script" --help >/dev/null
"$d1_script" --help >/dev/null
"$vinext_hardening_script" --help >/dev/null
"$sentry_script" --help >/dev/null
"$posthog_script" --help >/dev/null
"$hetzner_script" --help >/dev/null
"$namecheap_script" --help >/dev/null
