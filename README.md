
<!-- README.md is generated from README.Rmd. Please edit that file -->

# celflow

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/CEL)](https://CRAN.R-project.org/package=CEL)
<!-- badges: end -->

The goal of celflow is to provide a comprehensive set of tools and functions for optimizing the workflow of psychology research, specifically focusing on data preparation and cleaning. This package aims to streamline and simplify the process of preparing data for analysis, enabling researchers to follow good practices and adhere to established standards in the field.

By leveraging the functionality of celflow, researchers can benefit from efficient and standardized methods for data manipulation, transformation, and quality control. The package offers a collection of functions that address common challenges encountered during the data preparation phase, such as handling missing values, managing outliers, recoding variables, and conducting data checks.

With celflow, researchers can ensure the integrity and reliability of their data, reducing the potential for errors and enhancing the overall quality of their analyses. The package promotes good data management practices and facilitates the creation of reproducible research pipelines, contributing to the transparency and replicability of psychological research.

## Installation

You can install the development version of CEL like so:

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

    #> This is lavaan 0.6-14
    #> lavaan is FREE software! Please report any bugs.
    #>    lhs op rhs   est    se     z pvalue ci.lower ci.upper Parameter
    #> 1    M  ~   X 0.272 0.092 2.949  0.003    0.091    0.452     M ~ X
    #> 2    Y  ~   M 0.427 0.110 3.873  0.000    0.211    0.644     Y ~ M
    #> 3    M ~~   M 0.875 0.124 7.071  0.000    0.633    1.118    M ~~ M
    #> 4    Y ~~   Y 1.159 0.164 7.071  0.000    0.838    1.480    Y ~~ Y
    #> 5    X ~~   X 1.031 0.000    NA     NA    1.031    1.031    X ~~ X
    #> 6    M  ~   X 0.410 0.084 4.887  0.000    0.246    0.575     M ~ X
    #> 7    Y  ~   M 0.321 0.095 3.391  0.001    0.135    0.506     Y ~ M
    #> 8    M ~~   M 0.701 0.099 7.071  0.000    0.507    0.896    M ~~ M
    #> 9    Y ~~   Y 0.779 0.110 7.071  0.000    0.563    0.994    Y ~~ Y
    #> 10   X ~~   X 0.995 0.000    NA     NA    0.995    0.995    X ~~ X
    #> 11   M  ~   X 0.401 0.097 4.134  0.000    0.211    0.591     M ~ X
    #> 12   Y  ~   M 0.341 0.081 4.218  0.000    0.182    0.499     Y ~ M
    #> 13   M ~~   M 1.035 0.146 7.071  0.000    0.748    1.323    M ~~ M
    #> 14   Y ~~   Y 0.791 0.112 7.071  0.000    0.572    1.011    Y ~~ Y
    #> 15   X ~~   X 1.102 0.000    NA     NA    1.102    1.102    X ~~ X
    #> 16   M  ~   X 0.468 0.093 5.030  0.000    0.286    0.650     M ~ X
    #> 17   Y  ~   M 0.278 0.094 2.949  0.003    0.093    0.463     Y ~ M
    #> 18   M ~~   M 0.949 0.134 7.071  0.000    0.686    1.213    M ~~ M
    #> 19   Y ~~   Y 1.060 0.150 7.071  0.000    0.766    1.354    Y ~~ Y
    #> 20   X ~~   X 1.096 0.000    NA     NA    1.096    1.096    X ~~ X
    #> 21   M  ~   X 0.289 0.090 3.200  0.001    0.112    0.466     M ~ X
    #> 22   Y  ~   M 0.469 0.112 4.178  0.000    0.249    0.690     Y ~ M
    #> 23   M ~~   M 0.873 0.123 7.071  0.000    0.631    1.115    M ~~ M
    #> 24   Y ~~   Y 1.215 0.172 7.071  0.000    0.878    1.552    Y ~~ Y
    #> 25   X ~~   X 1.072 0.000    NA     NA    1.072    1.072    X ~~ X
    #> 26   M  ~   X 0.359 0.098 3.659  0.000    0.167    0.551     M ~ X
    #> 27   Y  ~   M 0.460 0.093 4.970  0.000    0.279    0.642     Y ~ M
    #> 28   M ~~   M 0.923 0.131 7.071  0.000    0.667    1.179    M ~~ M
    #> 29   Y ~~   Y 0.898 0.127 7.071  0.000    0.649    1.147    Y ~~ Y
    #> 30   X ~~   X 0.960 0.000    NA     NA    0.960    0.960    X ~~ X
    #> 31   M  ~   X 0.468 0.101 4.635  0.000    0.270    0.666     M ~ X
    #> 32   Y  ~   M 0.448 0.088 5.116  0.000    0.276    0.620     Y ~ M
    #> 33   M ~~   M 0.978 0.138 7.071  0.000    0.707    1.249    M ~~ M
    #> 34   Y ~~   Y 0.911 0.129 7.071  0.000    0.659    1.164    Y ~~ Y
    #> 35   X ~~   X 0.958 0.000    NA     NA    0.958    0.958    X ~~ X
    #> 36   M  ~   X 0.456 0.109 4.179  0.000    0.242    0.670     M ~ X
    #> 37   Y  ~   M 0.327 0.094 3.498  0.000    0.144    0.511     Y ~ M
    #> 38   M ~~   M 1.157 0.164 7.071  0.000    0.837    1.478    M ~~ M
    #> 39   Y ~~   Y 1.191 0.168 7.071  0.000    0.861    1.521    Y ~~ Y
    #> 40   X ~~   X 0.971 0.000    NA     NA    0.971    0.971    X ~~ X
    #> 41   M  ~   X 0.281 0.112 2.509  0.012    0.062    0.501     M ~ X
    #> 42   Y  ~   M 0.297 0.105 2.826  0.005    0.091    0.503     Y ~ M
    #> 43   M ~~   M 1.082 0.153 7.071  0.000    0.782    1.382    M ~~ M
    #> 44   Y ~~   Y 1.271 0.180 7.071  0.000    0.919    1.623    Y ~~ Y
    #> 45   X ~~   X 0.862 0.000    NA     NA    0.862    0.862    X ~~ X
    #> 46   M  ~   X 0.362 0.095 3.803  0.000    0.175    0.548     M ~ X
    #> 47   Y  ~   M 0.447 0.087 5.141  0.000    0.277    0.618     Y ~ M
    #> 48   M ~~   M 0.995 0.141 7.071  0.000    0.719    1.270    M ~~ M
    #> 49   Y ~~   Y 0.862 0.122 7.071  0.000    0.623    1.101    Y ~~ Y
    #> 50   X ~~   X 1.099 0.000    NA     NA    1.099    1.099    X ~~ X

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
