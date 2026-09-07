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

---

# Prime Number म्हणजे काय? (मराठीत)

भाऊ, अगदी सोप्या भाषेत:

**Prime Number म्हणजे असा number ज्याला फक्त 2 factors असतात:**
1. `1`
2. तो number स्वतः

उदाहरण:

`7` चे factors:
- `1`
- `7`

म्हणून `7` हा Prime Number आहे.

पण `8` चे factors:
- `1`
- `2`
- `4`
- `8`

म्हणून `8` हा Prime Number नाही.

> लक्षात ठेव: `1` हा Prime Number नाही.

---

## Logic समजून घेऊ

आपण number ला `2` पासून `number - 1` पर्यंत divide करून पाहतो.

जर कुठल्याही number ने पूर्ण divide झाला, म्हणजे remainder `0` आला, तर तो Prime नाही.

उदा. `8`:

```text
8 % 2 = 0
```

`0` remainder आला म्हणजे `8` हा `2` ने पूर्ण divide होतो.
त्यामुळे लगेच समजते की `8` Prime नाही.

पण `7` साठी:

```text
7 % 2 = 1
7 % 3 = 1
7 % 4 = 3
7 % 5 = 2
7 % 6 = 1
```

कुठेही remainder `0` आला नाही, त्यामुळे `7` Prime आहे.

---

## `%` Operator म्हणजे काय?

`%` ला Modulus Operator म्हणतात.
तो division केल्यानंतरचा **remainder** देतो.

Examples:

```text
10 % 2 = 0
10 % 3 = 1
7 % 2 = 1
15 % 5 = 0
```

Rule:

```text
number % i == 0
```

याचा अर्थ:

> `number` हा `i` ने पूर्ण divide होतो.

---

## `bool isPrime = true;` का घेतो?

आपण सुरुवातीला assume करतो की number Prime आहे.

```csharp
bool isPrime = true;
```

नंतर loop मध्ये जर number divide झाला तर:

```csharp
isPrime = false;
```

म्हणजे आपल्याला कळले की number Prime नाही.

---

## `break` का वापरतो?

जर एकदा factor सापडला तर पुढे loop चालवायची गरज नाही.

उदा. `8` ला `2` ने पूर्ण divide होते.

मग `3`, `4`, `5` check करण्याचा उपयोग नाही.

म्हणून:

```csharp
break;
```

loop लगेच बंद करतो.

---

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

---

# 5 Step-by-Step Examples

## Example 1: Number = 7

Start:

```text
number = 7
isPrime = true
```

Loop:

```text
i = 2 -> 7 % 2 = 1
No divide

i = 3 -> 7 % 3 = 1
No divide

i = 4 -> 7 % 4 = 3
No divide

i = 5 -> 7 % 5 = 2
No divide

i = 6 -> 7 % 6 = 1
No divide
```

`isPrime` अजूनही `true` आहे.

Result:

```text
7 is Prime
```

---

## Example 2: Number = 8

Start:

```text
number = 8
isPrime = true
```

First iteration:

```text
i = 2
8 % 2 = 0
```

Remainder `0` आला.

म्हणून:

```text
isPrime = false
break
```

Result:

```text
8 is Not Prime
```

---

## Example 3: Number = 11

```text
11 % 2 = 1
11 % 3 = 2
11 % 4 = 3
11 % 5 = 1
11 % 6 = 5
11 % 7 = 4
11 % 8 = 3
11 % 9 = 2
11 % 10 = 1
```

कुठेही remainder `0` नाही.

Result:

```text
11 is Prime
```

---

## Example 4: Number = 15

```text
15 % 2 = 1
15 % 3 = 0
```

`15` हा `3` ने पूर्ण divide झाला.

म्हणून:

```text
isPrime = false
break
```

Result:

```text
15 is Not Prime
```

15 चे factors:

```text
1, 3, 5, 15
```

दोनपेक्षा जास्त factors आहेत.

---

## Example 5: Number = 1

Code मध्ये:

```csharp
if (number <= 1)
{
    isPrime = false;
}
```

कारण `1` ला फक्त एक factor आहे:

```text
1
```

Prime Number ला exactly 2 factors पाहिजेत.

Result:

```text
1 is Not Prime
```

---

# Loop Dry Run Table for 9

`number = 9`

| i | Calculation | Remainder | Meaning |
|---|---|---:|---|
| 2 | `9 % 2` | 1 | divide होत नाही |
| 3 | `9 % 3` | 0 | पूर्ण divide होते |

`i = 3` ला factor सापडला.

म्हणून:

```csharp
isPrime = false;
break;
```

Result:

```text
9 is Not Prime
```

---

## Important Thinking Pattern

Prime Number check करताना स्वतःला हा प्रश्न विचार:

> `2` पासून सुरुवात करून असा कोणता number आहे का ज्याने माझा number पूर्ण divide होतो?

- जर **हो** -> Not Prime
- जर **नाही** -> Prime

---

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

### हे optimization नंतर लक्षात ठेव

Beginner म्हणून आधी हा loop नीट समजून घे:

```csharp
for (int i = 2; i < number; i++)
```

तो पूर्ण समजल्यानंतर `i * i <= number` optimization शिकणे सोपे जाईल.

---

## Complexity
- Beginner approach: `O(n)`
- Optimized approach: `O(sqrt(n))`
- Space: `O(1)`

---

## Practice
स्वतः dry run करून बघ:

1. Check `2`
2. Check `5`
3. Check `10`
4. Check `13`
5. Check `21`
6. Print all prime numbers from `1` to `50`

### Hint
प्रत्येक example साठी table बनव:

```text
number = ?
i = ?
number % i = ?
isPrime = ?
```

यामुळे logic पटकन clear होईल.
