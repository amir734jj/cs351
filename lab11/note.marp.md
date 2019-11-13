---
marp: true
---

# Map ADT

---

## Interface `Map<K,V>`

Type Parameters:
- `K` - the type of keys maintained by this map
- `V` - the type of mapped values

An object that maps keys to values. A map cannot contain duplicate keys; each key can map to at most one value.

---

## Collection Views

The Map interface provides three collection views, which allow a map's contents to be viewed as:

1. set of keys
2. collection of values
3. set of key-value mappings.

The order of a map is defined as the order in which the iterators on the map's collection views return their elements. Some map implementations, like the `TreeMap` class, make specific guarantees as to their order; others, like the `HashMap` class, do not.

---

# Concerning `Map` keys


We should be careful if mutable objects are used as map keys. The behavior of a map is not specified if the value of an object is changed in a manner that affects equals comparisons while the object is a key in the map.

---

# Concerning constructors

All general-purpose map implementation classes should provide two "standard" constructors:
- a void (no arguments) constructor which creates an empty map
- a constructor with a single argument of type Map, which creates a new map with the same key-value mappings as its argument.

The "destructive" methods contained in this interface, that is, the methods that modify the map on which they operate, are specified to throw UnsupportedOperationException if this map does not support the operation. If this is the case, these methods may, but are not required to, throw an UnsupportedOperationException if the invocation would have no effect on the map.

For example, invoking the putAll(Map) method on an unmodifiable map may, but is not required to, throw the exception if the map whose mappings are to be "superimposed" is empty.

---

# Restrictions


Some map implementations have restrictions on the keys and values they may contain. For example, some implementations prohibit null keys and values, and some have restrictions on the types of their keys. Attempting to insert an ineligible key or value throws an unchecked exception, typically NullPointerException or ClassCastException. Attempting to query the presence of an ineligible key or value may throw an exception, or it may simply return false; some implementations will exhibit the former behavior and some will exhibit the latter. More generally, attempting an operation on an ineligible key or value whose completion would not result in the insertion of an ineligible element into the map may throw an exception or it may succeed, at the option of the implementation. Such exceptions are marked as "optional" in the specification for this interface.

Many methods in Collections Framework interfaces are defined in terms of the equals method. For example, the specification for the containsKey(Object key) method says: "returns true if and only if this map contains a mapping for a key k such that (key==null ? k==null : key.equals(k))." This specification should not be construed to imply that invoking Map.containsKey with a non-null argument key will cause key.equals(k) to be invoked for any key k. Implementations are free to implement optimizations whereby the equals invocation is avoided, for example, by first comparing the hash codes of the two keys. (The Object.hashCode() specification guarantees that two objects with unequal hash codes cannot be equal.) More generally, implementations of the various Collections Framework interfaces are free to take advantage of the specified behavior of underlying Object methods wherever the implementor deems it appropriate.

Some map operations which perform recursive traversal of the map may fail with an exception for self-referential instances where the map directly or indirectly contains itself. This includes the clone(), equals(), hashCode() and toString() methods. Implementations may optionally handle the self-referential scenario, however most current implementations do not do so.

This interface is a member of the Java Collections Framework.

Since:
1.2
See Also:
HashMap, TreeMap, Hashtable, SortedMap, Collection, Set
Nested Class Summary
Nested Classes
Modifier and Type	Interface and Description
static interface 	Map.Entry<K,V>
A map entry (key-value pair).
Method Summary
All MethodsInstance MethodsAbstract MethodsDefault Methods
Modifier and Type	Method and Description
void	clear()
Removes all of the mappings from this map (optional operation).
boolean	containsKey(Object key)
Returns true if this map contains a mapping for the specified key.
boolean	containsValue(Object value)
Returns true if this map maps one or more keys to the specified value.
Set<Map.Entry<K,V>>	entrySet()
Returns a Set view of the mappings contained in this map.
boolean	equals(Object o)
Compares the specified object with this map for equality.
V	get(Object key)
Returns the value to which the specified key is mapped, or null if this map contains no mapping for the key.
int	hashCode()
Returns the hash code value for this map.
boolean	isEmpty()
Returns true if this map contains no key-value mappings.
Set<K>	keySet()
Returns a Set view of the keys contained in this map.
V	put(K key, V value)
Associates the specified value with the specified key in this map (optional operation).
void	putAll(Map<? extends K,? extends V> m)
Copies all of the mappings from the specified map to this map (optional operation).
V	remove(Object key)
Removes the mapping for a key from this map if it is present (optional operation).
int	size()
Returns the number of key-value mappings in this map.
Collection<V>	values()
Returns a Collection view of the values contained in this map.
