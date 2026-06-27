---
name: opl-scholarskills
description: "Operate OPL ScholarSkills as a Codex skill pack for repo-tracked scholarly capability modules, standard opl scholar-skills CLI readbacks, refs-only materialized candidate packages, and MAS owner-gated authority boundaries. Use when Codex needs ScholarSkills module guidance without claiming runtime, domain, quality, artifact, owner receipt, or production authority."
---

# OPL ScholarSkills

Use OPL ScholarSkills as a repo-tracked Codex entry for scholarly capability modules. Treat `contracts/scholar-skills-capability-modules.json` as this skill pack's module catalog snapshot. The executable `opl scholar-skills *` CLI and runtime bridge remain owned by OPL Framework.

## Local Install / Discovery

This `opl-scholarskills` repository is the source of truth for the skill pack. The recommended MAS consumption path is a compact local Codex discovery install inside the active paper workspace or runtime quest:

```text
<workspace_root>/.codex/skills/opl-scholarskills/
<quest_root>/.codex/skills/opl-scholarskills/
```

Use OPL Connect to sync that compact install:

```bash
opl connect sync-skills --domain scholarskills --scope workspace --target-workspace <workspace_root> --json
opl connect sync-skills --domain scholarskills --scope quest --target-quest <quest_root> --json
```

The local install is refs-only and authority false. It may include this Skill entry, plugin/module refs, compact gallery review refs, and lightweight manifests needed for discovery and review. Do not copy this whole source repository into a paper directory or quest. Do not copy MAS `outputs/display-pack-gallery/`, render caches, single-figure PNG/SVG/HTML exports, dependency locks, run-context files, or other gallery intermediates into each consuming workspace. Do not treat a MAS program-repo `plugins/opl-scholarskills/` mirror or system Codex registry install as the recommended runtime quest discovery surface.

## Boundary

- Keep the authority false boundary explicit: `can_write_domain_truth: false`, `can_write_runtime_state: false`, `can_mutate_artifact_body: false`, `can_sign_owner_receipt: false`, and `can_create_typed_blocker: false`.
- Use ScholarSkills outputs as refs-only candidates. Do not present CLI readbacks, materialized packages, or tests as runtime-ready, domain-ready, quality verdict, publication readiness, artifact authority, owner receipt, typed blocker, or production readiness.
- Respect the MAS owner gate: MAS or another domain owner must consume candidate refs and issue the owner receipt, typed blocker, reviewer receipt, route-back, or domain artifact mutation. Do not write MAS, Yang, runtime DB, queue, owner receipt, typed blocker, current package authority, publication eval, controller decision, or domain truth surfaces from this skill.

## Modules

The ten OPL ScholarSkills modules are:

- `opl.scholarskills.display` - Scholar Display
- `opl.scholarskills.tables` - Scholar Tables
- `opl.scholarskills.stats` - Scholar Stats
- `opl.scholarskills.omics` - Scholar Omics
- `opl.scholarskills.lit` - Scholar Lit
- `opl.scholarskills.write` - Scholar Write
- `opl.scholarskills.review` - Scholar Review
- `opl.scholarskills.submit` - Scholar Submit
- `opl.scholarskills.data` - Scholar Data
- `opl.scholarskills.intake` - Scholar Intake

## CLI

Use the standard CLI surface:

```bash
opl scholar-skills list --json
opl scholar-skills inspect --module <module_id> --json
opl scholar-skills prepare --module <module_id> --profile <profile> --platform <platform> --requirement-profile <path> --paper-root <path> --json
opl scholar-skills run-context --module <module_id> --profile <profile> --json
opl scholar-skills invoke --module <module_id> --input-ref <ref> --artifact-root <ref> --json
opl scholar-skills receipt --module <module_id> --input-ref <ref> --artifact-root <ref> --json
opl scholar-skills materialize --module <module_id> --input-ref <ref> --artifact-root <ref-or-path> --output-root <path> --json
opl scholar-skills runtime-prepare --module <module_id> --profile <profile> --platform <platform> --requirement-profile <path> --paper-root <path> [--apply] --json
opl scholar-skills runtime-run-context --module <module_id> --profile <profile> --platform <platform> --paper-root <path> --json
opl scholar-skills interfaces --json
opl scholar-skills validate --json
opl scholar-skills doctor --json
```

`materialize` writes a deterministic refs-only `materialized_candidate_package` containing package manifests and an unsigned execution receipt candidate. It must not write artifact bodies or authority surfaces.

## Display Gallery

For `opl.scholarskills.display`, use this repo's compact gallery review package:

- `gallery/medical-display/medical_display_gallery.pdf`
- `gallery/medical-display/medical_display_gallery_reference.md`
- `gallery/medical-display/display_pack_gallery_status.md`
- `gallery/medical-display/display_pack_gallery_quality_audit.md`
- `gallery/medical-display/gallery_manifest.json`
- `gallery/medical-display/gallery_snapshot.json`

The package is copied from MAS Display Pack final docs/gallery surfaces for direct human review. Treat these refs as human review and visual-audit preview refs only. They do not prove publication readiness, owner acceptance, artifact authority, or paper truth. Local workspace and quest installs should copy only these compact review refs when needed, not the gallery build workspace or intermediate outputs. MAS remains the owner for medical display truth, actual figure artifacts, visual audit receipts, and publication gates.

## Display Quality Floor

For scientific figures, including data evidence figures, page-level composite figures, graphical abstracts, and other design-led display work, apply `scholarskills_scientific_figure_quality_floor.v1`. Do not reuse the current gallery `submission_graphical_abstract` as a final template. Treat it as a lower-bound design shell only.

Use `Scholar Display` policy `brief_first_reference_guided_ai_candidate_not_single_template_reuse` for graphical abstracts, and the same brief/reference/candidate/critic discipline as the general refs-only scientific figure quality-floor workflow:

1. Start from the paper-local core claim, evidence chain, figure contract, target audience, journal/export needs, and forbidden claim drift.
2. Select or cite style references, then produce a style brief. A reference is a visual target, not data truth, claim authority, or a template authority.
3. Let the AI executor choose the suitable figure form, layout, panel hierarchy, renderer, and candidate count. The skill raises the lower bound; it must not cap the upper bound.
4. Require candidate refs for `core_claim_and_evidence_chain_ref`, `figure_contract_ref`, `reference_selection_ref`, `style_brief_ref`, `candidate_artifact_ref`, `critic_review_ref`, `final_size_inspection_ref`, `source_preservation_ref`, and `domain_owner_gate_ref`.
5. Run an AI/VLM or human visual critic pass before owner consumption. The critic should check semantic claim fit, reference-style adherence, label readability at final size, overlap, panel hierarchy, visual drift, and source/evidence preservation.

This policy adapts current external patterns from `scientific-agent-skills`, `nature-skills`, `PaperVizAgent` / `PaperBanana`, `FigMirror`, and a minimal scientific plotting skill. It does not install those runtimes, import their agents, or authorize publication readiness. MAS or the consuming domain owner still decides accept / reject / route-back.
