from pathlib import Path
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "sample"
OUT = ROOT / "docs" / "insights"

def main():
    sales = pd.read_csv(DATA/"sales.csv", parse_dates=["sales_date"])
    products = pd.read_csv(DATA/"products.csv")
    categories = pd.read_csv(DATA/"categories.csv")
    inventory = pd.read_csv(DATA/"inventory_monthly.csv", parse_dates=["snapshot_date","expiry_date"])
    web = pd.read_csv(DATA/"web_funnel.csv", parse_dates=["activity_date"])
    po = pd.read_csv(DATA/"purchase_orders.csv", parse_dates=["order_date","expected_date","received_date"])
    suppliers = pd.read_csv(DATA/"suppliers.csv")

    s = sales.merge(products, on="sku_id", validate="many_to_one").merge(categories, on="category_id", validate="many_to_one")
    s["gross_margin"] = s["net_sales"] - s["cost_value"]

    category = s.groupby(["category_id","category_name"], as_index=False).agg(
        net_sales=("net_sales","sum"),
        gross_margin=("gross_margin","sum"),
        units=("units_sold","sum"),
        orders=("orders","sum"),
    )
    category["margin_pct"] = np.where(category.net_sales!=0, category.gross_margin/category.net_sales, np.nan)
    category = category.sort_values("net_sales", ascending=False)

    latest = inventory[inventory.snapshot_date==inventory.snapshot_date.max()].merge(products[["sku_id","category_id","unit_cost"]], on="sku_id", validate="many_to_one")
    latest["near_expiry_units"] = np.where((latest.expiry_date-latest.snapshot_date).dt.days <= 90, latest.stock_units, 0)

    wf = web.merge(products[["sku_id","category_id"]], on="sku_id", validate="many_to_one")
    funnel = wf.groupby("category_id", as_index=False).agg(
        pdp_views=("product_detail_views","sum"),
        add_to_cart=("add_to_cart","sum"),
        online_orders=("online_orders","sum"),
    )
    funnel["atc_rate"] = np.where(funnel.pdp_views!=0, funnel.add_to_cart/funnel.pdp_views, np.nan)
    funnel["conversion_rate"] = np.where(funnel.pdp_views!=0, funnel.online_orders/funnel.pdp_views, np.nan)

    po2 = po.merge(suppliers, on="supplier_id", validate="many_to_one")
    po2["fill_rate"] = po2.received_qty/po2.ordered_qty
    po2["lead_time_days"] = (po2.received_date-po2.order_date).dt.days

    lines = ["# Python Analytical Findings", ""]
    top = category.iloc[0]
    lines.append(f"- Top category by net sales: **{top.category_name}** ({top.net_sales:,.2f} SAR).")
    lines.append(f"- Portfolio net sales: **{s.net_sales.sum():,.2f} SAR**; gross margin: **{s.gross_margin.sum():,.2f} SAR**.")
    lines.append(f"- Latest stock cost: **{latest.stock_cost.sum():,.2f} SAR**; near-expiry units within 90 days: **{int(latest.near_expiry_units.sum()):,}**.")
    best_conv = funnel.sort_values("conversion_rate", ascending=False).iloc[0]
    cname = categories.loc[categories.category_id==best_conv.category_id,"category_name"].iloc[0]
    lines.append(f"- Highest e-commerce PDP-to-order conversion category: **{cname}** ({best_conv.conversion_rate:.2%}).")
    lines.append(f"- Average PO fill rate: **{po2.fill_rate.mean():.2%}**; average actual lead time: **{po2.lead_time_days.mean():.1f} days**.")
    lines.append("")
    lines.append("> Findings are descriptive and based only on synthetic portfolio data. They do not imply causal relationships.")
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT/"python_findings.md").write_text("\n".join(lines), encoding="utf-8")
    print("\n".join(lines))

if __name__ == "__main__":
    main()
