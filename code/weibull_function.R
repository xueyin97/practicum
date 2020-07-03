weibull_parameters<-function(mean,median)
{
k=seq(0,10,0.01)
left=gamma(1+1/k)
right=mean/median*log(2)^(1/k)
loc=which.min(abs(left-right))
k<-k[loc]
lambdaw=median/log(2)^(1/k)
return(c(k,lambdaw))
}

##meanst,medianst:the original mean and median without time dependent
##meandep:mean age of death(life expectancy)increases by meandep each year
##mediandep:median age of death(life expectancy)increases by mediandep each year
##N:number of study years(every year a baby born with Morquio Syndrome A)
weibull_eventtime<-function(meanst,medianst,meandep,mediandep,N)
{ 
  surv=0
  for (i in 1:N){
  mean=meanst+i*meandep
  median=medianst+i*mediandep
  k<-weibull_parameters(mean,median)[1]
  lambdaw<-weibull_parameters(mean,median)[2]
  covs <- data.frame(id=1)
  surv[i] <- simsurv(dist="weibull",lambda = lambdaw^(-k), gamma = k,x = covs)[,2]
  }
return(surv)
}


##start:treatment starts working this year
##end:treatment does not improve after this year
weibull_eventtime_stop<-function(meanst,medianst,meandep,mediandep,N,start,stop)
{ 
  order=seq(1,N,1)
  mean=meanst+as.numeric((order-start)*(end-order)>=0)*(order-start)*meandep
  median=medianst+as.numeric((order-start)*(end-order)>=0)*(order-start)*mediandep
  mean[which(end-order<0)]=meanst+(end-start)*meandep
  median[which(end-order<0)]=medianst+(end-start)*mediandep
  surv=0
  for (i in 1:N) {
  k<-weibull_parameters(mean[i],median[i])[1]
  lambdaw<-weibull_parameters(mean[i],median[i])[2]
  covs <- data.frame(id= 1)
  surv[i] <- simsurv(dist="weibull",lambda = lambdaw^(-k), gamma = k,x = covs)[,2]
  }
  return(surv)
}