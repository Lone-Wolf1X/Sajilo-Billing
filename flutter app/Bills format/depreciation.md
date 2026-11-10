Bhai, bilkul sahi\! Nepal mein tax depreciation generally Asset Pool / Block-wise calculate hota hai, individual asset-wise nahi. Isliye tere Retail Accounting Software mein normal Straight Line aur Written Down Value depreciation ke saath Nepal Income Tax Act ke according Pool-wise Tax Depreciation Module banana chahiye.

Ek important distinction samajh:

- Accounting Depreciation: Financial statements ke liye asset ki useful life, residual value aur applicable accounting policy ke according.
- Tax Depreciation: Nepal Income Tax Act ke prescribed asset pools, depreciation rates aur tax adjustments ke according.

Dono ko alag maintain karna zaroori hai. Tax depreciation ko directly accounting depreciation samajhkar Balance Sheet mein post nahi karna chahiye.

## 1. Nepal Tax Depreciation – Pool Classification

Income Tax Act, 2058, Schedule 2 ke according five categories hain.

आन्तरिक राजस्व विभाग

+2

| Pool    | Asset Category                                                                     | Normal Tax Rate   |
| ------- | ---------------------------------------------------------------------------------- | ----------------- |
| A (Ka)  | Buildings, permanent structures                                                    | 5%                |
| B (Kha) | Computers, printers, furniture, fixtures, office equipment                         | 25%               |
| C (Ga)  | Automobiles, buses, minibuses                                                      | 20%               |
| D (Gha) | Construction equipment, excavation equipment and other eligible depreciable assets | 15%               |
| E (Nga) | Intangible assets                                                                  | Useful-life based |

These are the standard Schedule 2 rates. Special statutory concessions and amendments must be checked before calculating a particular taxpayer's deduction.

### Example: Retail Shop Asset Classification

Investment Sales - Matthews

Pool A – 5%

Shop building, permanent commercial structure and qualifying permanent construction.

Cosmetic Front Counter - Stylish & Functional Designs

Pool B – 25%

Computers, billing systems hardware, printers, office furniture, fixtures and equipment.

White delivery van isolated on white background

Pool C – 20%

Cars, buses and minibuses used in business.

Leton Power 10kw 15kw 17kw 18kw Generator Diesel Electrostatic Generator Price Portable Silent Electric Diesel Generators - Generator and Electric Generator

Pool D – 15%

Construction and excavation equipment and other eligible depreciable tangible assets not included elsewhere.

Business License Illustration Pack - 4 Free Download Business Illustrations | IconScout

Pool E – Useful-life based

Qualifying intangible assets such as software rights, patents and licences.

Note: Normal retail inventory, trading goods and consumables should not be added to fixed-asset depreciation pools. Classification depends on the actual nature and use of the asset, not just its name.

## 2. Pool-wise Calculation Logic

Pools A, B, C and D use a reducing-balance method at the pool level.

Basic calculation:

$$
\text{Depreciation}=\text{Eligible Pool Base}\times\text{Rate}
$$

The system should calculate the eligible depreciation base after applying opening balance, current-year eligible additions, timing adjustments and disposal proceeds.

### First-year addition rule

Nepal's income year runs from Shrawan to Ashadh. New asset additions are recognized in the tax depreciation base in different proportions depending on when the asset is first owned or put to qualifying use, subject to the statutory conditions.

| Acquisition / qualifying-use period | Current-year addition | Deferred addition |
| ----------------------------------- | --------------------- | ----------------- |
| Shrawan – Poush                     | 100%                  | 0%                |
| Magh – Chaitra                      | 2/3                   | 1/3               |
| Baisakh – Ashadh                    | 1/3                   | 2/3               |

The deferred portion is added in the following income year if the statutory conditions are met.

Income Tax Act, 2058 (2002)

+1

### Example: Pool B Calculation

Assume a retail shop has the following assets:

| Asset            | Cost        | Acquisition |
| ---------------- | ----------- | ----------- |
| Computer         | Rs. 100,000 | Shrawan     |
| Printer          | Rs. 30,000  | Magh        |
| Office Furniture | Rs. 60,000  | Baisakh     |

Pool B rate = 25%.

| Calculation              | Amount  |
| ------------------------ | ------- |
| Computer – 100% addition | 100,000 |
| Printer – 2/3 addition   | 20,000  |
| Furniture – 1/3 addition | 20,000  |
| Total eligible additions | 140,000 |
| Opening pool balance     | 0       |
| Depreciation base        | 140,000 |
| Depreciation @ 25%       | 35,000  |
| Closing pool balance     | 105,000 |

The remaining deferred addition of Rs. 50,000 is carried forward to the next income year's addition calculation.

This is an illustrative calculation assuming all assets qualify and are first owned/put to use in the stated periods.

### Disposal of Assets

Suppose Pool B has a closing depreciation base of Rs. 200,000 before disposal adjustment and a computer is sold for Rs. 40,000.

- Pool balance before disposal: Rs. 200,000
- Disposal proceeds: Rs. 40,000
- Adjusted pool base: Rs. 160,000

Depreciation is calculated on the adjusted pool base, subject to the statutory rules.

If disposal proceeds exceed the relevant pool balance, the excess may become taxable income. If all assets in a pool are disposed of, terminal depreciation rules may apply.

Income Tax Act, 2058 (2002)

+1

### Special rules to accommodate

- If the remaining eligible balance of Pool A–D after depreciation is below Rs. 2,000, the remaining amount is generally allowed as additional depreciation under Schedule 2.
- Certain qualifying projects and entities may receive an additional one-third of the normal depreciation rate.
- Certain special assets may qualify for specific accelerated or full deduction provisions.
- Pool E must be maintained separately for each intangible asset and calculated over its useful life.

Income Tax Act, 2058 (2002)

+1

## 3. Software mein Depreciation Module ka Design

Mera suggestion hai ki depreciation ke liye separate menu ho:

## Depreciation Management

Overview

Nepal Tax Mode

Total Asset Cost# Rs. 25L

Tax Depreciation# Rs. 3.2L

Depreciation Pools

| Pool | Rate        | Closing Balance |
| ---- | ----------- | --------------- |
| A    | 5%          | Rs. 8,00,000    |
| B    | 25%         | Rs. 3,00,000    |
| C    | 20%         | Rs. 5,00,000    |
| D    | 15%         | Rs. 6,00,000    |
| E    | Useful life | Rs. 2,00,000    |

Menu

- Asset Register
- Pool Management
- Asset Additions
- Asset Disposal
- Depreciation Calculation
- Pool-wise Depreciation Report
- Tax Depreciation Schedule
- Accounting vs Tax Depreciation
- Previous Year Closing Balance
- Export Tax Report

Illustrative dashboard values, not an actual depreciation computation.

## 4. Detailed AI Developer Prompt

Ye prompt directly apne existing billing software ke developer ya AI coding agent ko de sakta hai.

Writing

# Feature: Nepal Tax Pool-Based Depreciation Management Module

## Project Objective

Integrate a complete Nepal-specific pool-wise tax depreciation module into the existing Retail Billing and Accounting Software.

The system must follow the Income Tax Act, 2058, Section 19 and Schedule 2, including applicable amendments and Finance Act provisions.

IMPORTANT: Nepal tax depreciation for Pools A, B, C and D must be calculated on a pool-wise reducing-balance basis, not by calculating depreciation separately for each asset.

Pool E must be maintained separately for each eligible intangible asset.

The system must also maintain accounting depreciation separately from tax depreciation.

Do not modify or break the existing billing, inventory, accounting or financial reporting modules.

## 1\. Depreciation Configuration

Create a Nepal Tax Depreciation configuration.

Default pool classifications:

| Pool | Asset Description | Standard Rate | | A | Buildings and permanent structures | 5% | | B | Computers, data processing equipment, furniture, fixtures and office equipment | 25% | | C | Automobiles, buses and minibuses | 20% | | D | Construction, excavation equipment and other eligible depreciable assets not included elsewhere | 15% | | E | Eligible intangible assets | Useful-life based |

Requirements:

- Allow configurable tax depreciation rates.
- Keep statutory default rates.
- Maintain applicable income year and effective dates.
- Support special depreciation concessions where legally applicable.
- Maintain a record of changes to depreciation rules.
- Never overwrite historical depreciation calculations when rates change.

## 2\. Fixed Asset Register

Create an asset register with these fields:

- Asset ID
- Asset Code
- Asset Name
- Asset Description
- Asset Category
- Pool Classification (A/B/C/D/E)
- Acquisition Date
- Date First Owned
- Date First Put to Use
- Supplier
- Purchase Invoice Number
- Purchase Cost
- Eligible Tax Cost
- VAT Treatment
- Business Use Percentage, if applicable
- Location
- Department
- Ownership Status
- Asset Status
- Disposal Date
- Disposal Proceeds

Each asset must be linked to its appropriate depreciation pool.

For Pools A-D, assets must contribute to their respective collective tax pool calculations.

For Pool E, each intangible asset must have its own depreciation schedule.

## 3\. Pool-wise Depreciation Engine

Implement the tax depreciation calculation engine for Pools A, B, C and D.

The calculation must follow Schedule 2.

The general calculation structure:

Opening Pool Balance

- Eligible Current Year Additions
- Deferred Additions from Previous Year
- Applicable Disposal Proceeds = Depreciation Base Before Current Depreciation

Calculate depreciation using the applicable statutory rate and applicable tax depreciation base.

Closing Pool Balance = Adjusted Depreciation Base - Tax Depreciation

Important: Implement the exact statutory calculation sequence, including the prescribed first-year recognition adjustments, rather than using a simple asset-wise formula.

Ensure the depreciation base cannot become negative.

## 4\. First-Year Asset Addition Recognition

Implement the statutory addition timing rules.

Income year runs from Shrawan to Ashadh.

Addition recognition:

Shrawan to Poush: 100% of eligible acquisition cost.

Magh to Chaitra: 2/3 of eligible acquisition cost.

Baisakh to Ashadh: 1/3 of eligible acquisition cost.

Deferred portions must be added in the following income year according to the statutory rules.

The system must automatically:

- Detect the applicable acquisition and qualifying-use period.
- Calculate eligible current-year addition.
- Calculate deferred addition.
- Carry forward deferred additions.
- Prevent duplicate addition.
- Maintain a detailed calculation history.

Use the legally relevant date and qualifying conditions when determining the recognition period.

## 5\. Pool-wise Depreciation Calculation Example

Suppose Pool B contains:

Opening Pool Balance: Rs. 200,000

Current year additions:

- Computer: Rs. 100,000 acquired in Shrawan.
- Printer: Rs. 30,000 acquired in Magh.
- Furniture: Rs. 60,000 acquired in Baisakh.

Calculate:

Computer eligible addition = Rs. 100,000

Printer eligible addition = Rs. 20,000

Furniture eligible addition = Rs. 20,000

Total eligible current-year additions = Rs. 140,000.

Assume no disposals.

Depreciation base before depreciation:

Rs. 200,000 + Rs. 140,000 = Rs. 340,000.

Pool B depreciation:

Rs. 340,000 × 25% = Rs. 85,000.

Closing Pool Balance:

Rs. 340,000 - Rs. 85,000 = Rs. 255,000.

Deferred addition of Rs. 50,000 must be carried into the following income year, subject to statutory conditions.

Use this as a calculation test case.

## 6\. Asset Disposal Management

Create a disposal module.

Fields:

- Asset
- Pool
- Disposal Date
- Sale Invoice
- Disposal Proceeds
- Buyer Details
- Supporting Documents

For Pools A-D:

- Reduce the relevant pool's depreciation base by qualifying disposal proceeds.
- Apply statutory excess recovery and taxable income rules.
- Support terminal depreciation when all assets in a pool are disposed of.
- Record pool dissolution where applicable.
- Preserve the full disposal history.

Do not calculate individual accounting book value and tax pool value as the same thing.

## 7\. Pool E – Intangible Depreciation

Pool E must be handled separately.

Each eligible intangible asset must have:

- Individual Asset ID
- Acquisition Cost
- Acquisition Date
- Useful Life
- Applicable Depreciation Rate
- Accumulated Depreciation
- Current Tax Written Down Value

Calculate depreciation using the useful-life-based statutory rule and nearest half-year adjustment as prescribed.

Do not combine different Pool E assets into a single collective depreciation pool.

## 8\. Special Tax Depreciation Provisions

Create configurable support for:

- Additional one-third depreciation rates for qualifying projects and entities.
- Special renewable-energy depreciation provisions.
- Eligible fiscal printers and cash machines issuing bills.
- Rs. 2,000 remaining pool balance write-off provision.
- Terminal depreciation provisions.
- Applicable tax amendments and special concessions.

These provisions must only be applied when the business meets the statutory eligibility conditions.

Do not automatically grant tax benefits to every retail business.

Maintain eligibility evidence and approval records.

## 9\. Separate Accounting and Tax Depreciation

This is mandatory.

Maintain two independent depreciation systems:

A. Accounting Depreciation:

- Individual asset-wise depreciation.
- Useful life.
- Residual value.
- Straight Line Method.
- Written Down Value Method.
- Other applicable accounting methods.
- Accounting accumulated depreciation.
- Net carrying amount.

B. Nepal Tax Depreciation:

- Pool A-E.
- Statutory tax rates.
- Pool-wise reducing-balance calculations for A-D.
- Individual intangible calculations for E.
- Statutory additions and deferred additions.
- Disposal adjustments.
- Tax depreciation deductions.
- Tax written-down pool balances.

Generate an Accounting vs Tax Depreciation Reconciliation Report.

Show:

- Accounting Depreciation
- Tax Depreciation
- Difference
- Temporary Differences, where applicable
- Tax Adjustment
- Closing Accounting Book Value
- Closing Tax Pool Balance

Tax depreciation must not automatically overwrite the accounting depreciation journal entry.

## 10\. Accounting Integration

Accounting depreciation:

Debit: Depreciation Expense Credit: Accumulated Depreciation

Tax depreciation:

Maintain a separate tax computation ledger or tax adjustment schedule.

Do not post the tax pool deduction directly into accounting depreciation expense unless an approved accounting adjustment specifically requires it.

## 11\. Depreciation Reports

Create these reports:

1. Fixed Asset Register
2. Asset-wise Accounting Depreciation
3. Pool A Depreciation Schedule
4. Pool B Depreciation Schedule
5. Pool C Depreciation Schedule
6. Pool D Depreciation Schedule
7. Individual Pool E Depreciation Schedule
8. Pool-wise Opening Balance
9. Current Year Additions
10. Deferred Additions
11. Asset Disposal Report
12. Tax Depreciation Calculation
13. Closing Tax Pool Balance
14. Accounting vs Tax Depreciation Reconciliation
15. Historical Depreciation Comparison
16. Tax Depreciation Summary for Income Tax Return Preparation

All reports must support:

- Financial Year Selection
- Asset Category Filter
- Pool Filter
- Date Range
- PDF Export
- Excel Export
- Print

## 12\. Financial Year Management

Support Nepal's financial year:

Shrawan to Ashadh.

Example: 2082/83 2083/84

At year-end:

- Carry forward closing pool balances.
- Carry forward eligible deferred additions.
- Preserve previous-year calculations.
- Generate the next year's opening pool balance.
- Prevent duplicate depreciation calculations.
- Lock finalized tax depreciation schedules.
- Allow authorized amendments with audit history.

## 13\. Database Requirements

Create or extend the following tables:

- fixed_assets
- depreciation_pools
- depreciation_pool_rates
- depreciation_additions
- depreciation_deferred_additions
- depreciation_disposals
- tax_depreciation_schedules
- tax_depreciation_pool_balances
- tax_depreciation_transactions
- accounting_depreciation_schedules
- depreciation_adjustments
- depreciation_rule_versions
- depreciation_audit_logs

Use proper relationships and transaction management.

Every depreciation calculation must be reproducible from stored source transactions and rule versions.

## 14\. Testing Requirements

Test the following:

- New assets in Shrawan-Poush.
- New assets in Magh-Chaitra.
- New assets in Baisakh-Ashadh.
- Deferred addition carry-forward.
- Multiple assets in one pool.
- Asset disposal.
- Complete pool disposal.
- Pool E individual calculation.
- Rs. 2,000 balance rule.
- Special rate eligibility.
- Financial year carry-forward.
- Previous year recalculation prevention.
- Accounting versus tax depreciation reconciliation.

## Final Expected Result

The final system must provide a complete Nepal-specific Tax Depreciation Management Module.

It should automatically classify fixed assets into statutory pools, calculate pool-wise tax depreciation, maintain additions and disposals, carry forward balances, generate tax depreciation schedules and reconcile accounting depreciation with tax depreciation.

All calculations must follow the applicable Income Tax Act, 2058, Schedule 2 and current amendments.

## 5. Ek aur important feature: Tax vs Accounting Reconciliation

Isko zaroor add karna. Example:

| Particular             | Accounting | Tax                |
| ---------------------- | ---------- | ------------------ |
| Computer depreciation  | Rs. 20,000 | Pool B calculation |
| Furniture depreciation | Rs. 10,000 | Pool B calculation |
| Vehicle depreciation   | Rs. 40,000 | Pool C calculation |
| Total depreciation     | Rs. 70,000 | Rs. 95,000         |

System automatically difference calculate kare aur tax computation ke liye adjustment report banaye.

Meri recommendation: Accounting P&L mein accounting depreciation rahegi. Tax calculation mein Schedule 2 ki pool-wise depreciation deduction jayegi. Dono ke difference ko applicable accounting standards aur tax rules ke according reconcile karna hoga.

## 6. Reference Sources

- [Nepal Inland Revenue Department – Income Tax Act and Amendments](https://ird.gov.np/category/incometaxact/?utm_source=chatgpt.com)
- [Income Tax Act – Schedule 2: Assessment of Depreciation Deduction](https://webdisk.actnepal.com/en/schedule/2/0/assessment-of-depreciation-deduction?toc_type=sections&utm_source=chatgpt.com)
- [Nepal Depreciation Calculation – Technical Reference](https://www.caroshanpoudel.com.np/blogs/nepal-income-tax-reference-guide-including-amendment-for-fy-2083-84/schedule-2-determination-of-depreciation-deduction-related-to-section-19?utm_source=chatgpt.com)

Final implementation se pehle applicable latest Finance Act aur IRD guidance ko CA/tax professional se validate karwana, especially special concessions and eligibility.

Ek important suggestion: Tere software mein depreciation ka calculation button `Calculate Tax Depreciation` hona chahiye, aur uske baad `Review → Approve → Finalize`. Isse shop owner ya accountant calculation verify kiye bina tax schedule finalize nahi karega.
