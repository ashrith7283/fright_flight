---
name: next-proposal
description: Draft and print the prompt for the next OpenSpec change, based on openspec/project.md and what is already implemented. Slash-command only (/next-proposal).
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Bash(git log:*), Bash(git status:*), Bash(ls:*), Bash(openspec list:*)
---

Draft the prompt the user will paste to start the next OpenSpec change, then print it. This skill is read-only: do not edit files, create changes, or run the propose workflow. The user reviews the prompt first and runs `/opsx:propose` themselves.

## 1. Gather state

Read these, in this order:

1. `openspec/project.md`: purpose, platform scope, conventions, ads policy, testing, release rules, non-goals, and above all the **Roadmap** list of changes.
2. `openspec/changes/archive/`: directory names (`YYYY-MM-DD-<name>`) are the changes already finished. Also check `openspec/changes/` for any active, unarchived change (it is the "next" one, so say so instead of drafting a new prompt).
3. `openspec/specs/*/spec.md`: what is actually specified today. Skim requirement headings, not every scenario.
4. `git log --oneline -20` and `git status --short`: confirm the implemented state, and catch work that is committed but not archived or uncommitted.
5. Only if needed to judge scope: skim `lib/` and `pubspec.yaml` (e.g. to see which services and packages exist).

## 2. Pick the next change

Match archived changes against the roadmap, in roadmap order. The next change is the first roadmap item with no archived counterpart.

Archived changes that are not on the roadmap (for example `landscape-ellipse-clouds`) are follow-ups that were inserted along the way. They don't count as roadmap items, but they do change what exists, so account for them in the prompt's context.

Handle the odd cases explicitly rather than guessing:
- Roadmap exhausted: say so and suggest candidates drawn from project.md (deferred items, testing gaps, release checklist).
- An active unarchived change exists: report it and suggest apply/archive instead of a new proposal.
- Ambiguous state (uncommitted work, partially matching names): name the ambiguity and state which interpretation you used.

## 3. Write the prompt

The prompt must be self-contained, because it's pasted into a fresh session with no memory of this one. Make it specific to what the repo has now, not a generic restatement of the roadmap line. Include:

- **Change name** in kebab-case, matching the roadmap name.
- **Goal**: one or two sentences on what the change delivers and why it comes next.
- **Starting point**: what is already built that this change builds on (existing specs, services, screens), so the proposal doesn't redo or contradict it.
- **Scope**: concrete in-scope items taken from the roadmap entry and relevant project.md sections (ads policy for `ads`, release rules for release changes, and so on).
- **Out of scope**: the neighbouring roadmap items and the relevant non-goals, to keep the change reviewable in one sitting.
- **Constraints to respect**: only those that matter here, such as Android-only, `GameConfig` for tuning values, logic separable from Flame, the testing expectations, and the dart format / analyze / test gate.
- **Open questions**: anything project.md leaves unresolved that the proposal should ask about before assuming (e.g. package id, app name, state-management choice).
- Note any timing dependency from the roadmap (for example the 14-day closed-test clock after `release-readiness-min`).

Keep it proportionate: roughly 150-300 words. The proposal workflow generates the detailed artifacts, so the prompt should steer it, not pre-write the design.

## 4. Print it

Output in this shape, and nothing beyond it:

1. One line stating where the project stands: what is archived, and which roadmap item is next.
2. The prompt inside a single fenced code block, starting with `/opsx:propose <change-name>` followed by the body, so it can be copied as one unit.
3. A short list of assumptions or ambiguities, only if there were any.

Stop there. Do not start the proposal.
