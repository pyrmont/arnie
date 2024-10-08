(gcsetinterval 1000000000)

# patterns from the benchmark -- we will convert to pegs
(def match-regexes [
               "agggtaaa|tttaccct"
               "[cgt]gggtaaa|tttaccc[acg]"
               "a[act]ggtaaa|tttacc[agt]t"
               "ag[act]gtaaa|tttac[agt]ct"
               "agg[act]taaa|ttta[agt]cct"
               "aggg[acg]aaa|ttt[cgt]ccct"
               "agggt[cgt]aa|tt[acg]accct"
               "agggta[cgt]a|t[acg]taccct"
               "agggtaa[cgt]|[acg]ttaccct"])

(def subst-regex-pairs [
            [ "tHa[Nt]" "<4>" ]
            [ "aND|caN|Ha[DS]|WaS" "<3>" ]
            [ "a[NSt]|BY" "<2>" ]
            [ "<[^>]*>" "|" ]
            [ "|[^|][^|]*|" "-" ]
            ])

(defn re-to-peg
  ``A very limited converter from a regex re-str to a corresponding PEG.
    Just enough to handle the cases required by this benchmark.``
  [re-str]
  (def m
    (peg/match
      ~{:p (drop (cmt ($) ,(fn [n] (print "AT: " n) n)))
        #:l (set "acgt")
        :l :a
        :letters (<- (some :l))
        :sym (set "<>|")
        :wild (* "[" (cmt :letters ,(fn [ls] (tuple 'set ls))) "]")
        :squish (cmt (* (<- :sym) "[^" 
                        (? (* (<- :sym) "]" "[^"))
                        (<- :sym :1) "]*" (backmatch :1) )
                     ,(fn [& ss]
                        (match ss
                          @[a b c] (tuple '* a (tuple 'if-not b 1) (tuple 'thru c))
                          @[a b] (tuple '* a (tuple 'thru b)))))
        :sub (+ :letters :wild :squish)
        :word (cmt (some :sub) ,(fn [& ss] (if (= 1 (length ss)) (in ss 0) (tuple '* ;ss))))
        :words (cmt (* :word (any (* "|" :word)))
                    ,(fn [& wds]
                       (if (= 1 (length wds)) (in wds 0)
                         (tuple '+ ;wds))))
        :main (+ :words :word)
        }
      re-str))
  (match m
    @[pg] pg
    (errorf "unsupported regex pattern: %s" re-str)))

#(pp (re-to-peg "<[^>]*>"))
#(pp (re-to-peg  "|[^|][^|]*|"))

(defn finder
  "Creates a peg that finds all locations of pg (a PEG) in the text."
  [pg]
  (peg/compile ~(any (+ (* ($) ,pg) 1))))

(assert (deep= @[2 5] (peg/match (finder "x") "abxcdxe")))

(defn substituter
  "Creates a peg that replaces every instance of pg with rep"
  [pg rep]
  (peg/compile ~(% (any (+ (/ (<- ,pg) ,rep) (<- 1))))))

(assert (deep= @["aabarxbarnotbar"]
               (peg/match (substituter "foo" "bar") "aafooxfoonotfoo")))

(assert
  (deep= @[4 16]
         (peg/match (finder (re-to-peg (in match-regexes 0)))
                    "gagaagggtaaagagatttaccctat")))
(assert (deep= @[2] (peg/match (finder (re-to-peg (in match-regexes 1))) "aacgggtaaa")))

(defn regexredux []
  # Read data
  (def fpath (get (dyn :args) 1 "benchmarks/regex-redux/input1000.txt"))
  (def file-contents (slurp fpath))
  (def data
    (string/join
      (seq [s :in (string/split "\n" file-contents)
            :when (not (string/has-prefix? ">" s))]
        (string/trimr s))))

  # Counting matches for each of 'match-regexes'
  (loop [regex :in match-regexes]
    (def pg (finder (re-to-peg regex)))
    (def r (peg/match pg data))
    (printf "%s %d" regex (length r)))

  # Replacing using each of a set of re,sub pairs in 'subst-regex-pairs'
  (var d data)
  (loop [[regex sub] :in subst-regex-pairs]
    (def pg (substituter (re-to-peg regex) sub))
    (def r (peg/match pg d))
    (match r
      @[s] (set d s)
      (errorf "Unexpected lack of match: %s" regex)))

  # results
  (printf "\n%d\n%d\n%d" (length file-contents) (length data) (length d)))

(regexredux)

