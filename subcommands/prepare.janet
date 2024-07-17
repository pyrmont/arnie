(def- sep (if (= :windows (os/which)) "\\" "/"))
(def- deps-dir "deps")


(defn- subcommand [args]
  (def pwd (os/realpath (os/cwd)))
  (os/cd (string/join ["deps" "native"] sep))
  (os/execute ["jpm" "build"] :px)
  (os/cd pwd))


(def config
  {:info {:about `Prepares the prerequisites to benchmarking

                 Arnie includes native dependencies that must be built before
                 benchmarking.`}
   :rules []
   :help "Prepares prerequisites to benchmarking."
   :fn   subcommand})
