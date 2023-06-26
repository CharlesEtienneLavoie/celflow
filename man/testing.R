library(lavaan)

modpop <- '
M ~ 0.40*X
Y ~ 0.30*M
'

mod <- '
M ~ X
Y ~ M
'

simulate_power(modpop, mod)

