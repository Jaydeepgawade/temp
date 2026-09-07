# 10 - Scope, Hoisting and Closures

## English
### Scope
Scope decides where a variable can be accessed.
- Global scope
- Function scope
- Block scope

### Hoisting
JavaScript processes declarations before executing code. `var` behaves differently from `let` and `const`.

### Closure
A closure happens when an inner function remembers variables from its outer function.

```js
function outer() {
  let count = 0;
  return function inner() {
    count++;
    return count;
  };
}

const counter = outer();
console.log(counter());
console.log(counter());
```

## मराठी
Scope म्हणजे variable कुठे वापरता येईल हे. Closure मध्ये inner function ला outer function चे variables आठवत राहतात, outer function संपल्यानंतरही.

## Practice
1. Global आणि local variable चे example लिही.
2. `var` आणि `let` block scope compare कर.
3. Hoisting example लिही.
4. Closure वापरून counter बनव.
5. Private balance सारखा closure example तयार कर.