#glmmtmb_models: zero-inflated generalized linear mixed models (glmm) for individual species

# title: Optimization of video monitoring for reef fish assessments
# author: Stijn bruneel
# date: 20 November 2019

preprocess.data<-function(data.repeat.50){
  data.repeat.50$fIsland<-as.factor(data.repeat.50$Island)
  data.repeat.50$fLocation<-as.factor(data.repeat.50$Location)
  data.repeat.50$fCode_Transect<-as.factor(data.repeat.50$Code_Transect)
  data.repeat.50$fPerson<-as.factor(data.repeat.50$Person)
  data.repeat.50[is.na(data.repeat.50)==TRUE]=0
  return(data.repeat.50)
}

data.repeat.50.temp<-preprocess.data(data.repeat.50)

glmmtmb_models<-function(response,data,family){

  tryCatch({
  M1 <- glmmTMB(as.formula(paste(response,"~", "fIsland+(1|fLocation/fCode_Transect) + (1|fPerson) + (1|fPerson:fLocation) + (1|fPerson:fCode_Transect)")),
                  ziformula=~1,
                  data=data,
                  family=family)
  },error=function(e){cat("ERROR :",conditionMessage(e), "\n")})

  return(M1)

}

response=specieslist

no_cores <- detectCores()
cl <- makeCluster(no_cores-3)
registerDoParallel(cl)

foreach (i = length(response):1,.packages = "glmmTMB") %dopar%
{
  speciesmodel<-glmmtmb_models(response[i],data=data.repeat.50.temp,family="compois")
  filename=paste("./Rdata/Species_models/",response[i],".RData")
  save(speciesmodel, file = filename)
  print(i)
}
stopCluster(cl)

filelist<-list.files("./Rdata/Species_models/")

response=NA

for (i in 1:length(filelist)){
  filename=paste("./Rdata/Species_models/",filelist[i],sep="")
  load(filename)
  response[i]=all.vars(speciesmodel$call$formula)[1]
  if (i == 1){
    fullmodel=sjstats::icc(speciesmodel)
  }
  if (i > 1){
    fullmodel=rbind(fullmodel,sjstats::icc(speciesmodel))
  }
}
rownames(fullmodel)=response
colnames(fullmodel)=c("Transect","Location","Observer","Observer:Location","Observer:Transect")
fullmodel=as.data.frame(round(fullmodel,digits=4))
