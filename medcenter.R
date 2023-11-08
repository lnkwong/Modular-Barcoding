library(Biobase)

#Use this for log2 data
medcen <- function(f0) {
  f  = sub('.txt','',f0)
  f1 = paste0(f,'.txt')
  f2 = paste0(f,'_medcen.csv')
  as.matrix(round(read.table(f1),3))->data
  round(2^data,3)->unlog
  unlog[unlog==1]<-0.01
  round(rowMedians(unlog),3)->med
  round(rowMeans(unlog),3)->mean
  sweep(unlog,med,MARGIN=1,"/")->medcen
  cbind(round(medcen,3),med,mean)->medcen
  write.csv(medcen,f2)
}

#Use this for unlogged data
medcenu <- function(f0) {
  f  = sub('.txt','',f0)
  f1 = paste0(f,'.txt')
  f2 = paste0(f,'_medcen.csv')
  as.matrix(round(read.table(f1),3))->data
  data[data==0]<-0.01
  round(rowMedians(data),3)->med
  round(rowMeans(data),3)->mean
  sweep(data,med,MARGIN=1,"/")->medcen
  cbind(round(medcen,3),med,mean)->medcen
  write.csv(medcen,f2)
}
