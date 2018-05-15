## Core cancer metabolic network
This repository holds the [Julia](https://docs.julialang.org/en/stable/) implementation of the Core Cancer Metabolic Network published by Palsson and coworkers:

[Zielinski et al., (2017) Systems biology analysis of drivers underlying hallmarks of cancer cell metabolism. Sci Reports, 7:41241, doi: 10.1038/srep41241](https://rdcu.be/Olwc)

### Installation and Requirements
You can download this repository as a zip file, or `clone`/`pull` it by using the command (from the command-line):

	$ git pull https://github.com/varnerlab/Core-Cancer-Model

or

	$ git clone https://github.com/varnerlab/Core-Cancer-Model

This code is written in [Julia](https://docs.julialang.org/en/stable/),
and requires a few [Julia](https://docs.julialang.org/en/stable/) packages to run:

| Packages | Description |
---: | :--- |
| [GLPK](https://github.com/JuliaOpt/GLPK.jl) | GNU Linear programming kit package for Julia |
| [MAT](https://github.com/JuliaIO/MAT.jl) | Julia package to read/write MATLAB binary files |
| [JSON](https://github.com/JuliaIO/JSON.jl) | Julia JSON parser

These packages can be installed using the ``Pkg.add()`` command in the Julia REPL. For example, to
install the GLPK package, you would execute the command in the REPL:

    julia> Pkg.add("GLPK")


## Documentation
To use this code for your project, or to take advantage of changes that we have made to the Palsson study,
check out our [documentation](https://varnerlab.github.io/Core-Cancer-Model/).

## Funding
The work described was supported by the Center on the Physics of Cancer Metabolism through Award Number 1U54CA210184-01 from the National Cancer Institute. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Cancer Institute or the National Institutes of Health.  
