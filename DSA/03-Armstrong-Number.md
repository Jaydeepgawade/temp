# Topic 3: Armstrong Number in C#

## What is an Armstrong Number?
For a 3-digit number, if the sum of cubes of each digit is equal to the original number, it is an Armstrong number.

Example: `153`

```text
1³ + 5³ + 3³
= 1 + 125 + 27
= 153
```

So `153` is an Armstrong number.

Other examples:
- 153
- 370
- 371
- 407

## Logic
1. Store original number in `number`.
2. Copy it into `temp`.
3. Extract last digit using `% 10`.
4. Cube the digit.
5. Add cube to `sum`.
6. Remove last digit using `/ 10`.
7. Compare `sum` with original number.

## Full C# Program
```csharp
using System;

class Program
{
    public static void Main(string[] args)
    {
        int number = 153;
        int temp = number;
        int sum = 0;

        while (temp > 0)
        {
            int digit = temp % 10;
            sum = sum + (digit * digit * digit);
            temp = temp / 10;
        }

        if (sum == number)
        {
            Console.WriteLine(number + " is an Armstrong Number");
        }
        else
        {
            Console.WriteLine(number + " is NOT an Armstrong Number");
        }

        Console.ReadLine();
    }
}
```

## Dry Run for 153
Initial:
- number = 153
- temp = 153
- sum = 0

### Iteration 1
- digit = 153 % 10 = 3
- cube = 3 * 3 * 3 = 27
- sum = 0 + 27 = 27
- temp = 153 / 10 = 15

### Iteration 2
- digit = 15 % 10 = 5
- cube = 5 * 5 * 5 = 125
- sum = 27 + 125 = 152
- temp = 15 / 10 = 1

### Iteration 3
- digit = 1 % 10 = 1
- cube = 1
- sum = 152 + 1 = 153
- temp = 1 / 10 = 0

Now:
```text
sum = 153
number = 153
```
Therefore it is an Armstrong number.

## Important Difference
Reverse number:
```csharp
reverse = reverse * 10 + digit;
```

Armstrong number:
```csharp
sum = sum + (digit * digit * digit);
```

## Time Complexity
`O(d)` where d = number of digits.

## Space Complexity
`O(1)`.

## Practice Questions
1. Check `370`.
2. Check `371`.
3. Check `407`.
4. Check `123`.
5. Dry-run `153` without executing code.

## Challenge
The above logic is for 3-digit Armstrong numbers.
Later, learn how to support any number of digits using the digit count and `Math.Pow()`.
