(declare-project
  :name "Arnie"
  :description "Run benchmarks to compare Janet binaries"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/arnie"
  :repo "git+https://github.com/pyrmont/arnie"
  :vendored [{:url "https://github.com/pyrmont/argy-bargy"
              :prefix "argy-bargy"
              :include ["argy-bargy.janet"]}
             {:url "https://github.com/andrewchambers/janet-big"
              :prefix "janet-big"
              :include ["big.c"
                        "cutils.c"
                        "cutils.h"
                        "libbf.c"
                        "libbf.h"]}
             {:url "https://github.com/pyrmont/medea"
              :include ["medea/encode.janet"]}
             {:url "https://github.com/pyrmont/spork"
              :tag "bugfix.macos-compiler"
              :include ["spork/cc.janet"
                        "spork/path.janet"
                        "spork/sh.janet"]}])


(declare-binscript
  :main "bin/arnie")


(declare-source
  :source ["benchmarks"
           "deps"
           "subcommands"
           "build.janet"
           "cli.janet"
           "util.janet"]
  :prefix "arnie")


(task "vendor" []
  (def sep (if (= :windows (os/which)) "\\" "/"))
  (def deps-dir "deps")
  (def temp-dir "tmp")
  (defn mkdirp [path]
    (def pwd (os/cwd))
    (each dir (string/split sep path)
      (os/mkdir dir)
      (os/cd dir))
    (os/cd pwd))
  (defn is-tarball? [url]
    (or (string/has-suffix? ".gz" url)
        (string/has-suffix? ".tar" url)))
  (each {:url url
         :tag tag
         :prefix prefix
         :include includes
         :exclude excludes} (get (dyn :project) :vendored)
    (if-not url
      (error "Vended dependencies need a :url key")
      (do
        (default tag "HEAD")
        (def tarball (if (is-tarball? url) url (string url "/archive/" tag ".tar.gz")))
        (def dest-dir (if prefix (string/join [deps-dir prefix] sep) deps-dir))
        (def filename (-> (string/split "/" tarball) last))
        (print "Vendoring " tarball " to " dest-dir)
        (defer (rimraf temp-dir)
          (do
            (os/mkdir temp-dir)
            (def tar-file (string/join [temp-dir filename] sep))
            (curl "-sL" tarball "-o" tar-file)
            (tar "xf" tar-file "-C" temp-dir "--strip-components" "1")
            (rimraf tar-file)
            (when excludes
              (each exclude excludes
                (rimraf (string/join [temp-dir exclude] sep))))
            (def files (if includes includes (os/dir temp-dir)))
            (each file files
              (def from (string/join [temp-dir file] sep))
              (def to (string/join [dest-dir file] sep))
              (mkdirp (dirname to))
              (copy from to))))))))
