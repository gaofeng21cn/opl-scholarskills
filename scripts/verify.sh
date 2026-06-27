#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 - <<'PY'
import hashlib
import json
import pathlib
import re
import sys

root = pathlib.Path.cwd()

def fail(message: str) -> None:
    print(f"verify failed: {message}", file=sys.stderr)
    sys.exit(1)

def read_json(relative: str):
    path = root / relative
    if not path.is_file():
        fail(f"missing {relative}")
    return json.loads(path.read_text(encoding="utf-8"))

def read_text(relative: str) -> str:
    path = root / relative
    if not path.is_file():
        fail(f"missing {relative}")
    return path.read_text(encoding="utf-8")

def sha256_file(relative: str) -> str:
    h = hashlib.sha256()
    with (root / relative).open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

manifest = read_json(".codex-plugin/plugin.json")
if manifest.get("name") != "opl-scholarskills":
    fail("plugin name must be opl-scholarskills")
if manifest.get("skills") != "./skills/":
    fail("plugin skills path must be ./skills/")
if manifest.get("interface", {}).get("displayName") != "OPL ScholarSkills":
    fail("plugin displayName must be OPL ScholarSkills")

skill = read_text("skills/opl-scholarskills/SKILL.md")
if not re.search(r"^---\n[\s\S]*?^name:\s+opl-scholarskills$", skill, re.MULTILINE):
    fail("SKILL.md frontmatter must expose name: opl-scholarskills")

contract = read_json("contracts/scholar-skills-capability-modules.json")
modules = contract.get("modules")
if not isinstance(modules, list) or len(modules) != 10:
    fail("contract must contain exactly 10 ScholarSkills modules")
for module in modules:
    module_id = module.get("module_id")
    display_name = module.get("display_name")
    if not module_id or module_id not in skill:
        fail(f"SKILL.md missing module id {module_id}")
    if not display_name or display_name not in skill:
        fail(f"SKILL.md missing display name {display_name}")
    boundary = module.get("authority_boundary", {})
    for key in [
        "can_write_domain_truth",
        "can_write_runtime_state",
        "can_mutate_artifact_body",
        "can_sign_owner_receipt",
        "can_create_typed_blocker",
    ]:
        if boundary.get(key) is not False:
            fail(f"{module_id} authority flag {key} must be false")

for token in [
    "authority false",
    "MAS owner gate",
    "refs-only",
    "materialized_candidate_package",
    "gallery/medical-display/medical_display_gallery.pdf",
    "brief_first_reference_guided_ai_candidate_not_single_template_reuse",
    "critic_review_ref",
]:
    if token not in skill:
        fail(f"SKILL.md missing required token: {token}")

gallery_manifest = read_json("gallery/medical-display/gallery_manifest.json")
snapshot = read_json("gallery/medical-display/gallery_snapshot.json")
display_module = next(
    (item for item in modules if item.get("module_id") == "opl.scholarskills.display"),
    None,
)
if display_module is None:
    fail("contract missing Display module")
display_quality_floor = display_module.get("display_quality_floor_policy", {})
if display_quality_floor.get("graphical_abstract_strategy") != "brief_first_reference_guided_ai_candidate_not_single_template_reuse":
    fail("Display graphical abstract strategy must avoid single-template reuse")
if display_quality_floor.get("current_gallery_graphical_abstract_status") != "lower_bound_design_shell_not_reusable_template_authority":
    fail("Display graphical abstract gallery status must be lower-bound only")
minimum_candidate_refs = set(display_quality_floor.get("minimum_candidate_refs") or [])
for ref in [
    "core_claim_and_evidence_chain_ref",
    "figure_contract_ref",
    "reference_selection_ref",
    "style_brief_ref",
    "critic_review_ref",
    "final_size_inspection_ref",
    "domain_owner_gate_ref",
]:
    if ref not in minimum_candidate_refs:
        fail(f"Display quality floor missing minimum candidate ref {ref}")
external_learning_sources = {
    item.get("source") for item in display_quality_floor.get("external_learning_refs") or []
}
for source in [
    "K-Dense-AI/scientific-agent-skills",
    "Yuan1z0825/nature-skills",
    "google-research/papervizagent",
    "dwzhu-pku/PaperBanana",
    "VILA-Lab/FigMirror",
    "dazhiyang/scientific-plotting-skill",
]:
    if source not in external_learning_sources:
        fail(f"Display quality floor missing external learning source {source}")
if gallery_manifest.get("status") != "rendered":
    fail("gallery manifest status must be rendered")
expected_counts = {
    "visual_gallery_template_count": 37,
    "evidence_gallery_template_count": 34,
    "composition_recipe_gallery_count": 6,
}
for key, expected in expected_counts.items():
    if gallery_manifest.get(key) != expected:
        fail(f"gallery manifest {key} must be {expected}")
    if snapshot.get(key) != expected:
        fail(f"gallery snapshot {key} must be {expected}")
renderer_policy = gallery_manifest.get("renderer_policy_completion", {})
if renderer_policy.get("current_r_ggplot2_evidence_template_count") != 34:
    fail("gallery must keep 34 current R/ggplot2 evidence templates")
if renderer_policy.get("current_python_evidence_template_count") != 0:
    fail("gallery must keep current Python evidence templates at 0")
quality_summary = gallery_manifest.get("quality_summary", {})
if quality_summary.get("publication_ready_claim_authorized") is not False:
    fail("gallery must not authorize publication-ready claims")
if snapshot.get("publication_ready_claim_authorized") is not False:
    fail("snapshot must not authorize publication-ready claims")

for item in snapshot.get("included_files", []):
    relative = "gallery/medical-display/" + item["path"]
    actual = sha256_file(relative)
    if actual != item["sha256"]:
        fail(f"sha256 mismatch for {relative}: {actual} != {item['sha256']}")

required_gallery_files = [
    "gallery/medical-display/medical_display_gallery.pdf",
    "gallery/medical-display/gallery_manifest.json",
    "gallery/medical-display/medical_display_gallery_reference.md",
    "gallery/medical-display/display_pack_gallery_status.md",
    "gallery/medical-display/display_pack_gallery_quality_audit.md",
    "gallery/medical-display/gallery_snapshot.json",
]
for relative in required_gallery_files:
    if not (root / relative).is_file():
        fail(f"missing gallery file {relative}")

for forbidden in [
    "outputs/display-pack-gallery",
    "gallery/medical-display/medical_display_gallery_assets",
    "gallery/medical-display/render-cache",
]:
    if (root / forbidden).exists():
        fail(f"forbidden intermediate output present: {forbidden}")

gitignore = read_text(".gitignore")
for pattern in [
    "outputs/",
    "render-cache/",
    "gallery/**/assets/",
    "gallery/**/*.png",
    "gallery/**/*.svg",
    "gallery/**/*.html",
    "gallery/**/*.sidecar.json",
    "gallery/**/*.layout.json",
]:
    if pattern not in gitignore:
        fail(f".gitignore missing intermediate-output pattern {pattern}")

for relative in ["README.md", "README.zh-CN.md", "AGENTS.md", "TASTE.md"]:
    text = read_text(relative)
    lower = text.lower()
    if "publication ready" not in lower and "publication-ready" not in lower and "publication readiness" not in lower:
        fail(f"{relative} must mention publication readiness boundary")

print("verify ok: opl-scholarskills plugin, contract, gallery package, and no-authority boundaries are valid")
PY
