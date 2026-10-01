# Equity incentive dashboard

Install `Fab_Ims_EquityDashboard.sql` in SSMS against a test database containing the four original dbo incentive tables and `dbo.fn_ChkNISMvalidity`. Requires SQL Server 2016 SP1 or newer. This is a separate reporting procedure; the existing reporting and workflow procedures are not overwritten.

## Usage

```sql
EXEC dbo.Fab_Ims_EquityDashboard
    @GenDtFrm='202603', @GenDtTo='202606', @Prole=1;

-- Add @RmCode, @PositionName or @PStatus to filter.
-- NULL/empty string means unrestricted for string filters.
-- @PStatus is numeric: pass NULL for all, not an empty string.
```

Quarter keys are quarter-end YYYYMM: 202603, 202606, 202609, 202612. They are not four monthly quarters between March and June. The source IncQtr must consistently use these six-character keys. Optional bounds are inclusive. RM ranges use database string collation, not numeric ordering. Exact RM and RM range filters intersect if both are supplied.

## Result sets / ADO.NET DataSet

| Index | Content |
|---|---|
| Tables[0] | Financial KPI totals |
| Tables[1] | Eight workflow status cards |
| Tables[2] | Quarter totals |
| Tables[3] | Position totals |
| Tables[4] | RM and quarter totals |
| Tables[5] | B/S/E/R incentive type totals |
| Tables[6] | Detail grid, NISM flag and btnFlag |

Main progression: **0 Draft → 1 Pending Verifier → 2 Pending Accountant → 4 Pending HR → 6 Completed**.
Rejection cards: **3 Pending Admin**, **5 Pending Verifier**, **7 Pending Accountant**.

Status cards ignore the selected @PStatus so users can switch cards; every other result honors it. Quarter, RM, position and role filters apply to all results. Cards always return eight rows, including zeros.

## Role scope

Preserves the original role/status sets, enforced on each source row:

| @Prole | Role | Visible statuses |
|---|---|---|
| 1 | Admin | 0, 1, 3 |
| 2 | Verifier | 1, 5 |
| 3 | Auditor | 6 |
| 4 | Accountant | 2, 7 |
| 5 | HR | 4 |

Consequently a role will see zero cards for statuses outside its scope. An all-stage management view would require a separately authorized visibility policy. Missing/unknown roles throw instead of returning unrestricted data. Obtain the role from authenticated server-side identity; do not trust a browser-supplied role. Apply existing branch/employee permissions in the server as well: this SP only knows the supplied role and filters.

## Counting and amounts

- IncentiveRecordCount counts source rows across the four tables.
- TotalRM counts distinct EmployeeCode.
- RMQuarterCount counts distinct EmployeeCode + IncQtr, without concatenated keys.
- An RM-quarter with mixed incentive statuses appears in multiple cards; distinct counts must not be summed across cards.
- Only Incentive > 0 rows participate, matching the original report.
- NULL Status means Draft. Source statuses are assumed to be 0–7.
- NetIncentive = Incentive + ISNULL(AdjIncentive,0). FileAdjAmt is shown separately; it is not added to net.
- YearHoldAmt and FinPay each equal 50% of net, matching the supplied formula.
- NISM expiry is reported separately. Expired records remain in totals, but btnFlag is N.
- btnFlag only indicates the original source-status eligibility; backend authorization and the action procedure remain authoritative.

## Testing and integration

Run `testing.sql` in SSMS. It includes filter/role examples, validation assertions and an independent totals reconciliation query. Replace sample RM/position placeholders. Verify with known rows that mixed types/statuses and multiple quarters produce the expected counts.

SQL Server was unavailable in the authoring environment: the procedure and test script have not been executed against your database. Check actual column types, lengths and schema before deployment. In particular, adjust @PositionName to match the source column type (NVARCHAR if needed). No schema migration or index is applied.

No NOLOCK hints are used. #Scope materializes one filtered source read and all results derive from it. Under the database's default isolation this is not a guaranteed point-in-time snapshot; use an agreed snapshot isolation policy if required.

For performance, inspect the actual execution plan and existing indexes before considering indexes on IncQtr, EmployeeCode and Status. NISM validity is evaluated once per selected RM. Quarter/position summaries derive from the filtered materialization.

The existing workflow SP is unchanged. Its posted history insert can capture rows already at the target status, and its @IncTypes predicate supports one code or NULL, not a comma-separated list. Address those separately before relying on it for exact action audit history.
