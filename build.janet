(import ./deps/spork/cc)


(def- is-win (or (= :windows (os/which)) (= :mingw (os/which))))
(def- sep (if is-win "\\" "/"))
(def- build-parent "build")
(def- build-dir (string/join [build-parent janet/build] sep))


# Check if directory exists
(def- stat (os/stat build-dir))
(unless (nil? stat)
  (if (= :directory (get stat :mode))
    (os/exit 0)
    (error (string "file exists with path " build-dir))))


(setdyn :visit cc/visit-execute)
# (setdyn :visit cc/visit-generate-makefile)
(setdyn :build-dir build-dir)
(setdyn :smart-libs false)
(setdyn :lflags ["-undefined" "dynamic_lookup"])


# Specify libraries to build
(def- libs
  [{:name "arraymod" :source ["deps/arraymod/arraymod.c"]}

   {:name "big" :source ["deps/janet-big/big.c"
                         "deps/janet-big/cutils.c"
                         "deps/janet-big/libbf.c"]}])


# Compile libraries
(os/mkdir build-dir)
(each lib libs
  (def to (string build-dir sep (get lib :name) ".so"))
  (cc/compile-and-link-shared to ;(get lib :source)))
