#' Scenario Combos Function
#'
#' This function allows you generate risk scenarios.
#' @param sheeturl URL of your Google sheet. Defaults to demo gsheet.
#' @keywords combos
#' @export
#' @examples
#' combos()

combos <- function(sheeturl) {
  library(purrr)
  library(googledrive)
  library(readxl)
  library(clipr)
  
  # Download data
  fp <- sheeturl
  scope_components <- (gsheet_name <- drive_get(fp))
  drive_download(scope_components, path = "downloaded_temp", overwrite = TRUE)
  gScope <- read_excel("downloaded_temp.xlsx", sheet = "Scope", skip = 3)
  
  # Remove "excluded"
  gScope_refined <- gScope %>%
    select(starts_with("Included"))
  
  # Generate all Combos
  gScope_refined_combos <- gScope_refined %>%
    expand.grid() %>% na.omit()
  
  # Remove forbidden scenarios
  # Remove malicious software + accidentally (MSA)
  gScope_refined_combos_rm_MSA <- gScope_refined_combos %>%
    filter(Included...7 != "accidentally" | Included...5 != "malicious software") %>%
    
    # remove external attackers + accidentally (EAA)
    filter(Included...7 != "accidentally" | Included...5 != "external attackers")
  
  # Add row IDs
  lennn <-length(na.omit(gScope_refined_combos_rm_MSA$Included...1))
  prefix <- "Risk-"
  suffix <- seq(1:lennn)
  UID <- paste0(prefix,suffix)
  gScope_refined_combos_rm_MSA$UID <- cbind(UID)
  
  gScope_refined_combos_rm_MSA <- gScope_refined_combos_rm_MSA %>% select(UID, everything())
  
  write_clip(gScope_refined_combos_rm_MSA, col.names = FALSE)
  
  message <- "Paste what has been loaded into your clipboard to the Scenarios sheet at cell A4.

Re-run this script once you're done entering in respective risk estimates for each scenario.
  
  This script will stop now."
  
  rstudioapi::showDialog(title = "Paste time", message, url = sheeturl)
  
  break
  
}