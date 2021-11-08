; vim:set ft=lisp:

(require-macros "tests.test")

(local iter (require "iter"))

(deftest iterCollect
         (testing "collecting a table"
                  (assert-eq (iter.iterCollect (ipairs [ 10 20 30 ])) [ 10 20 30 ])))

(deftest map
         (testing "basic map"
                  (assert-eq (iter.iterCollect (iter.map #(* $ 2) (ipairs [ 2 3 5 ]))) [ 4 6 10 ]))
         (testing "map with filter"
                  (assert-eq (iter.iterCollect (iter.map #(if (= $ 3) nil (+ $ 5)) (ipairs [ 2 3 4 ]))) [ 7 9 ])))

(deftest filter
         (testing "basic filter"
                  (assert-eq (iter.iterCollect (iter.filter #(not= (% $ 2) 0) (ipairs [ 1 2 3 2 1 ]))) [ 1 3 1 ])))

(deftest head
         (testing "head of ipairs"
                  (assert-eq (iter.head (ipairs [ 2 3 4 ])) 2))
         (testing "head of map" (assert-eq (iter.head (iter.map #(* $ 2) (ipairs [ 5 6 ]))) 10)))

(deftest first
         (testing "basic first"
                  (assert-eq (iter.first #(= (% $ 2) 0) (ipairs [ 3 5 7 8 9 ])) 8)))

(deftest foldl
         (testing "basic foldl"
                  (assert-eq (iter.foldl (fn [a x] (+ a x)) 0 (ipairs [ 3 3 2 2 1 1 ])) 12)))

