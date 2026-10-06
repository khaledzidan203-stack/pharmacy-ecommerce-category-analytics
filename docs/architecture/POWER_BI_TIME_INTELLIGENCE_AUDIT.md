# Power BI Time-Intelligence Audit

## Current saved state

The current semantic model has:

- `__PBI_TimeIntelligenceEnabled = 1`;
- one `DateTableTemplate_*` object;
- three `LocalDateTable_*` objects;
- date relationships from:
  - `analytics vw_sales_enriched.sales_date`;
  - `analytics vw_inventory_risk.snapshot_date`;
  - `analytics vw_inventory_risk.expiry_date`.

The current model does **not** contain a separate governed explicit Date dimension imported from SQL.

## Assessment

This is functional Power BI Auto Date/Time behavior, but it is not the preferred long-term model-hygiene pattern for a governed analytical solution. Automatic local date tables add hidden semantic objects and make date logic less explicit in source control.

## Why it is not changed in repository hardening

Disabling Auto Date/Time and deleting the local date tables without Power BI Desktop regression could break:

- implicit date hierarchies;
- visual bindings;
- date filters;
- saved report interactions.

Therefore no destructive TMDL change is made as part of documentation/CI hardening.

## Recommended future remediation

A controlled future model revision should:

1. publish or generate a governed Date dimension;
2. import it into the semantic model;
3. bind sales and relevant inventory dates explicitly;
4. decide how the expiry-date role should be modeled;
5. replace any implicit date hierarchies in visuals;
6. disable Auto Date/Time;
7. remove generated local date tables;
8. reopen the PBIP in Power BI Desktop;
9. regression-test all nine pages and KPI filters;
10. retain runtime evidence before describing the remediation as validated.

## Current release statement

The current release remains valid as the saved implementation. Auto Date/Time is a documented model-hygiene limitation, not silently presented as a governed Date-dimension design.
