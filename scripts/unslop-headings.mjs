#!/usr/bin/env node
import { readFile, readdir, writeFile } from "node:fs/promises";
import { resolve } from "node:path";

const arguments_ = process.argv.slice(2);
const checkOnly = arguments_.includes("--check");
const repositoryArgument = arguments_.find((argument) => argument !== "--check");
const repositoryRoot = resolve(repositoryArgument ?? resolve(import.meta.dirname, ".."));
const skillsRoot = resolve(repositoryRoot, "skills");

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function lowerWord(word) {
  const acronymCompound = word.match(/^([A-Z]{2,})([-/])(.+)$/);
  if (acronymCompound) {
    return `${acronymCompound[1]}${acronymCompound[2]}${acronymCompound[3].toLowerCase()}`;
  }
  if (
    /^`.*`$/.test(word) ||
    /^[A-Z0-9]+(?:[/+.-][A-Z0-9]+)*$/.test(word) ||
    /[a-z][A-Z]/.test(word)
  ) {
    return word;
  }
  return word.toLowerCase();
}

function protectInlineCode(value) {
  const spans = [];
  let result = "";
  let cursor = 0;

  while (cursor < value.length) {
    const openerStart = value.indexOf("`", cursor);
    if (openerStart === -1) {
      result += value.slice(cursor);
      break;
    }

    let openerEnd = openerStart;
    while (value[openerEnd] === "`") openerEnd += 1;
    const delimiterLength = openerEnd - openerStart;
    let search = openerEnd;
    let closerEnd = -1;

    while (search < value.length) {
      const runStart = value.indexOf("`", search);
      if (runStart === -1) break;
      let runEnd = runStart;
      while (value[runEnd] === "`") runEnd += 1;
      if (runEnd - runStart === delimiterLength) {
        closerEnd = runEnd;
        break;
      }
      search = runEnd;
    }

    if (closerEnd === -1) {
      result += value.slice(cursor);
      break;
    }

    result += value.slice(cursor, openerStart);
    result += `\uE000${spans.length}\uE001`;
    spans.push(value.slice(openerStart, closerEnd));
    cursor = closerEnd;
  }

  return { result, spans };
}

function sentenceCaseHeading(heading) {
  const { result: protectedHeading, spans: codeSpans } = protectInlineCode(heading);
  const words = protectedHeading.split(/(\s+)/);
  let firstWordSeen = false;
  let result = words
    .map((word) => {
      if (/^\s+$/.test(word)) return word;
      if (!firstWordSeen) {
        firstWordSeen = true;
        if (!word.includes("-")) return word;
        const [first, ...rest] = word.split("-");
        return [first, ...rest.map(lowerWord)].join("-");
      }
      return lowerWord(word);
    })
    .join("");

  result = result.replace(/^(\d+[a-z]?\.\s+)([a-z])/, (_, prefix, letter) => `${prefix}${letter.toUpperCase()}`);
  result = result.replace(/^((?:Phase|Section)\s+)([a-z])(?=:)/, (_, prefix, letter) => `${prefix}${letter.toUpperCase()}`);
  result = result.replace(/^((?:Step|Phase)\s+(?:\d+[a-z]?|[a-z])[\s.,:-]+)([a-z])/, (_, prefix, letter) => `${prefix}${letter.toUpperCase()}`);
  result = result.replace(/([.!?]\s+)([a-z])/g, (_, prefix, letter) => `${prefix}${letter.toUpperCase()}`);

  const canonicalTerms = new Map([
    ["adr", "ADR"],
    ["adrs", "ADRs"],
    ["ai", "AI"],
    ["api", "API"],
    ["cloudflare", "Cloudflare"],
    ["d1", "D1"],
    ["diátaxis", "Diátaxis"],
    ["dns", "DNS"],
    ["eas", "EAS"],
    ["expo", "Expo"],
    ["google", "Google"],
    ["hetzner", "Hetzner"],
    ["hitl", "HITL"],
    ["html", "HTML"],
    ["http", "HTTP"],
    ["json", "JSON"],
    ["husky", "Husky"],
    ["mcp", "MCP"],
    ["namecheap", "Namecheap"],
    ["pr", "PR"],
    ["qa", "QA"],
    ["react", "React"],
    ["redux", "Redux"],
    ["saas", "SaaS"],
    ["sdk", "SDK"],
    ["sentry", "Sentry"],
    ["sql", "SQL"],
    ["ste", "STE"],
    ["tld", "TLD"],
    ["tailwind", "Tailwind"],
    ["turborepo", "Turborepo"],
    ["tui", "TUI"],
    ["typescript", "TypeScript"],
    ["ui", "UI"],
    ["unity", "Unity"],
    ["url", "URL"],
    ["wifi", "WiFi"],
    ["worker", "Worker"],
  ]);
  for (const [plain, canonical] of canonicalTerms) {
    const boundary = "\\p{L}\\p{N}_/+.:-";
    result = result.replace(
      new RegExp(`(?<![${boundary}])${escapeRegExp(plain)}(?![${boundary}])`, "giu"),
      canonical,
    );
  }
  result = result.replace(/\bcontext\.md\b/gi, "CONTEXT.md");
  result = result.replace(/\bnext\.js\b/gi, "Next.js");
  result = result.replace(/\bglobal english\b/gi, "Global English");
  return result.replace(/\uE000(\d+)\uE001/g, (_, index) => codeSpans[Number(index)]);
}

function sentenceCaseContentHeadings(source) {
  let fenceCharacter = "";
  let fenceLength = 0;

  return source
    .split("\n")
    .map((line) => {
      if (!fenceLength) {
        const opener = line.match(/^\s*(`{3,}|~{3,})/);
        if (opener) {
          fenceCharacter = opener[1][0];
          fenceLength = opener[1].length;
          return line;
        }
      } else {
        const closer = line.match(/^\s*(`+|~+)\s*$/);
        if (closer && closer[1][0] === fenceCharacter && closer[1].length >= fenceLength) {
          fenceCharacter = "";
          fenceLength = 0;
        }
        return line;
      }

      return line.replace(/^(#{2,6}) (.+)$/, (_, hashes, heading) => `${hashes} ${sentenceCaseHeading(heading)}`);
    })
    .join("\n");
}

let changedFiles = 0;
const changedSkillPaths = [];
for (const entry of await readdir(skillsRoot, { withFileTypes: true })) {
  if (!entry.isDirectory()) continue;
  const skillPath = resolve(skillsRoot, entry.name, "SKILL.md");
  let source;
  try {
    source = await readFile(skillPath, "utf8");
  } catch {
    continue;
  }
  const updated = sentenceCaseContentHeadings(source);
  if (updated === source) continue;
  if (!checkOnly) await writeFile(skillPath, updated, "utf8");
  changedFiles += 1;
  changedSkillPaths.push(`skills/${entry.name}/SKILL.md`);
}

if (checkOnly && changedFiles > 0) {
  process.stderr.write(`Sentence-case check failed for ${changedFiles} skill files:\n${changedSkillPaths.join("\n")}\n`);
  process.exitCode = 1;
} else {
  process.stdout.write(`Sentence-cased headings in ${changedFiles} skill files.\n`);
}
