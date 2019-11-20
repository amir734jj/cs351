---
marp: true
---
# HashTable ADT
---

## HashMap vs. Hashtable in Java:

- Both implement `Map` interface
    - Advantages: fast insertion, fast search.
    - Disadvantage: hash table has fixed size

---

## HashMap vs. Hashtable in Java (Cont.)

> 1. Hashtable is synchronized, whereas HashMap is not. This makes HashMap better for non-threaded applications, as unsynchronized Objects typically perform better than synchronized ones.

> 2. Hashtable does not allow null keys or values. HashMap allows one null key and any number of null values.

> 3. One of HashMap's subclasses is LinkedHashMap, so in the event that you'd want predictable iteration order (which is insertion order by default), you could easily swap out the HashMap for a LinkedHashMap. This wouldn't be as easy if you were using Hashtable.

[Source](https://stackoverflow.com/a/40878/1834787)

---
## ConcurrentHashMap


There is however [`ConcurrentHashMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html) which solves the concurrency issues of `HashTable`!

## Let's dive in to Java's HashTable source code ...

---

# Question

Why Java `AND`s the hashCode of the key with `0x7fffffff` before `%` with `table.length`


```java
private int hash(Key key) {
   return (key.hashCode() & 0x7fffffff) % table.length;
}
```

---

# Answer

`0x7FFFFFFF` is `0111 1111 1111 1111 1111 1111 1111 1111` : all 1 except the sign bit.

`(hash & 0x7FFFFFFF)` will result in a positive integer.

`(hash & 0x7FFFFFFF) % table.length` will be in the range of the tab length.

---

# Question

What does a `threshold` represent and why is it needed?

```java
void rehash() {
    int oldCapacity = table.length;
    Entry<?,?>[] oldMap = table;

    int newCapacity = (oldCapacity << 1) + 1;

    Entry<?,?>[] newMap = new Entry<?,?>[newCapacity];
    version++;
    threshold = (int)Math.min(newCapacity * loadFactor, MAX_ARRAY_SIZE + 1);
    table = newMap;

    // Traverse through the table and reset them using newCapacity
}
```

<!-- /**
    * Increases the capacity of and internally reorganizes this
    * hashtable, in order to accommodate and access its entries more
    * efficiently.  This method is called automatically when the
    * number of keys in the hashtable exceeds this hashtable's capacity
    * and load factor.
    */
@SuppressWarnings("unchecked")
protected void rehash() {
    int oldCapacity = table.length;
    Entry<?,?>[] oldMap = table;

    // overflow-conscious code
    int newCapacity = (oldCapacity << 1) + 1;
    if (newCapacity - MAX_ARRAY_SIZE > 0) {
        if (oldCapacity == MAX_ARRAY_SIZE)
            // Keep running with MAX_ARRAY_SIZE buckets
            return;
        newCapacity = MAX_ARRAY_SIZE;
    }
    Entry<?,?>[] newMap = new Entry<?,?>[newCapacity];

    modCount++;
    threshold = (int)Math.min(newCapacity * loadFactor, MAX_ARRAY_SIZE + 1);
    table = newMap;

    for (int i = oldCapacity ; i-- > 0 ;) {
        for (Entry<K,V> old = (Entry<K,V>)oldMap[i] ; old != null ; ) {
            Entry<K,V> e = old;
            old = old.next;

            int index = (e.hash & 0x7FFFFFFF) % newCapacity;
            e.next = (Entry<K,V>)newMap[index];
            newMap[index] = e;
        }
    }
} -->


---

# Answer

- The table is rehashed when its size exceeds this threshold
    - The value of this field is: `capacity * loadFactor`
- It's needed to prevent repeat collisions    

---

# Concrete definition of the HashTable

> HashTable is a data structure that implements an associative array abstract data type, a structure that can map keys to values. A hash table uses a hash function to compute an index, also called a hash code, into an array of buckets or slots, from which the desired value can be found.


---

# Addressing Techniques

What are the common implementations for HashTable's buckets?

- (**Chaining**) Separate chaining with linked lists $O(n)$
    - Buckets are just LinkedLists of entries
        - Look through the bucket to find an entry with matching hash
            - If any then update entry's value property
        - Otherwise, create new entry and add it to the head of LinkedList


--- 

# Addressing Techniques (Cont.)

- (**Chaining**) Separate chaining with self-balancing tree $O(log \ n)$
    - Similar to previous except using a tree hence faster lookup but more complexity

---

# Addressing Techniques (Cont.)
- (**Open addressing**) These are techniques to resolve collisions
    - Linear probing:
        - upon collision, $\text{hash}(key) + i$ where $i \in \{1 ... n\}$
        - repeat above if we there is still a collision
    - Quadratic probing:
        - upon collision, $\text{hash}(key) + i * i$ where $i \in \{1 ... n\}$
    - Double hashing: upon collision, add $i \in {0, n}$ to the hash(key) and then take modulo
        - upon collision, $\text{hash}(key) + i * \text{hash2}(key)$ where $i \in \{1 ... n\}$


---

## Linear probing

Linear probing: array of size M.
 - Hash: map key to integer $i$ between 0 and M-1.
 - Insert: put in slot $i$ if free, if not try $i+1$, $i+2$, etc.
 - Search: search slot $i$, if occupied but no match, try $i+1$, $i+2$, etc

More specifically:
- If slot $\text{hash}(x) + \% S$ is full, then we try $(\text{hash}(x) + 1) \% S$
    - If $(\text{hash}(x) + 1) + \% S$ is also full, then we try $(\text{hash}(x) + 2) \% S$
        - If $(\text{hash}(x) + 2) \% S$ is also full, then we try $(\text{hash}(x) + 3) \% S$ 

---

# Exercise

Let's implement linear probing given:
- `Entry<K, V>[] table`
- `hash(K): int`
- `key: K` and `value: V`


---
# Solution

```java
for (int i = hash(key); table[i] != null; i = (i + 1) % table.length) {
    // Update if there is already a key/value pair in the map
    if (table[i].getKey().equals(key)) {
        table[i] = new Entry<K, V>(key, value);
        return;
    }
}
// We found a free spot
table[i] = new Entry<K, V>(key, value);
```

---
# Exercise
Let's implement quadratic probing give:
- `Entry<K, V>[] table`
- `hash(K): int`
- `key: K` and `value: V`

---

# Solution

```java
for (int i = hash(key), j = 1; table[i] != null; i = (hash(key) + j * j) % table.length, j++) {
    // Update if there is already a key/value pair in the map
    if (table[i].getKey().equals(key)) {
        table[i] = new Entry<K, V>(key, value);
        return;
    }
}
// We found a free spot
table[i] = new Entry<K, V>(key, value);
```

---
# Exercise
Let's implement double hashing give:
- `Entry<K, V>[] table`
- `hash(K): int`
- `key: K` and `value: V`

---

# Solution

```java
for (int i = hash(key), j = 1; table[i] != null; i = (hash(key) + j * hash2(key)) % table.length, j++) {
    // Update if there is already a key/value pair in the map
    if (table[i].getKey().equals(key)) {
        table[i] = new Entry<K, V>(key, value);
        return;
    }
}
// We found a free spot
table[i] = new Entry<K, V>(key, value);
```

---
# Lab exercise

```
                        _   _           _   _____     _     _      
                        | | | |         | | |_   _|   | |   | |     
                        | |_| | __ _ ___| |__ | | __ _| |__ | | ___ 
                        |  _  |/ _` / __| '_ \| |/ _` | '_ \| |/ _ \
                        | | | | (_| \__ \ | | | | (_| | |_) | |  __/
                        \_| |_/\__,_|___/_| |_\_/\__,_|_.__/|_|\___|                                        
```