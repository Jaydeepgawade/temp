# Stack<T> in C#

## Why this chapter comes before advanced DSA

`Stack<int>` is a foundation collection. It stores values in last-in, first-out order so the most recently pushed value is processed first.
Graph traversal, caching, indexing, grouping, and many interview problems depend on collections.
Learn the behavior first; then advanced algorithms become easier to read and debug.

## Learning objectives

1. Explain the collection in plain English.
2. Create and initialize the collection.
3. Add and remove values safely.
4. Read values without causing avoidable exceptions.
5. Choose this collection for an appropriate requirement.
6. Trace state after each operation.
7. State common time complexities.
8. Solve five interview-style problems.
9. Recognize edge cases.
10. Compare it with other collections.

## Core mental model

Think of this collection as a structure that stores values in last-in, first-out order so the most recently pushed value is processed first.
The collection owns its current state.
Every modifying operation changes that state in a documented way.
A read operation observes state without intentionally changing it.
The generic type parameter controls which value type can be stored.
Strong typing prevents unrelated values from being inserted accidentally.
Choose a collection by required behavior, not because its syntax looks familiar.

## Namespace and declaration

```csharp
using System;
using System.Collections.Generic;
```

```csharp
Stack<int> collection = new();
```

## Operation guide

The concise rules below introduce selection criteria. The complete behavior, complexity, return-value, and safety details appear in the API deep dive later in this chapter.

## Choosing this collection

Use it when its ordering, uniqueness, lookup, or processing rule directly matches the requirement.
Do not choose it merely to avoid learning another collection.
Write down the most frequent operation: insert, lookup, remove, iterate, or process next.
Then compare expected complexity and clarity.

## Common complexity vocabulary

- `O(1)` means work stays roughly constant as the collection grows.
- `O(n)` means work may inspect every stored element.
- Amortized `O(1)` means occasional resizing is expensive but average insertion remains constant.
- Complexity depends on normal runtime assumptions and correct hashing where hashing is used.
- Big-O describes growth, not exact milliseconds.

## Solved Problem 1: Reverse a word

### Requirement

Push characters and pop them to reverse a word.

### Approach

Use `Stack<T>` because its LIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

string word = "CODE";
var stack = new Stack<char>();
foreach (char letter in word) stack.Push(letter);
var result = new StringBuilder();
while (stack.Count > 0) result.Append(stack.Pop());
Console.WriteLine(result);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Push C | `[C]` | C at top |
| 2: Push O,D,E | `[C,O,D,E]` | E at top |
| 3: Pop E | `E` | Last pushed first |
| 4: Pop D,O | `EDO` | Continue LIFO |
| 5: Pop C | `EDOC` | Reversed |

### Complexity

Pushing and popping n characters takes O(n) time and O(n) stack space.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 2: Validate brackets

### Requirement

Check whether parentheses are balanced.

### Approach

Use `Stack<T>` because its LIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

string text = "(()())";
var stack = new Stack<char>();
bool valid = true;
foreach (char ch in text)
{
    if (ch == '(') stack.Push(ch);
    else if (ch == ')' && !stack.TryPop(out _)) { valid = false; break; }
}
valid = valid && stack.Count == 0;
Console.WriteLine(valid);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: ( | `Count=1` | Push opener |
| 2: ( | `Count=2` | Push opener |
| 3: ) | `Count=1` | Match one |
| 4: () | `Count returns 1` | Push then pop |
| 5: ) | `Count=0` | All balanced |

### Complexity

Bracket validation is O(n) time and O(n) worst-case stack space.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 3: Undo text edits

### Requirement

Undo the two most recent edits.

### Approach

Use `Stack<T>` because its LIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var history = new Stack<string>();
history.Push("Hello");
history.Push("Hello world");
history.Push("Hello world!");
history.Pop(); // Undo "Hello world!"
history.Pop(); // Undo "Hello world"
string current = history.Peek();
Console.WriteLine(current);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Push 1 | `Hello` | First state |
| 2: Push 2 | `Hello world` | New state on top |
| 3: Push 3 | `Hello world!` | Latest state |
| 4: First Pop | `top = Hello world` | Undo the exclamation edit |
| 5: Second Pop, then Peek | `Hello` | Undo the world edit and read the current state |

### Complexity

Two Pop operations and one Peek are O(1); history storage is O(h).

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 4: Convert decimal to binary

### Requirement

Use a stack to emit remainders in reverse order.

### Approach

Use `Stack<T>` because its LIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

int number = 13;
var bits = new Stack<int>();
while (number > 0)
{
    bits.Push(number % 2);
    number /= 2;
}
while (bits.Count > 0) Console.Write(bits.Pop());
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 13/2 | `push 1` | number=6 |
| 2: 6/2 | `push 0` | number=3 |
| 3: 3/2 | `push 1` | number=1 |
| 4: 1/2 | `push 1` | number=0 |
| 5: Pop all | `1101` | Correct binary |

### Complexity

Decimal-to-binary conversion takes O(log n) time and O(log n) stack space.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 5: Evaluate postfix addition

### Requirement

Evaluate the postfix expression 2 3 + 4 *.

### Approach

Use `Stack<T>` because its LIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

string[] tokens = { "2", "3", "+", "4", "*" };
var values = new Stack<int>();
foreach (string token in tokens)
{
    if (int.TryParse(token, out int n)) values.Push(n);
    else
    {
        int right = values.Pop();
        int left = values.Pop();
        values.Push(token == "+" ? left + right : left * right);
    }
}
Console.WriteLine(values.Pop());
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 2 | `[2]` | Push operand |
| 2: 3 | `[2,3]` | Push operand |
| 3: + | `[5]` | 2+3 |
| 4: 4 | `[5,4]` | Push operand |
| 5: * | `[20]` | 5*4 |

### Complexity

Postfix evaluation is O(t) time and O(t) worst-case stack space for t tokens.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input

## Common mistakes

### Mistake 1

Problem: Using an index without validating its range.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 2

Problem: Modifying a collection inside foreach when the enumerator forbids it.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 3

Problem: Ignoring the return value of a safe operation.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 4

Problem: Assuming every collection preserves the same order.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 5

Problem: Using a collection with the wrong lookup behavior.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 6

Problem: Failing to handle empty state.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 7

Problem: Confusing Count with the last valid index.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 8

Problem: Using a linear search when a keyed or set lookup is required.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 9

Problem: Hiding all logic inside Main.
Correction: state the required behavior, use the safe API, and verify the collection state.

### Mistake 10

Problem: Skipping a dry run before debugging.
Correction: state the required behavior, use the safe API, and verify the collection state.

## Interview questions

### Question 1: Why use a generic collection?

It provides type safety and avoids many casts.

### Question 2: What does Count represent?

The number of elements currently stored.

### Question 3: Why prefer Try-style methods?

They represent an expected missing or empty case without using exceptions for control flow.

### Question 4: Can collection operations throw?

Yes. Invalid indexes, duplicate keys, or empty-state operations may throw depending on the API.

### Question 5: How do you select a collection?

Match ordering, uniqueness, lookup, and removal requirements.

### Question 6: What is an invariant?

A condition that remains true throughout the algorithm.

### Question 7: Why separate logic from Console code?

Reusable methods are easier to test and call from APIs or applications.

### Question 8: What should a dry run record?

The operation, collection state, important variables, and decision.

### Question 9: Does O(1) mean free?

No. It means growth is constant with respect to input size.

### Question 10: What comes next?

Combine these collections in graph and other algorithms.

## Practice problems

1. Write a new Stack<T> in C# problem that focuses on `Push` and dry-run it.
2. Write a new Stack<T> in C# problem that focuses on `Pop` and dry-run it.
3. Write a new Stack<T> in C# problem that focuses on `Peek` and dry-run it.
4. Write a new Stack<T> in C# problem that focuses on `TryPop` and dry-run it.
5. Write a new Stack<T> in C# problem that focuses on `TryPeek` and dry-run it.
6. Write a new Stack<T> in C# problem that focuses on `Contains` and dry-run it.
7. Write a new Stack<T> in C# problem that focuses on `ToArray` and dry-run it.
8. Write a new Stack<T> in C# problem that focuses on `Count` and dry-run it.
9. Write a new Stack<T> in C# problem that focuses on `Clear` and dry-run it.
10. Write a new Stack<T> in C# problem that focuses on `foreach` and dry-run it.
11. Write a new Stack<T> in C# problem that focuses on `LIFO` and dry-run it.
12. Write a new Stack<T> in C# problem that focuses on `Push` and dry-run it.
13. Write a new Stack<T> in C# problem that focuses on `Pop` and dry-run it.
14. Write a new Stack<T> in C# problem that focuses on `Peek` and dry-run it.
15. Write a new Stack<T> in C# problem that focuses on `TryPop` and dry-run it.
16. Write a new Stack<T> in C# problem that focuses on `TryPeek` and dry-run it.
17. Write a new Stack<T> in C# problem that focuses on `Contains` and dry-run it.
18. Write a new Stack<T> in C# problem that focuses on `ToArray` and dry-run it.
19. Write a new Stack<T> in C# problem that focuses on `Count` and dry-run it.
20. Write a new Stack<T> in C# problem that focuses on `Clear` and dry-run it.

## Chapter completion checklist

- [ ] I can create the collection from memory.
- [ ] I can explain its ordering rule.
- [ ] I can add, read, and remove values safely.
- [ ] I understand Count.
- [ ] I can solve the five examples without copying.
- [ ] I can write a dry-run table.
- [ ] I know the important complexities.
- [ ] I know when another collection is a better choice.
- [ ] I can explain common exceptions.
- [ ] I am ready to use this collection in Graph algorithms.

## API deep dive

### `Push`

- Behavior: Places one value on the top.
- Typical cost: O(1) amortized.
- Safety note: The pushed value becomes the next value returned.

### `Pop`

- Behavior: Removes and returns the top value.
- Typical cost: O(1).
- Safety note: It throws InvalidOperationException when empty.

### `Peek`

- Behavior: Returns the top without removing it.
- Typical cost: O(1).
- Safety note: It throws InvalidOperationException when empty.

### `TryPop`

- Behavior: Safely removes the top when available.
- Typical cost: O(1).
- Safety note: It returns false for an empty stack.

### `TryPeek`

- Behavior: Safely reads the top when available.
- Typical cost: O(1).
- Safety note: It does not change Count.

### `Contains`

- Behavior: Searches for an equal value.
- Typical cost: O(n).
- Safety note: It is not a constant-time membership structure.

### `ToArray`

- Behavior: Copies items from top to bottom.
- Typical cost: O(n) time and O(n) extra space.
- Safety note: The returned array is independent of the stack.

### `Count`

- Behavior: Reports stored item count.
- Typical cost: O(1).
- Safety note: Check it before Pop when TryPop is not used.

### `Clear`

- Behavior: Removes every value.
- Typical cost: O(n) in common implementations.
- Safety note: Count becomes zero.

### `LIFO rule`

- Behavior: Last pushed is first removed.
- Typical cost: This is behavior, not an API method.
- Safety note: Use it for undo, parsing, and backtracking.

### `foreach`

- Behavior: Enumerates values from the current top toward the bottom.
- Typical cost: O(n) for a complete pass.
- Safety note: Do not modify the stack while its enumerator is active.
