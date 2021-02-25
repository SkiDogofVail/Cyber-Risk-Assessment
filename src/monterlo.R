#' MonteRlo Function
#'
#' This function allows you to loop distribution sampling.
#' Thank you @theonaunheim for showing me how to vectorize!
#' @param n_scens The number of scenarios you have.
#' @param n_perms The number of iterations you want.
#' @param prb The probability.
#' @param mn The minimum bound of your estimate interval.
#' @param ml The most likely (mode) of your estimate interval.
#' @param mx The maximum bound of your estimate interval.
#' @param out_var The output of this function.
#' @keywords monterlo
#' @export
#' @examples
#' monterlo()

monterlo <- function( n_scens, n_perms, prb, mn,ml,mx, out_var){
  
  out_var <- data.frame(matrix(NA, nrow=as.numeric(n_perms), ncol=n_scens))

  for (i in 1:n_scens) {
    LEF <- prb[i]
    LMmin <- mn[i]
    LMmin <- as.numeric(sub("\\$ ","",sub(",","",LMmin)))

    LMmax <- mx[i]
    LMmax <- as.numeric(sub("\\$ ","",sub(",","",LMmax)))

    LMmlk <- ml[i]
    LMmlk <- as.numeric(sub("\\$ ","",sub(",","",LMmlk)))
    
    # Vector approach
    binomial_vec <- rbinom(n=as.numeric(n_perms),size=1,p=as.numeric(LEF))
    pert_vec <- rpert(as.numeric(n_perms),LMmin,LMmax,LMmlk,2.7)
    out_vec <- binomial_vec * pert_vec
    out_var[[i]] <- out_vec}
    
  return(out_var)
}

