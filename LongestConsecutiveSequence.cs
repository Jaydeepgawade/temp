using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        int[] nums = { 100, 4, 200, 1, 3, 2, 8, 7, 6, 5 };

        HashSet<int> numbers = new HashSet<int>(nums);

        int longestLength = 0;
        int longestStart = 0;

        foreach (int num in numbers)
        {
            // A number starts a sequence only when its previous number does not exist.
            if (!numbers.Contains(num - 1))
            {
                int currentNumber = num;
                int currentLength = 1;

                while (numbers.Contains(currentNumber + 1))
                {
                    currentNumber++;
                    currentLength++;
                }

                if (currentLength > longestLength)
                {
                    longestLength = currentLength;
                    longestStart = num;
                }
            }
        }

        Console.WriteLine("Longest Consecutive Sequence:");

        for (int i = 0; i < longestLength; i++)
        {
            Console.Write(longestStart + i);

            if (i < longestLength - 1)
            {
                Console.Write(", ");
            }
        }

        Console.WriteLine();
        Console.WriteLine($"Length = {longestLength}");
    }
}
