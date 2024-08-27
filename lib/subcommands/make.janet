(import ../util)


(def- download-dir (util/path util/data-root "tmp"))
(def- install-parent (util/path util/data-root "installs"))


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
              (merge {"PREFIX" prefix}
                     (os/environ))))


(defn move-and-rename
  [install-dir commit-hash]
  (def old-exe (string "janet" (when util/is-win ".exe")))
  (def new-exe (string "janet_" commit-hash (when util/is-win ".exe")))
  (os/rename (util/path install-dir "bin" old-exe)
             (util/path install-parent new-exe)))


(defn- download
  [url save-dir &opt tag]
  (default tag "HEAD")
  (util/mkdirp save-dir)
  (git "-c" "init.defaultBranch=master" "-C" save-dir "init")
  (git "-C" save-dir "remote" "add" "origin" url)
  (git "-C" save-dir "fetch" "--depth" "1" "origin" tag)
  (git "-C" save-dir "reset" "--hard" "FETCH_HEAD"))


(defn- build
  [source-dir install-dir commit-hash]
  (util/mkdirp install-dir)
  (make install-dir "install" "-C" source-dir)
  (move-and-rename install-dir commit-hash))


(defn- subcommand [args]
  (def sub-args (get args :sub))
  (def repo (get-in sub-args [:params :repo]))
  (def [url tag] (if (string/has-prefix? "http" repo)
                   (string/split "#" repo)
                   ["https://github.com/janet-lang/janet" repo]))
  (defer (util/rmrf download-dir)
    (download url download-dir tag)
    (def commit-hash (echo "git" "-C" download-dir "rev-parse" "--short" "HEAD"))
    (def install-dir (util/path install-parent commit-hash))
    (build download-dir install-dir commit-hash)
    (def exe (string "janet_" commit-hash (when util/is-win ".exe")))
    (print "Executable installed to " (util/path install-parent exe))))


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
