# Validation Contract

Hospital E-commerce Category Analytics uses separate validation layers. A PASS in one layer must not be described as proof of a different layer.

## 1. Automated public-sample validation

Run:

```bash
python python/validate_portfolio.py
```

Expected outcome: `VALIDATION PASS`.

The script checks:

- dimension and fact-grain uniqueness;
- referential integrity;
- sales arithmetic;
- non-negative commercial and inventory values;
- purchase-order quantity domains;
- web-funnel monotonicity;
- exact reconciliation to `EXPECTED_BASELINES.json`.

The same script is executed in GitHub Actions.

## 2. Clone-safe pytest suite

Run:

```bash
pytest -q
```

Current tests check:

- unique sales grain;
- exact sales arithmetic;
- `PDP Views >= Add to Cart >= Online Orders`.

## 3. SQL validation

After building the SQL Server demo, run:

`sql/validation/05_data_quality_and_reconciliation.sql`

Required outputs:

- duplicate-grain queries: no rows;
- orphan counts: 0;
- arithmetic/domain errors: 0;
- source vs analytics Net Sales difference: 0;
- source vs analytics Gross Margin difference: 0.

GitHub Actions does **not** provision SQL Server, so the SQL suite is an executable local validation contract rather than a CI runtime claim.

## 4. Power BI implementation status

The Power BI implementation is no longer “pending build.” The repository contains a saved PBIP/PBIR/TMDL implementation with:

- 6 imported governed SQL analytical views;
- a disconnected `_Measures` table;
- 22 current explicit DAX measures;
- 9 saved report pages;
- 62 saved visuals.

Repository CI validates this saved source structure.

### Runtime evidence boundary

The repository does **not** currently retain a fresh Power BI Desktop / DAX runtime execution artifact proving all measures at total and filtered levels. Therefore the release should be described as:

**source-controlled Power BI implementation with static structural validation and SQL/Python baseline contracts**, not as a freshly runtime-certified DAX model.

## 5. Current time-intelligence note

The saved semantic model has Power BI Auto Date/Time enabled and retains three `LocalDateTable_*` relationships. This is documented in the dedicated time-intelligence audit. It is not changed automatically because removing those tables without Desktop regression could break date hierarchies or report bindings.
