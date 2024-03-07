.onAttach <- function(libname, pkgname) {
  # Install the remotes package if you haven't already
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }

  # Install the specific version from a URL
  remotes::install_url("https://raw.githubusercontent.com/Glender/DutchSentimentAnalysis/main/inst/script/vwr_0.3.0.tar.gz")

  if(packageVersion("stringr") != "1.4.0"){
    devtools::install_version("stringr", version = "1.4.0", repos = "http://cran.us.r-project.org")
  }
}

