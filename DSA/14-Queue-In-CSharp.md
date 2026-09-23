# Queue<T> in C#

## Why this chapter comes before advanced DSA

`Queue<int>` is a foundation collection. It stores values in first-in, first-out order so the earliest enqueued value is processed first.
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

Think of this collection as a structure that stores values in first-in, first-out order so the earliest enqueued value is processed first.
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
Queue<int> collection = new();
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

## Solved Problem 1: Serve customers in arrival order

### Requirement

Add three customers and serve the first two.

### Approach

Use `Queue<T>` because its FIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var customers = new Queue<string>();
customers.Enqueue("Asha");
customers.Enqueue("Ravi");
customers.Enqueue("Neha");
Console.WriteLine(customers.Dequeue());
Console.WriteLine(customers.Dequeue());
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Asha arrives | `[Asha]` | Front is Asha |
| 2: Ravi arrives | `[Asha,Ravi]` | Ravi waits |
| 3: Neha arrives | `[Asha,Ravi,Neha]` | Neha waits |
| 4: Serve | `Asha` | First in |
| 5: Serve | `Ravi` | Next earliest |

### Complexity

Each Enqueue or Dequeue is O(1) amortized; serving two known customers is O(1).

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 2: Print binary numbers from 1 to 5

### Requirement

Generate binary strings with a queue.

### Approach

Use `Queue<T>` because its FIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

int count = 5;
var queue = new Queue<string>();
queue.Enqueue("1");
for (int i = 0; i < count; i++)
{
    string current = queue.Dequeue();
    Console.WriteLine(current);
    queue.Enqueue(current + "0");
    queue.Enqueue(current + "1");
}
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Start | `[1]` | Seed |
| 2: Take 1 | `add 10,11` | Output 1 |
| 3: Take 10 | `add 100,101` | Output 10 |
| 4: Take 11 | `add 110,111` | Output 11 |
| 5: Next | `100,101` | Outputs 100 and 101 |

### Complexity

Generating n binary strings takes O(n) queue operations plus output-string construction space.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 3: Moving average of three values

### Requirement

Maintain a fixed-size queue and calculate each three-value average.

### Approach

Use `Queue<T>` because its FIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

int[] input = { 10, 20, 30, 40 };
var window = new Queue<int>();
int sum = 0;
foreach (int value in input)
{
    window.Enqueue(value); sum += value;
    if (window.Count > 3) sum -= window.Dequeue();
    if (window.Count == 3) Console.WriteLine(sum / 3.0);
}
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: 10 | `[10], sum=10` | Window incomplete |
| 2: 20 | `[10,20], sum=30` | Incomplete |
| 3: 30 | `[10,20,30]` | Average 20 |
| 4: 40 | `count becomes 4` | Remove 10 |
| 5: Final | `[20,30,40]` | Average 30 |

### Complexity

The moving-window pass is O(n) time and O(1) space because the queue holds at most three values.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 4: Round-robin tasks

### Requirement

Process each task once and requeue unfinished work.

### Approach

Use `Queue<T>` because its FIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var tasks = new Queue<(string Name, int Work)>();
tasks.Enqueue(("A", 2));
tasks.Enqueue(("B", 1));
while (tasks.Count > 0)
{
    var task = tasks.Dequeue();
    task.Work--;
    Console.WriteLine(task.Name);
    if (task.Work > 0) tasks.Enqueue(task);
}
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Initial | `[A2,B1]` | A at front |
| 2: Run A | `A1` | Requeue A |
| 3: Queue | `[B1,A1]` | B now front |
| 4: Run B | `[A1]` | B completes |
| 5: Run A | `[]` | A completes |

### Complexity

Round-robin time is proportional to total work units; the queue stores unfinished tasks.

### Edge cases

- Empty input
- One value
- Repeated values
- Missing lookup value
- Large input


## Solved Problem 5: Breadth-first traversal idea

### Requirement

Visit a small graph level by level using a queue.

### Approach

Use `Queue<T>` because its FIFO behavior matches the operations in this problem.
Keep the algorithm separate from input collection creation when converting it into a reusable method.
Trace the state after every modification instead of guessing the final output.

### C# solution

```csharp
using System;
using System.Collections.Generic;
using System.Text;

var graph = new Dictionary<int, List<int>>
{
    [1] = new() { 2, 3 }, [2] = new() { 4 },
    [3] = new(), [4] = new()
};
var queue = new Queue<int>();
var visited = new HashSet<int> { 1 };
queue.Enqueue(1);
while (queue.Count > 0)
{
    int node = queue.Dequeue();
    Console.Write(node + " ");
    foreach (int next in graph[node])
        if (visited.Add(next)) queue.Enqueue(next);
}
```

### Dry Run

| Step | Collection or variable state | Explanation |
|---:|---|---|
| 1: Start | `queue=[1]` | Visit set={1} |
| 2: Take 1 | `queue=[2,3]` | Discover level 1 |
| 3: Take 2 | `queue=[3,4]` | Discover 4 |
| 4: Take 3 | `queue=[4]` | No neighbor |
| 5: Take 4 | `queue=[]` | Order 1,2,3,4 |

### Complexity

BFS is O(V + E) time and O(V) space for queue and visited set.

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

1. Write a new Queue<T> in C# problem that focuses on `Enqueue` and dry-run it.
2. Write a new Queue<T> in C# problem that focuses on `Dequeue` and dry-run it.
3. Write a new Queue<T> in C# problem that focuses on `Peek` and dry-run it.
4. Write a new Queue<T> in C# problem that focuses on `TryDequeue` and dry-run it.
5. Write a new Queue<T> in C# problem that focuses on `TryPeek` and dry-run it.
6. Write a new Queue<T> in C# problem that focuses on `Contains` and dry-run it.
7. Write a new Queue<T> in C# problem that focuses on `ToArray` and dry-run it.
8. Write a new Queue<T> in C# problem that focuses on `Count` and dry-run it.
9. Write a new Queue<T> in C# problem that focuses on `Clear` and dry-run it.
10. Write a new Queue<T> in C# problem that focuses on `foreach` and dry-run it.
11. Write a new Queue<T> in C# problem that focuses on `FIFO` and dry-run it.
12. Write a new Queue<T> in C# problem that focuses on `Enqueue` and dry-run it.
13. Write a new Queue<T> in C# problem that focuses on `Dequeue` and dry-run it.
14. Write a new Queue<T> in C# problem that focuses on `Peek` and dry-run it.
15. Write a new Queue<T> in C# problem that focuses on `TryDequeue` and dry-run it.
16. Write a new Queue<T> in C# problem that focuses on `TryPeek` and dry-run it.
17. Write a new Queue<T> in C# problem that focuses on `Contains` and dry-run it.
18. Write a new Queue<T> in C# problem that focuses on `ToArray` and dry-run it.
19. Write a new Queue<T> in C# problem that focuses on `Count` and dry-run it.
20. Write a new Queue<T> in C# problem that focuses on `Clear` and dry-run it.

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

### `Enqueue`

- Behavior: Adds a value at the back.
- Typical cost: O(1) amortized.
- Safety note: Earlier values remain ahead of it.

### `Dequeue`

- Behavior: Removes and returns the front value.
- Typical cost: O(1).
- Safety note: It throws InvalidOperationException when empty.

### `Peek`

- Behavior: Reads the front without removal.
- Typical cost: O(1).
- Safety note: It throws InvalidOperationException when empty.

### `TryDequeue`

- Behavior: Safely removes the front when available.
- Typical cost: O(1).
- Safety note: It returns false for an empty queue.

### `TryPeek`

- Behavior: Safely reads the front when available.
- Typical cost: O(1).
- Safety note: It does not change Count.

### `Contains`

- Behavior: Searches for an equal value.
- Typical cost: O(n).
- Safety note: Use a HashSet too when fast membership is required.

### `ToArray`

- Behavior: Copies values from front to back.
- Typical cost: O(n) time and O(n) extra space.
- Safety note: The returned array can be modified independently.

### `Count`

- Behavior: Reports waiting item count.
- Typical cost: O(1).
- Safety note: Count is zero for an empty queue.

### `Clear`

- Behavior: Removes all queued values.
- Typical cost: O(n) in common implementations.
- Safety note: No item remains at the front.

### `FIFO rule`

- Behavior: First enqueued is first removed.
- Typical cost: This is behavior, not an API method.
- Safety note: Use it for fair scheduling and BFS.

### `foreach`

- Behavior: Enumerates values from the current front toward the back.
- Typical cost: O(n) for a complete pass.
- Safety note: Do not modify the queue while its enumerator is active.
