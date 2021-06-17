
### clr

centerLR <- function(vec) {
  require("pracma", quietly = T)
    
  vec_out <- log(vec / pracma::nthroot(prod(vec), length(vec)))
  
  return(vec_out)
  
}


### alr

relAbund <- function(x) {
  
  rel_out <- apply(x, 2, function(x) x / sum(x))
  
  return(rel_out)
  
}
