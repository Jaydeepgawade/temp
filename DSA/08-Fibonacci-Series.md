# 08 - Fibonacci Series

## Goal
Print Fibonacci numbers.

The Fibonacci sequence starts like this:
`0, 1, 1, 2, 3, 5, 8, 13...`

Each next number is the sum of the previous two numbers.

## C# Code
```csharp
using System;

class Program
{
    static void Main()
    {
        int n = 10;
        int first = 0;
        int second = 1;

        Console.Write(first + " " + second + " ");

        for (int i = 3; i <= n; i++)
        {
            int next = first + second;
            Console.Write(next + " ");

            first = second;
            second = next;
        }
    }
}
```

## Dry Run
Start:
- `first = 0`
- `second = 1`

Then:
- `next = 0 + 1 = 1`
- `next = 1 + 1 = 2`
- `next = 1 + 2 = 3`
- `next = 2 + 3 = 5`

Output for 10 terms:
`0 1 1 2 3 5 8 13 21 34`

## Why variables change
After calculating `next`:
```csharp
first = second;
second = next;
```

This shifts the last two numbers forward so we can calculate the next Fibonacci number.

## Complexity
- Time: `O(n)`
- Space: `O(1)`

## Practice
1. Print first 5 Fibonacci numbers.
2. Print first 15 Fibonacci numbers.
3. Take number of terms from user input.
4. Try Fibonacci using a `while` loop.
