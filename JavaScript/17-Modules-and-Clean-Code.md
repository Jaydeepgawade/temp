# 17 - Modules and Clean Code

## English
Modules let you split JavaScript into smaller reusable files.

### export
```js
export function add(a, b) {
  return a + b;
}
```

### import
```js
import { add } from "./math.js";
console.log(add(2, 3));
```

### Clean Code Basics
- Use meaningful variable and function names.
- Keep functions small.
- Avoid duplicate code.
- Prefer `const`, use `let` when reassignment is needed.
- Use strict equality `===`.
- Handle errors.
- Separate UI, API, and business logic where possible.

## मराठी
Module म्हणजे मोठा JavaScript code वेगवेगळ्या छोट्या files मध्ये विभागणे. त्यामुळे code maintain, reuse आणि test करणे सोपे होते.

Clean code म्हणजे फक्त चालणारा code नाही; दुसऱ्या developer ला समजणारा, बदलायला सोपा code.

## Practice
1. `math.js` तयार करून add/subtract export कर.
2. दुसऱ्या file मध्ये functions import कर.
3. मोठा function 3 छोट्या functions मध्ये divide कर.
4. Repeated logic common function मध्ये move कर.
5. Meaningless variable names सुधार.