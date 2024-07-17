(declare-project
  :name "Native Modules"
  :dependencies ["https://github.com/andrewchambers/janet-big.git"])

(declare-native
  :name "arraymod"
  :source @["arraymod/arraymod.c"])

(declare-native
    :name "big"
    :cflags ["-Wall" "-O2" "-flto"]
    :source ["janet-big/big.c"
             "janet-big/libbf.c"
             "janet-big/cutils.c"])
