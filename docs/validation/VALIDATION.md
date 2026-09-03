# Validation

## Automated Public-Sample Validation
Run:
```bash
python python/validate_portfolio.py
```

Expected outcome: `VALIDATION PASS`.

The script validates:
- key uniqueness
- fact grains
- referential integrity
- sales arithmetic
- inventory and PO domains
- e-commerce funnel consistency
- exact reconciliation to committed baseline totals

## SQL Validation
Run `sql/validation/05_data_quality_and_reconciliation.sql` after the SQL build.

Required:
- duplicate outputs: none
- orphan counts: 0
- arithmetic/domain errors: 0
- source vs analytics Net Sales difference: 0
- source vs analytics Gross Margin difference: 0

## Power BI
Status: **PENDING MANUAL** until the model is built in Power BI Desktop and DAX totals are reconciled to SQL at total and filtered levels.
