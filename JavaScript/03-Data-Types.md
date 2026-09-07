# 03 - JavaScript Data Types

## English
A data type tells JavaScript what kind of value is stored in a variable.

Common JavaScript data types:
- String
- Number
- Boolean
- Undefined
- Null
- Object
- Array

## मराठी
Data type म्हणजे variable मध्ये कोणत्या प्रकारची value आहे ते सांगणारा type.

उदाहरण:
नाव = String
वय = Number
हो/नाही = Boolean

## String
Text value.

```javascript
let name = "Jaydeep";
console.log(name);
```

## Number
Integer किंवा decimal number.

```javascript
let age = 25;
let salary = 50000.50;
```

## Boolean
फक्त `true` किंवा `false`.

```javascript
let isDeveloper = true;
console.log(isDeveloper);
```

## Undefined
Variable declare केला पण value दिली नाही.

```javascript
let city;
console.log(city);
```

Output:
```text
undefined
```

## Null
आपण जाणूनबुजून empty value assign करतो.

```javascript
let selectedUser = null;
```

## Object
Related data key-value format मध्ये ठेवतो.

```javascript
let user = {
    name: "Jaydeep",
    age: 25
};
```

## Array
एकाच variable मध्ये multiple values store करता येतात.

```javascript
let cities = ["Pune", "Mumbai", "Thane"];
```

## typeof
Variable चा type तपासण्यासाठी `typeof` वापरतो.

```javascript
let name = "Jaydeep";
console.log(typeof name);
```

Output:
```text
string
```

## Practice Questions
1. Data type म्हणजे काय?
2. String आणि Number मध्ये difference काय?
3. Boolean मध्ये कोणत्या values असतात?
4. Undefined आणि Null मध्ये difference काय?
5. `typeof` काय करते?
6. खालील values चा type ओळखा:
   - "JavaScript"
   - 100
   - true
   - undefined
   - [1,2,3]

## Coding Practice
1. `name`, `age`, `isWorking`, `city` variables तयार करा.
2. प्रत्येक variable चा `typeof` print करा.
3. तीन programming languages ची array तयार करा.
4. तुमची माहिती object मध्ये store करा.
