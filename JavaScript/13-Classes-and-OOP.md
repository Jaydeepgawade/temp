# 13 - Classes and OOP

## English
JavaScript supports object-oriented programming using classes and objects.

### Topics
- Class
- Constructor
- Object creation
- Methods
- Inheritance
- `super`
- Encapsulation basics

```js
class Person {
  constructor(name) {
    this.name = name;
  }

  greet() {
    console.log(`Hello ${this.name}`);
  }
}

class Employee extends Person {
  constructor(name, role) {
    super(name);
    this.role = role;
  }
}
```

## मराठी
Class म्हणजे object तयार करण्याचा blueprint. Constructor object तयार होताना initial values set करतो. Inheritance मुळे एका class चे features दुसऱ्या class मध्ये reuse करता येतात.

## Practice
1. Student class तयार कर.
2. Employee class मध्ये name, salary ठेव.
3. Method वापरून employee details print कर.
4. Person -> Employee inheritance कर.
5. BankAccount class तयार कर.
6. Deposit आणि withdraw methods लिही.