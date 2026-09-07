# 08 - Objects

## English
Objects store related data using key-value pairs.

```js
const person = {
  name: "Jaydeep",
  age: 25,
  greet() {
    console.log(`Hello ${this.name}`);
  }
};

console.log(person.name);
person.greet();
```

### Important Topics
- Object properties
- Dot and bracket notation
- Nested objects
- Methods
- `this`
- Destructuring
- Spread operator
- `Object.keys()`
- `Object.values()`
- `Object.entries()`

## मराठी
Object म्हणजे related माहिती key-value format मध्ये ठेवण्याची पद्धत. उदाहरणार्थ user चे नाव, age, city एकाच object मध्ये ठेवू शकतो.

## Practice
1. Student object तयार कर.
2. Employee object मध्ये salary add कर.
3. Object मधील property update कर.
4. Nested address object तयार कर.
5. Method वापरून full name print कर.
6. Object destructuring वापर.
7. Spread वापरून object clone कर.
8. `Object.keys()` वापरून keys print कर.