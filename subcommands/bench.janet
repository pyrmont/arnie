(import ../lib/util)


(def- benchmarks-dir (util/path util/lib-root ".." "benchmarks"))
(def- install-parent (util/path util/data-root "installs"))
(def- build-script (util/path util/lib-root "build.janet"))


(defn- get-exes []
  (def ret @[])
  (each child (os/dir install-parent)
    (when (string/has-prefix? "janet_" child)
      (array/push ret (util/path install-parent child))))
  ret)


(defn- prepare [exes]
  (def [r w] (os/pipe))
  (each exe exes
    (when (one? (os/execute [exe build-script] :p {:out w :err w}))
      (ev/close w)
      (eprin (ev/read r :all))
      (os/exit 1)))
  (ev/close w))


(defn- get-benchmarks [path]
  (defn get-children [path &opt pred]
    (->> (os/dir path)
         (map (fn [basename] (util/path path basename)))
         (filter pred)))
  (defn dir? [path] (= :directory (os/stat path :mode)))
  (defn janet-file? [path] (and (= :file (os/stat path :mode))
                                (string/has-suffix? ".janet" path)))
  (def benchmarks @[])
  (each dir (get-children path dir?)
    (array/concat benchmarks (get-children dir janet-file?)))
  benchmarks)


(defn- bench
  [benchmarks exes runs]
  (def ret @{})
  (def devnull (util/devnull))
  (defer (:close devnull)
    (each exe exes
      (def [r w] (os/pipe))
      (os/execute [exe "-e" "(print janet/version `-` janet/build)"]
                  :px {:out w :err devnull})
      (ev/close w)
      (def name (string "Janet " (string/slice (ev/read r :all) 0 -2)))
      (each benchmark benchmarks
        (def times @[])
        (put-in ret [name benchmark] times)
        (loop [i :in (range 1 (inc runs))]
          (try
            (do
              (def start (os/clock))
              (os/execute [exe benchmark] :px {:out devnull :err devnull})
              (def end (os/clock))
              (array/push times (tuple/brackets i start end)))
            ([e f]
             (eprint "Binary '" name "' running benchmark '" benchmark "' raised an error")
             (os/exit 1)))))))
  ret)


(defn- tabulate
  [times-by-bin]
  (def times-by-mark
    (do
      (def ret @{})
      (each [bin marks] (pairs times-by-bin)
        (each [mark times] (pairs marks)
          (put-in ret [mark bin] times)))
      ret))
  (var first? true)
  (each [mark results] (pairs times-by-mark)
    (if first?
      (set first? false)
      (print ""))
    (prin "# Benchmark: ")
    (print mark)
    (each [bin times] (pairs results)
      (prin bin)
      (prin "    ")
      (var total 0)
      (var runs 0)
      (each [run start end] times
        (++ runs)
        (+= total (- end start)))
      (prin "Avg: ")
      (print (/ total runs)))))


(defn- show
  [times format]
  (case format
    "jdn"
    (printf "%j" times)

    "json"
    (print (util/to-json times))

    "plain"
    (tabulate times)))


(defn- subcommand [args]
  (def sub-args (get args :sub))
  (def exes (or (get-in sub-args [:params :path])
                (get-exes)))
  (def config-path (get sub-args "config"))
  # TODO allow configuration
  (def bench-config (when config-path
                      (eprint "Configs are not currently supported")
                      (os/exit 1)))
  (def format (get-in sub-args [:opts "format"]))
  (def runs (scan-number (get-in sub-args [:opts "num"])))
  (def benchmarks (or (get-in sub-args [:opts "run"])
                      (get-benchmarks benchmarks-dir)))
  # Prepare native code
  (prepare exes)
  # Run benchmarks
  (def times (bench benchmarks exes runs))
  # (def times
  #   @{"bin/janet_872b39c" @{"benchmarks/knucleotide/knucleotide2.janet" @[[1 1721702223.3480251 1721702223.4969079]] "benchmarks/regex-redux/regexredux2.janet" @[[1 1721702223.0794711 1721702223.0936899]] "benchmarks/nbody/nbody2.janet" @[[1 1721702223.0937009 1721702223.1233621]] "benchmarks/fannkuch/fannkuch4-parallel.janet" @[[1 1721702223.496944 1721702224.436059]] "benchmarks/fannkuch/fannkuch1.janet" @[[1 1721702227.8424881 1721702234.095679]] "benchmarks/fannkuch/fannkuch2.janet" @[[1 1721702242.1945441 1721702247.0684099]] "benchmarks/fannkuch/fannkuch3.janet" @[[1 1721702238.621717 1721702239.993576]] "benchmarks/fannkuch/fannkuch2b.janet" @[[1 1721702224.4360759 1721702224.4851761]] "benchmarks/fannkuch/fannkuch5.janet" @[[1 1721702239.9935949 1721702242.1945331]] "benchmarks/fannkuch/fannkuch2-in.janet" @[[1 1721702234.095696 1721702238.6217]] "benchmarks/regex-redux/regexredux.janet" @[[1 1721702223.0371201 1721702223.0794649]] "benchmarks/fannkuch/fannkuch4.janet" @[[1 1721702247.0684249 1721702250.636102]] "benchmarks/reverse-complement/revcomp2_113.janet" @[[1 1721702250.729691 1721702250.7344601]] "benchmarks/binarytrees/binarytrees1.janet" @[[1 1721702223.013068 1721702223.037117]] "benchmarks/reverse-complement/revcomp2.janet" @[[1 1721702250.682656 1721702250.705538]] "benchmarks/knucleotide/knucleotide.janet" @[[1 1721702223.175225 1721702223.3480101]] "benchmarks/nbody/nbody.janet" @[[1 1721702223.123369 1721702223.17522]] "benchmarks/reverse-complement/counts.janet" @[[1 1721702250.6361151 1721702250.6826501]] "benchmarks/reverse-complement/revcomp.janet" @[[1 1721702250.7055421 1721702250.7296879]] "benchmarks/pidigits/pidigits.janet" @[[1 1721702250.734463 1721702250.7727201]] "benchmarks/fannkuch/fannkuch4-bakpakin.janet" @[[1 1721702224.4851799 1721702227.8424709]]}})
  # Output results
  (show times format))


(def config
  {:info {:about `Runs the benchmarks

                 Arnie will run benchmarks across multiple versions of the
                 janet executable. The user can pass paths to multiple
                 executables and Arnie will use each to run the benchmarks.

                 If bench is run with no paths, Arnie will run the benchmarks
                 against all janet executables in the 'installs' directory.`}
   :rules [:path {:splat? true
                  :help "A path to a Janet executable."}
            "--config" {:kind  :single
                        :short "c"
                        :proxy "file"
                        :help  "A path to a JDN configuration file."}
            "--format" {:kind    :single
                        :short   "f"
                        :default "plain"
                        :help    `One of 'jdn', 'json' or 'plain' as the data
                                  format to use for printing the results to
                                  stdout.`}
            "--num" {:kind     :single
                     :short   "n"
                     :proxy   "count"
                     :default "1"
                     :help    "The number of runs to perform of each benchmark."}
            "--run" {:kind  :multi
                     :short "r"
                     :proxy "file"
                     :help  `A Janet script to run instead of the full suite.
                            The option can be used multiple times to run more
                            than one file.`}
            "-----------------------------------------------------"]
   :help "Runs the benchmarks using multiple versions of Janet."
   :fn   subcommand})
