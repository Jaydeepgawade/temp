# 06 - Prime Number

## Goal
Check whether a number is prime.

A prime number has exactly two factors:
- `1`
- the number itself

Examples:
- `2` -> Prime
- `7` -> Prime
- `8` -> Not Prime

## Beginner Approach
Check divisibility from `2` to `number - 1`.

## C# Code
```csharp
using System;

class Program
{
    static void Main()
    {
        int number = 7;
        bool isPrime = true;

        if (number <= 1)
        {
            isPrime = false;
        }
        else
        {
            for (int i = 2; i < number; i++)
            {
                if (number % i == 0)
                {
                    isPrime = false;
                    break;
                }
            }
        }

        if (isPrime)
            Console.WriteLine(number + " is Prime");
        else
            Console.WriteLine(number + " is Not Prime");
    }
}
```

## Dry Run for 7
- `7 % 2 != 0`
- `7 % 3 != 0`
- `7 % 4 != 0`
- `7 % 5 != 0`
- `7 % 6 != 0`

So `7` is prime.

## Optimized Idea
You only need to check divisors up to the square root of the number.

```csharp
for (int i = 2; i * i <= number; i++)
{
    if (number % i == 0)
    {
        isPrime = false;
        break;
    }
}
```

## Complexity
- Beginner approach: `O(n)`
- Optimized approach: `O(sqrt(n))`
- Space: `O(1)`

## Practice
1. Check `11`.
2. Check `15`.
3. Check `1`.
4. Print all prime numbers from `1` to `50`.
