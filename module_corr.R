library('stringr')

Sm  <- function(f,x,rnames = F,cnames = F,...) {
       write.table(x,f,sep=',',col.names = cnames,row.names = rnames,...) }
sm  <- function(f,x,rnames = F,cnames = F,...) {
       write.table(x,f,sep=',',col.names = cnames,row.names = rnames,append = T,...)}

cc  <- function(...) paste0(...)

nl  <- function(...) cat(...,'\n',file="")
fw  <- function(f,...) cat(...,file=f)
fa  <- function(f,...) cat(...,file=f,append=T)
fnl <- function(f,...) cat(...,'\n',file=f,append=T)

####################################################################

scor <- function(x,y=NULL) {
   x1 = as.matrix(x)
   y1 = as.matrix(y)
   if (nrow(x1)<5 || ((nrow(x1) != nrow(y1)) && (ncol(x1) == ncol(y1)))) cor(t(x),t(y),method='spearman') else   cor(x,y,method='spearman')
}

####################################################################

me <- function(x) {
   nc = ncol(x)
   m = NULL
   for (k in 1:nc) {
      m = c(m, median(x[,k]))
   }
   return(t(m))
}

ds <- function(x,y) norm(as.matrix(x-y),'m')

######### For explanation of above, see previous it_doc.r ##########

# function to calculate the fixed-point median when given a matrix
# condensed from the function mscor(...) in it.r
#   Only returns the final median - no writing to file, no printing
#     of the intervening medians and 
#     how many genes are used in each iteration
msc <- function(ms,co1=20,co2=0.6) {
   nc = ncol(ms)
   nr = nrow(ms)

   m1 = me(ms)
   s1 = t(scor(m1,ms))
   ss = sort(s1)
   cutoff = ss[length(ss) * (1 - co1/100) - 1]
   if(length(cutoff)==0){
     cutoff =ss[1]
   }
   
   S  = s1

   msc = ms[s1[] >= cutoff,]
   nmc = nrow(msc)
   msc2 = ms[s1[] >= co2,]            #picks only the rows that have a score over 0.60, problem when there is non within a certain module --> empty list
   nmc2 = nrow(msc2)

   m2 = me(msc)
   
   while (ds(m2,m1) > 1e-7) {       # m2 is median values of top correlated values, m1 is median values of all values in a module
      m1 = m2                       #error arises when taking correlated values larger than co2 (0.6) and there are none
      s1 = t(scor(m1,ms))           #you run ds(m2,m1) and returns NA cause m2 is empty, no TRUE/FALSE value included.
      S  = cbind(S,s1)
      msc = ms[s1[] >= co2,]
      nmc = nrow(msc)
      if(nmc ==0){                  # conditional break if the >= 0.6 is not met and returns an empty list that would lead to ds(m2,m1) to return NA
        break
      }
      m2 = me(msc)
   }
   m2
}

# This is the function that separates the various gene sets and
#   calls msc for each set, calculate the fixed-point median and
#   finally compute the correlations
mmsc <- function(file,c1=0,c2=0) {

   # hanles default or assigned cutoffs as in it.r
   if (c1 == 0) { c1 = get0('cutoff1'); if (is.null(c1)) { c1 = 20 } }
   if (c2 == 0) { c2 = get0('cutoff2'); if (is.null(c2)) { c2 = 0.6 } }
   if (c1 < 1 && c2 == 0.6) { co1 = 20; co2 = c1 }
   if (c1 < c2) { co1 = c2; co2 = c1 } else { co1 = c1; co2 = c2 }
   if ((co1 > 1 && co2 > 1) || (co1 < 1 && co2 < 1)) {
      nl("**** ERROR: one cutoff should be > 1 and the other < 1"); return; }

   # set the input and output file name, again see it.r
   f  = sub('.csv','',file)
   f1 = paste0(f,'.csv')
   f2 = paste0(f,'_',co1,'_',co2,'_2_output.csv')

   ms0 <- read.csv(f1,stringsAsFactors = FALSE)                    # read in the data matrix
   ms0 = ms0[!is.na(ms0$module),]       # delte the extra blank rows
   ms00 = ms0                             # make a copy of the data
   ms01 = ms0[,-1:-2]                     # get rid of the first 2 columns
   cnames = colnames(ms0)                 # column names
   genesets = unique(ms0$module)        # find the gene set numbers
                                          # forms the first line of output
   r = t(rbind(as.matrix(cnames),as.matrix(genesets)))
   Sm(f2,r)                               # write first line to output file

   # loop for each gene set
   for (g in genesets) { 
      ms1 = ms00[ms0$module == g, ];    # carve out each gene set
      ms1 = ms1[,-1:-2]                   # get rid of the first 2 columns
      me1 = msc(ms1)                      # compute the fp median
      sm(f2,cbind("", g, me1));           # write it to output file
      ms0 = cbind(ms0, t(scor(me1,ms01))) # compute the Sp-correlation and
   }                                      #   add that to the right of ms0
   sm(f2,ms0)                             # output the augmented ms0
}
