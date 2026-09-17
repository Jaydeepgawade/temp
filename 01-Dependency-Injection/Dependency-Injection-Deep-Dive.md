# Dependency Injection (DI) — 5 Years Experience Interview Preparation

## 1. What is Dependency Injection?
Dependency Injection is a design technique used to reduce tight coupling between classes. Instead of a class creating its own dependencies using `new`, those dependencies are supplied from outside, commonly through constructor injection.

In ASP.NET Core, the built-in DI container creates and supplies registered services automatically.

## 2. Why do we need DI?
Without DI, business classes often directly create concrete services. This makes code tightly coupled, harder to test, harder to maintain, and harder to extend when requirements change.

DI gives us loose coupling, easier unit testing, replaceable implementations, centralized dependency configuration, and controlled object lifetimes.

## 3. What happens if we do NOT use DI?
Consider an order service that creates EmailService itself:

```csharp
public class OrderService
{
    private readonly EmailService _emailService;

    public OrderService()
    {
        _emailService = new EmailService();
    }

    public void PlaceOrder()
    {
        // Save order
        _emailService.SendEmail();
    }
}
```

The problem is that OrderService knows exactly which concrete class it must create. It is tightly coupled to EmailService.

Suppose tomorrow the requirement changes from email notification to SMS notification. We now need to modify OrderService itself. If similar concrete dependencies are created in many classes, the same type of change can spread throughout the application.

Testing is another problem. During a unit test of OrderService, we usually do not want to send a real email. Because OrderService creates EmailService internally, replacing it with a fake or mock is difficult.

## 4. Solution using DI
First create an abstraction:

```csharp
public interface INotificationService
{
    void Send();
}
```

Create the email implementation:

```csharp
public class EmailService : INotificationService
{
    public void Send()
    {
        Console.WriteLine("Email Sent");
    }
}
```

Inject the abstraction into OrderService:

```csharp
public class OrderService
{
    private readonly INotificationService _notificationService;

    public OrderService(INotificationService notificationService)
    {
        _notificationService = notificationService;
    }

    public void PlaceOrder()
    {
        // Save order
        _notificationService.Send();
    }
}
```

Register it in ASP.NET Core:

```csharp
builder.Services.AddScoped<INotificationService, EmailService>();
```

Now OrderService does not care whether the implementation is EmailService, SmsService, or another notification provider. It only depends on the contract.

If the requirement changes to SMS:

```csharp
builder.Services.AddScoped<INotificationService, SmsService>();
```

The OrderService code does not need to change.

## 5. Before DI vs After DI

Without DI:

```text
OrderService -> new EmailService()
```

OrderService controls creation of its dependency and depends directly on a concrete implementation.

With DI:

```text
OrderController
      |
      v
OrderService
      |
      v
INotificationService
      |
      v
EmailService
```

The DI container resolves the implementation and injects it into the dependent class.

## 6. Real-world project scenario
Imagine a banking application where TransactionService directly creates several dependencies:

```csharp
var repository = new TransactionRepository();
var logger = new FileLogger();
var notification = new EmailService();
```

As the application grows, infrastructure decisions become mixed with business logic. Changing logging, database access, or notification providers requires modifying business classes.

With DI, TransactionService can depend on abstractions:

```csharp
public TransactionService(
    ITransactionRepository repository,
    ILogger<TransactionService> logger,
    INotificationService notificationService)
{
    _repository = repository;
    _logger = logger;
    _notificationService = notificationService;
}
```

Now implementations are configured centrally and TransactionService focuses on business logic.

## 7. How DI improves unit testing
A fake implementation can be passed during testing:

```csharp
public class FakeNotificationService : INotificationService
{
    public bool WasCalled { get; private set; }

    public void Send()
    {
        WasCalled = true;
    }
}
```

Test:

```csharp
var fakeNotification = new FakeNotificationService();
var service = new OrderService(fakeNotification);

service.PlaceOrder();

Assert.True(fakeNotification.WasCalled);
```

No real email is sent. This is one of the practical benefits interviewers expect an experienced developer to understand.

## 8. DI service lifetimes in ASP.NET Core

### Transient
```csharp
builder.Services.AddTransient<IMyService, MyService>();
```
A new instance is created each time the service is requested. Suitable for lightweight, stateless services.

### Scoped
```csharp
builder.Services.AddScoped<IMyService, MyService>();
```
One instance is normally used within a single web request scope. This is commonly used for request-oriented business services and database contexts.

### Singleton
```csharp
builder.Services.AddSingleton<IMyService, MyService>();
```
One instance is used for the application's lifetime. Singleton services must be designed carefully for thread safety and must not directly capture shorter-lived scoped dependencies.

## 9. Constructor Injection
Constructor injection is generally the preferred approach because required dependencies are explicit and the object cannot normally be created without them.

```csharp
public class EmployeeService
{
    private readonly IEmployeeRepository _repository;

    public EmployeeService(IEmployeeRepository repository)
    {
        _repository = repository;
    }
}
```

## 10. Dependency Injection vs Dependency Inversion
These terms are related but not identical.

Dependency Inversion Principle is a SOLID design principle: high-level modules should not depend directly on low-level implementation details; both should depend on abstractions.

Dependency Injection is a technique that can help implement that principle by supplying dependencies from outside the class.

## 11. Common mistakes
Do not say that DI means simply using interfaces. An interface can exist without dependency injection.

Do not say DI completely removes dependencies. The class still has dependencies; they are made explicit and supplied externally.

Avoid manually calling `new` for application services everywhere when those services should be managed by the container.

Be careful with service lifetimes. Injecting a scoped service directly into a singleton can create lifetime problems.

## 12. Interview-ready answer
> Dependency Injection is a technique for reducing tight coupling between classes. Instead of a class creating concrete dependencies itself using the `new` keyword, dependencies are supplied from outside, usually through constructor injection. In ASP.NET Core, I register implementations in the built-in DI container using Transient, Scoped, or Singleton lifetimes. This makes implementations easier to replace, improves maintainability and unit testing, and keeps object creation separate from business logic.

## 13. If interviewer asks: What happens without DI?
> Without DI, classes often create concrete dependencies themselves. That introduces tight coupling. If an implementation changes, dependent classes may also need modification. Unit testing becomes harder because real dependencies cannot easily be replaced with mocks or fakes, and object lifetime management becomes scattered across the application.

## 14. Follow-up interview questions
1. What is the difference between Transient, Scoped, and Singleton?
2. Why is constructor injection preferred?
3. Can a Singleton service depend on a Scoped service?
4. What is a captive dependency?
5. How does ASP.NET Core resolve dependencies internally?
6. What happens when a dependency is not registered?
7. What is the difference between DI and Dependency Inversion Principle?
8. How do you unit test a service that uses DI?
9. When would you register multiple implementations of the same interface?
10. What problems can incorrect service lifetimes cause?

## 15. Five-year-experience expectation
For an experienced interview, do not stop at the definition. Explain the business problem first, show what happens without DI, demonstrate the refactoring, discuss service lifetimes and testing, and connect the concept to a real production scenario.

For every major topic in this interview branch, use the same learning flow:

```text
What is it?
    ↓
Why do we need it?
    ↓
What happens without it?
    ↓
Problem example
    ↓
Solution with code
    ↓
Real project scenario
    ↓
Common mistakes
    ↓
Interview-ready answer
    ↓
Follow-up questions
```
