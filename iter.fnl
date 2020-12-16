; vim:set ft=lisp:
(fn map [pred iter inv startControl]
  "Map an iterator. For example, to double each element: `(map #(* $ 2) iter)`"
  (var control startControl)
  (fn mapIter []
    (let [(newControl value) (iter inv control)]
      (set control newControl)
      (if (= value nil)
          nil
          (let [mapped (pred value)]
            (if (= mapped nil)
                (mapIter)
                (values control mapped)))))))

(fn filter [pred iter inv control]
  "Filter an iterator. For example, to only include even elements: `(filter #(= (% x 2) 0) iter)`"
  (map #(when (pred $) $) iter inv control))

(fn head [iter inv control]
  "Get the first element from an iterator."
  (let [(control value) (iter inv control)]
    value))

(fn first [pred iter inv control]
  "Get the first element matching a predicate from an iterator. For example, to get the first element other than 2: `(first #(not= $ 2) iter)`"
  (head (filter pred iter inv control)))

(fn collect [iter inv control]
  "Eagerly evaluates an iterator to convert it to a table."
  (local tbl [])
  (each [control value (values iter inv control)]
    (table.insert tbl value))
  tbl)

(fn foldl [pred state iter inv control]
  "Applies a left fold to an iterator. For example, to sum an iterator: `(foldl (fn [a x] (+ a x)) 0 iter)`"
  (let [(control value) (iter inv control)]
    (if (= value nil)
        state
        (foldl pred (pred state value) iter inv control))))

{:_DESCRIPTION "Tiny lazy iterator library for Fennel. This library defines an iterator as a function that takes a fixed argument and a state, and returns a new state and an element. This is a subset of what Fennel's `each` and Lua's `for` accept, and matches the return value of `ipairs`."
 :_LICENSE "MIT"
 :_VERSION "0.1.0"
 :collect collect
 :filter filter
 :first first
 :foldl foldl
 :head head
 :map map}
