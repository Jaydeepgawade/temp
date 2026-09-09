# Topic 2: Palindrome Number in C#

## What is a Palindrome Number?
A palindrome number reads the same from left to right and right to left.

Examples:
- `121` -> palindrome
- `1331` -> palindrome
- `123` -> not palindrome

## Idea
We already know how to reverse a number.
For palindrome:
1. Store original number.
2. Reverse the number.
3. Compare original number with reversed number.

If both are equal, the number is palindrome.

## Full C# Program
```csharp
using System;

class Program
{
    public static void Main(string[] args)
    {
        int number = 121;
        int temp = number;
        int reverse = 0;

        while (temp > 0)
        {
            int digit = temp % 10;
            reverse = reverse * 10 + digit;
            temp = temp / 10;
        }

        if (number == reverse)
        {
            Console.WriteLine(number + " is a Palindrome Number");
        }
        else
        {
            Console.WriteLine(number + " is NOT a Palindrome Number");
        }

        Console.ReadLine();
    }
}
```

## Dry Run for 121
Initial:
- number = 121
- temp = 121
- reverse = 0

### Iteration 1
- digit = 121 % 10 = 1
- reverse = 0 * 10 + 1 = 1
- temp = 121 / 10 = 12

### Iteration 2
- digit = 12 % 10 = 2
- reverse = 1 * 10 + 2 = 12
- temp = 12 / 10 = 1

### Iteration 3
- digit = 1 % 10 = 1
- reverse = 12 * 10 + 1 = 121
- temp = 1 / 10 = 0

Now:
```text
number = 121
reverse = 121
```
So it is palindrome.

## Why do we use `temp`?
If we directly change `number`, the original value will be lost.
We need the original number at the end for comparison.

That is why:
```csharp
int temp = number;
```

## Time Complexity
`O(d)` where d = digits.

## Space Complexity
`O(1)`.

## Practice Questions
1. Check `1221`.
2. Check `1234`.
3. Check `1001`.
4. Check `56765`.
5. Write the logic yourself without looking at the solution.

## Interview Question
Why is palindrome based on reverse logic?

Answer:
Because a palindrome remains unchanged after reversing its digits.

# Detailed English Workbook

## Learning contract

This workbook develops a complete understanding of **Palindrome Number**.
It keeps the earlier lesson and code available above.
The added material uses English only.
Every solved problem includes a requirement, reasoning, C# solution, and dry run.
Read the sections in order on the first attempt.
On revision days, start with the problems and return to theory when necessary.

## Mental model

The central idea is to reverse the digits and compare the reversed value with the unchanged original value.
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
static bool IsPalindrome(int number)
{
    if (number < 0) return false;
    int original = number;
    int reversed = 0;
    do
    {
        reversed = reversed * 10 + number % 10;
        number /= 10;
    } while (number > 0);
    return reversed == original;
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

## Solved Problem 1: Palindrome Number case 1

### Requirement

Process the representative input `121` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `121`.
2. Apply the rule: reverse the digits and compare the reversed value with the unchanged original value.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine(IsPalindrome(121));
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `121` | Initialize method state | No input work has been processed yet |
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

## Solved Problem 2: Palindrome Number case 2

### Requirement

Process the representative input `123` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `123`.
2. Apply the rule: reverse the digits and compare the reversed value with the unchanged original value.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine(IsPalindrome(123));
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `123` | Initialize method state | No input work has been processed yet |
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

## Solved Problem 3: Palindrome Number case 3

### Requirement

Process the representative input `7` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `7`.
2. Apply the rule: reverse the digits and compare the reversed value with the unchanged original value.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine(IsPalindrome(7));
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `7` | Initialize method state | No input work has been processed yet |
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

## Solved Problem 4: Palindrome Number case 4

### Requirement

Process the representative input `1001` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `1001`.
2. Apply the rule: reverse the digits and compare the reversed value with the unchanged original value.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine(IsPalindrome(1001));
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `1001` | Initialize method state | No input work has been processed yet |
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

## Solved Problem 5: Palindrome Number case 5

### Requirement

Process the representative input `1221` using the chapter algorithm.
Return or display the mathematically correct result.
Do not hide the logic inside an unrelated library shortcut.
Keep the algorithm in a separate method so it can be tested.

### Reasoning

1. Begin with the input `1221`.
2. Apply the rule: reverse the digits and compare the reversed value with the unchanged original value.
3. Record state after every meaningful update.
4. Continue only while unprocessed work remains.
5. Verify the result against the definition, not merely the program output.

### C# solution usage

Use the reference implementation above with this call:

```csharp
Console.WriteLine(IsPalindrome(1221));
```

### Detailed dry run

| Step | State inspected | Decision or calculation | Why it is correct |
|---:|---|---|---|
| 0 | Input is `1221` | Initialize method state | No input work has been processed yet |
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
