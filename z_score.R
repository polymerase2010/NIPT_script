#!/usr/bin/Rscript

Args<-commandArgs()
data=read.table(Args[6],header=TRUE)
out=paste(Args[6],'.pdf')
pdf(out)
#data
chr=c(1:22,'X','Y')
ymax=max(data[,2],4)
ymin=min(data[,2],-4)
plot(data[,2],xaxt="n",xlab="Chrom",ylab="z_score",ylim=c(ymin,ymax),col=rainbow(26))
axis(side=1,at=c(1:24),labels=c(1:22,'X','Y'),cex.axis=0.7)
#par(new=TRUE)
abline(h=c(-3,0,3))
