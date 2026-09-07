# 10 - Graph Basics, BFS and DFS

## What is a Graph?
A Graph is a non-linear data structure made of:
- **Vertex (Node)** - an item in the graph.
- **Edge** - a connection between two vertices.

Example:

```text
A ---- B
|      |
|      |
C ---- D
```

Vertices: A, B, C, D
Edges: A-B, A-C, B-D, C-D

## Types of Graph
1. Undirected Graph
2. Directed Graph
3. Weighted Graph
4. Unweighted Graph

## Adjacency List
For beginner learning, an adjacency list is easy and memory efficient.

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        Dictionary<int, List<int>> graph = new Dictionary<int, List<int>>
        {
            { 1, new List<int> { 2, 3 } },
            { 2, new List<int> { 1, 4 } },
            { 3, new List<int> { 1, 4 } },
            { 4, new List<int> { 2, 3 } }
        };

        foreach (var node in graph)
        {
            Console.Write(node.Key + " -> ");
            foreach (int neighbour in node.Value)
            {
                Console.Write(neighbour + " ");
            }
            Console.WriteLine();
        }
    }
}
```

## BFS - Breadth First Search
BFS visits nodes level by level and normally uses a **Queue**.

### Example
```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void BFS(Dictionary<int, List<int>> graph, int start)
    {
        Queue<int> queue = new Queue<int>();
        HashSet<int> visited = new HashSet<int>();

        queue.Enqueue(start);
        visited.Add(start);

        while (queue.Count > 0)
        {
            int current = queue.Dequeue();
            Console.Write(current + " ");

            foreach (int neighbour in graph[current])
            {
                if (!visited.Contains(neighbour))
                {
                    visited.Add(neighbour);
                    queue.Enqueue(neighbour);
                }
            }
        }
    }

    static void Main()
    {
        Dictionary<int, List<int>> graph = new Dictionary<int, List<int>>
        {
            { 1, new List<int> { 2, 3 } },
            { 2, new List<int> { 1, 4 } },
            { 3, new List<int> { 1, 4 } },
            { 4, new List<int> { 2, 3 } }
        };

        BFS(graph, 1);
    }
}
```

Output:
```text
1 2 3 4
```

## DFS - Depth First Search
DFS goes as deep as possible before coming back. It is commonly implemented using **recursion** or a **Stack**.

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void DFS(Dictionary<int, List<int>> graph, int current, HashSet<int> visited)
    {
        visited.Add(current);
        Console.Write(current + " ");

        foreach (int neighbour in graph[current])
        {
            if (!visited.Contains(neighbour))
            {
                DFS(graph, neighbour, visited);
            }
        }
    }

    static void Main()
    {
        Dictionary<int, List<int>> graph = new Dictionary<int, List<int>>
        {
            { 1, new List<int> { 2, 3 } },
            { 2, new List<int> { 1, 4 } },
            { 3, new List<int> { 1, 4 } },
            { 4, new List<int> { 2, 3 } }
        };

        HashSet<int> visited = new HashSet<int>();
        DFS(graph, 1, visited);
    }
}
```

Possible output:
```text
1 2 4 3
```

## Complexity
For both BFS and DFS:
- Time Complexity: **O(V + E)**
- Space Complexity: **O(V)**

Where:
- V = number of vertices
- E = number of edges

## Practice
1. Create a graph with 5 nodes.
2. Print its adjacency list.
3. Traverse it using BFS.
4. Traverse it using DFS.
5. Find whether a particular node exists in the graph.
