# 02 - Variables: var, let, const

## English
A variable is a named container used to store data.

JavaScript provides three common keywords:
- `var`
- `let`
- `const`

For modern JavaScript, prefer `let` and `const`.

## मराठी
Variable म्हणजे data ठेवण्यासाठी वापरलेला नाव असलेला container.

उदा. तुमचे नाव, age, salary, city अशी values variable मध्ये ठेवता येतात.

## let
`let` वापरल्यावर value नंतर change करू शकतो.

```javascript
let age = 25;
console.log(age);

age = 26;
console.log(age);
```

Output:
```text
25
26
```

## const
`const` वापरल्यावर variable ला पुन्हा नवीन value assign करता येत नाही.

```javascript
const country = "India";
console.log(country);
```

## var
`var` हे जुने keyword आहे. Modern JavaScript मध्ये शक्यतो `let` किंवा `const` वापरा.

```javascript
var name = "Jaydeep";
console.log(name);
```

## Important Rule
Value change होणार असेल → `let`

Value change होणार नसेल → `const`

## Practice Questions
1. Variable म्हणजे काय?
2. `let` आणि `const` मध्ये difference काय?
3. `var` modern JavaScript मध्ये कमी का वापरतात?
4. तुमचे नाव `const` मध्ये store करा.
5. तुमची age `let` मध्ये store करा आणि नंतर 1 ने change करा.
6. खालील code चे output predict करा:

```javascript
let x = 10;
x = 20;
console.log(x);
```

## Exercise
तुमचे नाव, profession, experience आणि city variables मध्ये store करा आणि `console.log()` ने print करा.
