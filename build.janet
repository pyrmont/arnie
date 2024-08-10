(import ./util)
(import ./deps/spork/cc)


(def- build-parent (util/path util/data-root "build"))
(def- build-dir (util/path build-parent janet/build))


# Check if directory exists
(def- stat (os/stat build-dir))
(unless (nil? stat)
  (if (= :directory (get stat :mode))
    (os/exit 0)
    (error (string "file exists with path " build-dir))))


(setdyn :visit cc/visit-execute)
# (setdyn :visit cc/visit-generate-makefile)
(setdyn :build-dir build-dir)


# Specify libraries to build
(def- libs
  [{:name "arraymod" :source ["deps/arraymod/arraymod.c"]}

   {:name "big" :source ["deps/janet-big/big.c"
                         "deps/janet-big/cutils.c"
                         "deps/janet-big/libbf.c"]}])


# Compile libraries
(util/mkdirp build-dir)
(each lib libs
  (def to (util/path build-dir (string (get lib :name) ".so")))
  (cc/compile-and-link-shared to ;(get lib :source)))
