# Topic 1: Reverse a Number in C#

## Goal
Given a number like `456`, reverse it and get `654`.

## Core Logic
For every loop iteration:
1. Get the last digit using `% 10`.
2. Add that digit into `reverse`.
3. Remove the last digit using `/ 10`.

## Important Formula
```csharp
int digit = temp % 10;
reverse = reverse * 10 + digit;
temp = temp / 10;
```

## Full C# Program
```csharp
using System;

class Program
{
    public static void Main(string[] args)
    {
        int number = 456;
        int temp = number;
        int reverse = 0;

        while (temp > 0)
        {
            int digit = temp % 10;
            reverse = reverse * 10 + digit;
            temp = temp / 10;
        }

        Console.WriteLine("Reverse Number: " + reverse);
        Console.ReadLine();
    }
}
```

## Dry Run for 456

### Iteration 1
- temp = 456
- digit = 456 % 10 = 6
- reverse = 0 * 10 + 6 = 6
- temp = 456 / 10 = 45

### Iteration 2
- temp = 45
- digit = 45 % 10 = 5
- reverse = 6 * 10 + 5 = 65
- temp = 45 / 10 = 4

### Iteration 3
- temp = 4
- digit = 4 % 10 = 4
- reverse = 65 * 10 + 4 = 654
- temp = 4 / 10 = 0

Loop stops because `temp > 0` is false.

## Why `reverse * 10`?
Suppose reverse is `65` and next digit is `4`.

If we only add:
```csharp
65 + 4 = 69
```
That is wrong.

We first shift digits left:
```text
65 * 10 = 650
650 + 4 = 654
```

## Common Mistake
Wrong:
```csharp
temp = temp % 10;
reverse = reverse * 10 + number;
```

Why wrong?
- `temp % 10` gives only the last digit and destroys the remaining number.
- We must store last digit in another variable called `digit`.
- We must add `digit`, not the original `number`.

## Time Complexity
`O(d)` where d = number of digits.

## Space Complexity
`O(1)`.

## Practice
1. Reverse `1234`.
2. Reverse `9876`.
3. Reverse `1205`.
4. Try to dry-run `789` on paper.
5. Explain why `% 10` gives the last digit.
