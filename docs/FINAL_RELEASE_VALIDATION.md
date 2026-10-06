# Final Release Validation

## Current release evidence

The repository now has a presentation-neutral documentation path, explicit evidence mapping, an automated repository contract and a source-controlled Power BI implementation.

### Fresh CI-verifiable checks

GitHub Actions validates:

- protected analytical-core Git blob hashes;
- required project/evidence files;
- exact public-sample baseline contract;
- 9 saved PBIR report pages;
- 62 saved PBIR visuals;
- 22 saved DAX measures;
- current Auto Date/Time state;
- expected SQL analytical-view contract;
- README presentation contract;
- executable Python baseline validation;
- pytest;
- Python source compilation.

### Retained / local-runtime evidence

The repository also contains:

- SQL Server DDL, analytical views and validation scripts;
- retained historical Python build log;
- PBIP/PBIR/TMDL implementation source.

GitHub Actions does not provision SQL Server or Power BI Desktop.

## Power BI evidence boundary

The saved Power BI model is implemented, not “pending build.” Static source evidence confirms its current structure.

A fresh Power BI Desktop/DAX runtime reconciliation artifact is **not retained**, so this release does not claim complete runtime certification of all report measures at every filter context.

## Core-protection rule

Documentation hardening does not modify the committed synthetic dataset, SQL analytical logic, Python analytical logic, TMDL measures/relationships, PBIR pages or validation baselines.

Any future intentional core change should update the analytical evidence and repository contract together.
