metrop_hastings<-function(x_0, iter=1, log_post_density,
                          proposal_dist = function(x, prop_sigma){ 
                            MASS::mvrnorm(1, mu = x, Sigma = prop_sigma )
                          }, 
                          lower=-Inf, upper=Inf, prop_sigma,
                          ... ){
  for(i in 1:iter){
    # draw from proposal distribution
    x_star <- proposal_dist(x_0, prop_sigma) 
    
    # calculate ratio of conditional posterior densities
    r_num <- do.call(log_post_density, c(list(x_star), list(...)) )
    r_denom <- do.call(log_post_density, c(list(x_0), list(...)) )
    r <- exp(r_num - r_denom)
    rmin<-min(r,1)
    if(is.na(rmin)) browser()
    # accept / reject proposal
    if(rbinom(1,1,rmin)==1){ 
      x_0<-x_star
    }
  }
  
  res<-list(x_0 = x_0, accept_prob = rmin )
  return(res)
}