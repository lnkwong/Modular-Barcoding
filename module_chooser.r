library(RColorBrewer)
library(gplots)
library(amap) 
library(dendextend) 
library(colorspace)
library(Hmisc)

moduh <- function(f0, h0 = 0.8) {
f  = sub('.txt','',f0)
f1 = paste0(f,'.txt')
f2 = paste0(f,'_Spear.txt')
f3 = paste0(f,'_rank_Dist_Output.txt')
f4 = paste0(f,'_h_0.95_',h0,'.txt')
f5 = paste0(f,'_h_rank_0.95_',h0,'.png')
f6 = paste0(f,'_h_heatmap_0.95','.png')

table <- read.table(f1, header=TRUE, sep="\t",
                    row.names=1, stringsAsFactors=FALSE, comment.char="", check.names=FALSE)

c_table <- rcorr(as.matrix(t(table)), type="spearman")

stafr<-as.matrix(round(c_table[[1]],3))
write.table(stafr, f2, row.names=TRUE, col.names=NA, quote=FALSE, sep="\t")
stafr[is.na(stafr)]<--1
data.frame(apply(stafr, 1, rank, ties.method='min'))->star
starp<-star/nrow(stafr)

sta0<-as.matrix(round(starp,3))

#restrict to top 5% and conduct clustering - generate Dist output for future shortcut use
sta0[sta0<0.95]<-0
sta0d<-Dist(sta0,"correlation")
write.table(round(as.matrix(sta0d),3),f3, row.names=TRUE, col.names=NA, quote=FALSE, sep="\t")
sta0da<-hclust(sta0d,"average")
sta0da$height <- round(sta0da$height, 6) 

#perform cutree to file and for heatmap
sta0dac<-cutree(sta0da,h = h0) 
write.table(sta0dac,f4,sep="\t") #output file 2
sta0dad<-as.dendrogram(sta0da)

#generate dendrogram to see node height
#png(file=f5) #output file 1
#plot(sta0da,hang=-1)
#dev.off()

#generate heatmap
png(file=f6) #output file 3
heatmap.2(sta0,Rowv=sta0dad, Colv=sta0dad,col=brewer.pal(9,"PuRd"),density.info="none", trace="none")
dev.off()
}

moduk <- function(f0, k0 = 5) {
  f  = sub('.txt','',f0)
  f1 = paste0(f,'.txt')
  f2 = paste0(f,'_Spear.txt')
  f3 = paste0(f,'_rank_Dist_Output.txt')
  f4 = paste0(f,'_k_0.95_',k0,'.txt')
  f5 = paste0(f,'_k_rank_0.95_',k0,'.png')
  f6 = paste0(f,'_k_heatmap_0.95_','.png')
  
  table <- read.table(f1, header=TRUE, sep="\t",
                      row.names=1, stringsAsFactors=FALSE, comment.char="", check.names=FALSE)
  
  c_table <- rcorr(as.matrix(t(table)), type="spearman")
  
  stafr<-as.matrix(round(c_table[[1]],3))
  write.table(stafr, f2, row.names=TRUE, col.names=NA, quote=FALSE, sep="\t")
  stafr[is.na(stafr)]<--1
  data.frame(apply(stafr, 1, rank, ties.method='min'))->star
  starp<-star/nrow(stafr)
  
  sta0<-as.matrix(round(starp,3))
  
  #restrict to top 5% and conduct clustering - generate Dist output for future shortcut use
  sta0[sta0<0.95]<-0
  sta0d<-Dist(sta0,"correlation")
  write.table(round(as.matrix(sta0d),3),f3, row.names=TRUE, col.names=NA, quote=FALSE, sep="\t")
  sta0da<-hclust(sta0d,"average")
  sta0da$height <- round(sta0da$height, 6) 
  
  #perform cutree to file and for heatmap
  sta0dac<-cutree(sta0da,k = k0) 
  write.table(sta0dac,f4,sep="\t") #output file 2
  sta0dad<-as.dendrogram(sta0da)

  #generate heatmap
  png(file=f6) #output file 3
  heatmap.2(sta0,Rowv=sta0dad, Colv=sta0dad,col=brewer.pal(9,"PuRd"),density.info="none", trace="none")
  dev.off()
}

modureh <- function(f0, h0 = 0.8) {
  f  = sub('.txt','',f0)
  f3 = paste0(f,'_rank_Dist_Output.txt')
  f4 = paste0(f,'_h_0.95_',h0,'.txt')
  f5 = paste0(f,'_h_rank_0.95_',h0,'.png')
  f6 = paste0(f,'_h_heatmap_0.95_',h0,'.png')
  
  sta0d <- as.dist(read.table(f3, header=TRUE, sep="\t",
                     row.names=1, stringsAsFactors=FALSE, comment.char="", check.names=FALSE))
  sta0da<-hclust(sta0d,"average")
  sta0da$height <- round(sta0da$height, 6) 
  
  #perform cutree to file and for heatmap
  sta0dac<-cutree(sta0da,h = h0) 
  write.table(sta0dac,f4,sep="\t") #output file 2
  sta0dad<-as.dendrogram(sta0da)
}

modurek <- function(f0, k0 = 5) {
  f  = sub('.txt','',f0)
  f3 = paste0(f,'_rank_Dist_Output.txt')
  f4 = paste0(f,'_h_0.95_',k0,'.txt')
  f5 = paste0(f,'_h_rank_0.95_',k0,'.png')
  f6 = paste0(f,'_h_heatmap_0.95_',k0,'.png')
  
  sta0d <- as.dist(read.table(f3, header=TRUE, sep="\t",
                              row.names=1, stringsAsFactors=FALSE, comment.char="", check.names=FALSE))
  sta0da<-hclust(sta0d,"average")
  sta0da$height <- round(sta0da$height, 6) 
  
  #perform cutree to file and for heatmap
  sta0dac<-cutree(sta0da,k = k0) 
  write.table(sta0dac,f4,sep="\t") #output file 2
  sta0dad<-as.dendrogram(sta0da)
}