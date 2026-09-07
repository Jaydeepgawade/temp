# 06 - Functions

## English
A function is a reusable block of code. It can accept input through parameters and return output.

### Function Declaration
```js
function add(a, b) {
  return a + b;
}
console.log(add(10, 20));
```

### Function Expression
```js
const multiply = function(a, b) {
  return a * b;
};
```

### Arrow Function
```js
const square = n => n * n;
```

### Default Parameter
```js
function greet(name = "User") {
  console.log(`Hello ${name}`);
}
```

## मराठी
Function म्हणजे पुन्हा वापरता येणारा code block. Parameter म्हणजे function ला दिलेला input आणि `return` म्हणजे function बाहेर पाठवलेला result.

## Practice
1. दोन numbers add करणारा function लिही.
2. Even/odd तपासणारा function लिही.
3. Square आणि cube functions लिही.
4. Largest of 3 function लिही.
5. Factorial function लिही.
6. Prime checker function लिही.
7. Arrow function वापरून multiplication कर.
8. Default parameter असलेला greet function लिही.