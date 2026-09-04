# 04 - Count Digits in a Number

## Goal
Given a number, count how many digits it contains.

Example:
- Input: `12345`
- Output: `5`

## Core Idea
Every time we divide an integer by `10`, its last digit is removed.

Example:
`12345 -> 1234 -> 123 -> 12 -> 1 -> 0`

So we can keep dividing by `10` and increase a counter until the number becomes `0`.

## C# Code
```csharp
using System;

class Program
{
    static void Main()
    {
        int number = 12345;
        int temp = number;
        int count = 0;

        while (temp > 0)
        {
            count++;
            temp = temp / 10;
        }

        Console.WriteLine("Digit count: " + count);
    }
}
```

## Dry Run
For `number = 12345`:

| Iteration | temp before | count | temp after |
|---|---:|---:|---:|
| 1 | 12345 | 1 | 1234 |
| 2 | 1234 | 2 | 123 |
| 3 | 123 | 3 | 12 |
| 4 | 12 | 4 | 1 |
| 5 | 1 | 5 | 0 |

Final answer = `5`.

## Important Edge Case
If number is `0`, it still has one digit.

```csharp
if (number == 0)
{
    count = 1;
}
```

## Time & Space Complexity
- Time: `O(d)` where `d` = number of digits
- Space: `O(1)`

## Practice
1. Count digits in `9876`.
2. Count digits in `100000`.
3. Count digits in `7`.
4. Modify the program to accept input from the user.
