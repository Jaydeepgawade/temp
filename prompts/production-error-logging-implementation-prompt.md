# Prompt: Implement Production-Level Error Logging with Minimal Changes

I want you to review my existing .NET 8 ASP.NET MVC application and implement production-level centralized error handling and database error logging with the **minimum possible changes to the existing codebase**.

## Important Rules

1. First review the existing project structure, current exception handling, controller flow, service layer, repository layer, database access pattern, and middleware pipeline.
2. Do **not** rewrite the project architecture.
3. Do **not** refactor unrelated working code.
4. Do **not** change existing business logic unless it is required for error handling.
5. Keep existing controller/service/repository method signatures unchanged wherever possible.
6. Avoid adding repetitive try-catch blocks in every controller or service method.
7. Prefer a centralized/global exception handling approach.
8. Keep the implementation production-ready, maintainable, secure, and easy to debug.
9. Before changing files, clearly list which files you plan to add or modify and why.
10. After implementation, provide a concise summary of all changes.

## Existing Error Table

I already have a database table named:

`IMS_UAT.ErrorLogMaster`

Existing columns include:

- ErrorId bigint primary key auto_increment
- UserId int nullable
- ErrorDate datetime default current_timestamp
- ErrorCode bigint nullable
- ErrorMsg varchar(1000) nullable
- ErrorPara text nullable
- ErrorFrom varchar(200) nullable
- FrmProcess varchar(200) nullable
- ErrorObjType char(1) nullable
- ConstraintName varchar(200) nullable
- TableName varchar(100) nullable
- ColumnName varchar(100) nullable
- SearchCondition varchar(1000) nullable
- RefTableName varchar(100) nullable
- RefColumnName varchar(100) nullable
- RequestUrl varchar(500) nullable
- StackTrace longtext nullable
- ServerName varchar(200) nullable

Use this existing table instead of creating a completely new logging table unless there is a strong technical reason.

## Main Goal

When an unexpected error happens in Production, I should be able to quickly understand:

- what error occurred
- where it occurred
- which method/process failed
- which URL/request caused it
- which logged-in user was affected, when available
- database-related details when available
- inner exception details
- complete stack trace
- server/machine name
- a unique ErrorId or TraceId that can be shared by the user/support team

## Required Architecture

Implement a centralized error logging flow similar to:

Request
→ Controller
→ Service
→ Repository / Database / External API
→ Exception
→ Global Exception Middleware / Handler
→ ErrorLogService
→ ErrorLogMaster table
→ safe response to user containing ErrorId/TraceId

Prefer one reusable error logging service instead of directly writing INSERT logic in multiple catch blocks.

## Global Exception Handling

Implement a production-level global exception middleware or ASP.NET Core exception handler.

It should:

- catch unhandled exceptions
- generate/use the current TraceIdentifier or a correlation ID
- capture the actual exception
- capture inner exception details
- call a reusable ErrorLogService
- persist the error to ErrorLogMaster
- return a safe response
- never expose stack trace or internal database details to the end user in Production

For MVC page requests, preserve the current application behavior as much as possible.

For AJAX/API requests, return a predictable JSON error response where appropriate.

Example safe response shape:

```json
{
  "success": false,
  "message": "Something went wrong. Please try again or contact support.",
  "errorId": 12345,
  "traceId": "0H..."
}
```

Do not force this response shape if the existing application already has a standard response model; integrate with the existing response model instead.

## ErrorLogService

Create a reusable service such as:

`IErrorLogService`

and

`ErrorLogService`

The service should be responsible only for creating a safe ErrorLogMaster record.

Do not duplicate logging code across controllers.

The service should accept enough context to populate as many existing columns as possible.

Capture values like:

- UserId
- ErrorCode
- ErrorMsg
- ErrorPara
- ErrorFrom
- FrmProcess
- ConstraintName
- TableName
- ColumnName
- SearchCondition
- RefTableName
- RefColumnName
- RequestUrl
- StackTrace
- ServerName

Use sensible null values when specific information is not available.

## Exception Information

For the actual error message, prefer the most useful exception message while preserving the outer exception context.

Capture:

- ex.Message
- ex.InnerException?.Message
- exception type
- stack trace
- source

If the database driver exposes useful information such as:

- error number/code
- SQL state
- constraint name
- table name
- column name
- duplicate key information
- foreign key information
- datatype conversion information

capture it when reliably available.

Do not hardcode messages such as `datatype mismatch` for all failures.

The actual exception must be recorded so that the root cause is visible.

## Database Exceptions

Review which database provider this project currently uses and implement provider-specific handling only when necessary.

Examples of error categories to identify when possible:

- datatype conversion / invalid value
- duplicate key / unique constraint
- foreign key constraint violation
- null constraint violation
- database connection failure
- command timeout
- deadlock
- stored procedure failure
- syntax error

Do not rely only on parsing raw error strings if the provider exposes structured error properties.

If structured information is unavailable, save the raw exception safely and leave optional metadata columns null.

## Local Catch Blocks

Do not remove every existing catch block automatically.

Review them first.

Keep local catch blocks only when they provide meaningful business handling, for example:

- expected validation errors
- duplicate business records
- user-friendly domain errors
- retry logic
- transaction rollback
- resource cleanup

Unexpected exceptions should either be rethrown using:

```csharp
throw;
```

or allowed to propagate to the global exception handler.

Never use:

```csharp
throw ex;
```

because it can damage the original stack trace.

Do not swallow exceptions silently.

## Logging Failure Safety

This is very important:

If inserting into `ErrorLogMaster` itself fails, the application must not enter an infinite exception loop.

The error logging component should fail safely.

Use the existing ILogger fallback where appropriate so that a logging-table failure does not replace the original exception.

Do not recursively call ErrorLogService when ErrorLogService itself fails.

## Sensitive Data Protection

Never store the following in ErrorPara, logs, stack-related custom metadata, or user-visible responses:

- passwords
- access tokens
- JWT tokens
- refresh tokens
- API keys
- database connection strings
- private keys
- full card data
- CVV
- authorization headers
- session IDs
- sensitive personal data unless absolutely required and approved

If request parameters are logged, create a sanitization/redaction helper.

Mask fields such as:

- password
- confirmPassword
- token
- accessToken
- refreshToken
- authorization
- secret
- apiKey

Do not blindly serialize the entire HttpContext or request body.

## UserId

If the current logged-in UserId already exists in:

- Claims
- Session
- authentication context

reuse the current mechanism.

Do not introduce a new authentication mechanism just for logging.

If UserId cannot be determined, save null.

## Request Information

Capture safely when available:

- HTTP method
- Request.Path / URL
- QueryString only if it does not expose sensitive data
- TraceIdentifier / correlation ID
- controller/action/process name
- server/machine name

If the existing ErrorLogMaster table does not have dedicated fields for TraceId, HttpMethod, StatusCode, ExceptionType, or Environment, do **not** alter the table immediately.

First show me a recommendation for optional future columns such as:

- TraceId varchar(100)
- HttpMethod varchar(10)
- StatusCode int
- ExceptionType varchar(300)
- Environment varchar(50)

The current implementation must still work with the existing table.

## ErrorPara

Use ErrorPara only for sanitized useful debugging context.

Examples:

- safe record ID
- safe filter values
- operation name
- sanitized DTO summary

Avoid storing large payloads.

Add a maximum length/size strategy where appropriate.

## Stack Trace

Save the full useful exception stack trace into StackTrace.

Preserve the original exception stack trace.

Include inner exception context where useful.

Do not show StackTrace to the end user.

## FrmProcess and ErrorFrom

Populate these fields in a useful way.

Example:

- ErrorFrom = `EmployeeRepository`
- FrmProcess = `SaveEmployeeAsync`

or

- ErrorFrom = `EmployeeController`
- FrmProcess = `Save`

Prefer actual type/method context instead of generic values like `Controller Error`.

## ErrorCode

If the database/provider exposes a numeric error code, store it.

If no numeric error code exists, leave ErrorCode null rather than inventing random numbers.

Do not overload ErrorCode with HTTP status unless that is already the application's convention.

## Transactions

If the application uses database transactions:

- preserve existing transaction logic
- rollback appropriately on failure
- log the original exception after rollback attempt
- do not let logging accidentally participate in a failed business transaction if that would prevent the error record from being saved

If needed, explain how the ErrorLogService should use a separate connection/transaction scope.

## ADO.NET / Repository Requirement

If the existing project uses ADO.NET, continue using the existing database access style.

Do not introduce Entity Framework only for error logging.

If the project already has a common database helper/repository pattern, reuse it where safe.

However, avoid a design where the same failing database helper causes recursive logging failures.

## Performance

The implementation must not significantly slow normal successful requests.

Do not insert error logs for successful requests.

Do not log every normal validation message as a production exception.

Avoid synchronous blocking if the project is already async.

Use async database operations where the existing project supports them.

## ILogger Integration

Keep/use `ILogger<T>` in addition to the database table.

The database table is useful for support and business troubleshooting, but application logging should still exist.

On an unhandled exception:

- write structured ILogger error log
- save ErrorLogMaster record
- include ErrorId/TraceId in the log scope where possible

Do not log the same exception repeatedly at Controller + Service + Repository + Middleware unless there is a specific reason.

Prefer logging once at the final handling boundary.

## Production vs Development

In Development:

- detailed exception diagnostics may be available to developers

In Production:

- never expose raw exception messages, SQL errors, table names, connection details, or stack traces to the user
- return a generic support-friendly message
- return ErrorId/TraceId so support can search the logs

Respect the project's existing environment configuration.

## Expected Support Flow

The final implementation should support this workflow:

1. User reports: `Save button gives an error.`
2. UI/API response provides `ErrorId = 58721` or a TraceId.
3. Support/developer searches ErrorLogMaster by ErrorId.
4. Record shows actual error such as:
   `Incorrect integer value 'ABC' for column 'UserId'`
5. Record also shows process, URL, user, stack trace, server, and related metadata.
6. Developer can identify whether the failure came from controller, service, repository, database, or external API.

## Required Deliverables

After reviewing the existing codebase, provide and implement:

1. A short analysis of the current error handling.
2. Exact list of files to add/change.
3. ErrorLog model/entity/DTO only if required.
4. `IErrorLogService`.
5. `ErrorLogService`.
6. Production-safe database insert logic using the project's existing DB technology.
7. Global exception middleware/handler.
8. Program.cs registration with correct middleware order.
9. Minimal integration changes.
10. AJAX/API handling compatible with the existing frontend.
11. Sensitive-data sanitization.
12. Logging-failure fallback.
13. Example ErrorLogMaster record for a datatype mismatch.
14. Example for duplicate key error.
15. Example for DB timeout.
16. Example for NullReferenceException.
17. Example production response containing ErrorId/TraceId.
18. Manual testing steps.
19. Regression checklist.
20. Explanation of how to search/debug production issues using ErrorId.

## Testing Scenarios

Please verify at minimum:

- normal request still works
- validation error does not become a 500
- NullReferenceException is captured globally
- database datatype mismatch is logged
- duplicate key is logged
- FK violation is logged
- timeout is logged
- inner exception is captured
- request URL is saved
- UserId is saved when available
- stack trace is saved
- server name is saved
- user receives generic message only
- ErrorId is returned/displayed
- sensitive values are not persisted
- logging-table failure does not cause recursive exception handling
- existing login/session flow is not broken
- existing APIs and AJAX calls continue to work

## Final Constraint

The most important requirement is:

**Implement production-level centralized error handling with the fewest possible changes to my existing working project.**

Do not give me only sample code. First inspect my actual project and adapt the implementation to my current architecture, naming conventions, database access pattern, existing response models, and middleware pipeline.

If you find multiple valid approaches, choose the one requiring the least disruption while still being safe for Production.
