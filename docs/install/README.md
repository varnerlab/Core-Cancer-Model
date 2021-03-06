## Installation
You can download the core cancer model code repository as a zip file, or `clone`/`pull` it by using the command (from the command-line):

	$ git pull https://github.com/varnerlab/Core-Cancer-Model

or

	$ git clone https://github.com/varnerlab/Core-Cancer-Model

This code is written in [Julia](https://docs.julialang.org/en/stable/).
[Julia](https://docs.julialang.org/en/stable/) is an open-source mathematical programming language,
similar to MATLAB and other languages such as Python.
However, it has execution times similar to C.
[Julia can be installed on all platforms](https://julialang.org/downloads/).

The core cancer model requires a few [Julia](https://docs.julialang.org/en/stable/) packages to run:

| Packages | Description |
:---: | :--- |
| [GLPK](https://github.com/JuliaOpt/GLPK.jl) | GNU Linear programming kit package for Julia |
| [MAT](https://github.com/JuliaIO/MAT.jl) | Julia package to read/write MATLAB binary files |
| [JSON](https://github.com/JuliaIO/JSON.jl) | Julia JSON parser

These packages can be installed using the ``Pkg.add()`` command in the Julia REPL. For example, to
install the GLPK package, you would execute the command in the REPL:

    julia> Pkg.add("GLPK")
