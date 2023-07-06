
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

This is a basic example which shows you how to solve a common problem:

``` r
library(celflow)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

    #> This is lavaan 0.6-15
    #> lavaan is FREE software! Please report any bugs.
    #>    lhs op rhs   est    se     z pvalue ci.lower ci.upper Parameter
    #> 1    M  ~   X 0.268 0.111 2.411  0.016    0.050    0.486     M ~ X
    #> 2    Y  ~   M 0.359 0.088 4.074  0.000    0.186    0.532     Y ~ M
    #> 3    M ~~   M 1.113 0.157 7.071  0.000    0.804    1.421    M ~~ M
    #> 4    Y ~~   Y 0.914 0.129 7.071  0.000    0.661    1.167    Y ~~ Y
    #> 5    X ~~   X 0.899 0.000    NA     NA    0.899    0.899    X ~~ X
    #> 6    M  ~   X 0.379 0.106 3.587  0.000    0.172    0.585     M ~ X
    #> 7    Y  ~   M 0.426 0.097 4.370  0.000    0.235    0.616     Y ~ M
    #> 8    M ~~   M 1.047 0.148 7.071  0.000    0.757    1.337    M ~~ M
    #> 9    Y ~~   Y 1.121 0.158 7.071  0.000    0.810    1.431    Y ~~ Y
    #> 10   X ~~   X 0.940 0.000    NA     NA    0.940    0.940    X ~~ X
    #> 11   M  ~   X 0.332 0.113 2.933  0.003    0.110    0.554     M ~ X
    #> 12   Y  ~   M 0.147 0.088 1.671  0.095   -0.025    0.320     Y ~ M
    #> 13   M ~~   M 1.270 0.180 7.071  0.000    0.918    1.622    M ~~ M
    #> 14   Y ~~   Y 1.069 0.151 7.071  0.000    0.772    1.365    Y ~~ Y
    #> 15   X ~~   X 0.992 0.000    NA     NA    0.992    0.992    X ~~ X
    #> 16   M  ~   X 0.502 0.079 6.334  0.000    0.346    0.657     M ~ X
    #> 17   Y  ~   M 0.517 0.091 5.664  0.000    0.338    0.695     Y ~ M
    #> 18   M ~~   M 0.734 0.104 7.071  0.000    0.530    0.937    M ~~ M
    #> 19   Y ~~   Y 0.855 0.121 7.071  0.000    0.618    1.092    Y ~~ Y
    #> 20   X ~~   X 1.169 0.000    NA     NA    1.169    1.169    X ~~ X
    #> 21   M  ~   X 0.374 0.094 3.988  0.000    0.190    0.559     M ~ X
    #> 22   Y  ~   M 0.279 0.094 2.957  0.003    0.094    0.464     Y ~ M
    #> 23   M ~~   M 0.909 0.129 7.071  0.000    0.657    1.161    M ~~ M
    #> 24   Y ~~   Y 0.938 0.133 7.071  0.000    0.678    1.197    Y ~~ Y
    #> 25   X ~~   X 1.031 0.000    NA     NA    1.031    1.031    X ~~ X
    #> 26   M  ~   X 0.363 0.094 3.863  0.000    0.179    0.547     M ~ X
    #> 27   Y  ~   M 0.190 0.095 2.003  0.045    0.004    0.375     Y ~ M
    #> 28   M ~~   M 0.891 0.126 7.071  0.000    0.644    1.138    M ~~ M
    #> 29   Y ~~   Y 0.919 0.130 7.071  0.000    0.664    1.173    Y ~~ Y
    #> 30   X ~~   X 1.009 0.000    NA     NA    1.009    1.009    X ~~ X
    #> 31   M  ~   X 0.238 0.098 2.435  0.015    0.046    0.430     M ~ X
    #> 32   Y  ~   M 0.434 0.101 4.283  0.000    0.235    0.632     Y ~ M
    #> 33   M ~~   M 0.818 0.116 7.071  0.000    0.592    1.045    M ~~ M
    #> 34   Y ~~   Y 0.890 0.126 7.071  0.000    0.643    1.136    Y ~~ Y
    #> 35   X ~~   X 0.856 0.000    NA     NA    0.856    0.856    X ~~ X
    #> 36   M  ~   X 0.540 0.092 5.835  0.000    0.358    0.721     M ~ X
    #> 37   Y  ~   M 0.396 0.079 5.001  0.000    0.241    0.551     Y ~ M
    #> 38   M ~~   M 0.834 0.118 7.071  0.000    0.603    1.065    M ~~ M
    #> 39   Y ~~   Y 0.700 0.099 7.071  0.000    0.506    0.894    Y ~~ Y
    #> 40   X ~~   X 0.975 0.000    NA     NA    0.975    0.975    X ~~ X
    #> 41   M  ~   X 0.428 0.094 4.557  0.000    0.244    0.612     M ~ X
    #> 42   Y  ~   M 0.418 0.103 4.044  0.000    0.215    0.620     Y ~ M
    #> 43   M ~~   M 0.788 0.111 7.071  0.000    0.569    1.006    M ~~ M
    #> 44   Y ~~   Y 1.014 0.143 7.071  0.000    0.733    1.295    Y ~~ Y
    #> 45   X ~~   X 0.893 0.000    NA     NA    0.893    0.893    X ~~ X
    #> 46   M  ~   X 0.400 0.099 4.038  0.000    0.206    0.594     M ~ X
    #> 47   Y  ~   M 0.300 0.091 3.281  0.001    0.121    0.479     Y ~ M
    #> 48   M ~~   M 0.922 0.130 7.071  0.000    0.667    1.178    M ~~ M
    #> 49   Y ~~   Y 0.895 0.127 7.071  0.000    0.647    1.143    Y ~~ Y
    #> 50   X ~~   X 0.941 0.000    NA     NA    0.941    0.941    X ~~ X

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
