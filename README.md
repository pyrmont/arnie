# Arnie

Arnie is a command-line benchmarking tool for Janet.

## Features

Arnie has the following features:

- downloads and compiles the Janet version to benchmark
  - supports URLs to Git repositories
  - supports tags used by the official GitHub repository
- benchmarks against an extensive test suite
  - supports benchmarking multiple Janet executables
  - supports user-defined benchmarks
  - supports printing results as JDN, JSON or plain text

## Download

Download the repository:

```shell
$ git clone https://github.com/pyrmont/arnie
$ cd arnie
$ ./arnie --help
```

## Usage

Arnie can be used like this:

```shell
$ ./arnie make v1.35.0
$ ./arnie make v1.32.0
$ ./arnie bench
# Benchmark: benchmarks/knucleotide/knucleotide2.janet
Binary: ./installs/janet_0d9e999    Avg: 0.177464962005615
Binary: ./installs/janet_b5996f5    Avg: 0.145122051239014

# Benchmark: benchmarks/regex-redux/regexredux2.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0148491859436035
Binary: ./installs/janet_b5996f5    Avg: 0.00767302513122559

# Benchmark: benchmarks/nbody/nbody2.janet
Binary: ./installs/janet_0d9e999    Avg: 0.050076961517334
Binary: ./installs/janet_b5996f5    Avg: 0.0332450866699219

# Benchmark: benchmarks/fannkuch/fannkuch4-parallel.janet
Binary: ./installs/janet_0d9e999    Avg: 0.940793037414551
Binary: ./installs/janet_b5996f5    Avg: 1.01315712928772

# Benchmark: benchmarks/fannkuch/fannkuch1.janet
Binary: ./installs/janet_0d9e999    Avg: 6.44058799743652
Binary: ./installs/janet_b5996f5    Avg: 6.2940239906311

# Benchmark: benchmarks/fannkuch/fannkuch2.janet
Binary: ./installs/janet_0d9e999    Avg: 5.04867696762085
Binary: ./installs/janet_b5996f5    Avg: 5.03374409675598

# Benchmark: benchmarks/fannkuch/fannkuch3.janet
Binary: ./installs/janet_0d9e999    Avg: 1.42126893997192
Binary: ./installs/janet_b5996f5    Avg: 1.34642910957336

# Benchmark: benchmarks/fannkuch/fannkuch2b.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0256819725036621
Binary: ./installs/janet_b5996f5    Avg: 0.0316779613494873

# Benchmark: benchmarks/fannkuch/fannkuch5.janet
Binary: ./installs/janet_0d9e999    Avg: 2.48296499252319
Binary: ./installs/janet_b5996f5    Avg: 2.64009308815002

# Benchmark: benchmarks/fannkuch/fannkuch2-in.janet
Binary: ./installs/janet_0d9e999    Avg: 4.60360503196716
Binary: ./installs/janet_b5996f5    Avg: 4.45298409461975

# Benchmark: benchmarks/regex-redux/regexredux.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0459721088409424
Binary: ./installs/janet_b5996f5    Avg: 0.0564069747924805

# Benchmark: benchmarks/fannkuch/fannkuch4.janet
Binary: ./installs/janet_0d9e999    Avg: 3.67635917663574
Binary: ./installs/janet_b5996f5    Avg: 3.76855492591858

# Benchmark: benchmarks/reverse-complement/revcomp2_113.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0160830020904541
Binary: ./installs/janet_b5996f5    Avg: 0.0293169021606445

# Benchmark: benchmarks/binarytrees/binarytrees1.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0687720775604248
Binary: ./installs/janet_b5996f5    Avg: 0.0186178684234619

# Benchmark: benchmarks/reverse-complement/revcomp2.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0376360416412354
Binary: ./installs/janet_b5996f5    Avg: 0.0157310962677002

# Benchmark: benchmarks/knucleotide/knucleotide.janet
Binary: ./installs/janet_0d9e999    Avg: 0.220686912536621
Binary: ./installs/janet_b5996f5    Avg: 0.192162990570068

# Benchmark: benchmarks/nbody/nbody.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0813360214233398
Binary: ./installs/janet_b5996f5    Avg: 0.0696351528167725

# Benchmark: benchmarks/reverse-complement/counts.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0654737949371338
Binary: ./installs/janet_b5996f5    Avg: 0.0292580127716064

# Benchmark: benchmarks/reverse-complement/revcomp.janet
Binary: ./installs/janet_0d9e999    Avg: 0.0161888599395752
Binary: ./installs/janet_b5996f5    Avg: 0.0384879112243652

# Benchmark: benchmarks/pidigits/pidigits.janet
Binary: ./installs/janet_0d9e999    Avg: 0.265177011489868
Binary: ./installs/janet_b5996f5    Avg: 0.220757007598877

# Benchmark: benchmarks/fannkuch/fannkuch4-bakpakin.janet
Binary: ./installs/janet_0d9e999    Avg: 3.23902702331543
Binary: ./installs/janet_b5996f5    Avg: 3.32378482818604
```

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/arnie/issues

## Licence

Arnie is licensed under the MIT Licence. See [LICENSE][] for more details. It
includes code from [janet-benchmarksgame][] and [janet-big][].

[LICENSE]: https://github.com/pyrmont/arnie/blob/master/LICENSE
[janet-benchmarksgame]: https://github.com/MikeBeller/janet-benchmarksgame
[janet-big]: https://github.com/andrewchambers/janet-big
