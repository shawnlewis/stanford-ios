(ns a2-clj.core
    (:require [seesaw.core :as ss]
              [seesaw.action :as ssa]))

;;; pure functions

(defn to-string [v]
     (with-out-str (print v)))

(defn pop-n [coll n] 
  (loop [popped []
         coll coll
         n n]
    (if (or (empty? coll) (= n 0)) 
        [popped coll]
        (recur (conj popped (peek coll)) (pop coll) (dec n)))))

(defn push-operand [stack val]
  (conj stack val))

(defn push-operator [stack op arity]
  (let [[args stack] (pop-n stack arity)]
    (if (= (count args) arity)
        (conj stack (apply op args)) 
        [])))


;;; state/UI


(def *stack* (atom []))

(def frame (ss/frame :title "Calc"))

(def result (ss/label ""))

(add-watch *stack* :_
           (fn [key ref old new]
               (ss/text! result (to-string new))))

(defn operand-button [val]
  (ssa/action :name val
              :handler (fn [_] (swap! *stack* push-operand val))))

(defn operator-button [name op arity]
  (ssa/action :name name
              :handler (fn [_] (swap! *stack* push-operator op arity))))

(ss/config! frame :content
         (ss/vertical-panel
           :items [
             result
             (ss/grid-panel
               :columns 4
               :border 10
               :items [(operand-button 9)
                       (operand-button 8)
                       (operand-button 7)
                       (operator-button "*" * 2)
                       (operand-button 6)
                       (operand-button 5)
                       (operand-button 4)
                       (operator-button "/" / 2)
                       (operand-button 3)
                       (operand-button 2)
                       (operand-button 1)
                       (operator-button "+" + 2)
                       ""
                       (operand-button 0)
                       ""
                       (operator-button "-" - 2)
                       ])]))

(ss/native!)
(-> frame ss/pack! ss/show!)
