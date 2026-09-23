# Dictionary<TKey, TValue> in C#

## Why this chapter comes before advanced DSA

`Dictionary<string, int>` is a foundation collection. It stores unique keys mapped to values and provides fast lookup by key.
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

Think of this collection as a structure that stores unique keys mapped to values and provides fast lookup by key.
The collection owns its current state.
Every modifying operation changes that state in a documented way.
A read operation observes state without intentionally changing it.
The two generic type parameters define the key type and the value type.
Strong typing prevents unrelated values from being inserted accidentally.
Choose a collection by required behavior, not because its syntax looks familiar.

## Namespace and declaration

```csharp
using System;
using System.Collections.Generic;
```

```csharp
Dictionary<string, int> collection = new();
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

## Solved Problem 1: Store product prices

### Requirement

Create product-to-price mappings and retrieve the keyboard price safely.

### Approach

Use `Dictionary<string, int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var prices = new Dictionary<string, decimal>
{
    ["Mouse"] = 599m,
    ["Keyboard"] = 1299m,
    ["Monitor"] = 8999m
};
if (prices.TryGetValue("Keyboard", out decimal price))
    Console.WriteLine(price);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Create | `{}` | Empty dictionary |
| 2: Mouse | `Mouse=599` | Unique key added |
| 3: Keyboard | `Keyboard=1299` | Second key added |
| 4: Lookup | `found=true` | Key exists |
| 5: Output | `1299` | Value returned |

### Complexity

Building three entries is constant for this sample; TryGetValue is average O(1).

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 2: Count word frequency

### Requirement

Count how many times each word appears.

### Approach

Use `Dictionary<string, int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

string[] words = { "api", "sql", "api", "csharp", "api" };
var counts = new Dictionary<string, int>();
foreach (string word in words)
{
    counts[word] = counts.GetValueOrDefault(word) + 1;
}
foreach (var pair in counts)
    Console.WriteLine($"{pair.Key}: {pair.Value}");
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: api | `api=1` | Missing key starts at zero |
| 2: sql | `sql=1` | Add sql |
| 3: api | `api=2` | Increment existing key |
| 4: csharp | `csharp=1` | Add csharp |
| 5: api | `api=3` | Final api frequency |

### Complexity

The frequency loop is O(n) average time and O(k) space for k distinct words.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 3: Update employee salary

### Requirement

Update an existing salary and avoid accidentally adding an unknown employee.

### Approach

Use `Dictionary<string, int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var salaries = new Dictionary<int, decimal> { [101] = 30000m, [102] = 35000m };
int employeeId = 102;
if (salaries.ContainsKey(employeeId))
    salaries[employeeId] = 38000m;
Console.WriteLine(salaries[employeeId]);
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Initial | `102=35000` | Employee exists |
| 2: Check | `true` | ContainsKey confirms key |
| 3: Assign | `102=38000` | Indexer replaces value |
| 4: Count | `2` | No new key created |
| 5: Output | `38000` | Updated salary |

### Complexity

ContainsKey and indexer assignment are average O(1); storage is unchanged.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 4: Group names by first letter

### Requirement

Map each starting letter to a list of names.

### Approach

Use `Dictionary<string, int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

string[] names = { "Asha", "Amit", "Ravi", "Riya" };
var groups = new Dictionary<char, List<string>>();
foreach (string name in names)
{
    char key = name[0];
    if (!groups.ContainsKey(key))
        groups[key] = new List<string>();
    groups[key].Add(name);
}
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Asha | `A=[Asha]` | Create A group |
| 2: Amit | `A=[Asha,Amit]` | Reuse A group |
| 3: Ravi | `R=[Ravi]` | Create R group |
| 4: Riya | `R=[Ravi,Riya]` | Reuse R group |
| 5: Finish | `2 keys` | A and R |

### Complexity

Grouping is O(n) average time and O(n) total storage for names and groups.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 5: Find the highest-scoring student

### Requirement

Find the dictionary entry with the greatest value without LINQ.

### Approach

Use `Dictionary<string, int>` because its behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var scores = new Dictionary<string, int> { ["Neha"] = 78, ["Raj"] = 92, ["Sam"] = 85 };
string topper = "";
int best = int.MinValue;
foreach (var pair in scores)
{
    if (pair.Value > best)
    {
        best = pair.Value;
        topper = pair.Key;
    }
}
Console.WriteLine($"{topper}: {best}");
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Initial | `best=-infinity` | No candidate |
| 2: Neha | `Neha=78` | First candidate |
| 3: Raj | `Raj=92` | 92 is greater |
| 4: Sam | `Raj=92` | 85 is smaller |
| 5: Output | `Raj: 92` | Top entry |

### Complexity

Finding the highest score scans k entries in O(k) time and uses O(1) extra space.

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

1. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Add` and dry-run it.
2. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `TryAdd` and dry-run it.
3. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `ContainsKey` and dry-run it.
4. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `TryGetValue` and dry-run it.
5. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Remove` and dry-run it.
6. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Keys` and dry-run it.
7. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Values` and dry-run it.
8. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Count` and dry-run it.
9. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Clear` and dry-run it.
10. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `indexer` and dry-run it.
11. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `foreach` and dry-run it.
12. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Add` and dry-run it.
13. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `TryAdd` and dry-run it.
14. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `ContainsKey` and dry-run it.
15. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `TryGetValue` and dry-run it.
16. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Remove` and dry-run it.
17. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Keys` and dry-run it.
18. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Values` and dry-run it.
19. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Count` and dry-run it.
20. Write a new Dictionary<TKey, TValue> in C# problem that focuses on `Clear` and dry-run it.

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

- Behavior: Adds a new key and value.
- Typical cost: Average O(1).
- Safety note: A duplicate key throws ArgumentException.

### `TryAdd`

- Behavior: Adds only when the key is absent.
- Typical cost: Average O(1).
- Safety note: It returns false instead of throwing for a duplicate.

### `ContainsKey`

- Behavior: Checks key membership.
- Typical cost: Average O(1).
- Safety note: It does not return the associated value.

### `TryGetValue`

- Behavior: Looks up a value safely.
- Typical cost: Average O(1).
- Safety note: The bool result distinguishes found from missing.

### `Remove`

- Behavior: Deletes an entry by key.
- Typical cost: Average O(1).
- Safety note: Use the bool result to detect a missing key.

### `Keys`

- Behavior: Exposes a live view of all keys.
- Typical cost: Enumerating all keys is O(n).
- Safety note: Do not mutate the dictionary during enumeration.

### `Values`

- Behavior: Exposes a live view of all values.
- Typical cost: Enumerating all values is O(n).
- Safety note: Different keys may map to equal values.

### `Count`

- Behavior: Reports the number of key-value pairs.
- Typical cost: O(1).
- Safety note: It is a property, not a method.

### `Indexer`

- Behavior: Reads or assigns a value with dictionary[key].
- Typical cost: Average O(1).
- Safety note: Reading a missing key throws; assigning may insert.

### `foreach`

- Behavior: Enumerates KeyValuePair entries.
- Typical cost: O(n) for a full pass.
- Safety note: foreach is a language construct, not a dictionary method.

### `Clear`

- Behavior: Removes every key-value pair.
- Typical cost: O(n) in common implementations.
- Safety note: Count becomes zero and later reads need normal missing-key handling.
