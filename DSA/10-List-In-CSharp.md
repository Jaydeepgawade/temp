# List<T> in C#

## Why this chapter comes before advanced DSA

`List<int>` is a foundation collection. It stores an ordered, resizable collection of values and allows access by zero-based index.
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

Think of this collection as a structure that stores an ordered, resizable collection of values and allows access by zero-based index.
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
List<int> collection = new();
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

## Solved Problem 1: Add and print student marks

### Requirement

Add 70, 85, 90, and 76 to a list and print them in insertion order.

### Approach

Use `List<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var marks = new List<int>();
marks.Add(70);
marks.Add(85);
marks.Add(90);
marks.Add(76);
foreach (int mark in marks)
    Console.WriteLine(mark);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Start | `[]` | Create an empty list |
| 2: Add 70 | `[70]` | 70 becomes index 0 |
| 3: Add 85 | `[70, 85]` | 85 becomes index 1 |
| 4: Add 90 | `[70, 85, 90]` | Count becomes 3 |
| 5: Add 76 | `[70, 85, 90, 76]` | Iteration preserves order |

### Complexity

Adding and printing n marks takes O(n) time; the list stores O(n) values.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 2: Find the largest number

### Requirement

Find the maximum value without using Max().

### Approach

Use `List<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var numbers = new List<int> { 12, 45, 7, 89, 34 };
int largest = numbers[0];
for (int i = 1; i < numbers.Count; i++)
{
    if (numbers[i] > largest)
        largest = numbers[i];
}
Console.WriteLine(largest);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Initial | `largest = 12` | Use the first item |
| 2: 45 | `largest = 45` | 45 > 12 |
| 3: 7 | `largest = 45` | 7 is smaller |
| 4: 89 | `largest = 89` | 89 > 45 |
| 5: 34 | `largest = 89` | Final maximum |

### Complexity

The maximum scan takes O(n) time and O(1) extra space.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 3: Remove duplicate values

### Requirement

Create a new list containing each number once while preserving first appearance.

### Approach

Use `List<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var input = new List<int> { 2, 3, 2, 5, 3, 7 };
var unique = new List<int>();
foreach (int value in input)
{
    if (!unique.Contains(value))
        unique.Add(value);
}
Console.WriteLine(string.Join(", ", unique));
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 2 | `[2]` | 2 is new |
| 2: 3 | `[2, 3]` | 3 is new |
| 3: 2 | `[2, 3]` | 2 already exists |
| 4: 5 | `[2, 3, 5]` | 5 is new |
| 5: 3, 7 | `[2, 3, 5, 7]` | Skip 3, add 7 |

### Complexity

List.Contains inside the loop makes the worst case O(n squared); the result list uses O(n) space.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 4: Filter even numbers

### Requirement

Build a second list containing only even values.

### Approach

Use `List<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var numbers = new List<int> { 1, 2, 3, 4, 5, 6 };
var evens = new List<int>();
foreach (int number in numbers)
{
    if (number % 2 == 0)
        evens.Add(number);
}
Console.WriteLine(string.Join(", ", evens));
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 1 | `[]` | Odd, skip |
| 2: 2 | `[2]` | Even, add |
| 3: 3 | `[2]` | Odd, skip |
| 4: 4 | `[2, 4]` | Even, add |
| 5: 5, 6 | `[2, 4, 6]` | Skip 5, add 6 |

### Complexity

Filtering inspects n values in O(n) time and may store O(n) even values.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 5: Insert and remove tasks

### Requirement

Insert an urgent task at the front and remove a completed task.

### Approach

Use `List<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var tasks = new List<string> { "Code", "Test", "Deploy" };
tasks.Insert(0, "Fix production bug");
tasks.Remove("Test");
for (int i = 0; i < tasks.Count; i++)
    Console.WriteLine($"{i}: {tasks[i]}");
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Initial | `Code, Test, Deploy` | Three tasks |
| 2: Insert | `Bug, Code, Test, Deploy` | Existing indexes shift right |
| 3: Remove | `Bug, Code, Deploy` | First matching Test is deleted |
| 4: Index 0 | `Bug` | Urgent work is first |
| 5: Finish | `Count = 3` | List resized automatically |

### Complexity

Insert at the front and Remove both may shift or scan items, so each is O(n).

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

1. Write a new List<T> in C# problem that focuses on `Add` and dry-run it.
2. Write a new List<T> in C# problem that focuses on `AddRange` and dry-run it.
3. Write a new List<T> in C# problem that focuses on `Insert` and dry-run it.
4. Write a new List<T> in C# problem that focuses on `Remove` and dry-run it.
5. Write a new List<T> in C# problem that focuses on `RemoveAt` and dry-run it.
6. Write a new List<T> in C# problem that focuses on `Contains` and dry-run it.
7. Write a new List<T> in C# problem that focuses on `IndexOf` and dry-run it.
8. Write a new List<T> in C# problem that focuses on `Sort` and dry-run it.
9. Write a new List<T> in C# problem that focuses on `Reverse` and dry-run it.
10. Write a new List<T> in C# problem that focuses on `Clear` and dry-run it.
11. Write a new List<T> in C# problem that focuses on `Count` and dry-run it.
12. Write a new List<T> in C# problem that focuses on `Add` and dry-run it.
13. Write a new List<T> in C# problem that focuses on `AddRange` and dry-run it.
14. Write a new List<T> in C# problem that focuses on `Insert` and dry-run it.
15. Write a new List<T> in C# problem that focuses on `Remove` and dry-run it.
16. Write a new List<T> in C# problem that focuses on `RemoveAt` and dry-run it.
17. Write a new List<T> in C# problem that focuses on `Contains` and dry-run it.
18. Write a new List<T> in C# problem that focuses on `IndexOf` and dry-run it.
19. Write a new List<T> in C# problem that focuses on `Sort` and dry-run it.
20. Write a new List<T> in C# problem that focuses on `Reverse` and dry-run it.

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

### `Add`

- Behavior: Appends one item at the end.
- Typical cost: Amortized O(1).
- Safety note: The new item receives index Count - 1.

### `AddRange`

- Behavior: Appends every item from another sequence.
- Typical cost: O(k) for k appended items, excluding resize costs.
- Safety note: The source sequence must not be null.

### `Insert`

- Behavior: Places an item at a chosen index.
- Typical cost: O(n) because later items may shift right.
- Safety note: Valid indexes range from zero through Count.

### `Remove`

- Behavior: Deletes the first equal item.
- Typical cost: O(n) because it searches and may shift items.
- Safety note: Its bool result says whether a match was removed.

### `RemoveAt`

- Behavior: Deletes the item at an exact index.
- Typical cost: O(n) when later items shift left.
- Safety note: An invalid index throws ArgumentOutOfRangeException.

### `Contains`

- Behavior: Checks whether an equal item exists.
- Typical cost: O(n) linear search.
- Safety note: Use a HashSet when membership lookup dominates.

### `IndexOf`

- Behavior: Returns the first matching index.
- Typical cost: O(n) linear search.
- Safety note: It returns -1 when no value matches.

### `Sort`

- Behavior: Reorders the list using its comparer.
- Typical cost: O(n log n) for the built-in comparison sort.
- Safety note: Sorting changes the original list.

### `Reverse`

- Behavior: Reverses the current item order in place.
- Typical cost: O(n).
- Safety note: It does not create a second list.

### `Clear`

- Behavior: Removes all items.
- Typical cost: O(n) for reference clearing in common implementations.
- Safety note: Count becomes zero.

### `Count`

- Behavior: Reports the number of stored items.
- Typical cost: O(1).
- Safety note: The final valid index is Count - 1, not Count.
