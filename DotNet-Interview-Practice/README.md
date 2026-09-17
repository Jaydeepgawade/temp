# .NET Interview Practice — 5 Years Experience Level

This branch is designed for .NET interview preparation at approximately 5 years experience level. The goal is not to memorize definitions, but to explain concepts with production scenarios, trade-offs, debugging approaches, and clean code examples.

## Study Areas

1. Advanced C# and OOP
2. ASP.NET Core and Web API
3. Dependency Injection and Middleware
4. async/await, Tasks and Concurrency
5. LINQ and Collections
6. Entity Framework Core and ADO.NET
7. SQL Server and Query Optimization
8. Authentication, Authorization, JWT and Security
9. Microservices Architecture
10. RabbitMQ and Asynchronous Communication
11. Caching and Application Performance
12. SOLID Principles and Design Patterns
13. Clean/Onion/N-Layer Architecture and CQRS
14. Exception Handling, Logging and Monitoring
15. Unit Testing and Integration Testing
16. IIS, Deployment and CI/CD
17. Git and Code Review
18. Production Troubleshooting Scenarios
19. C# Coding Round Problems
20. SQL Interview Problems

## How to Answer at 5-Year Level

For each interview question, use this structure:

- Definition: Explain what the concept is.
- Why: Explain why we need it.
- How: Explain how it works internally or in ASP.NET Core.
- Example: Give a short practical example.
- Project Usage: Explain where you used or would use it in a real application.
- Trade-off: Mention disadvantages or alternatives when relevant.
- Follow-up: Be prepared for the interviewer's next question.

## Example Question — Dependency Injection

### Question
What is Dependency Injection in ASP.NET Core and why do you use it?

### Interview-ready answer
Dependency Injection is a design technique where a class receives the dependencies it requires instead of creating those dependencies itself. ASP.NET Core provides a built-in DI container. We register services in the application container and request them through constructor injection.

DI reduces tight coupling, improves testability, centralizes object creation, and makes implementations easier to replace.

### Example

```csharp
public interface ICustomerService
{
    Task<Customer?> GetByIdAsync(int id);
}

public class CustomerService : ICustomerService
{
    public Task<Customer?> GetByIdAsync(int id)
    {
        // Fetch customer from repository/database.
        throw new NotImplementedException();
    }
}

builder.Services.AddScoped<ICustomerService, CustomerService>();

public class CustomerController : ControllerBase
{
    private readonly ICustomerService _customerService;

    public CustomerController(ICustomerService customerService)
    {
        _customerService = customerService;
    }
}
```

### Important follow-up
Explain Transient, Scoped and Singleton lifetimes and why injecting a Scoped service directly into a Singleton is problematic.

## Example Scenario — Slow API

### Question
An API that previously responded in 300 ms now takes 5 seconds when the table contains 20,000+ records. How would you troubleshoot it?

### Strong answer structure
Do not immediately add caching. First identify the bottleneck.

1. Measure API, service and database execution time.
2. Inspect generated SQL/stored procedure execution.
3. Check the actual SQL execution plan.
4. Look for table scans, missing/ineffective indexes and expensive joins.
5. Verify that filters execute in the database rather than after loading data into memory.
6. Avoid unnecessary columns and large object graphs.
7. Review pagination or virtualization requirements.
8. Check N+1 queries when using an ORM.
9. Use async database/network operations for I/O scalability.
10. Add caching only when the data and consistency requirements make caching appropriate.
11. Load-test again and compare measurements before and after the change.

At a 5-year interview level, explain both the solution and how you proved where the performance problem existed.

## Practice Rule

For every topic, practice explaining the answer aloud in 2–3 minutes, then answer follow-up questions without reading notes. Interviewers generally learn more from your reasoning around real scenarios than from textbook definitions.
