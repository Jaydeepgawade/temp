# 12 - Dynamic Programming Basics

## What is Dynamic Programming?
Dynamic Programming (DP) is a technique used when a problem has:
- repeated subproblems
- overlapping calculations
- an answer that can be built from smaller answers

Main idea:
```text
Calculate once -> store the result -> reuse it
```

This avoids solving the same problem again and again.

## Recursion vs Dynamic Programming
Normal recursion may repeat the same calculations many times.

Example Fibonacci:
```text
fib(5)
 -> fib(4)
 -> fib(3)
 -> fib(3)
 -> fib(2)
```

Here some values are calculated repeatedly.

Dynamic Programming stores those answers.

## 1. Memoization
Memoization means:
**Top-down approach + recursion + cache**

### C# Example
```csharp
using System;
using System.Collections.Generic;

class Program
{
    static Dictionary<int, int> memo = new Dictionary<int, int>();

    static int Fibonacci(int n)
    {
        if (n <= 1)
        {
            return n;
        }

        if (memo.ContainsKey(n))
        {
            return memo[n];
        }

        int result = Fibonacci(n - 1) + Fibonacci(n - 2);
        memo[n] = result;

        return result;
    }

    static void Main()
    {
        Console.WriteLine(Fibonacci(6));
    }
}
```

Output:
```text
8
```

## 2. Tabulation
Tabulation means:
**Bottom-up approach + loops + table/array**

```csharp
using System;

class Program
{
    static int Fibonacci(int n)
    {
        if (n <= 1)
        {
            return n;
        }

        int[] dp = new int[n + 1];
        dp[0] = 0;
        dp[1] = 1;

        for (int i = 2; i <= n; i++)
        {
            dp[i] = dp[i - 1] + dp[i - 2];
        }

        return dp[n];
    }

    static void Main()
    {
        Console.WriteLine(Fibonacci(6));
    }
}
```

## Fibonacci Table
For n = 6:
```text
Index : 0 1 2 3 4 5 6
Value : 0 1 1 2 3 5 8
```

## Climbing Stairs Problem
Suppose you can climb either:
- 1 step
- 2 steps

Question:
How many different ways can you reach step `n`?

Formula:
```text
ways[n] = ways[n - 1] + ways[n - 2]
```

### C# Example
```csharp
using System;

class Program
{
    static int ClimbStairs(int n)
    {
        if (n <= 2)
        {
            return n;
        }

        int[] dp = new int[n + 1];
        dp[1] = 1;
        dp[2] = 2;

        for (int i = 3; i <= n; i++)
        {
            dp[i] = dp[i - 1] + dp[i - 2];
        }

        return dp[n];
    }

    static void Main()
    {
        Console.WriteLine(ClimbStairs(5));
    }
}
```

Output:
```text
8
```

## Memoization vs Tabulation

| Memoization | Tabulation |
|---|---|
| Top-down | Bottom-up |
| Uses recursion | Uses loops |
| Stores results when needed | Builds all required results |
| Can use extra recursion stack | No recursion stack needed |

## Complexity - Fibonacci DP
- Time Complexity: **O(n)**
- Space Complexity: **O(n)**

Later we can optimize Fibonacci space to **O(1)**.

## Practice
1. Fibonacci using normal recursion.
2. Fibonacci using memoization.
3. Fibonacci using tabulation.
4. Climbing Stairs.
5. Compare recursive and DP solutions.
