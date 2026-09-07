# 04 - Operators and Conditions

## English
Operators are symbols used to perform calculations and comparisons. Conditions help your program make decisions.

### Important Operators
- Arithmetic: `+ - * / % **`
- Assignment: `= += -= *= /=`
- Comparison: `== === != !== > < >= <=`
- Logical: `&& || !`
- Ternary: `condition ? value1 : value2`

### if / else
```js
let age = 20;
if (age >= 18) {
  console.log("Adult");
} else {
  console.log("Minor");
}
```

### switch
```js
let day = 2;
switch(day) {
  case 1: console.log("Monday"); break;
  case 2: console.log("Tuesday"); break;
  default: console.log("Invalid");
}
```

## मराठी
Operator म्हणजे value वर calculation किंवा comparison करण्यासाठी वापरले जाणारे चिन्ह. Condition वापरून program निर्णय घेतो.

`===` value आणि datatype दोन्ही compare करतो, म्हणून JavaScript मध्ये शक्यतो `===` वापर.

## Practice
1. दोन numbers मधला मोठा number शोध.
2. Number even की odd तपास.
3. Age वरून vote eligibility तपास.
4. तीन numbers मधला largest शोध.
5. Marks वरून grade काढ.
6. Number positive, negative की zero तपास.
7. `switch` वापरून weekday print कर.
8. Ternary वापरून adult/minor print कर.