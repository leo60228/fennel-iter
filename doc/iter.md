# Iter.fnl (0.2.0)
Tiny lazy iterator library for Fennel. This library defines an iterator as a function that takes a fixed argument and a state, and returns a new state and an element. This is a subset of what Fennel's `each` and Lua's `for` accept, and matches the return value of `ipairs`.

**Table of contents**

- [`filter`](#filter)
- [`first`](#first)
- [`foldl`](#foldl)
- [`head`](#head)
- [`iterCollect`](#iterCollect)
- [`map`](#map)

## `filter`
Function signature:

```
(filter pred iter inv control)
```

Filter an iterator. For example, to only include even elements: `(filter #(= (% x 2) 0) iter)`

## `first`
Function signature:

```
(first pred iter inv control)
```

Get the first element matching a predicate from an iterator. For example, to get the first element other than 2: `(first #(not= $ 2) iter)`

## `foldl`
Function signature:

```
(foldl pred state iter inv control)
```

Applies a left fold to an iterator. For example, to sum an iterator: `(foldl (fn [a x] (+ a x)) 0 iter)`

## `head`
Function signature:

```
(head iter inv control)
```

Get the first element from an iterator.

## `iterCollect`
Function signature:

```
(iterCollect iter inv control)
```

Eagerly evaluates an iterator to convert it to a table.

## `map`
Function signature:

```
(map pred iter inv startControl)
```

Map an iterator, skipping nil values. For example, to double each element: `(map #(* $ 2) iter)`


---

License: MIT


<!-- Generated with Fenneldoc 0.0.6
     https://gitlab.com/andreyorst/fenneldoc -->
