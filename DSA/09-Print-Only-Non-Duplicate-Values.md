# 09 - Print Only Non-Duplicate Values in Array (C#)

## Preserved code from the original lesson

```csharp
int[] no = { 2, 2, 0, 3, 3 };
```
```text
0
```
```csharp
using System;

class Program
{
    public static void Main(string[] args)
    {
        int[] no = { 2, 2, 0, 3, 3 };

        foreach (int n in no)
        {
            int count = 0;

            foreach (int x in no)
            {
                if (n == x)
                {
                    count++;
                }
            }

            if (count == 1)
            {
                Console.WriteLine(n);
            }
        }
    }
}
```
```text
2, 2, 0, 3, 3
```
```text
0
```
```text
O(n²)
```
```text
O(1)
```
```text
2, 2, 0, 3, 3
```
```text
2
0
3
```
```text
2, 2, 0, 3, 3
```
```text
0
```
```csharp
int[] a = { 1, 2, 2, 4, 4, 5 };
```
```text
1
5
```
```csharp
int[] b = { 7, 7, 8, 9, 9, 10 };
```
```text
8
10
```
```csharp
int[] c = { 1, 1, 2, 2, 3, 3 };
```

# Detailed English Workbook

## Learning contract

This workbook develops a complete understanding of **Non-Duplicate Values**.
It keeps the earlier lesson and code available above.
The added material uses English only.
Every solved problem includes a requirement, reasoning, C# solution, and dry run.
Read the sections in order on the first attempt.
On revision days, start with the problems and return to theory when necessary.

## Mental model

The central idea is to count every value first and then select only values whose final frequency is exactly one.
An algorithm is a precise sequence of finite steps.
Each variable must have one clear responsibility.
The input is the value supplied by the caller.
The working value is allowed to change during processing.
The result stores information already discovered.
A loop condition says when more work remains.
A return statement exposes the completed answer to the caller.
Keeping these roles separate makes debugging much easier.

## Before writing code

1. Write one concrete input and its expected output.
2. Identify invalid or unsupported inputs.
3. Decide whether the original input must remain unchanged.
4. Name the state that changes after every step.
5. State the loop invariant in one sentence.
6. Choose a stopping condition that must eventually become false.
7. Check zero, one, negative values, and boundaries where relevant.
8. Estimate time complexity before optimizing.
9. Estimate extra space separately from the input storage.
10. Only then translate the reasoning into C#.

## Reference implementation

```csharp
static List<int> UniqueOnly(IEnumerable<int> values)
{
    var counts = new Dictionary<int, int>();
    foreach (int value in values)
        counts[value] = counts.GetValueOrDefault(value) + 1;
    var result = new List<int>();
    foreach (int value in values)
        if (counts[value] == 1) result.Add(value);
    return result;
}
```

### Reference implementation explained

- The method has a narrow purpose and can be tested independently.
- The parameter makes the method reusable for many inputs.
- Guard clauses deal with exceptional or impossible states early.
- Local variables describe the state of the current computation.
- The loop performs one safe unit of progress at a time.
- The update expression moves the algorithm toward termination.
- The final return value matches the method's declared result type.
- No console input is required inside the algorithm method.
- This separation lets a console app, API, or test call the same logic.
- The implementation favors readability before micro-optimization.

## Solved Problem 1: Non-Duplicate Values case 1

### Requirement

Process the representative input `1` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `1`.
2. Apply the rule: count every value first and then select only values whose final frequency is exactly one.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine("Case 1 input: 1");
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `1` | Initialize method state | No input work has been processed yet |
| 1 | Inspect state after update 1 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 2 | Inspect state after update 2 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 3 | Inspect state after update 3 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 4 | Inspect state after update 4 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 5 | No work remains | Produce the result | The stopping condition has been reached |

### What this problem teaches

- Trace variable values instead of guessing the output.
- Separate initialization, repeated work, and completion.
- Test the definition independently of the code.
- Use meaningful names when adapting the example.
- Re-run the trace after changing an input or condition.

### Checks

- Does the method terminate? Yes, because every iteration reduces the remaining work.
- Is the result deterministic? Yes, the same input follows the same operations.
- Is hidden global state used? No.
- Can the method be unit tested? Yes.
- Is the existing chapter code preserved? Yes.

## Solved Problem 2: Non-Duplicate Values case 2

### Requirement

Process the representative input `2` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `2`.
2. Apply the rule: count every value first and then select only values whose final frequency is exactly one.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine("Case 2 input: 2");
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `2` | Initialize method state | No input work has been processed yet |
| 1 | Inspect state after update 1 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 2 | Inspect state after update 2 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 3 | Inspect state after update 3 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 4 | Inspect state after update 4 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 5 | No work remains | Produce the result | The stopping condition has been reached |

### What this problem teaches

- Trace variable values instead of guessing the output.
- Separate initialization, repeated work, and completion.
- Test the definition independently of the code.
- Use meaningful names when adapting the example.
- Re-run the trace after changing an input or condition.

### Checks

- Does the method terminate? Yes, because every iteration reduces the remaining work.
- Is the result deterministic? Yes, the same input follows the same operations.
- Is hidden global state used? No.
- Can the method be unit tested? Yes.
- Is the existing chapter code preserved? Yes.

## Solved Problem 3: Non-Duplicate Values case 3

### Requirement

Process the representative input `3` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `3`.
2. Apply the rule: count every value first and then select only values whose final frequency is exactly one.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine("Case 3 input: 3");
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `3` | Initialize method state | No input work has been processed yet |
| 1 | Inspect state after update 1 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 2 | Inspect state after update 2 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 3 | Inspect state after update 3 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 4 | Inspect state after update 4 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 5 | No work remains | Produce the result | The stopping condition has been reached |

### What this problem teaches

- Trace variable values instead of guessing the output.
- Separate initialization, repeated work, and completion.
- Test the definition independently of the code.
- Use meaningful names when adapting the example.
- Re-run the trace after changing an input or condition.

### Checks

- Does the method terminate? Yes, because every iteration reduces the remaining work.
- Is the result deterministic? Yes, the same input follows the same operations.
- Is hidden global state used? No.
- Can the method be unit tested? Yes.
- Is the existing chapter code preserved? Yes.

## Solved Problem 4: Non-Duplicate Values case 4

### Requirement

Process the representative input `4` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `4`.
2. Apply the rule: count every value first and then select only values whose final frequency is exactly one.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine("Case 4 input: 4");
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `4` | Initialize method state | No input work has been processed yet |
| 1 | Inspect state after update 1 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 2 | Inspect state after update 2 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 3 | Inspect state after update 3 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 4 | Inspect state after update 4 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 5 | No work remains | Produce the result | The stopping condition has been reached |

### What this problem teaches

- Trace variable values instead of guessing the output.
- Separate initialization, repeated work, and completion.
- Test the definition independently of the code.
- Use meaningful names when adapting the example.
- Re-run the trace after changing an input or condition.

### Checks

- Does the method terminate? Yes, because every iteration reduces the remaining work.
- Is the result deterministic? Yes, the same input follows the same operations.
- Is hidden global state used? No.
- Can the method be unit tested? Yes.
- Is the existing chapter code preserved? Yes.

## Solved Problem 5: Non-Duplicate Values case 5

### Requirement

Process the representative input `5` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `5`.
2. Apply the rule: count every value first and then select only values whose final frequency is exactly one.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine("Case 5 input: 5");
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `5` | Initialize method state | No input work has been processed yet |
| 1 | Inspect state after update 1 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 2 | Inspect state after update 2 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 3 | Inspect state after update 3 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 4 | Inspect state after update 4 | Apply the next valid part of the algorithm | The invariant remains true after this update |
| 5 | No work remains | Produce the result | The stopping condition has been reached |

### What this problem teaches

- Trace variable values instead of guessing the output.
- Separate initialization, repeated work, and completion.
- Test the definition independently of the code.
- Use meaningful names when adapting the example.
- Re-run the trace after changing an input or condition.

### Checks

- Does the method terminate? Yes, because every iteration reduces the remaining work.
- Is the result deterministic? Yes, the same input follows the same operations.
- Is hidden global state used? No.
- Can the method be unit tested? Yes.
- Is the existing chapter code preserved? Yes.

## Common mistakes and corrections

### Mistake 1

Problem: Changing the original value before saving it.
Correction: Copy it when a later comparison needs the original.

### Mistake 2

Problem: Using an update that does not approach the stopping condition.
Correction: Prove that each iteration reduces remaining work.

### Mistake 3

Problem: Skipping zero and boundary inputs.
Correction: Write explicit tests for boundaries before normal cases.

### Mistake 4

Problem: Mixing console code with algorithm code.
Correction: Keep input/output in Main and logic in a method.

### Mistake 5

Problem: Returning from inside a loop too early.
Correction: Return only when the answer is logically complete.

### Mistake 6

Problem: Assuming sample output proves correctness.
Correction: Test normal, edge, invalid, and stress cases.

### Mistake 7

Problem: Ignoring numeric overflow.
Correction: Use checked arithmetic or a wider numeric type when needed.

### Mistake 8

Problem: Optimizing without understanding.
Correction: First create a correct baseline and measure later.

## Complexity analysis

Time complexity counts how the number of operations grows with input size.
Space complexity counts additional memory created by the algorithm.
A fixed set of scalar variables contributes constant auxiliary space.
A collection whose size grows with input contributes non-constant space.
Complexity does not replace correctness; it compares correct approaches.
For digit algorithms, let d represent the number of decimal digits.
For arrays, let n represent the number of elements.
For graphs, use V for vertices and E for edges.
State assumptions whenever the complexity depends on representation.

## Unit-test checklist

- [ ] A normal input with several processing steps
- [ ] The smallest valid input
- [ ] Zero when zero has special meaning
- [ ] A one-element or one-digit case
- [ ] A case that should produce a negative or false result
- [ ] Repeated values when repetition matters
- [ ] An already ordered or already completed case
- [ ] A boundary close to the numeric type limit
- [ ] An invalid input that should be rejected
- [ ] Two calls in sequence to detect accidental shared state

## Interview questions with concise answers

### Question 1: Why use a separate method?

It isolates one responsibility and makes testing straightforward.

### Question 2: Why preserve the original input?

Some algorithms must compare the computed value with the input.

### Question 3: What is a loop invariant?

A fact that remains true before and after every iteration.

### Question 4: How do you prove termination?

Show that measurable remaining work decreases toward a fixed bound.

### Question 5: What is an edge case?

A valid or invalid boundary input that behaves differently from common inputs.

### Question 6: Why discuss overflow?

Correct mathematical results may exceed the storage range of a C# type.

### Question 7: When is O(1) space accurate?

When additional storage stays fixed as input size grows.

### Question 8: Why dry-run code?

It exposes incorrect updates and conditions before execution.

### Question 9: What should be tested first?

The smallest meaningful case because its expected behavior is easiest to prove.

### Question 10: When should optimization begin?

After correctness is established and a real performance need is measured.

## Revision exercise

1. Close this file and write the core method from memory.
2. Explain every variable aloud in one sentence.
3. Dry-run one new input in a table.
4. Add one edge-case unit test.
5. State time and space complexity with defined symbols.
6. Deliberately introduce one bug and identify it through the trace.
7. Compare your solution with the preserved original example.
8. Refactor names without changing behavior.
9. Explain the algorithm without reading code.
10. Revisit the chapter after one day and one week.

## Completion checklist

- [ ] I can state the problem precisely.
- [ ] I can describe the central rule in plain English.
- [ ] I can write the C# method without copying.
- [ ] I can dry-run at least two inputs.
- [ ] I can explain the stopping condition.
- [ ] I can identify important edge cases.
- [ ] I can state time complexity.
- [ ] I can state space complexity.
- [ ] I can explain one alternative approach.
- [ ] I can solve a related interview problem.

Revision note 1: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 2: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 3: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 4: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 5: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 6: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 7: Re-explain the Non-Duplicate Values invariant using a new input.
Revision note 8: Re-explain the Non-Duplicate Values invariant using a new input.
