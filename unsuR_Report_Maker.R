# Open this script in RStudio and click "Source" to start report generation process.

# About: https://SkiDogofVail.github.io/Cyber-Risk-Assessment/

library(pacman)
library(rstudioapi)

# Install the rStudio API if absent (for pop-up input windows)
  if (!require("rstudioapi")) install.packages("rstudioapi")

# Set the working directory to wherever this .R file is.
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Install/Load package manager pacman then others.
  if (!require("pacman")) install.packages("pacman")
  source("src/packs.R")
  library(pacman)
  p_load(char=packages, install = TRUE, character.only = FALSE)
  
# Google account selection and auths
  email <- rstudioapi::showPrompt(
    title = 'Google account to use',
    message = 'Enter your email address.',
    default = "wavespbc.network@gmail.com")
  drive_auth(email=email)
  gs4_auth(email=email)

# Optionally replace the .png logo and icon with your own as you please.
  render(output_dir = "output/",
         "src/unsuR_Report.Rmd",
         flex_dashboard(logo = "../imgs/emblem.png",
                        favicon = "../imgs/favicon.png",
                        theme="bootstrap",
                        self_contained = TRUE,
                        source_code = "https://github.com/cneskey/unsuR"))

# Launch the report in default browser.
  browseURL("output/unsuR_Report.html")
  
# Error Handling Notes
  # If having Pandoc errors you may need to create a file that explicitly tells R where to launch from. This will happen if you have a weird install or are using a virtual workstation etc.
  # Sys.getenv('R_USER')
  # .Renviron file in H:/ and included in it the single entry R_USER=H:/
