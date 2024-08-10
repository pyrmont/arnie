# The native module has to be compiled for the version of Janet we're using so
# making sure we import the correct version of that is a bit involved
(def is-win (or (= :windows (os/which)) (= :mingw (os/which))))
(def sep (if is-win "\\" "/"))
(def data-root (if-let [home (os/getenv (if is-win "USERPROFILE" "HOME"))]
                 (string "@" home sep ".arnie")
                 (string ".." sep "..")))
(def dep-path (string/join [data-root "build" janet/build "big"] sep))
(import* dep-path)

(var acc (big/int 0))
(var den (big/int 1))
(var num (big/int 1))

# Simple implementation.  But division in libbf (janet-big)
# is slow for large num and den where denominator is just sligtly
# smaller than numerator.  Which is always the case here, so use the
# implementation below it instead.
#(defn extract-digit [n]
#  (/ (+ acc (* num n)) den))

(defn extract-digit [n]
  (var tmp1 (+ acc (* num n)))
  (var d 0)
  (while (>= tmp1 den)
    (++ d)
    (-= tmp1 den))
  d)

(defn eliminate-digit [d]
  (-= acc (* den d))
  (*= acc 10)
  (*= num 10))

(defn next-term [k]
  (def k2 (+ 1 (* k 2)))
  (+= acc (* num 2))
  (*= acc k2)
  (*= den k2)
  (*= num k))

(defn pidigits [n]
  (var i 0)
  (var k 0)
  (while (< i n)
    (++ k)
    (next-term k)
    (when (<= num acc)
      (def d (extract-digit 3))
      (def e (extract-digit 4))
      (when (= d e)
        (prin d)
        (++ i)
        (when (= (% i 10) 0)
          (printf "\t: %d" i))
        (eliminate-digit d)
        ))))


(defn main [& args]
  (def n (scan-number (get args 1 "30")))
  (pidigits n))

