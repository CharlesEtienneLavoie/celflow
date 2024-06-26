# ctrl + shift + B = install my own package
# ctrl + shift + D = document
# ctrl + shift + L = load library
# ctrl + S = save
# ctrl + shift + n = new file
# ctrl + shift + K = knit
# ctrl + shift + T = run tests
# ctrl + shift + E = run different checks

#install.packages("usethis")
library(usethis)

usethis::use_github()

usethis::use_git_remote("origin", url = 'https://github.com/CharlesEtienneLavoie/celflow.git', overwrite = TRUE)

?usethis

#test


use_github_links()


usethis::gh_token_help()

create_github_token()

gitcreds::gitcreds_set()

