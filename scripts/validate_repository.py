from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

EXPECTED_CORE_BLOBS = {
    "data/sample/branches.csv": "47ec960373d7f1030d54f6e8883ef1c7e1fd0243",
    "data/sample/categories.csv": "9b9158c65a229042b7a01526b0907ab3920f99b0",
    "data/sample/inventory_monthly.csv": "628cf3fc55bb1ccfa3e5d8843c3318e09fa65fa2",
    "data/sample/products.csv": "43b00643cab114898f7b6406a9506d0373fb3ae0",
    "data/sample/promotions.csv": "6cc26fce0695ea9d02b506094ab943598869e8e0",
    "data/sample/purchase_orders.csv": "508121eb07736726b7d4bb1cfeffcac34cb885b7",
    "data/sample/sales.csv": "519ae971a81bf32df14206fd9daa68b05c1c04fe",
    "data/sample/suppliers.csv": "08b54a7c6208968e22983bfafa639a91114bb66f",
    "data/sample/web_funnel.csv": "40335b1f3dc6fa569604cd6d98270c5c0f15fb4d",
    "docs/validation/EXPECTED_BASELINES.json": "0a81b660fe46c40e77c4d2ba6ce7207f34b3f060",
    "python/validate_portfolio.py": "0ec9b92a9eab2ecac43b8867cb4d13a74379a45d",
    "tests/test_portfolio_data.py": "089ea311ea557c8a4c5f122642d8b1ed7edd1f0f",
    "sql/analytics/03_create_analytics_views.sql": "d30d2b784628a8aea766c4b3a78638d443d687d3",
    "sql/validation/05_data_quality_and_reconciliation.sql": "70b00a2d061015a59ee8933d6248fb46e3d3bd3b",
    "powerbi/PharmacyEcommerceCategoryAnalytics.SemanticModel/definition/model.tmdl": "9a6ca460864a4e4e8c21dc6078b2ea38a12c1545",
    "powerbi/PharmacyEcommerceCategoryAnalytics.SemanticModel/definition/relationships.tmdl": "bcd74562c20781da7152b6f5757cf1103a0b7433",
    "powerbi/PharmacyEcommerceCategoryAnalytics.SemanticModel/definition/tables/_Measures.tmdl": "f0ec680524a47ef381bee2b8c28400dbd683554e",
    "powerbi/PharmacyEcommerceCategoryAnalytics.Report/definition/pages/pages.json": "0c309ba00d5a4df5d86a1d750e37cd2271659db6",
}

EXPECTED_BASELINES = {
    "branch_count": 8,
    "category_count": 6,
    "supplier_count": 6,
    "product_count": 60,
    "sales_rows": 48722,
    "web_rows": 10860,
    "inventory_rows": 2880,
    "purchase_order_rows": 450,
    "net_sales": 4717692.51,
    "gross_margin": 1672360.7,
    "units_sold": 74057,
    "orders": 57348,
}

EXPECTED_PAGES = [
    "5efa60788c897ca2254b",
    "exec002",
    "funnel003",
    "category004",
    "sku005",
    "inventory006",
    "supplier007",
    "promo008",
    "branch009",
]

EXPECTED_VIEWS = [
    "analytics.vw_sales_enriched",
    "analytics.vw_category_scorecard",
    "analytics.vw_ecommerce_funnel",
    "analytics.vw_inventory_risk",
    "analytics.vw_supplier_performance",
    "analytics.vw_assortment_action",
]


def git_blob_sha(path: Path) -> str:
    data = path.read_bytes()
    header = f"blob {len(data)}\0".encode()
    return hashlib.sha1(header + data).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    # Protected analytical core.
    for rel, expected in EXPECTED_CORE_BLOBS.items():
        path = ROOT / rel
        require(path.exists(), f"Missing protected core file: {rel}")
        actual = git_blob_sha(path)
        require(actual == expected, f"Protected core changed: {rel} ({actual} != {expected})")

    # Baseline contract.
    baseline_path = ROOT / "docs/validation/EXPECTED_BASELINES.json"
    actual_baselines = json.loads(baseline_path.read_text(encoding="utf-8"))
    require(actual_baselines == EXPECTED_BASELINES, "Expected baseline contract changed")

    # Presentation/documentation contract.
    required = [
        "README.md",
        "docs/PROJECT_INDEX.md",
        "docs/CASE_STUDY.md",
        "docs/TECHNICAL_WALKTHROUGH.md",
        "docs/PROJECT_EVIDENCE_MAP.md",
        "docs/FINAL_RELEASE_VALIDATION.md",
        "docs/architecture/POWER_BI_TIME_INTELLIGENCE_AUDIT.md",
        "docs/assets/Pharmacy E-Commerce Analytics Pipeline.png",
    ]
    for rel in required:
        require((ROOT / rel).exists(), f"Missing required project file: {rel}")

    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    require("Featured Portfolio" not in readme, "README contains presentation-targeting language")
    require("Primary roles demonstrated" not in readme, "README contains role-targeting language")
    require("## Quick Start" in readme, "README Quick Start missing")
    require("Pharmacy%20E-Commerce%20Analytics%20Pipeline.png" in readme, "README hero asset not linked")

    # SQL view contract.
    sql = (ROOT / "sql/analytics/03_create_analytics_views.sql").read_text(encoding="utf-8")
    for view in EXPECTED_VIEWS:
        require(view in sql, f"Missing analytical view contract: {view}")

    # Power BI structure.
    pages_path = ROOT / "powerbi/PharmacyEcommerceCategoryAnalytics.Report/definition/pages/pages.json"
    pages = json.loads(pages_path.read_text(encoding="utf-8"))
    require(pages.get("pageOrder") == EXPECTED_PAGES, "Power BI page order/count changed")

    visual_count = 0
    pages_root = pages_path.parent
    for page_id in EXPECTED_PAGES:
        page_json = pages_root / page_id / "page.json"
        require(page_json.exists(), f"Missing page.json for {page_id}")
        visuals = pages_root / page_id / "visuals"
        require(visuals.exists(), f"Missing visuals directory for {page_id}")
        visual_count += len([p for p in visuals.iterdir() if p.is_dir()])
    require(visual_count == 62, f"Expected 62 saved visuals, found {visual_count}")

    measures_path = ROOT / "powerbi/PharmacyEcommerceCategoryAnalytics.SemanticModel/definition/tables/_Measures.tmdl"
    measures = measures_path.read_text(encoding="utf-8")
    measure_count = len(re.findall(r"(?m)^\s*measure\s", measures))
    require(measure_count == 22, f"Expected 22 measures, found {measure_count}")

    model = (ROOT / "powerbi/PharmacyEcommerceCategoryAnalytics.SemanticModel/definition/model.tmdl").read_text(encoding="utf-8")
    require("__PBI_TimeIntelligenceEnabled = 1" in model, "Current Auto Date/Time state changed without contract update")
    local_date_refs = len(re.findall(r"ref table LocalDateTable_", model))
    require(local_date_refs == 3, f"Expected 3 LocalDateTable refs, found {local_date_refs}")

    print("PASS | protected analytical core")
    print("PASS | baseline contract")
    print("PASS | documentation/presentation contract")
    print("PASS | 6 analytical SQL views")
    print("PASS | 9 report pages")
    print("PASS | 62 saved visuals")
    print("PASS | 22 explicit DAX measures")
    print("PASS | current Auto Date/Time state documented")
    print("REPOSITORY VALIDATION PASS")


if __name__ == "__main__":
    main()
