# Dependency Injection (DI) — मराठीत सविस्तर स्पष्टीकरण

## 1. Dependency Injection म्हणजे काय?
सोप्या भाषेत, एखाद्या class ला काम करण्यासाठी दुसऱ्या service/class ची गरज असेल, तर ती dependency त्या class ने स्वतः `new` करून तयार करण्याऐवजी बाहेरून provide करणे म्हणजे Dependency Injection.

उदाहरणार्थ `OrderService` ला notification पाठवण्यासाठी `EmailService` ची गरज आहे. जर `OrderService` स्वतः `new EmailService()` करत असेल तर दोन्ही classes एकमेकांशी tightly coupled होतात.

## 2. DI का वापरतो?
DI चा मुख्य उद्देश loose coupling तयार करणे आहे. त्यामुळे implementation बदलणे सोपे होते, unit testing सोपी होते, code maintain करणे सोपे होते आणि dependencies चे lifetime centrally manage करता येते.

## 3. DI वापरला नाही तर काय होईल?

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
        // Order save करणे
        _emailService.SendEmail();
    }
}
```

इथे `OrderService` स्वतः `EmailService` तयार करत आहे. त्यामुळे `OrderService` ला EmailService ची concrete implementation माहीत आहे.

उद्या requirement आली की email ऐवजी SMS पाठवायचा आहे, तर `OrderService` चा code बदलावा लागेल. अशा dependencies अनेक services मध्ये असतील तर requirement बदलल्यावर अनेक classes modify कराव्या लागू शकतात.

Unit testing करतानाही problem येतो. आपल्याला फक्त OrderService test करायचा असेल आणि actual email पाठवायचा नसेल, तरी EmailService internally तयार होत असल्यामुळे fake/mock service सहज देता येत नाही.

## 4. DI वापरून solution

```csharp
public interface INotificationService
{
    void Send();
}

public class EmailService : INotificationService
{
    public void Send()
    {
        Console.WriteLine("Email Sent");
    }
}
```

आता OrderService concrete EmailService वर depend न करता interface वर depend करेल:

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
        _notificationService.Send();
    }
}
```

ASP.NET Core मध्ये registration:

```csharp
builder.Services.AddScoped<INotificationService, EmailService>();
```

आता `OrderService` ला EmailService वापरली आहे की SmsService याची काळजी नाही. त्याला फक्त `INotificationService` contract माहिती आहे.

SMS वापरायचा असेल:

```csharp
builder.Services.AddScoped<INotificationService, SmsService>();
```

OrderService मध्ये बदल करण्याची गरज नाही.

## 5. DI आधी आणि DI नंतर

DI शिवाय:

```text
OrderService -> new EmailService()
```

DI सोबत:

```text
OrderController
      ↓
OrderService
      ↓
INotificationService
      ↓
EmailService / SmsService
```

म्हणजे business class dependency create करत नाही; DI container योग्य implementation resolve करून inject करतो.

## 6. Real project example
Banking application मध्ये `TransactionService` आहे असे समजा. DI शिवाय:

```csharp
var repository = new TransactionRepository();
var logger = new FileLogger();
var notification = new EmailService();
```

TransactionService ला database, logger आणि notification ची concrete implementation माहिती आहे. उद्या FileLogger ऐवजी दुसरा logger किंवा Email ऐवजी SMS आला तर business class modify करावा लागू शकतो.

DI वापरल्यावर:

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

आता TransactionService फक्त business logic वर focus करतो.

## 7. Unit Testing मध्ये फायदा
Fake notification service तयार करता येते:

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

Test मध्ये:

```csharp
var fake = new FakeNotificationService();
var service = new OrderService(fake);
service.PlaceOrder();
Assert.True(fake.WasCalled);
```

Actual email न पाठवता OrderService चं behavior test करता येतं.

## 8. Transient, Scoped आणि Singleton

### Transient
प्रत्येक वेळी dependency मागितली की नवीन instance मिळतो.

```csharp
builder.Services.AddTransient<IMyService, MyService>();
```

### Scoped
एका web request scope मध्ये साधारणपणे एकच instance वापरला जातो.

```csharp
builder.Services.AddScoped<IMyService, MyService>();
```

### Singleton
Application lifetime साठी एकच instance वापरला जातो.

```csharp
builder.Services.AddSingleton<IMyService, MyService>();
```

Singleton वापरताना thread safety आणि shorter-lived scoped dependencies बद्दल काळजी घ्यावी लागते.

## 9. Constructor Injection का preferred आहे?

```csharp
public EmployeeService(IEmployeeRepository repository)
{
    _repository = repository;
}
```

Class ला कोणत्या dependencies आवश्यक आहेत हे constructor मधून स्पष्ट दिसते. त्यामुळे code समजणे आणि test करणे सोपे होते.

## 10. DI आणि Dependency Inversion Principle मधला फरक
Dependency Inversion Principle हा SOLID principle आहे. High-level module ने low-level concrete implementation वर थेट depend न करता abstraction वर depend करावे असे तो सांगतो.

Dependency Injection ही dependencies बाहेरून supply करण्याची technique आहे. DI वापरून Dependency Inversion Principle implement करण्यास मदत होते, पण दोन्ही शब्द एकच नाहीत.

## 11. Interview मध्ये सांगण्यासारखे उत्तर
> Dependency Injection म्हणजे class ने स्वतःच्या dependencies `new` keyword वापरून तयार करण्याऐवजी त्या dependencies बाहेरून inject करणे. यामुळे tight coupling कमी होते, implementation सहज बदलता येते, unit testing मध्ये mock/fake dependencies देता येतात आणि dependency lifetime centrally manage करता येते. ASP.NET Core मध्ये built-in DI container आहे आणि आपण services Transient, Scoped किंवा Singleton lifetime ने register करू शकतो.

## 12. Interviewer विचारला: DI नसता तर काय problem होईल?
> DI नसल्यास classes concrete dependencies स्वतः create करू शकतात, त्यामुळे tight coupling वाढते. Implementation बदलल्यावर dependent classes modify कराव्या लागू शकतात. Unit testing कठीण होते कारण actual dependency mock/fake ने replace करणे सोपे नसते. तसेच object creation आणि lifetime management application मध्ये scattered होऊ शकते.

## 13. लक्षात ठेवण्याची shortcut line

```text
Without DI = class स्वतः dependency तयार करतो
With DI    = class dependency मागतो, container ती provide करतो
```

## 14. 5 Years Experience Interview Pattern
प्रत्येक topic असा prepare करा:

```text
What is it?
    ↓
Why do we need it?
    ↓
नसता तर काय झालं असतं?
    ↓
Problem example
    ↓
Solution + Code
    ↓
Real Project Scenario
    ↓
Common Mistakes
    ↓
Interview-ready Answer
    ↓
Follow-up Questions
```

फक्त definition पाठ करण्याऐवजी interviewer ला problem, reason, implementation आणि production impact explain करता आला पाहिजे.
