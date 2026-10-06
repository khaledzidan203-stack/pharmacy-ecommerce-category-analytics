# Environment Baseline

## CI baseline

GitHub Actions uses:

- Ubuntu latest
- Python 3.12
- dependencies from `requirements.txt`

Current declared Python dependencies:

- pandas >= 2.2
- NumPy >= 2.0
- pytest >= 8.0

These are compatibility ranges, not an exact lockfile.

## SQL baseline

The SQL implementation targets Microsoft SQL Server / T-SQL and the database:

`PharmacyEcommerceCategoryAnalytics`

The public SQL seed is intentionally compact and self-contained.

## Power BI baseline

The repository stores Power BI Project source:

- PBIP project pointer;
- PBIR report definitions;
- TMDL semantic model.

A compatible Power BI Desktop environment is required for runtime rendering and refresh.

## Reproducibility boundary

Python validation is clone-safe and runs in CI. SQL runtime validation requires SQL Server. Power BI runtime validation requires Power BI Desktop; the repository does not claim those local runtimes were executed by GitHub Actions.
