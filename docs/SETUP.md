# Setup

## Python
```powershell
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python python/validate_portfolio.py
python python/category_eda.py
```

## SQL Server
Use Windows Authentication where appropriate. Run the six SQL scripts in the README order.

The SQL demo is self-contained and does not require BULK INSERT permissions.

## Power BI
Connect to database `PharmacyEcommerceCategoryAnalytics`, prefer Import mode for this portfolio scale, and load only business-ready analytical tables/views required by the semantic model.
