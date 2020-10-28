---
layout: default-nav
title: Get Started
displaytitle: Get Started
description: mlpack | fast, flexible machine learning library in C++
order: 2
---

<div class="page-title-header">Get Started</div>

# Overview

There are multiple ways to get mlpack up and running. Python bindings can be
installed using pip or conda, or built from source (see "Build from source"
tutorials).  Julia bindings can be installed via Julia's `Pkg` package manager.

For C++, if mlpack is not available via your preferred OS package manager, or if
you need to build your own version (e.g. to apply optimizations, use a different
set of BLAS/LAPACK, or build a different configuration), please refer to the
"Build from source" tutorials.  For Windows, prebuilt binaries will help you get
started without the need of building mlpack. These packages include both the C++
mlpack library as well as the CLI tools.

Once you get mlpack running, check out the [documentation](docs.html) or the
[examples repository](https://github.com/mlpack/examples/), which contains
simple example usages of mlpack.

Here is a summary of the currently available distribution options you can use
depending on your needs:

## Python

### Get via pip or conda

<div class="quick-command">pip install mlpack</div>
<div class="quick-command">conda install -c conda-forge mlpack</div>

- [mlpack in Python quickstart guide](doc/mlpack-3.4.2/doxygen/python_quickstart.html)

### Databricks
- From your workspace dropdown, select Create -> Library. Then specify PyPI and
  use "mlpack" as the package name.

## Julia

### Get via Pkg

<div class="quick-command">import Pkg;<br />Pkg.add("mlpack")</div>

## Ubuntu, Debian, Fedora, Red Hat

### Install using a package manager
- [mlpack command-line quickstart guide](doc/mlpack-3.4.2/doxygen/cli_quickstart.html)

### Build from source
- [Linux build tutorial](doc/mlpack-3.4.2/doxygen/build.html)

## Windows

### Download prebuilt binaries
- [Windows 64 bit - MSI Installer](/files/mlpack-3.4.2.msi)
- [Windows 64 bit - ZIP](/files/mlpack-3.4.2.zip)

### Install using a package manager
- [Installation through vcpkg](doc/mlpack-3.4.2/doxygen/build_windows.html)

### Build from source
- [Windows build tutorial](doc/mlpack-3.4.2/doxygen/build_windows.html)

## macOS

### Install using homebrew
<div class="quick-command">brew install mlpack</div>

### Build from source 
- [Linux build tutorial](doc/mlpack-3.4.2/doxygen/build.html)

