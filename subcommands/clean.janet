(import ../util)


(def- build-parent (util/path util/data-root "build"))
(def- install-parent (util/path util/data-root "installs"))


(defn- subcommand [args]
  (def sub-args (get args :sub))
  (def build? (get-in sub-args [:opts "build"]))
  (def installs? (get-in sub-args [:opts "installs"]))
  (def both? (and (nil? build?) (nil? installs?)))
  (def clean-build? (or build? both?))
  (def clean-installs? (or installs? both?))
  (when (and clean-build? (= :directory (os/stat build-parent :mode)))
    (print "Cleaning build...")
    (each child (os/dir build-parent)
      (unless (= ".gitkeep" child)
        (def path (util/path build-parent child))
        (util/rmrf path))))
  (when (and clean-installs? (= :directory (os/stat install-parent :mode)))
    (print "Cleaning installs...")
    (each child (os/dir install-parent)
      (unless (= ".gitkeep" child)
        (def path (util/path install-parent child))
        (util/rmrf path)))))


(def config
  {:info {:about "Cleans the build and installs directories"}
   :rules ["--build" {:kind  :flag
                      :short "b"
                      :help  "Only clean the build directory."}
           "--installs" {:kind  :flag
                         :short "i"
                         :help  "Only clean the installs directory."}
           "-----------------------------------------------------"]
   :help "Cleans the build and installs directories."
   :fn   subcommand})
