# 09 - Print Only Non-Duplicate Values in Array (C#)

## Problem
Given an integer array, print only those values that appear exactly one time.

Example:

```csharp
int[] no = { 2, 2, 0, 3, 3 };
```

Expected output:

```text
0
```

Why?
- `2` appears 2 times, so do not print it.
- `3` appears 2 times, so do not print it.
- `0` appears only 1 time, so print it.

## Beginner Approach - Nested foreach loop

```csharp
using System;

class Program
{
    public static void Main(string[] args)
    {
        int[] no = { 2, 2, 0, 3, 3 };

        foreach (int n in no)
        {
            int count = 0;

            foreach (int x in no)
            {
                if (n == x)
                {
                    count++;
                }
            }

            if (count == 1)
            {
                Console.WriteLine(n);
            }
        }
    }
}
```

## Logic Step by Step

1. Take one number from the array using the outer `foreach` loop.
2. Set `count = 0` for that number.
3. The inner `foreach` loop checks that number against every value in the array.
4. Whenever `n == x`, increase `count`.
5. After checking the complete array, if `count == 1`, that number is not duplicated.
6. Print only that number.

## Dry Run

For array:

```text
2, 2, 0, 3, 3
```

For `n = 2`:
- Count becomes 2
- `count == 1` is false
- Do not print

For second `2`:
- Count is again 2
- Do not print

For `n = 0`:
- Count becomes 1
- `count == 1` is true
- Print `0`

For `n = 3`:
- Count becomes 2
- Do not print

Final output:

```text
0
```

## Time Complexity

Because one loop runs inside another loop:

```text
O(n²)
```

Space Complexity:

```text
O(1)
```

This is a good beginner solution because it makes the duplicate-counting logic very clear.

## Important Interview Difference

There are two different duplicate-array questions:

### 1. Print each distinct value only once

Input:

```text
2, 2, 0, 3, 3
```

Output:

```text
2
0
3
```

### 2. Print only values that are not duplicated

Input:

```text
2, 2, 0, 3, 3
```

Output:

```text
0
```

This chapter solves the second problem.

## Practice

Try these yourself:

```csharp
int[] a = { 1, 2, 2, 4, 4, 5 };
```
Expected:

```text
1
5
```

```csharp
int[] b = { 7, 7, 8, 9, 9, 10 };
```
Expected:

```text
8
10
```

```csharp
int[] c = { 1, 1, 2, 2, 3, 3 };
```
Expected: nothing should be printed.

## Next Step
After understanding this `O(n²)` beginner approach, solve the same problem using `Dictionary<int, int>` in `O(n)` time.
