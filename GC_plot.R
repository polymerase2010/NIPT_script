#!/usr/bin/Rscript

Args<-commandArgs()
cat(Args[6],Args[7],Args[8],"\n")
sample=strsplit(Args[6],split=".",fixed=TRUE)
#sample[[1]][1]
pdf(paste(sample[[1]][1],"_GC_content.pdf",sep=""))
par(mfrow=c(2,2));
a=read.table(Args[6])
file1=paste(Args[6],"_gc_plot.pdf",sep="")
#pdf(file1)
plot(a[,5],a[,6],main=Args[6],xlab="GC_content",ylab="Reads count per 60kb")
#dev.off()

b=read.table(Args[7])
file2=paste(Args[7],"_gc_plot.pdf",sep="")
#pdf(file2)
plot(b[,5],b[,7],main=Args[7],xlab="GC_content",ylab="Corrected reads count per 60kb")
#dev.off()

c=read.table(Args[8])
file3=paste(Args[8],"_gc_plot.pdf",sep="")
#pdf(file3)
plot(c[,1],c[,2],main=Args[8],xlab="GC_content",ylab="Average reads count per 60kb")
dev.off()

q()
