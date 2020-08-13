my_packages = c("shiny", "shinydashboard", "shinyjs", "DT",  "readr", "shinycssloaders", "shinybusy", "reshape2",
                "shinyalert","ggplot2", "htmlwidgets","plotly","shinyWidgets", "tidyverse","dplyr",
                "plyr","stringr", "lubridate","reticulate","base64enc")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
}

invisible(sapply(my_packages, install_if_missing))