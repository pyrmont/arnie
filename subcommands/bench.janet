(def- sep (if (= :windows (os/which)) "\\" "/"))
(def- benchmarks-dir "benchmarks")


(defn- get-benchmarks [path]
  (defn get-children [path &opt pred]
    (->> (os/dir path)
         (map (fn [basename] (string path sep basename)))
         (filter pred)))
  (defn dir? [path] (= :directory (os/stat path :mode)))
  (defn janet-file? [path] (and (= :file (os/stat path :mode))
                                (string/has-suffix? ".janet" path)))
  (def benchmarks @[])
  (each dir (get-children path dir?)
    (array/concat benchmarks (get-children dir janet-file?)))
  benchmarks)


(defn- subcommand [args]
  (def all-times @{})
  (def sub-args (get args :sub))
  (def bins (get-in sub-args [:params :path]))
  (def config-path (get sub-args "config"))
  # TODO allow configuration
  (def bench-config (when config-path
                      (parse (slurp config-path))))
  (def n (scan-number (get-in sub-args [:opts "times"])))
  (def benchmarks (get-benchmarks benchmarks-dir))
  (each bin bins
    (def devnull (file/open "/dev/null" :w))
    (defer (:close devnull)
      (each benchmark benchmarks
        (def times @[])
        (put-in all-times [bin benchmark] times)
        (loop [i :in (range n)]
          (try
            (do
              (def start (os/clock))
              (os/execute [bin benchmark] :px {:out devnull :err devnull})
              (def end (os/clock))
              (array/push times [i start end]))
            ([e f]
             (eprint "Binary '" bin "' running benchmark '" benchmark "' raised an error")
             (os/exit 1)))))))
  (pp all-times))


(def config
  {:info {:about `Runs the benchmarks

                 Arnie will run benchmarks across multiple versions of the
                 janet binary. The user can pass multiple paths to the binary
                 and arnie will use each to run the benchmarks.`}
   :rules [:path {:req? true
                  :splat? true
                  :help "A path to a Janet binary."}
            "--config" {:kind  :single
                        :short "c"
                        :proxy "file"
                        :help  "A path to a JDN configuration file."}
            "--times" {:kind    :single
                       :short   "t"
                       :default "1"
                       :help    "The number of times to run each benchmark."}
            "-----------------------------------------------------"]
   :help "Runs the benchmarks using multiple version of Janet."
   :fn   subcommand})
