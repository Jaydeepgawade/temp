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
