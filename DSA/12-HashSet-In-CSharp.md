# HashSet<T> in C#

## Why this chapter comes before advanced DSA

`HashSet<int>` is a foundation collection. It stores unique values and supports fast membership and mathematical set operations.
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

Think of this collection as a structure that stores unique values and supports fast membership and mathematical set operations.
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
HashSet<int> collection = new();
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

## Solved Problem 1: Remove duplicates

### Requirement

Use a set to keep each input number only once.

### Approach

Use `HashSet<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace mathematical membership after every modification; do not assume an enumeration order.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

int[] numbers = { 4, 2, 4, 3, 2, 7 };
var unique = new HashSet<int>();
foreach (int number in numbers)
    unique.Add(number);
Console.WriteLine(string.Join(", ", unique)); // Display order is not guaranteed.
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 4 | `{4}` | Add returns true |
| 2: 2 | `{4,2}` | New value |
| 3: 4 | `{4,2}` | Duplicate ignored |
| 4: 3 | `{4,2,3}` | New value |
| 5: 2,7 | `{4,2,3,7}` | Skip 2, add 7 |

### Complexity

Adding n values takes O(n) average time and O(k) space for k unique values.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 2: Find common skills

### Requirement

Find skills shared by two developers.

### Approach

Use `HashSet<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace mathematical membership after every modification; do not assume an enumeration order.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var first = new HashSet<string> { "C#", "SQL", "Git" };
var second = new HashSet<string> { "Java", "SQL", "Git" };
first.IntersectWith(second);
Console.WriteLine(string.Join(", ", first)); // Display order is not guaranteed.
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Start | `first={C#,SQL,Git}` | Original set |
| 2: Compare C# | `not common` | Remove |
| 3: Compare SQL | `common` | Keep |
| 4: Compare Git | `common` | Keep |
| 5: Result | `{SQL,Git}` | Intersection |

### Complexity

Intersection is normally proportional to the participating set sizes and changes the first set.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 3: Combine visitor IDs

### Requirement

Create the union of visitors from morning and evening sessions.

### Approach

Use `HashSet<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace mathematical membership after every modification; do not assume an enumeration order.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var morning = new HashSet<int> { 1, 2, 3 };
var evening = new HashSet<int> { 3, 4, 5 };
morning.UnionWith(evening);
Console.WriteLine(string.Join(", ", morning)); // Display order is not guaranteed.
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Initial | `{1,2,3}` | Morning |
| 2: Visit 3 | `unchanged` | Already present |
| 3: Visit 4 | `{1,2,3,4}` | New ID |
| 4: Visit 5 | `{1,2,3,4,5}` | New ID |
| 5: Result | `Count=5` | Union |

### Complexity

Union is O(n + m) average time and may retain O(n + m) unique values.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 4: Detect the first repeated number

### Requirement

Stop when Add returns false for the first time.

### Approach

Use `HashSet<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace mathematical membership after every modification; do not assume an enumeration order.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

int[] values = { 8, 3, 5, 3, 9 };
var seen = new HashSet<int>();
int? repeated = null;
foreach (int value in values)
{
    if (!seen.Add(value))
    {
        repeated = value;
        break;
    }
}
Console.WriteLine(repeated);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 8 | `{8}` | Add succeeds |
| 2: 3 | `{8,3}` | Add succeeds |
| 3: 5 | `{8,3,5}` | Add succeeds |
| 4: 3 | `Add=false` | First repeat |
| 5: Stop | `repeated=3` | Break loop |

### Complexity

The scan stops at the first repeat; worst-case time and space are O(n).

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 5: Check subset permissions

### Requirement

Check whether requested permissions are contained in allowed permissions.

### Approach

Use `HashSet<int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace mathematical membership after every modification; do not assume an enumeration order.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var allowed = new HashSet<string> { "read", "write", "export" };
var requested = new HashSet<string> { "read", "export" };
bool valid = requested.IsSubsetOf(allowed);
Console.WriteLine(valid);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Requested read | `found` | Allowed |
| 2: Requested export | `found` | Allowed |
| 3: Missing items | `none` | Every request exists |
| 4: Subset | `true` | Definition satisfied |
| 5: Output | `True` | Request valid |

### Complexity

Subset checking is O(r) average for r requested permissions.

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

1. Write a new HashSet<T> in C# problem that focuses on `Add` and dry-run it.
2. Write a new HashSet<T> in C# problem that focuses on `Remove` and dry-run it.
3. Write a new HashSet<T> in C# problem that focuses on `Contains` and dry-run it.
4. Write a new HashSet<T> in C# problem that focuses on `UnionWith` and dry-run it.
5. Write a new HashSet<T> in C# problem that focuses on `IntersectWith` and dry-run it.
6. Write a new HashSet<T> in C# problem that focuses on `ExceptWith` and dry-run it.
7. Write a new HashSet<T> in C# problem that focuses on `SymmetricExceptWith` and dry-run it.
8. Write a new HashSet<T> in C# problem that focuses on `IsSubsetOf` and dry-run it.
9. Write a new HashSet<T> in C# problem that focuses on `SetEquals` and dry-run it.
10. Write a new HashSet<T> in C# problem that focuses on `Count` and dry-run it.
11. Write a new HashSet<T> in C# problem that focuses on `Clear` and dry-run it.
12. Write a new HashSet<T> in C# problem that focuses on `Add` and dry-run it.
13. Write a new HashSet<T> in C# problem that focuses on `Remove` and dry-run it.
14. Write a new HashSet<T> in C# problem that focuses on `Contains` and dry-run it.
15. Write a new HashSet<T> in C# problem that focuses on `UnionWith` and dry-run it.
16. Write a new HashSet<T> in C# problem that focuses on `IntersectWith` and dry-run it.
17. Write a new HashSet<T> in C# problem that focuses on `ExceptWith` and dry-run it.
18. Write a new HashSet<T> in C# problem that focuses on `SymmetricExceptWith` and dry-run it.
19. Write a new HashSet<T> in C# problem that focuses on `IsSubsetOf` and dry-run it.
20. Write a new HashSet<T> in C# problem that focuses on `SetEquals` and dry-run it.

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

- Behavior: Adds a value only if it is not already present.
- Typical cost: Average O(1).
- Safety note: The bool result is true only for a new value.

### `Remove`

- Behavior: Deletes a matching value.
- Typical cost: Average O(1).
- Safety note: The bool result reports whether removal happened.

### `Contains`

- Behavior: Tests value membership.
- Typical cost: Average O(1).
- Safety note: Correct equality and hash codes are essential.

### `UnionWith`

- Behavior: Keeps values found in either set.
- Typical cost: O(n + m) under normal hashing assumptions.
- Safety note: It changes the receiving set.

### `IntersectWith`

- Behavior: Keeps only values found in both sets.
- Typical cost: Usually proportional to the participating set sizes.
- Safety note: It changes the receiving set.

### `ExceptWith`

- Behavior: Removes values found in the other set.
- Typical cost: Usually O(m) average for m inputs.
- Safety note: This models set difference.

### `SymmetricExceptWith`

- Behavior: Keeps values found in exactly one set.
- Typical cost: Usually O(n + m).
- Safety note: Shared values are removed.

### `IsSubsetOf`

- Behavior: Checks whether every value exists in another set.
- Typical cost: Usually O(n) average for n requested values.
- Safety note: An empty set is a subset of every set.

### `SetEquals`

- Behavior: Compares mathematical set membership.
- Typical cost: Usually O(n) average.
- Safety note: Enumeration order does not affect equality.

### `Count`

- Behavior: Reports the number of unique values.
- Typical cost: O(1).
- Safety note: Duplicates never increase Count.

### `Enumeration`

- Behavior: Visits every stored value.
- Typical cost: O(n).
- Safety note: HashSet enumeration order is not guaranteed.

### `Clear`

- Behavior: Removes every unique value from the set.
- Typical cost: O(n) in common implementations.
- Safety note: Count becomes zero and no ordering information is preserved.
