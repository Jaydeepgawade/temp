# Generic SQL Queries for Dynamic Approval Workflow

> This file is written as a notebook-friendly reference so the workflow can be explained easily to a Team Lead.

---

## 1. Core Idea

The stored procedure should not know role names such as Verifier, Manager, Auditor, Accountant, HR, Admin, etc.
It should only know:

- RequestId
- WorkflowId
- CurrentStepOrder
- CurrentRoleId
- Action

The next role is always fetched from `WorkflowStep` configuration.

---

## 2. Get Current Request Workflow State

```sql
DECLARE @WorkflowId INT;
DECLARE @WorkflowVersion INT;
DECLARE @CurrentStepOrder INT;
DECLARE @CurrentRoleId INT;
DECLARE @VerticalId INT;

SELECT
    @WorkflowId = WorkflowId,
    @WorkflowVersion = WorkflowVersion,
    @CurrentStepOrder = CurrentStepOrder,
    @CurrentRoleId = CurrentRoleId,
    @VerticalId = VerticalId
FROM RequestWorkflow
WHERE RequestId = @RequestId;
```

### Explanation

The UI should send only the request identity and action.
The database itself loads the authoritative workflow state.
This avoids trusting browser values such as RoleId or CurrentStepOrder.

Notebook explanation:

```text
RequestId -> RequestWorkflow -> WorkflowId + CurrentStep + CurrentRole
```

---

## 3. Get Next Step for APPROVE

```sql
DECLARE @NextStepOrder INT;
DECLARE @NextRoleId INT;

SELECT TOP 1
    @NextStepOrder = StepOrder,
    @NextRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND StepOrder > @CurrentStepOrder
  AND IsActive = 1
ORDER BY StepOrder ASC;
```

### How it works

Example configuration:

```text
Step 1 -> Maker
Step 2 -> Verifier
Step 3 -> Manager
Step 4 -> HR
```

If current step is 2, the query searches:

```text
StepOrder > 2
```

Possible results are Step 3 and Step 4.
Because of:

```sql
ORDER BY StepOrder ASC
```

and:

```sql
TOP 1
```

it returns Step 3.

No role name is hardcoded.

---

## 4. Complete Request When No Next Step Exists

```sql
IF @NextStepOrder IS NULL
BEGIN
    UPDATE RequestWorkflow
    SET Status = 'COMPLETED',
        UpdatedOn = SYSDATETIME()
    WHERE RequestId = @RequestId;
END
ELSE
BEGIN
    UPDATE RequestWorkflow
    SET CurrentStepOrder = @NextStepOrder,
        CurrentRoleId = @NextRoleId,
        Status = 'PENDING',
        UpdatedOn = SYSDATETIME()
    WHERE RequestId = @RequestId;
END
```

### Explanation

We do not need to say:

```text
If HR approves -> Complete
```

or:

```text
If Admin approves -> Complete
```

If there is no configured step after the current one, that automatically means the current role is the final role for that workflow version.

---

## 5. Get Previous Step for REJECT

```sql
DECLARE @PreviousStepOrder INT;
DECLARE @PreviousRoleId INT;

SELECT TOP 1
    @PreviousStepOrder = StepOrder,
    @PreviousRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND StepOrder < @CurrentStepOrder
  AND IsActive = 1
ORDER BY StepOrder DESC;
```

### How it works

Example:

```text
Step 1 -> Maker
Step 2 -> Verifier
Step 3 -> Auditor
Step 4 -> Manager
```

If Manager is on Step 4 and rejects, query checks:

```text
StepOrder < 4
```

The highest previous StepOrder is 3.
Therefore request moves to Auditor.

---

## 6. Reject Update

```sql
IF @PreviousStepOrder IS NULL
BEGIN
    -- Business decision required for first-step reject.
    -- Example: keep request on current step or mark final rejected.
    THROW 50020, 'No previous workflow step is configured.', 1;
END
ELSE
BEGIN
    UPDATE RequestWorkflow
    SET CurrentStepOrder = @PreviousStepOrder,
        CurrentRoleId = @PreviousRoleId,
        Status = 'PENDING',
        UpdatedOn = SYSDATETIME()
    WHERE RequestId = @RequestId;
END
```

For the first implementation, confirm the exact business behavior for rejection at Step 1.

---

## 7. Get Active Workflow for a Vertical

This query is used when creating a NEW request.

```sql
DECLARE @WorkflowId INT;
DECLARE @WorkflowVersion INT;

SELECT TOP 1
    @WorkflowId = WorkflowId,
    @WorkflowVersion = VersionNo
FROM WorkflowMaster
WHERE VerticalId = @VerticalId
  AND IsActive = 1
ORDER BY VersionNo DESC;
```

### Explanation

Each vertical has its own workflow versions.

Example:

```text
Finance V1 -> inactive for new requests
Finance V2 -> active for new requests
```

A new Finance request picks V2.
An existing request that already stores V1 continues V1.

---

## 8. Get First Step of a Workflow

```sql
DECLARE @FirstStepOrder INT;
DECLARE @FirstRoleId INT;

SELECT TOP 1
    @FirstStepOrder = StepOrder,
    @FirstRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND IsActive = 1
ORDER BY StepOrder ASC;
```

This is used during request creation.

---

## 9. Create RequestWorkflow Entry

```sql
INSERT INTO RequestWorkflow
(
    RequestId,
    VerticalId,
    WorkflowId,
    WorkflowVersion,
    CurrentStepOrder,
    CurrentRoleId,
    Status,
    CreatedOn
)
VALUES
(
    @RequestId,
    @VerticalId,
    @WorkflowId,
    @WorkflowVersion,
    @FirstStepOrder,
    @FirstRoleId,
    'PENDING',
    SYSDATETIME()
);
```

### Important

Once this row is created, do not automatically replace its WorkflowId when Admin publishes a newer version.
That WorkflowId is the request's process definition.

---

## 10. Generic Processing Skeleton

```sql
CREATE PROCEDURE ProcessWorkflow
(
    @RequestId BIGINT,
    @Action VARCHAR(20),
    @PerformedBy BIGINT,
    @Remarks NVARCHAR(1000) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkflowId INT;
    DECLARE @WorkflowVersion INT;
    DECLARE @CurrentStepOrder INT;
    DECLARE @CurrentRoleId INT;
    DECLARE @VerticalId INT;
    DECLARE @TargetStepOrder INT;
    DECLARE @TargetRoleId INT;

    BEGIN TRY
        BEGIN TRAN;

        SELECT
            @WorkflowId = WorkflowId,
            @WorkflowVersion = WorkflowVersion,
            @CurrentStepOrder = CurrentStepOrder,
            @CurrentRoleId = CurrentRoleId,
            @VerticalId = VerticalId
        FROM RequestWorkflow WITH (UPDLOCK, ROWLOCK)
        WHERE RequestId = @RequestId
          AND Status = 'PENDING';

        IF @WorkflowId IS NULL
        BEGIN
            THROW 50001, 'Pending workflow request not found.', 1;
        END;

        IF UPPER(@Action) = 'APPROVE'
        BEGIN
            SELECT TOP 1
                @TargetStepOrder = StepOrder,
                @TargetRoleId = RoleId
            FROM WorkflowStep
            WHERE WorkflowId = @WorkflowId
              AND StepOrder > @CurrentStepOrder
              AND IsActive = 1
            ORDER BY StepOrder ASC;

            IF @TargetStepOrder IS NULL
            BEGIN
                UPDATE RequestWorkflow
                SET Status = 'COMPLETED',
                    UpdatedOn = SYSDATETIME()
                WHERE RequestId = @RequestId;
            END
            ELSE
            BEGIN
                UPDATE RequestWorkflow
                SET CurrentStepOrder = @TargetStepOrder,
                    CurrentRoleId = @TargetRoleId,
                    Status = 'PENDING',
                    UpdatedOn = SYSDATETIME()
                WHERE RequestId = @RequestId;
            END;
        END
        ELSE IF UPPER(@Action) = 'REJECT'
        BEGIN
            SELECT TOP 1
                @TargetStepOrder = StepOrder,
                @TargetRoleId = RoleId
            FROM WorkflowStep
            WHERE WorkflowId = @WorkflowId
              AND StepOrder < @CurrentStepOrder
              AND IsActive = 1
            ORDER BY StepOrder DESC;

            IF @TargetStepOrder IS NULL
            BEGIN
                THROW 50002, 'No previous workflow step is configured.', 1;
            END;

            UPDATE RequestWorkflow
            SET CurrentStepOrder = @TargetStepOrder,
                CurrentRoleId = @TargetRoleId,
                Status = 'PENDING',
                UpdatedOn = SYSDATETIME()
            WHERE RequestId = @RequestId;
        END
        ELSE
        BEGIN
            THROW 50003, 'Invalid workflow action.', 1;
        END;

        -- Existing business-table update logic can remain here.
        -- Existing dynamic SQL / cursor logic can also remain if still required.

        INSERT INTO ApprovalHistory
        (
            RequestId,
            WorkflowId,
            WorkflowVersion,
            FromStepOrder,
            ToStepOrder,
            FromRoleId,
            ToRoleId,
            Action,
            PerformedBy,
            Remarks,
            PerformedOn
        )
        VALUES
        (
            @RequestId,
            @WorkflowId,
            @WorkflowVersion,
            @CurrentStepOrder,
            @TargetStepOrder,
            @CurrentRoleId,
            @TargetRoleId,
            UPPER(@Action),
            @PerformedBy,
            @Remarks,
            SYSDATETIME()
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH;
END;
```

### Important note

This is a generic design skeleton.
Before using it in production, merge it carefully with the existing stored procedure and existing business update rules.
Do not blindly replace the whole existing SP.

---

## 11. Generic Query for Workflow Display

Admin UI can load a workflow in sequence using:

```sql
SELECT
    wm.WorkflowId,
    wm.VerticalId,
    wm.VersionNo,
    ws.WorkflowStepId,
    ws.RoleId,
    ws.StepOrder,
    ws.IsActive
FROM WorkflowMaster wm
INNER JOIN WorkflowStep ws
    ON ws.WorkflowId = wm.WorkflowId
WHERE wm.VerticalId = @VerticalId
  AND wm.IsActive = 1
ORDER BY ws.StepOrder ASC;
```

Role names can be resolved from the MySQL role master through the .NET service layer.

---

## 12. Check Pending Requests Before Role Removal

```sql
SELECT COUNT(*) AS PendingCount
FROM RequestWorkflow
WHERE WorkflowId = @WorkflowId
  AND CurrentRoleId = @RoleId
  AND Status = 'PENDING';
```

If PendingCount > 0, the safest first-version behavior is to block destructive removal from that active workflow.
Preferred design is to publish a NEW workflow version without the role instead of changing the old version.

---

## 13. Versioning Query - Get Current Version

```sql
DECLARE @OldWorkflowId INT;
DECLARE @OldVersion INT;

SELECT TOP 1
    @OldWorkflowId = WorkflowId,
    @OldVersion = VersionNo
FROM WorkflowMaster
WHERE VerticalId = @VerticalId
  AND IsActive = 1
ORDER BY VersionNo DESC;
```

Then:

```sql
DECLARE @NewVersion INT;
SET @NewVersion = ISNULL(@OldVersion, 0) + 1;
```

---

## 14. Versioning Query - Create New Workflow Version

```sql
INSERT INTO WorkflowMaster
(
    VerticalId,
    VersionNo,
    IsActive,
    CreatedBy,
    CreatedOn,
    PublishedOn
)
VALUES
(
    @VerticalId,
    @NewVersion,
    1,
    @AdminUserId,
    SYSDATETIME(),
    SYSDATETIME()
);

DECLARE @NewWorkflowId INT;
SET @NewWorkflowId = SCOPE_IDENTITY();
```

Then insert the new ordered WorkflowStep rows against `@NewWorkflowId`.

After all rows are inserted successfully:

```sql
UPDATE WorkflowMaster
SET IsActive = 0
WHERE WorkflowId = @OldWorkflowId;
```

### Important meaning

`IsActive = 0` means:

```text
Do not use this version for NEW requests.
```

It does NOT mean:

```text
Existing requests cannot continue using this version.
```

---

## 15. Versioning Notebook Example

Write this simple example when explaining to TL:

```text
Finance V1
Verifier -> Accountant -> HR

Request 1001 starts
WorkflowId = 101
Version = 1

Admin changes flow

Finance V2
Verifier -> Manager -> Auditor -> HR

Request 2001 starts
WorkflowId = 102
Version = 2

Result:
Request 1001 -> continues Workflow 101 / V1
Request 2001 -> follows Workflow 102 / V2
```

Main sentence to explain:

```text
We never overwrite a workflow version already referenced by in-progress requests.
```

---

## 16. Nine Verticals Example

```text
Vertical 1 -> Workflow 101 -> 3 steps
Vertical 2 -> Workflow 102 -> 5 steps
Vertical 3 -> Workflow 103 -> 2 steps
Vertical 4 -> Workflow 104 -> 4 steps
Vertical 5 -> Workflow 105 -> 6 steps
Vertical 6 -> Workflow 106 -> 3 steps
Vertical 7 -> Workflow 107 -> 2 steps
Vertical 8 -> Workflow 108 -> 5 steps
Vertical 9 -> Workflow 109 -> 4 steps
```

The query is still the same for every vertical:

```sql
SELECT TOP 1
    @NextStepOrder = StepOrder,
    @NextRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND StepOrder > @CurrentStepOrder
  AND IsActive = 1
ORDER BY StepOrder ASC;
```

That single query is the heart of the dynamic workflow.

---

## 17. Simple TL Explanation

You can explain the design like this:

```text
Earlier:
Role -> Hardcoded CASE -> Static Status -> Hardcoded Next Role

New Design:
RequestId -> Current Workflow Version -> Current Step -> Generic Query -> Next Step -> Next Role
```

Then show this query:

```sql
SELECT TOP 1
    @NextStepOrder = StepOrder,
    @NextRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND StepOrder > @CurrentStepOrder
  AND IsActive = 1
ORDER BY StepOrder ASC;
```

And explain:

```text
Whatever role exists at the next StepOrder is the next approver.
The SP does not care whether it is Manager, Auditor, HR, Admin, or any future role.
```

---

## 18. Marathi TL Explanation

```text
आधी आपल्या SP मध्ये role नुसार CASE/IF होते.
म्हणून role add/remove किंवा sequence change झाला की SP change करावा लागत होता.

नवीन design मध्ये request ला WorkflowId आणि CurrentStepOrder save राहील.
Approve झाल्यावर आपण WorkflowStep table मध्ये current step पेक्षा मोठा सर्वात पहिला active step शोधू.
तोच next approver असेल.

Reject झाल्यावर current step पेक्षा छोटा सर्वात जवळचा active step शोधू.
तो previous approver असेल.

त्यामुळे 2 roles असोत, 5 roles असोत किंवा 10 roles असोत query same राहते.

Workflow change झाला तर old configuration overwrite करत नाही.
New version तयार करतो.
Old requests old WorkflowId ने complete होतात.
New requests latest active version घेतात.
```

---

## 19. One-Page Notebook Summary

```text
1. MySQL
   User / Role / Vertical / Access

2. MS SQL
   WorkflowMaster
   WorkflowStep
   RequestWorkflow
   ApprovalHistory

3. New Request
   VerticalId
      -> Active Workflow
      -> First Step
      -> Save WorkflowId + Version + CurrentStep

4. Approve
   RequestId
      -> Read WorkflowId + CurrentStep
      -> Find TOP 1 StepOrder > CurrentStep
      -> Move to Next Role
      -> If none -> Completed

5. Reject
   RequestId
      -> Read WorkflowId + CurrentStep
      -> Find TOP 1 StepOrder < CurrentStep ORDER BY DESC
      -> Move to Previous Role

6. Version Change
   Do not edit old version
   Create V2
   Old V1 requests -> V1
   New requests -> V2

7. Admin Only
   Workflow configuration protected in UI + backend

8. No Hardcoding
   No role-name CASE
   No Admin=1 / Verifier=2 mapping
   No role-specific status numbers
```

---

## 20. Final Generic Rule

The workflow engine should never ask:

```text
Is the current role Verifier?
Is the next role Manager?
Is HR the final approver?
```

It should ask only:

```text
What workflow version does this request belong to?
What is its current StepOrder?
What is the next configured active StepOrder?
```

That is the complete generic workflow concept.
