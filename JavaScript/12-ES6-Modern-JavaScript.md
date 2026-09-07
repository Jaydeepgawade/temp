# 12 - ES6+ Modern JavaScript

## English
Modern JavaScript introduced syntax that makes code cleaner and easier to maintain.

### Topics
- `let` and `const`
- Template literals
- Arrow functions
- Destructuring
- Spread operator `...`
- Rest parameters
- Default parameters
- Optional chaining `?.`
- Nullish coalescing `??`

```js
const user = { name: "Jaydeep", age: 25 };
const { name, age } = user;

const nums = [1, 2, 3];
const copy = [...nums, 4];

const greet = (name = "User") => `Hello ${name}`;
```

## मराठी
ES6+ म्हणजे JavaScript मधल्या modern features. यामुळे code कमी, clean आणि readable होतो.

Destructuring ने object/array मधून values थेट variables मध्ये काढता येतात. Spread ने array/object copy किंवा merge करता येतो.

## Practice
1. Array destructuring कर.
2. Object destructuring कर.
3. दोन arrays spread ने merge कर.
4. Rest parameter वापरून sum function लिही.
5. Optional chaining example लिही.
6. Nullish coalescing वापरून default value दे.