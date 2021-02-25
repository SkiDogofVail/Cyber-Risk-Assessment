#' r betaPERT Function
#'
#' This function allows you to sample a Modified Beta PERT distribution.
#' The function gives you the "position" of a value assuming a domain of 0 to 1.
#' The "rbeta*x.range+x.min" in the return statement scales that to your actual domain e.g. $0 to $25
#' Initially inspired by: https://www.riskamp.com/beta-pert.
#' Improved upon based on statistical guidance in:
#' "Risk Analysis-A Quantitative Guide" by David Vose (John Wiley & Sons, 2000).
#' https://www.vosesoftware.com/riskwiki/ModifiedPERTdistribution.php
#' @param lambda Confidence/kurtosis modifier. Defaults to 2.75.
#' @param n 
#' @param x.min
#' @param x.max
#' @param x.mode
#' @keywords rpert
#' @export
#' @examples
#' rpert()

rpert <- function( n, x.min, x.max, x.mode, lambda = 2.75 ){
  if( x.min > x.max || x.mode > x.max || x.mode < x.min ) stop( "invalid parameters" );
  x.range <- x.max - x.min;
  if( x.range == 0 ) return( rep( x.min, n ));
  mu <- ( x.min + x.max + lambda * x.mode ) / ( lambda + 2 );
  # special case if mu == mode
  if( mu == x.mode ){
    v <- ( lambda / 2 ) + 1
  }
  else {
    v <- (( mu - x.min ) * ( 2 * x.mode - x.min - x.max )) /
      (( x.mode - mu ) * ( x.max - x.min ));
  }
  w <- ( v * ( x.max - mu )) / ( mu - x.min );
  return ( rbeta( n, v, w ) * x.range + x.min );
}
