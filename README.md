
<!-- README.md is generated from README.Rmd. Please edit that file -->

# celflow

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/CEL)](https://CRAN.R-project.org/package=CEL)
<!-- badges: end -->

The goal of celflow is to provide a comprehensive set of tools and
functions for optimizing the workflow of psychology research,
specifically focusing on data preparation and cleaning. This package
aims to streamline and simplify the process of preparing data for
analysis, enabling researchers to follow good practices and adhere to
established standards in the field.

By leveraging the functionality of celflow, researchers can benefit from
efficient and standardized methods for data manipulation,
transformation, and quality control. The package offers a collection of
functions that address common challenges encountered during the data
preparation phase, such as handling missing values, managing outliers,
recoding variables, and conducting data checks.

With celflow, researchers can ensure the integrity and reliability of
their data, reducing the potential for errors and enhancing the overall
quality of their analyses. The package promotes good data management
practices and facilitates the creation of reproducible research
pipelines, contributing to the transparency and replicability of
psychological research.

## Installation

You can install the development version of celflow like so:

``` r
# If package `remotes` isn't already installed, install it with `install.packages("remotes")`
remotes::install_github("CharlesEtienneLavoie/celflow")
```

## Example

This is a basic example which shows you how to simulate power for a
Structural Equation Model (SEM) using the `simulate_power` function
provided by celflow:

``` r
library(celflow)
library(lavaan)
#> This is lavaan 0.6-15
#> lavaan is FREE software! Please report any bugs.

# Define the lavaan model with population estimate values
modpop <- '
M ~ 0.40*X
Y ~ 0.30*M
'

# Define the lavaan model that will be tested in each simulation
mod <- '
M ~ X
Y ~ M
'
# Use the `simulate_power` function to perform power analysis
# Assume we will perform 10 simulations and generate 5 observations in each simulation
simulate_power(modpop, mod, ksim = 10, nobs = 5)
#>    lhs op rhs    est    se      z pvalue ci.lower ci.upper Parameter
#> 1    M  ~   X  0.613 0.471  1.301  0.193   -0.310    1.537     M ~ X
#> 2    Y  ~   M -0.185 0.190 -0.975  0.330   -0.557    0.187     Y ~ M
#> 3    M ~~   M  1.088 0.688  1.581  0.114   -0.261    2.437    M ~~ M
#> 4    Y ~~   Y  0.262 0.166  1.581  0.114   -0.063    0.587    Y ~~ Y
#> 5    X ~~   X  0.979 0.000     NA     NA    0.979    0.979    X ~~ X
#> 6    M  ~   X  1.050 0.265  3.964  0.000    0.531    1.569     M ~ X
#> 7    Y  ~   M  0.019 0.254  0.076  0.939   -0.479    0.518     Y ~ M
#> 8    M ~~   M  0.317 0.200  1.581  0.114   -0.076    0.709    M ~~ M
#> 9    Y ~~   Y  0.424 0.268  1.581  0.114   -0.102    0.949    Y ~~ Y
#> 10   X ~~   X  0.903 0.000     NA     NA    0.903    0.903    X ~~ X
#> 11   M  ~   X  0.377 1.049  0.360  0.719   -1.679    2.434     M ~ X
#> 12   Y  ~   M  0.371 0.350  1.062  0.288   -0.314    1.056     Y ~ M
#> 13   M ~~   M  0.931 0.589  1.581  0.114   -0.223    2.084    M ~~ M
#> 14   Y ~~   Y  0.583 0.369  1.581  0.114   -0.140    1.306    Y ~~ Y
#> 15   X ~~   X  0.169 0.000     NA     NA    0.169    0.169    X ~~ X
#> 16   M  ~   X  0.500 0.154  3.251  0.001    0.198    0.801     M ~ X
#> 17   Y  ~   M  1.887 0.134 14.087  0.000    1.625    2.150     Y ~ M
#> 18   M ~~   M  0.169 0.107  1.581  0.114   -0.040    0.378    M ~~ M
#> 19   Y ~~   Y  0.047 0.030  1.581  0.114   -0.011    0.106    Y ~~ Y
#> 20   X ~~   X  1.428 0.000     NA     NA    1.428    1.428    X ~~ X
#> 21   M  ~   X  0.103 0.255  0.405  0.686   -0.397    0.603     M ~ X
#> 22   Y  ~   M  0.099 0.347  0.285  0.776   -0.581    0.778     Y ~ M
#> 23   M ~~   M  0.385 0.244  1.581  0.114   -0.092    0.863    M ~~ M
#> 24   Y ~~   Y  0.239 0.151  1.581  0.114   -0.057    0.535    Y ~~ Y
#> 25   X ~~   X  1.184 0.000     NA     NA    1.184    1.184    X ~~ X
#> 26   M  ~   X  0.506 0.611  0.827  0.408   -0.693    1.704     M ~ X
#> 27   Y  ~   M  0.513 0.290  1.768  0.077   -0.056    1.082     Y ~ M
#> 28   M ~~   M  2.018 1.277  1.581  0.114   -0.484    4.520    M ~~ M
#> 29   Y ~~   Y  0.966 0.611  1.581  0.114   -0.232    2.164    Y ~~ Y
#> 30   X ~~   X  1.080 0.000     NA     NA    1.080    1.080    X ~~ X
#> 31   M  ~   X  0.669 0.321  2.083  0.037    0.040    1.298     M ~ X
#> 32   Y  ~   M  0.415 0.318  1.307  0.191   -0.207    1.037     Y ~ M
#> 33   M ~~   M  0.617 0.390  1.581  0.114   -0.148    1.381    M ~~ M
#> 34   Y ~~   Y  0.581 0.367  1.581  0.114   -0.139    1.301    Y ~~ Y
#> 35   X ~~   X  1.197 0.000     NA     NA    1.197    1.197    X ~~ X
#> 36   M  ~   X  0.296 0.259  1.145  0.252   -0.211    0.803     M ~ X
#> 37   Y  ~   M  1.003 0.453  2.214  0.027    0.115    1.891     Y ~ M
#> 38   M ~~   M  0.241 0.152  1.581  0.114   -0.058    0.540    M ~~ M
#> 39   Y ~~   Y  0.312 0.197  1.581  0.114   -0.075    0.699    Y ~~ Y
#> 40   X ~~   X  0.720 0.000     NA     NA    0.720    0.720    X ~~ X
#> 41   M  ~   X  0.700 0.448  1.562  0.118   -0.178    1.578     M ~ X
#> 42   Y  ~   M  0.407 0.433  0.939  0.348   -0.442    1.256     Y ~ M
#> 43   M ~~   M  0.694 0.439  1.581  0.114   -0.166    1.555    M ~~ M
#> 44   Y ~~   Y  0.970 0.613  1.581  0.114   -0.232    2.172    Y ~~ Y
#> 45   X ~~   X  0.692 0.000     NA     NA    0.692    0.692    X ~~ X
#> 46   M  ~   X -2.695 1.207 -2.234  0.025   -5.060   -0.330     M ~ X
#> 47   Y  ~   M -0.369 0.206 -1.793  0.073   -0.773    0.034     Y ~ M
#> 48   M ~~   M  0.391 0.247  1.581  0.114   -0.094    0.875    M ~~ M
#> 49   Y ~~   Y  0.165 0.105  1.581  0.114   -0.040    0.371    Y ~~ Y
#> 50   X ~~   X  0.054 0.000     NA     NA    0.054    0.054    X ~~ X
```
