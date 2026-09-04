# 05 - Sum of Digits

## Goal
Find the sum of all digits in a number.

Example:
- Input: `456`
- Output: `15`

Because:
`4 + 5 + 6 = 15`

## Core Idea
Use `% 10` to get the last digit and `/ 10` to remove the last digit.

## C# Code
```csharp
using System;

class Program
{
    static void Main()
    {
        int number = 456;
        int temp = number;
        int sum = 0;

        while (temp > 0)
        {
            int digit = temp % 10;
            sum = sum + digit;
            temp = temp / 10;
        }

        Console.WriteLine("Sum of digits: " + sum);
    }
}
```

## Dry Run for 456
| Iteration | temp | digit | sum |
|---|---:|---:|---:|
| 1 | 456 | 6 | 6 |
| 2 | 45 | 5 | 11 |
| 3 | 4 | 4 | 15 |

Final answer = `15`.

## Remember
- `% 10` -> last digit
- `/ 10` -> remove last digit

## Complexity
- Time: `O(d)`
- Space: `O(1)`

## Practice
1. Sum digits of `567`.
2. Sum digits of `9999`.
3. Sum digits of `1024`.
4. Take number from user input.
