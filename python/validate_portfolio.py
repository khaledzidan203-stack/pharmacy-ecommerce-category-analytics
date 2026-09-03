from pathlib import Path
import json
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "sample"
BASELINES = ROOT / "docs" / "validation" / "EXPECTED_BASELINES.json"

def load(name, **kwargs):
    return pd.read_csv(DATA / name, **kwargs)

def assert_zero(name, value):
    if value != 0:
        raise AssertionError(f"{name}: expected 0, got {value}")
    print(f"PASS | {name}: 0")

def main():
    branches = load("branches.csv")
    categories = load("categories.csv")
    suppliers = load("suppliers.csv")
    products = load("products.csv")
    promotions = load("promotions.csv")
    sales = load("sales.csv")
    web = load("web_funnel.csv")
    inventory = load("inventory_monthly.csv")
    po = load("purchase_orders.csv")
    expected = json.loads(BASELINES.read_text())

    # Keys / duplicates
    assert_zero("duplicate branch keys", branches.duplicated(["branch_id"]).sum())
    assert_zero("duplicate category keys", categories.duplicated(["category_id"]).sum())
    assert_zero("duplicate supplier keys", suppliers.duplicated(["supplier_id"]).sum())
    assert_zero("duplicate product keys", products.duplicated(["sku_id"]).sum())
    assert_zero("duplicate sales grain", sales.duplicated(["sales_date","branch_id","sku_id","channel"]).sum())
    assert_zero("duplicate inventory grain", inventory.duplicated(["snapshot_date","branch_id","sku_id"]).sum())
    assert_zero("duplicate web grain", web.duplicated(["activity_date","sku_id"]).sum())

    # Referential integrity
    assert_zero("orphan sales products", (~sales.sku_id.isin(products.sku_id)).sum())
    assert_zero("orphan sales branches", (~sales.branch_id.isin(branches.branch_id)).sum())
    assert_zero("orphan product suppliers", (~products.supplier_id.isin(suppliers.supplier_id)).sum())
    assert_zero("orphan product categories", (~products.category_id.isin(categories.category_id)).sum())
    assert_zero("orphan inventory products", (~inventory.sku_id.isin(products.sku_id)).sum())

    # Commercial arithmetic
    arithmetic_diff = (sales.net_sales - (sales.gross_sales - sales.discount_value)).abs()
    assert_zero("sales arithmetic errors", int((arithmetic_diff > 0.01).sum()))
    assert_zero("negative net sales", int((sales.net_sales < 0).sum()))
    assert_zero("negative cost", int((sales.cost_value < 0).sum()))
    assert_zero("negative inventory", int((inventory.stock_units < 0).sum()))
    assert_zero("invalid purchase order quantities", int(((po.received_qty < 0) | (po.received_qty > po.ordered_qty) | (po.ordered_qty <= 0)).sum()))

    # Funnel integrity
    assert_zero("add-to-cart exceeds PDP views", int((web.add_to_cart > web.product_detail_views).sum()))
    assert_zero("online orders exceed add-to-cart", int((web.online_orders > web.add_to_cart).sum()))

    actual = {
        "branch_count": len(branches),
        "category_count": len(categories),
        "supplier_count": len(suppliers),
        "product_count": len(products),
        "sales_rows": len(sales),
        "web_rows": len(web),
        "inventory_rows": len(inventory),
        "purchase_order_rows": len(po),
        "net_sales": round(float(sales.net_sales.sum()), 2),
        "gross_margin": round(float((sales.net_sales-sales.cost_value).sum()), 2),
        "units_sold": int(sales.units_sold.sum()),
        "orders": int(sales.orders.sum()),
    }
    if actual != expected:
        raise AssertionError(f"Baseline mismatch\nExpected: {expected}\nActual:   {actual}")

    print("PASS | baseline reconciliation")
    print(json.dumps(actual, indent=2))
    print("VALIDATION PASS")

if __name__ == "__main__":
    main()
