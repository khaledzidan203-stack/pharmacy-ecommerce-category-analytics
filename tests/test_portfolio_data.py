from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT/"data"/"sample"

def test_sales_grain_unique():
    s=pd.read_csv(DATA/"sales.csv")
    assert s.duplicated(["sales_date","branch_id","sku_id","channel"]).sum()==0

def test_sales_arithmetic():
    s=pd.read_csv(DATA/"sales.csv")
    assert ((s.net_sales-(s.gross_sales-s.discount_value)).abs()<=0.01).all()

def test_web_funnel_monotonic():
    w=pd.read_csv(DATA/"web_funnel.csv")
    assert (w.add_to_cart<=w.product_detail_views).all()
    assert (w.online_orders<=w.add_to_cart).all()
