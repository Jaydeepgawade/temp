# ASP.NET Session Management – Interview Practice

## 1. What is Session Management?
Session management is a way to store user-specific data across multiple HTTP requests.

HTTP is stateless, which means the server does not automatically remember a user between requests. Session provides a mechanism to maintain temporary user data such as login information, user preferences, workflow state, and selected values.

### Interview Answer
> Session management is used to maintain user-specific data across multiple requests because HTTP is stateless.

---

## 2. Why do we need Session in ASP.NET?
Without session, every request is treated independently. If a user logs in and then moves to another page, the application needs some mechanism to remember that the user is already authenticated or to retain temporary data.

Typical session use cases:
- Logged-in user information
- User ID
- Role or permissions
- Shopping cart information
- Temporary workflow data
- Selected filters or preferences

---

## 3. What does Stateless HTTP mean?
HTTP does not remember previous requests by default.

Example:
1. User sends login request.
2. Server validates credentials.
3. User sends another request.
4. Without cookies, tokens, or session, the server does not automatically know that both requests belong to the same user.

This is why applications use mechanisms such as cookies, session, JWT, or authentication tickets.

---

## 4. How does Session work internally?
A common flow is:

1. User sends a request.
2. Server creates or reads a session identifier.
3. Session ID is usually stored in a cookie.
4. The server stores session data against that session ID.
5. On the next request, the browser sends the cookie.
6. Server uses the session ID to load that user's session data.

Important point: The browser generally stores the session identifier, not all server-side session values.

---

## 5. Session vs Cookie

| Session | Cookie |
|---|---|
| Usually stores data on the server | Stores data in the browser |
| Client normally keeps only a session identifier | Actual cookie value is sent by the client |
| Better for temporary server-side user state | Useful for preferences, identifiers, auth cookies, etc. |
| Can consume server/distributed cache memory | Limited by browser cookie size |

### Interview Question
**Is Session the same as Cookie?**

No. A cookie is client-side storage sent with HTTP requests. Session is typically server-side state identified using a session cookie.

---

## 6. Session vs JWT

### Session-based approach
- Server keeps session state.
- Client sends a session cookie.
- Server loads session data.

### JWT-based approach
- Token contains claims/data needed for authentication and authorization.
- Server can validate the token without keeping traditional user session state.
- Common in APIs and microservices.

### Interview Answer
Session is generally stateful because the server stores session data, whereas JWT authentication is commonly implemented as a stateless approach.

---

## 7. What is Session Timeout?
Session timeout defines how long a session can remain inactive before it expires.

Example:
- Timeout = 20 minutes
- User does not make a request for 20 minutes
- Session expires
- User may need to log in again or recreate temporary state

---

## 8. What happens when Session expires?
After session expiration:
- Session values may no longer be available.
- Accessing a required session value can return null/missing data.
- The application should handle this safely.
- Protected pages should normally redirect the user to the login page.

A user-friendly message can be shown:

`Your session has expired. Please login again.`

---

## 9. How should Session expiry be handled globally?
Avoid checking the same session value inside every controller action.

Bad approach:
```csharp
if (HttpContext.Session.GetString("UserId") == null)
{
    return RedirectToAction("Login", "Account");
}
```

If this logic is repeated in every action, it creates duplicate code.

Better approaches include:
- Action filter
- Authorization filter
- Base controller in some legacy designs
- Custom middleware for suitable cross-cutting request checks

For MVC action-level session validation, a custom action/authorization filter is often cleaner than repeating code in every controller method.

---

## 10. Example: Custom Session Action Filter

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

public class SessionCheckFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context)
    {
        var userId = context.HttpContext.Session.GetString("UserId");

        if (string.IsNullOrEmpty(userId))
        {
            context.Result = new RedirectToActionResult(
                "Login",
                "Account",
                new { sessionExpired = true });
        }
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
    }
}
```

This avoids writing the same check repeatedly inside every action method.

---

## 11. How do you configure Session in ASP.NET Core / .NET 8?

In `Program.cs`:

```csharp
builder.Services.AddDistributedMemoryCache();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(20);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});
```

Then enable session in the request pipeline:

```csharp
app.UseSession();
```

Middleware order matters. Session must be enabled before endpoints/actions that need to use it.

---

## 12. How do you store values in Session?

```csharp
HttpContext.Session.SetString("UserName", "Jaydeep");
```

For integers:

```csharp
HttpContext.Session.SetInt32("UserId", 101);
```

---

## 13. How do you read values from Session?

```csharp
string? userName = HttpContext.Session.GetString("UserName");
int? userId = HttpContext.Session.GetInt32("UserId");
```

Always consider that the value may be null because the session may have expired or the key may not exist.

---

## 14. How do you remove a single Session value?

```csharp
HttpContext.Session.Remove("UserName");
```

---

## 15. How do you clear the entire Session?

```csharp
HttpContext.Session.Clear();
```

This is commonly used during logout when application-specific temporary session values need to be removed.

---

## 16. What is the difference between Remove and Clear?

`Remove("key")` removes only one session value.

`Clear()` removes all values from the current session.

---

## 17. Should passwords be stored in Session?
No.

Sensitive information such as plain-text passwords should never be stored in session. Store only the minimum necessary user-related state.

Good examples:
- User ID
- Display name
- Non-sensitive role identifier

Avoid:
- Password
- Secret keys
- Full card information
- Highly sensitive personal data

---

## 18. What problems can occur when Session is used heavily?
Heavy use of session can cause:
- Higher server memory/cache usage
- More complexity in load-balanced environments
- Serialization overhead with distributed session stores
- Tight coupling between requests and temporary server state
- Difficult scaling if session is stored only in one server's memory

Therefore, session should be used only for necessary temporary state.

---

## 19. What happens to Session in Load Balancing?
Suppose an application runs on two servers:

- Request 1 → Server A
- Session stored only in Server A memory
- Request 2 → Server B

Server B may not have that session data.

Common solutions:
- Sticky sessions (less flexible)
- Distributed session storage
- Redis
- SQL Server distributed cache
- Another shared distributed cache

---

## 20. In-Memory Session vs Distributed Session

### In-Memory
- Stored in application memory
- Simple and fast
- Works well for a single server
- Data is lost when the application restarts
- Not ideal for multi-server environments without affinity

### Distributed
- Stored in a shared external store
- Multiple application instances can access it
- Better for scaled-out systems
- Examples: Redis, SQL Server distributed cache

---

## 21. Session vs TempData vs ViewData vs ViewBag

### Session
Used across multiple requests for temporary user-specific state.

### TempData
Usually intended to survive one subsequent request, especially after redirects.

### ViewData
Passes data from controller to view for the current request.

### ViewBag
Dynamic wrapper around ViewData for the current request.

### Interview Shortcut
- ViewData/ViewBag → current request
- TempData → typically next request
- Session → multiple requests until removed/expired

---

## 22. Session vs Cache
Session stores user-specific temporary state.

Cache stores reusable data to improve performance and is commonly shared by many requests/users depending on the cache design.

Example:
- Current logged-in UserId → Session
- Product category master data → Cache

---

## 23. Can Session be used inside an API?
Technically it can be used in some architectures, but REST APIs commonly prefer stateless authentication and avoid server-side session where possible.

Typical API approach:
- JWT / OAuth token
- Claims
- Database or distributed cache only when required

---

## 24. Is Session secure?
Session can be used securely if configured correctly, but developers must protect the session identifier and avoid storing unnecessary sensitive data.

Good practices:
- HTTPS
- HttpOnly cookies
- Secure cookie configuration in production
- Appropriate SameSite settings
- Regenerate authentication state after login where applicable
- Avoid predictable identifiers
- Clear relevant state during logout

---

## 25. What is Session Hijacking?
Session hijacking occurs when an attacker obtains a valid session identifier and uses it to impersonate a user.

Risk reduction techniques:
- HTTPS
- Secure cookies
- HttpOnly cookies
- Correct SameSite settings
- Strong authentication/session handling
- Reasonable expiration policies

---

## 26. Session Interview Scenario

### Question
Your application checks session in every controller action. What will you do?

### Strong Answer
I would move the common session validation into a reusable action filter or authorization filter so that the validation is centralized. This reduces repetitive code and makes session-expiry behavior consistent across controllers.

---

## 27. Scenario: Session expires while the user is on a protected page
Expected flow:

1. User requests protected action.
2. Global filter checks required session value.
3. Session value is missing.
4. Redirect to login.
5. Send a flag such as `sessionExpired=true`.
6. Login page displays a message like:
   `Your session has expired. Please login again.`

---

## 28. Common Session Interview Questions

1. What is session management?
2. Why is HTTP called stateless?
3. Why do we need session?
4. How does ASP.NET session work internally?
5. Where is the session ID stored?
6. What is session timeout?
7. What happens after session timeout?
8. How can you handle session expiry globally?
9. Session vs cookie?
10. Session vs JWT?
11. Session vs TempData?
12. Session vs cache?
13. How do you store and retrieve session values?
14. Remove vs Clear?
15. Can session store complex objects?
16. What are the disadvantages of session?
17. How does session work with multiple servers?
18. In-memory vs distributed session?
19. Redis session use case?
20. Is session suitable for REST APIs?
21. How do you secure a session?
22. What is session hijacking?
23. What happens to session after an app restart?
24. Why should you avoid storing passwords in session?
25. Why should common session validation not be repeated inside every controller action?

---

# Quick Revision

**Session:** Stores temporary user-specific state across requests.

**HTTP:** Stateless by default.

**Session ID:** Usually maintained through a cookie.

**Timeout:** Session expires after configured inactivity.

**Global validation:** Prefer reusable filter/centralized logic over duplicate checks in every action.

**Scaling:** Use distributed session such as Redis/SQL Server when multiple app instances need shared session state.

**Security:** HTTPS + secure cookie configuration + minimal sensitive data.

**REST APIs:** Prefer stateless token-based authentication such as JWT when practical.
