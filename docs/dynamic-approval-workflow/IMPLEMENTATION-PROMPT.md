# Dynamic Approval Workflow - Implementation Prompt

Use the following prompt with your company AI/Copilot/Codex when you cannot use ChatGPT directly.

```text
I am working on an existing .NET 8 application with jQuery/Razor UI and two databases:

1. MySQL
   - Users
   - Roles
   - Verticals
   - User-to-Role / User-to-Vertical mappings

2. MS SQL Server
   - Main business/lake data
   - Existing stored procedures
   - Approval processing logic

Current problem:
- Approval workflow is hardcoded.
- Role names are converted to static numeric values in JavaScript.
- SQL stored procedures contain hardcoded CASE / IF conditions for specific roles.
- Status values are also hardcoded.
- This makes the system fragile when a role is added, removed, renamed, or reordered.

My target:
Build a fully dynamic, database-driven approval workflow system inside the EXISTING project with minimum code changes.

Important requirements:

1. We have approximately 9 verticals.
2. Each vertical can have a completely different approval flow.
3. Example:
   - Vertical A -> 3 roles
   - Vertical B -> 5 roles
   - Vertical C -> 2 roles
   - Other verticals may contain any number of roles.
4. Admin should be able to configure:
   - Which roles belong to a vertical workflow
   - Role sequence / StepOrder
   - Add role
   - Remove role
   - Reorder roles
   - Activate a new workflow version
5. No role-specific switch/if/else should remain in JavaScript, C#, or SQL.
6. Do not use logic like:
   Admin = 1
   Verifier = 2
   Auditor = 3
7. Workflow processing must depend only on configuration data.

Recommended design:

MySQL should remain the source of truth for:
- User
- Role
- Vertical
- User access mapping

MS SQL should contain:
- WorkflowMaster
- WorkflowStep
- RequestWorkflow
- WorkflowAudit / ApprovalHistory

WorkflowMaster should support:
- WorkflowId
- VerticalId
- Version
- IsActive
- CreatedOn
- CreatedBy

WorkflowStep should support:
- WorkflowStepId
- WorkflowId
- RoleId
- StepOrder
- IsActive

RequestWorkflow should track:
- RequestId
- VerticalId
- WorkflowId
- WorkflowVersion
- CurrentStepOrder
- CurrentRoleId
- Status
- CreatedOn
- UpdatedOn

Core approval logic:

For APPROVE:
- Get current WorkflowId and CurrentStepOrder from the database using RequestId.
- Find the next active workflow step:
  StepOrder > CurrentStepOrder
  ORDER BY StepOrder ASC
  TOP 1
- Move request to that RoleId / StepOrder.
- If no next step exists, mark request as COMPLETED.

For REJECT:
- Find the previous active workflow step:
  StepOrder < CurrentStepOrder
  ORDER BY StepOrder DESC
  TOP 1
- Move request back to that step.
- If business requirements later need configurable reject targets, design this to be extendable.

MANDATORY GENERIC QUERY DEVELOPMENT:
Do not only describe the query concept. Actually design and implement the generic SQL queries/stored-procedure sections required by this workflow.
These queries are new workflow infrastructure and may need to be developed separately before integrating them into the existing stored procedure.
Do not assume the existing stored procedure already provides these values.
First inspect the current database schema and current SP, then add the minimum new query logic necessary.

The generic query flow must explicitly include where every parameter/value comes from.

The UI/API should preferably send only:
- RequestId
- Action
- Remarks if required

The following values must NOT be trusted from the browser:
- WorkflowId
- WorkflowVersion
- CurrentStepOrder
- CurrentRoleId
- NextStepOrder
- NextRoleId
- Status

The stored procedure/service must obtain authoritative workflow values from the database.

Step A - Fetch current workflow context using RequestId:

SELECT
    @WorkflowId = WorkflowId,
    @WorkflowVersion = WorkflowVersion,
    @CurrentStepOrder = CurrentStepOrder,
    @CurrentRoleId = CurrentRoleId,
    @VerticalId = VerticalId
FROM RequestWorkflow
WHERE RequestId = @RequestId;

Parameter/value source explanation:
- @RequestId comes from the selected business record/API request.
- @Action comes from Approve/Reject action requested by the user.
- @WorkflowId comes from RequestWorkflow using @RequestId.
- @WorkflowVersion comes from RequestWorkflow using @RequestId.
- @CurrentStepOrder comes from RequestWorkflow using @RequestId.
- @CurrentRoleId comes from RequestWorkflow using @RequestId.
- @VerticalId comes from RequestWorkflow using @RequestId.
- @NextStepOrder and @NextRoleId are OUTPUT values discovered from WorkflowStep configuration; they are not inputs from UI.

Step B - Generic APPROVE next-step query:

SELECT TOP 1
    @NextStepOrder = StepOrder,
    @NextRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND StepOrder > @CurrentStepOrder
  AND IsActive = 1
ORDER BY StepOrder ASC;

If @NextStepOrder is NULL:
- The current step is the final configured step.
- Mark the request COMPLETED.

If @NextStepOrder is not NULL:
- Update RequestWorkflow.CurrentStepOrder = @NextStepOrder.
- Update RequestWorkflow.CurrentRoleId = @NextRoleId.
- Keep Status = PENDING.

Step C - Generic REJECT previous-step query:

SELECT TOP 1
    @PreviousStepOrder = StepOrder,
    @PreviousRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND StepOrder < @CurrentStepOrder
  AND IsActive = 1
ORDER BY StepOrder DESC;

Do not hardcode statements such as:
- If Verifier then go to Manager.
- If Manager rejects then go to Auditor.
- If HR approves then complete.
The workflow table and StepOrder must determine this dynamically.

Step D - New request workflow binding query:
For a NEW request, first determine VerticalId, then fetch the currently active workflow version for that vertical:

SELECT TOP 1
    @WorkflowId = WorkflowId,
    @WorkflowVersion = VersionNo
FROM WorkflowMaster
WHERE VerticalId = @VerticalId
  AND IsActive = 1
ORDER BY VersionNo DESC;

Then fetch the first active step:

SELECT TOP 1
    @CurrentStepOrder = StepOrder,
    @CurrentRoleId = RoleId
FROM WorkflowStep
WHERE WorkflowId = @WorkflowId
  AND IsActive = 1
ORDER BY StepOrder ASC;

Then insert RequestWorkflow with:
- RequestId
- VerticalId
- WorkflowId
- WorkflowVersion
- CurrentStepOrder
- CurrentRoleId
- Status = PENDING

Step E - Role removal safety query:
Before destructive removal from a workflow already in use, check pending requests:

SELECT COUNT(*) AS PendingCount
FROM RequestWorkflow
WHERE WorkflowId = @WorkflowId
  AND CurrentRoleId = @RoleId
  AND Status = 'PENDING';

Preferred versioned behavior:
- Do not modify/delete old published workflow steps used by existing requests.
- Publish a new workflow version without the removed role.
- Existing requests continue the old version.
- New requests use the new version.

Step F - Workflow versioning query logic:
Get current active version for the selected vertical.
Calculate NewVersion = CurrentVersion + 1.
Insert a NEW WorkflowMaster row.
Insert the new ordered WorkflowStep rows against the new WorkflowId.
Only after the new version is fully created, mark the old version inactive for NEW requests.
Keep old WorkflowMaster/WorkflowStep rows available for in-progress requests and audit history.

Very important meaning of IsActive on WorkflowMaster:
IsActive = 0 means do not assign this version to new requests.
It does NOT mean existing requests using this WorkflowId must stop working.

Example:
Workflow V1:
Verifier -> Accountant -> HR

Request 1001 starts on V1 and stores WorkflowId 101.

Admin changes flow and publishes V2:
Verifier -> Manager -> Auditor -> HR

Request 2001 starts on V2 and stores WorkflowId 102.

Expected behavior:
- Request 1001 continues WorkflowId 101 / V1.
- Request 2001 follows WorkflowId 102 / V2.
- Never overwrite V1 just because V2 is published.

For every generic query you develop, clearly document:
1. Why the query is required.
2. Which table it reads/writes.
3. Where each parameter comes from.
4. Which values are input from API.
5. Which values are fetched from DB.
6. Which values are calculated by the query.
7. What happens when the query returns no row.
8. How it interacts with the existing stored procedure.
9. Whether the existing SP section remains unchanged, is wrapped, or is replaced.
10. How to test the query independently before integrating it.

Do NOT blindly inject the new SQL into the existing SP.
First create/review the generic query logic separately, validate it with sample workflow data, and then merge only the workflow-decision portion into the existing SP with minimum changes.
Preserve existing business-table update logic unless it conflicts with the new design.

Role removal rules:
- Never physically delete a role used by workflow history.
- Use IsActive / soft-delete where appropriate.
- Before removing a role from an active workflow, check whether pending requests are currently assigned to that role.
- If pending records exist, block destructive removal initially and return a clear message.
- Prefer publishing a new workflow version without that role.
- Future enhancement can allow controlled migration to another step.

Workflow versioning is mandatory:
- Existing/in-progress requests must continue using the workflow version they started with.
- New workflow changes must create a new version.
- Old workflow versions must remain available for historical/in-progress requests.
- New requests should use only the latest active version.

Admin-only access:
- Workflow configuration page must be visible only to Admin.
- Do NOT rely only on hiding UI.
- Protect Controller/API endpoints using server-side authorization.
- If a normal user manually calls the API or URL, return 403 Forbidden.
- Role must come from authenticated server-side session/claims, not from editable client payload.

Admin Workflow Configuration UI:
- Vertical dropdown
- Existing ordered workflow steps
- Role dropdown/list
- Add role
- Remove role
- Move role up/down or drag-and-drop reorder
- Save/Publish workflow
- When published, create a new workflow version instead of overwriting the old one.

Stored procedure refactoring:
- Do NOT rewrite the complete existing SP if unnecessary.
- Preserve existing transaction handling, TRY/CATCH, sp_executesql, QUOTENAME, business update logic, and table iteration logic where safe.
- Refactor only the workflow decision-making part.
- Remove hardcoded role-specific CASE conditions and static status mapping.
- Replace them with generic WorkflowId + CurrentStepOrder + NextStep lookup.
- Develop and test the generic queries independently before merging them into the current SP.
- Show the exact old SP section that should be replaced and the exact new generic section that replaces it.

Security:
- Do not trust RoleId, WorkflowId, CurrentStepOrder, or status sent by the browser.
- UI should preferably send only RequestId + Action.
- Stored procedure/service should fetch authoritative workflow information from DB.
- Validate that the current authenticated user actually has permission for the current role/vertical before processing Approve/Reject.

Audit:
Maintain approval history such as:
- RequestId
- WorkflowId
- WorkflowVersion
- FromStep
- ToStep
- FromRoleId
- ToRoleId
- Action
- PerformedBy
- PerformedOn
- Remarks

For workflow configuration changes maintain:
- VerticalId
- OldVersion
- NewVersion
- ChangedBy
- ChangedOn
- Change description

Architecture:
MySQL:
Users / Roles / Verticals / UserAccess

.NET Application:
Authentication
Authorization
Workflow Service
Business Service

MS SQL:
Workflow configuration
Request state
Business records
Approval history

Important constraints:
- This is an existing production-style project.
- Make minimum invasive changes.
- Do not break current business logic.
- Before changing code, first review all relevant existing files and stored procedures.
- Explain what currently happens and identify hardcoded workflow dependencies.
- Do not directly replace large files without explaining the impact.
- Prefer incremental implementation.
- New generic workflow queries are allowed and expected where the current system does not have equivalent logic.
- 'Minimum changes' does NOT mean avoiding necessary new tables/queries; it means isolate the new workflow engine and avoid unnecessary changes to unrelated existing code.

Implementation order:
1. Review existing UI, API/controller/service, stored procedure, and relevant tables.
2. Identify all hardcoded role/status dependencies.
3. Identify where RequestId, VerticalId, RoleId, and current status currently come from.
4. Design the generic workflow SQL queries separately.
5. For each query, document parameter/value sources.
6. Create WorkflowMaster and WorkflowStep.
7. Add RequestWorkflow state tracking.
8. Seed/map the current 9 vertical flows into configuration data.
9. Test generic next-step and previous-step queries independently using sample data.
10. Add workflow versioning queries and test V1/V2 behavior.
11. Refactor only the workflow-decision part of the existing SP.
12. Keep stable existing business update logic wherever possible.
13. Update .NET service/API.
14. Remove frontend role-number switch mappings.
15. Add Admin-only workflow configuration.
16. Add audit history.
17. Test existing flows.
18. Test dynamic role add/remove/reorder scenarios.
19. Perform regression testing before removing old hardcoded code completely.

Required test scenarios:
- Vertical with 2 roles
- Vertical with 3 roles
- Vertical with 5 roles
- Add a new role in the middle
- Remove an unused role through a new workflow version
- Attempt to remove a role having pending requests
- Reorder workflow
- Approve through all steps
- Reject to previous step
- Complete on last step
- Existing request continues old workflow version
- New request follows new version
- Verify query parameters are loaded from RequestWorkflow, not browser payload
- Verify NextRoleId is calculated from WorkflowStep, not client input
- Unauthorized user cannot open workflow configuration
- Unauthorized API request returns 403
- Browser-modified RoleId must not bypass authorization

Very important:
Do not implement role flow using role names.
Do not implement sequence using status numbers.
Do not hardcode the number of steps.
Do not ask the browser to supply workflow state that can be fetched from the DB.
The same generic engine must work whether a vertical has 2, 3, 5, 9, or more roles.

When you respond:
1. First explain the current issue you detect.
2. Show the proposed architecture.
3. List exact files/SPs/tables that need changes.
4. Explain what will remain unchanged.
5. Identify all new generic SQL queries that must be developed.
6. For every query, show where every parameter/value comes from.
7. Give the DB migration first.
8. Build and test generic queries separately before SP integration.
9. Then implement one layer at a time.
10. Show the exact SP section to refactor rather than rewriting the entire SP.
11. After every major change, explain how I should test it.
12. If something in my current project conflicts with this design, do not guess—show the conflict and propose the safest solution.
```
