# 14 - Callbacks, Promises and Async/Await

## English
JavaScript can perform asynchronous work without blocking other code.

### Callback
A function passed to another function.

### Promise
A Promise represents a future result: pending, fulfilled, or rejected.

```js
const promise = new Promise((resolve, reject) => {
  const success = true;
  if (success) resolve("Done");
  else reject("Failed");
});

promise.then(console.log).catch(console.error);
```

### Async/Await
```js
async function loadData() {
  try {
    const result = await promise;
    console.log(result);
  } catch (error) {
    console.error(error);
  }
}
```

## मराठी
Async काम म्हणजे result लगेच मिळत नाही. Promise future result represent करतो. `await` result येईपर्यंत त्या async function मध्ये थांबतो, पण पूर्ण app block करत नाही.

## Practice
1. Callback example लिही.
2. Promise resolve example लिही.
3. Promise reject handle कर.
4. `async/await` ने promise consume कर.
5. `try/catch` वापरून async error handle कर.
6. दोन async operations sequence मध्ये execute कर.