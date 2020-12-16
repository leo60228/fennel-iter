; vim:set ft=lisp:
(local test {})

(fn eq-fn []
  "Returns recursive equality function.

This function is able to compare tables of any depth, even if one of
the tables uses tables as keys."
  `(fn eq# [left# right#]
     (if (= left# right#)
         true
         (and (= (type left#) :table) (= (type right#) :table))
         (let [oldmeta# (getmetatable right#)]
           ;; In case if we'll get something like
           ;; (eq {[1 2 3] {:a [1 2 3]}} {[1 2 3] {:a [1 2 3]}})
           ;; we have to do even deeper search
           (setmetatable right# {:__index (fn [tbl# key#]
                                        (var res# nil)
                                        (each [k# v# (pairs tbl#)]
                                          (when (eq# k# key#)
                                            (set res# v#)
                                            (lua :break)))
                                        res#)})
           (var [res# count-a# count-b#] [true 0 0])
           (each [k# v# (pairs left#)]
             (set res# (eq# v# (. right# k#)))
             (set count-a# (+ count-a# 1))
             (when (not res#) (lua :break)))
           (when res#
             (each [_# _# (pairs right#)]
               (set count-b# (+ count-b# 1)))
             (set res# (= count-a# count-b#)))
           (setmetatable right# oldmeta#)
           res#)
         false)))

(fn test.assert-eq
  [expr1 expr2 msg]
  "Like `assert`, except compares results of two expressions on equality.
Generates formatted message if `msg` is not set to other message.

# Example
Compare two expressions:

``` fennel
>> (assert-eq 1 (+1 1))
runtime error: equality assertion failed
  Left: 1
  Right: 3
```

Deep compare values:

``` fennel
>> (assert-eq [1 {[2 3] [4 5 6]}] [1 {[2 3] [4 5]}])
runtime error: equality assertion failed
  Left: [1 {
    [2 3] [4 5 6]
  }]
  Right: [1 {
    [2 3] [4 5]
  }]
```"
  `(let [left# ,expr1
         right# ,expr2
         (res# view#) (pcall require :fennelview)
         eq# ,(eq-fn)
         tostr# (if res# view# tostring)]
     (assert (eq# left# right#)
             (or ,msg (.. "equality assertion failed
  Left: " (tostr# left#) "
  Right: " (tostr# right#) "\n")))))

(fn test.assert-ne
  [expr1 expr2 msg]
  "Assert for unequality.  Same as [`assert-eq`](#assert-eq)."
  `(let [left# ,expr1
         right# ,expr2
         (res# view#) (pcall require :fennelview)
         eq# ,(eq-fn)
         tostr# (if res# view# tostring)]
     (assert (not (eq# left# right#))
             (or ,msg (.. "unequality assertion failed
  Left: " (tostr# left#) "
  Right: " (tostr# right#) "\n")))))

(fn test.assert-is
  [expr msg]
  "Assert for truth. Same as inbuilt `assert`, except generates more
  verbose message if `msg` is not set.

``` fennel
>> (assert-is (= 1 2 3))
runtime error: assertion failed for (= 1 2 3)
```"
  `(assert ,expr (.. "assertion failed for "
                     (or ,msg ,(tostring expr)))))
(fn test.assert-not
  [expr msg]
  "Assert for not truth. Works the same as [`assert-is`](#assert-is)."
  `(assert (not ,expr) (.. "assertion failed for "
                           (or ,msg ,(tostring expr)))))

(fn test.deftest
  [name ...]
  "Simple way of grouping tests."
  `(do ,...))

(fn test.testing
  [description ...]
  "Print test description and run it."
  `(do (io.stderr:write (.. "testing: " ,description "\n"))
       ,...))

(doto test
  (tset :_DOC_ORDER #[:deftest :testing
                      :assert-eq :assert-ne
                      :assert-is :assert-not]))
