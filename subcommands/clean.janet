(def- is-win (or (= :windows (os/which)) (= :mingw (os/which))))
(def- sep (if is-win "\\" "/"))
(def- build-parent "build")
(def- install-parent "installs")


(defn- rm
  "Remove a directory and all sub directories."
  [path]
  (case (os/lstat path :mode)
    nil
    nil

    :directory
    (do
      (each subpath (os/dir path)
        (rm (string path sep subpath)))
      (os/rmdir path))

    (os/rm path)))


(defn- rmrf
  "Hard deletes a directory tree"
  [path]
  (def sys (os/which))
  (if is-win
    (when (os/stat path :mode) # windows get rid of read-only files
      (os/shell (string `rmdir /S /Q "` path `"`)))
    (rm path)))


(defn- subcommand [args]
  (def sub-args (get args :sub))
  (def build? (get-in sub-args [:opts "build"]))
  (def installs? (get-in sub-args [:opts "installs"]))
  (def both? (and (nil? build?) (nil? installs?)))
  (def clean-build? (or build? both?))
  (def clean-installs? (or installs? both?))
  (when clean-build?
    (print "Cleaning build...")
    (each child (os/dir build-parent)
      (unless (= ".gitkeep" child)
        (def path (string build-parent sep child))
        (rmrf path))))
  (when clean-installs?
    (print "Cleaning installs...")
    (each child (os/dir install-parent)
      (unless (= ".gitkeep" child)
        (def path (string install-parent sep child))
        (rmrf path)))))


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
