# Arnie

Arnie is a command-line benchmarking tool for Janet.

## Features

Arnie has the following features:

- downloads and compiles the Janet version to benchmark
  - supports URLs to Git repositories
  - supports commit hashes and tags for GitHub repositories
- benchmarks against an extensive test suite
  - supports benchmarking multiple Janet executables
  - supports user-defined benchmarks
  - supports printing results as JDN, JSON or plain text

## Installation

Install via JPM:

```shell
$ jpm install https://github.com/pyrmont/arnie
$ arnie --help
```

## Usage

Arnie can be used like this:

```shell
$ arnie make v1.35.0
$ arnie make v1.32.0
$ arnie bench
# Benchmark: benchmarks/knucleotide/knucleotide2.janet
Janet 1.32.0-b5996f5    Avg: 0.161672115325928
Janet 1.35.0-0d9e999    Avg: 0.147693157196045

# Benchmark: benchmarks/regex-redux/regexredux2.janet
Janet 1.32.0-b5996f5    Avg: 0.00700902938842773
Janet 1.35.0-0d9e999    Avg: 0.0256609916687012

# Benchmark: benchmarks/nbody/nbody2.janet
Janet 1.32.0-b5996f5    Avg: 0.0324769020080566
Janet 1.35.0-0d9e999    Avg: 0.0349478721618652

# Benchmark: benchmarks/fannkuch/fannkuch4-parallel.janet
Janet 1.32.0-b5996f5    Avg: 0.995783090591431
Janet 1.35.0-0d9e999    Avg: 0.916385889053345

# Benchmark: benchmarks/fannkuch/fannkuch1.janet
Janet 1.32.0-b5996f5    Avg: 6.55872511863708
Janet 1.35.0-0d9e999    Avg: 6.42196393013

# Benchmark: benchmarks/fannkuch/fannkuch2.janet
Janet 1.32.0-b5996f5    Avg: 4.95723104476929
Janet 1.35.0-0d9e999    Avg: 4.99268579483032

# Benchmark: benchmarks/fannkuch/fannkuch3.janet
Janet 1.32.0-b5996f5    Avg: 1.38383603096008
Janet 1.35.0-0d9e999    Avg: 1.38260197639465

# Benchmark: benchmarks/fannkuch/fannkuch2b.janet
Janet 1.32.0-b5996f5    Avg: 0.229254961013794
Janet 1.35.0-0d9e999    Avg: 0.0403671264648438

# Benchmark: benchmarks/fannkuch/fannkuch5.janet
Janet 1.32.0-b5996f5    Avg: 2.87757301330566
Janet 1.35.0-0d9e999    Avg: 2.47903203964233

# Benchmark: benchmarks/fannkuch/fannkuch2-in.janet
Janet 1.32.0-b5996f5    Avg: 4.76161003112793
Janet 1.35.0-0d9e999    Avg: 4.70300483703613

# Benchmark: benchmarks/regex-redux/regexredux.janet
Janet 1.32.0-b5996f5    Avg: 0.0431818962097168
Janet 1.35.0-0d9e999    Avg: 0.0177791118621826

# Benchmark: benchmarks/regex-redux/regexredux2.janet
Janet 1.32.0-b5996f5    Avg: 0.00700902938842773
Janet 1.35.0-0d9e999    Avg: 0.0256609916687012

# Benchmark: benchmarks/nbody/nbody2.janet
Janet 1.32.0-b5996f5    Avg: 0.0324769020080566
Janet 1.35.0-0d9e999    Avg: 0.0349478721618652

# Benchmark: benchmarks/fannkuch/fannkuch4-parallel.janet
Janet 1.32.0-b5996f5    Avg: 0.995783090591431
Janet 1.35.0-0d9e999    Avg: 0.916385889053345

# Benchmark: benchmarks/fannkuch/fannkuch1.janet
Janet 1.32.0-b5996f5    Avg: 6.55872511863708
Janet 1.35.0-0d9e999    Avg: 6.42196393013

# Benchmark: benchmarks/fannkuch/fannkuch2.janet
Janet 1.32.0-b5996f5    Avg: 4.95723104476929
Janet 1.35.0-0d9e999    Avg: 4.99268579483032

# Benchmark: benchmarks/fannkuch/fannkuch3.janet
Janet 1.32.0-b5996f5    Avg: 1.38383603096008
Janet 1.35.0-0d9e999    Avg: 1.38260197639465

# Benchmark: benchmarks/fannkuch/fannkuch2b.janet
Janet 1.32.0-b5996f5    Avg: 0.229254961013794
Janet 1.35.0-0d9e999    Avg: 0.0403671264648438

# Benchmark: benchmarks/fannkuch/fannkuch5.janet
Janet 1.32.0-b5996f5    Avg: 2.87757301330566
Janet 1.35.0-0d9e999    Avg: 2.47903203964233

# Benchmark: benchmarks/fannkuch/fannkuch2-in.janet
Janet 1.32.0-b5996f5    Avg: 4.76161003112793
Janet 1.35.0-0d9e999    Avg: 4.70300483703613

# Benchmark: benchmarks/regex-redux/regexredux.janet
Janet 1.32.0-b5996f5    Avg: 0.0431818962097168
Janet 1.35.0-0d9e999    Avg: 0.0177791118621826

# Benchmark: benchmarks/fannkuch/fannkuch4.janet
Janet 1.32.0-b5996f5    Avg: 3.56411409378052
Janet 1.35.0-0d9e999    Avg: 3.69160199165344

# Benchmark: benchmarks/reverse-complement/revcomp2_113.janet
Janet 1.32.0-b5996f5    Avg: 0.00463700294494629
Janet 1.35.0-0d9e999    Avg: 0.0048828125

# Benchmark: benchmarks/binarytrees/binarytrees1.janet
Janet 1.32.0-b5996f5    Avg: 0.0272018909454346
Janet 1.35.0-0d9e999    Avg: 0.0221970081329346

# Benchmark: benchmarks/reverse-complement/revcomp2.janet
Janet 1.32.0-b5996f5    Avg: 0.0215470790863037
Janet 1.35.0-0d9e999    Avg: 0.00510501861572266

# Benchmark: benchmarks/knucleotide/knucleotide.janet
Janet 1.32.0-b5996f5    Avg: 0.279989004135132
Janet 1.35.0-0d9e999    Avg: 0.155150890350342

# Benchmark: benchmarks/nbody/nbody.janet
Janet 1.32.0-b5996f5    Avg: 0.0543398857116699
Janet 1.35.0-0d9e999    Avg: 0.0534029006958008

# Benchmark: benchmarks/reverse-complement/counts.janet
Janet 1.32.0-b5996f5    Avg: 0.0332131385803223
Janet 1.35.0-0d9e999    Avg: 0.0292308330535889

# Benchmark: benchmarks/reverse-complement/revcomp.janet
Janet 1.32.0-b5996f5    Avg: 0.021298885345459
Janet 1.35.0-0d9e999    Avg: 0.00989699363708496

# Benchmark: benchmarks/pidigits/pidigits.janet
Janet 1.32.0-b5996f5    Avg: 0.212692975997925
Janet 1.35.0-0d9e999    Avg: 0.39533805847168

# Benchmark: benchmarks/fannkuch/fannkuch4-bakpakin.janet
Janet 1.32.0-b5996f5    Avg: 3.37368202209473
Janet 1.35.0-0d9e999    Avg: 3.26073312759399
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
