# 09 - Strings, Numbers, Date and Math

## English
JavaScript provides many built-in methods for common operations.

### Strings
```js
let text = "JavaScript";
console.log(text.length);
console.log(text.toUpperCase());
console.log(text.includes("Script"));
console.log(text.slice(0, 4));
```

Important string methods: `trim`, `replace`, `split`, `startsWith`, `endsWith`, `substring`.

### Numbers
`Number()`, `parseInt()`, `parseFloat()`, `toFixed()`.

### Math
`Math.round`, `Math.floor`, `Math.ceil`, `Math.max`, `Math.min`, `Math.random`, `Math.sqrt`, `Math.pow`.

### Date
```js
const now = new Date();
console.log(now.getFullYear());
console.log(now.getMonth() + 1);
```

## मराठी
String म्हणजे text. String methods वापरून text search, replace, split आणि format करता येतो. `Math` calculation साठी आणि `Date` तारीख/वेळ हाताळण्यासाठी वापरतो.

## Practice
1. String reverse कर.
2. Vowels count कर.
3. Palindrome string तपास.
4. Sentence मधले words count कर.
5. First letter uppercase कर.
6. Random 1-100 number तयार कर.
7. दोन dates मधला फरक काढ.
8. Current date formatted स्वरूपात print कर.