(def- sep (if (= :windows (os/which)) "\\" "/"))


(defn- echo
  "Grabs the output of a CLI command"
  [& args]
  (def [r w] (os/pipe))
  (os/execute args :px {:out w})
  (ev/close w)
  (string/slice (ev/read r :all) 0 -2))


(defn- git
  "Runs the `git` CLI utility"
  [& args]
  (os/execute ["git" ;args] :px))


(defn- make
  "Runs the `make` CLI utility"
  [& args]
  (os/execute ["make" ;args] :px))


(defn- mkdirp
  "Makes a directory tree, creating intermediate directories if necessary"
  [path]
  (def pwd (os/cwd))
  (each dir (string/split sep path)
    (os/mkdir dir)
    (os/cd dir))
  (os/cd pwd))


(defn- rm
  "Remove a directory and all sub directories."
  [path]
  (case (os/lstat path :mode)
    :directory
    (do
      (each subpath (os/dir path)
        (rm (string path "/" subpath)))
      (os/rmdir path))

    nil
    nil

    (os/rm path)))


(defn- rmrf
  "Hard deletes a directory tree"
  [path]
  (def sys (os/which))
  (if (or (= sys :windows) (= sys :mingw))
    (when (os/stat path :mode) # windows get rid of read-only files
      (os/shell (string `rmdir /S /Q "` path `"`)))
    (rm path)))


(defn- download
  [url tag save-dir]
  (when (os/stat save-dir)
    (rmrf save-dir))
  (mkdirp save-dir)
  (git "-c" "init.defaultBranch=master" "-C" save-dir "init")
  (git "-C" save-dir "remote" "add" "origin" url)
  (git "-C" save-dir "fetch" "--depth" "1" "origin" (or tag "HEAD"))
  (git "-C" save-dir "reset" "--hard" "FETCH_HEAD"))


(defn- move
  [tag from to]
  (def id (echo "git" "-C" from "rev-parse" "--short" "HEAD"))
  (def filename (string "janet_" id (when (or (= :windows (os/which))
                                              (= :mingw (os/which)))
                                      ".exe")))
  (os/rename (string/join [from "build" "janet"] sep)
             (string/join [to filename] sep)))


(defn- build
  [tag save-dir]
  (make "-C" save-dir)
  (move tag save-dir "bin"))


(defn- subcommand [args]
  (def sub-args (get args :sub))
  (def repo (get-in sub-args [:params :repo]))
  (def [url tag] (if (string/has-prefix? "http" repo)
                   (string/split "#" repo)
                   ["https://github.com/janet-lang/janet" repo]))
  (def save-dir (string/join ["tmp" (gensym)] sep))
  (defer (rmrf "tmp")
    (download url tag save-dir)
    (build tag save-dir)))


(def config
  {:info {:about `Makes Janet from a Git repository

                 Arnie can download and compile Janet from a Git repository.
                 Repositories are downloaded to a temporary directory before
                 Arnie then builds using make and moves the resulting Janet
                 binary to 'bin'.`}
   :rules [:repo {:req? true
                  :help `URL to the repository. If the value does not begin with
                        'http', treats this as a tag of the official repository.`}]
   :help "Makes Janet from a Git repository."
   :fn   subcommand})
