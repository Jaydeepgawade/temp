# 11 - Greedy Algorithm Basics

## What is a Greedy Algorithm?
A Greedy Algorithm chooses the **best option available right now** at every step.

It does not usually go back and change the previous decision.

Simple idea:
```text
Choose the best local option -> move forward -> repeat
```

## Where Greedy is useful
Common examples:
- Activity Selection
- Coin Change for some coin systems
- Minimum/Maximum selection problems
- Kruskal's Algorithm
- Prim's Algorithm
- Huffman Coding

## Beginner Example - Activity Selection
Suppose we have activities with start and end times.
We want to select the maximum number of non-overlapping activities.

```text
Activity  Start  End
A1        1      2
A2        3      4
A3        0      6
A4        5      7
A5        8      9
A6        5      9
```

Greedy idea:
Choose the activity that finishes earliest.

## C# Example
```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Activity
{
    public string Name { get; set; }
    public int Start { get; set; }
    public int End { get; set; }
}

class Program
{
    static void Main()
    {
        List<Activity> activities = new List<Activity>
        {
            new Activity { Name = "A1", Start = 1, End = 2 },
            new Activity { Name = "A2", Start = 3, End = 4 },
            new Activity { Name = "A3", Start = 0, End = 6 },
            new Activity { Name = "A4", Start = 5, End = 7 },
            new Activity { Name = "A5", Start = 8, End = 9 },
            new Activity { Name = "A6", Start = 5, End = 9 }
        };

        activities = activities.OrderBy(x => x.End).ToList();

        int lastEndTime = -1;

        foreach (Activity activity in activities)
        {
            if (activity.Start >= lastEndTime)
            {
                Console.WriteLine(activity.Name);
                lastEndTime = activity.End;
            }
        }
    }
}
```

## Coin Change Basic Example
Suppose coins are:
```text
10, 5, 2, 1
```
Amount:
```text
18
```

Greedy choice:
```text
10 + 5 + 2 + 1 = 18
```

## C# Code
```csharp
using System;

class Program
{
    static void Main()
    {
        int amount = 18;
        int[] coins = { 10, 5, 2, 1 };

        foreach (int coin in coins)
        {
            while (amount >= coin)
            {
                Console.Write(coin + " ");
                amount = amount - coin;
            }
        }
    }
}
```

Output:
```text
10 5 2 1
```

## Important Note
Greedy does **not** give the correct answer for every problem.
It works only when the problem has a valid greedy property.

## Time Complexity
It depends on the problem.
For Activity Selection, sorting usually takes:
- Time Complexity: **O(n log n)**

## Practice
1. Select maximum non-overlapping activities.
2. Solve coin change using greedy.
3. Find minimum number of notes for an amount.
4. Find maximum value by repeatedly choosing the largest available value.
