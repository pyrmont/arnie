(import ./deps/argy-bargy/argy-bargy :as argy)


# Subcommands
(import ./subcommands/bench :as cmd/bench)
(import ./subcommands/clean :as cmd/clean)
(import ./subcommands/make :as cmd/make)


(def- subcommands
  ```
  Subcommands for the arnie tool.
  ```
  ["bench" cmd/bench/config
   "clean" cmd/clean/config
   "make" cmd/make/config])


(def- config
  ```
  Top-level information about the arnie tool.
  ```
  {:info {:about "A benchmarking tool for Janet executables."}
   :subs subcommands})


(defn- get-subconfig
  ```
  Gets the subconfig
  ```
  [config args]
  (var res config)
  (var sub args)
  (while (set sub (get sub :sub))
    (def subconfigs (res :subs))
    (def i (find-index (fn [x] (= (sub :cmd) x)) subconfigs))
    (set res (get subconfigs (inc i))))
  (unless (= config res)
    res))


(defn run
  []
  (def args (argy/parse-args "arnie" config))
  (def err (args :err))
  (def help (args :help))
  (cond
    (not (empty? help))
    (do
      (prin help)
      (os/exit (if (get-in args [:opts "help"]) 1 0)))

    (not (empty? err))
    (do
      (eprin err)
      (os/exit 1))

    (do
      (def name (get-in args [:sub :cmd]))
      (def subconfig (get-subconfig config args))
      (if subconfig
        ((subconfig :fn) args)
        (do
          (eprint "arnie: missing subcommand\nTry 'arnie --help' for more information.")
          (os/exit 1))))))


# for testing in development
(defn- main [& args] (run))
