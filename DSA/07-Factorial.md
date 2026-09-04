# 07 - Factorial of a Number

## Goal
Find the factorial of a number.

Factorial means multiplying all positive integers from `1` to that number.

Example:
`5! = 5 × 4 × 3 × 2 × 1 = 120`

## C# Code
```csharp
using System;

class Program
{
    static void Main()
    {
        int number = 5;
        long factorial = 1;

        for (int i = 1; i <= number; i++)
        {
            factorial = factorial * i;
        }

        Console.WriteLine("Factorial: " + factorial);
    }
}
```

## Dry Run for 5
| i | factorial |
|---:|---:|
| 1 | 1 |
| 2 | 2 |
| 3 | 6 |
| 4 | 24 |
| 5 | 120 |

Final answer = `120`.

## Important
`0! = 1`

## While Loop Version
```csharp
int number = 5;
int i = 1;
long factorial = 1;

while (i <= number)
{
    factorial = factorial * i;
    i++;
}
```

## Complexity
- Time: `O(n)`
- Space: `O(1)`

## Practice
1. Find `4!`.
2. Find `6!`.
3. Find `0!`.
4. Take number from user and calculate factorial.
