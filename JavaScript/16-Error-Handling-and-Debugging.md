# 16 - Error Handling and Debugging

## English
Errors are normal in development. Good JavaScript code detects and handles expected failures.

### try/catch/finally
```js
try {
  const data = JSON.parse("invalid json");
} catch (error) {
  console.error(error.message);
} finally {
  console.log("Completed");
}
```

### throw
```js
function withdraw(balance, amount) {
  if (amount > balance) {
    throw new Error("Insufficient balance");
  }
  return balance - amount;
}
```

### Debugging Tools
- `console.log()`
- `console.error()`
- Browser DevTools
- Breakpoints
- Network tab
- Sources tab

## मराठी
Error handling म्हणजे error आली तरी application controlled पद्धतीने handle करणे. `try` मध्ये risky code, `catch` मध्ये error handling आणि `finally` मध्ये नेहमी चालणारा code ठेवतो.

## Practice
1. Invalid JSON error handle कर.
2. Divide by zero validation लिही.
3. Withdraw function मध्ये custom error throw कर.
4. Fetch request error handle कर.
5. Browser DevTools breakpoint लावून loop debug कर.