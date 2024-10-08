# Version with reverse-slice replaced with function table
# cuts time by 20% over the fannkuch2-in.janet version

(defn factorial [n]
  (assert (< n 19))  # overflow for Janet
  (assert (>= n 0))
  (if (< n 2) 1
    (product (range 2 (inc n)))))

(defn rotate-slice
  "Rotate left elements of array a from index i through
   (and including) index j.  Assumes i,j are valid indexes."
  [a i j]
  (def ai (in a i))
  (for k i j
    (put a k (in a (inc k))))
  (put a j ai))

(defn gen-rev-help [n]
  (def r @[])
  (for i 0 (/ n 2)
    (array/push r (tuple 'set 't (tuple 'in 'a i)))
    (array/push r (tuple 'put 'a i (tuple 'in 'a (- n i))))
    (array/push r (tuple 'put 'a (- n i) 't)))
  r)

(defmacro gen-rev [n]
       ~(fn [a]
          (var t 0)
          ,;(gen-rev-help n)))

(def rev-tab (seq [i :range [0 18]] (eval ~(gen-rev ,i))))

(let [a @[1 2]] ((in rev-tab 1) a) (assert (deep= a @[2 1])))
(let [a @[1 2 3]] ((in rev-tab 2) a) (assert (deep= a @[3 2 1])))
(let [a @[1 2 3 4 5]] ((in rev-tab 3) a) (assert (deep= a @[4 3 2 1 5])))

(defn fannkuch [n]
  (var checksum 0)
  (var sign 1)
  (var maxflips 0)
  (def cnt (array/new-filled n 0))
  (def perm (range n))

  (def idxmax (factorial n))
  (var idx 0)
  (def p (array/new-filled n 0))
  (while true
    # Count flips for this permutation
    (var nflips 0)
    #(def p (array/slice perm))
    (array/remove p 0 n)
    (array/insert p 0 ;perm)
    (while (not= (in p 0) 0)
      ((rev-tab (in p 0)) p)
      (++ nflips))
    (+= checksum (* sign nflips))
    (set sign (- sign))
    (if (> nflips maxflips)
      (set maxflips nflips))
    (when (= (++ idx) idxmax) (break))

    # Generate next permutation
    (rotate-slice perm 0 1)
    (var i 1)
    (while true
      (++ (cnt i))
      (when (<= (in cnt i) i) (break))
      (put cnt i 0)
      (++ i)
      (rotate-slice perm 0 i)))

  [checksum maxflips])

#(assert (= [228 16] (fannkuch 7)))
(def arg (scan-number (get (dyn :args) 1 "10")))
(def [checksum mf] (fannkuch arg))
(print checksum)
(printf "Pfannkuchen(%d) = %d" arg mf)

