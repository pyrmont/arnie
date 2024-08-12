(import ./deps/spork/path)
(import ./deps/medea/encode)


(def path path/join)
(def to-json encode/encode)


(def is-win (or (= :windows (os/which)) (= :mingw (os/which))))
(def is-mac (= :macos (os/which)))
(def lib-root (path/dirname (path/abspath (dyn :current-file))))
(def data-root (if-let [home (os/getenv (if is-win "USERPROFILE" "HOME"))]
                 (path/join home ".arnie")
                 lib-root))


(defn devnull
  "Gets the /dev/null equivalent of the current platform as an open file"
  []
  (os/open (if (= :windows (os/which)) "NUL" "/dev/null") :rw))


(defn mkdirp
  "Makes a directory tree, creating intermediate directories if necessary"
  [path]
  (def pwd (os/cwd))
  (each dir (path/parts path)
    (if (= "" dir) # the empty string means root
      (os/cd "/")
      (do
        (os/mkdir dir)
        (os/cd dir))))
  (os/cd pwd))


(defn- rm
  "Remove a directory and all sub directories."
  [path]
  (case (os/lstat path :mode)
    nil
    nil

    :directory
    (do
      (each subpath (os/dir path)
        (rm (path/join path subpath)))
      (os/rmdir path))

    (os/rm path)))


(defn rmrf
  "Hard deletes a directory tree"
  [path]
  (if is-win
    (when (os/stat path :mode) # windows get rid of read-only files
      (os/shell (string `rmdir /S /Q "` path `"`)))
    (rm path)))
