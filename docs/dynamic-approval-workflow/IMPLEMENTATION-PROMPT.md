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

Role removal rules:
- Never physically delete a role used by workflow history.
- Use IsActive / soft-delete.
- Before removing a role from an active workflow, check whether pending requests are currently assigned to that role.
- If pending records exist, block removal initially and return a clear message.
- Future enhancement can allow controlled migration to another step.

Workflow versioning is mandatory:
- Existing/in-progress requests must continue using the workflow version they started with.
- New workflow changes must create a new version.
- Old workflow versions must remain available for historical/in-progress requests.
- New requests should use only the latest active version.

Example:

Workflow V1:
Verifier -> Accountant -> HR

Existing request:
Request 1001 -> Workflow V1

Admin changes flow.

Workflow V2:
Verifier -> Manager -> Auditor -> HR

New request:
Request 2001 -> Workflow V2

Request 1001 must continue V1.
Request 2001 must follow V2.

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

Security:
- Do not trust RoleId, WorkflowId, CurrentStepOrder, or status sent by the browser.
- UI should preferably send only RequestId + Action.
- Stored procedure/service should fetch authoritative workflow information from DB.
- Validate that the current authenticated user actually has permission for the current role/vertical before processing Approve/Reject.

Audit:
Maintain audit/history such as:
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

Implementation order:
1. Review existing UI, API/controller/service, and stored procedure.
2. Identify all hardcoded role and status dependencies.
3. Propose database migration.
4. Create WorkflowMaster and WorkflowStep.
5. Map current 9 vertical flows into configuration data.
6. Add RequestWorkflow state tracking.
7. Refactor SP workflow logic.
8. Update .NET service/API.
9. Remove frontend role-number switch mappings.
10. Add Admin-only workflow configuration.
11. Add workflow versioning.
12. Add audit history.
13. Test existing flows.
14. Test dynamic role add/remove/reorder scenarios.

Required test scenarios:
- Vertical with 2 roles
- Vertical with 3 roles
- Vertical with 5 roles
- Add a new role in the middle
- Remove an unused role
- Attempt to remove a role having pending requests
- Reorder workflow
- Approve through all steps
- Reject to previous step
- Complete on last step
- Existing request continues old workflow version
- New request follows new version
- Unauthorized user cannot open workflow configuration
- Unauthorized API request returns 403
- Browser-modified RoleId must not bypass authorization

Very important:
Do not implement role flow using role names.
Do not implement sequence using status numbers.
Do not hardcode the number of steps.
The same generic engine must work whether a vertical has 2, 3, 5, 9, or more roles.

When you respond:
1. First explain the current issue you detect.
2. Show the proposed architecture.
3. List exact files/SPs/tables that need changes.
4. Explain what will remain unchanged.
5. Give the DB migration first.
6. Then implement one layer at a time.
7. After every major change, explain how I should test it.
8. If something in my current project conflicts with this design, do not guess—show the conflict and propose the safest solution.
```
