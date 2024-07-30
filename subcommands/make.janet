(def- is-win (or (= :windows (os/which)) (= :mingw (os/which))))
(def- sep (if is-win "\\" "/"))
(def- download-dir "tmp")
(def- install-parent "installs")


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
  "Runs the `make` CLI utility with the given prefix"
  [prefix & args]
  (os/execute ["make" ;args] :epx
              {"PREFIX" (string/join [(os/cwd) prefix] sep)}))


(defn- mkdirp
  "Makes a directory tree, creating intermediate directories if necessary"
  [path]
  (def pwd (os/cwd))
  (each dir (string/split sep path)
    (os/mkdir dir)
    (os/cd dir))
  (os/cd pwd))


(defn move-and-rename
  [install-dir commit-hash]
  (def old-exe (string "janet" (when is-win ".exe")))
  (def new-exe (string "janet_" commit-hash (when is-win ".exe")))
  (os/rename (string/join [install-dir "bin" old-exe] sep)
             (string/join [install-parent new-exe] sep)))


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


(defn- download
  [url save-dir &opt tag]
  (default tag "HEAD")
  (mkdirp save-dir)
  (git "-c" "init.defaultBranch=master" "-C" save-dir "init")
  (git "-C" save-dir "remote" "add" "origin" url)
  (git "-C" save-dir "fetch" "--depth" "1" "origin" tag)
  (git "-C" save-dir "reset" "--hard" "FETCH_HEAD"))


(defn- build
  [source-dir install-dir commit-hash]
  (mkdirp install-dir)
  (make install-dir "install" "-C" source-dir)
  (move-and-rename install-dir commit-hash))


(defn- subcommand [args]
  (def sub-args (get args :sub))
  (def repo (get-in sub-args [:params :repo]))
  (def [url tag] (if (string/has-prefix? "http" repo)
                   (string/split "#" repo)
                   ["https://github.com/janet-lang/janet" repo]))
  (defer (rmrf download-dir)
    (download url download-dir tag)
    (def commit-hash (echo "git" "-C" download-dir "rev-parse" "--short" "HEAD"))
    (def install-dir (string/join [install-parent commit-hash] sep))
    (build download-dir install-dir commit-hash)
    (print "Executable installed to " install-parent sep "janet_" commit-hash)))


(def config
  {:info {:about `Makes Janet from a Git repository

                 Arnie can download and compile Janet from a Git repository.
                 Repositories are downloaded to a temporary directory before
                 Arnie then builds using make and moves the resulting Janet
                 binary to 'bin'.`}
   :rules [:repo {:req? true
                  :help `URL to the repository. If the value does not begin with
                        'http', treats this as a tag of the official repository.
                        This enables 'arnie make v1.35.0'.`}]
   :help "Makes Janet from a Git repository."
   :fn   subcommand})
