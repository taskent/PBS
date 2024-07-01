#set working directory
setwd('/mnt/NEOGENE1/toTransfer/workshopfiles/PBS')

#load data
af_euas =read.table("af_euas_norep.chr2.windowed.weir.fst", header = T)
head(af_euas)
dim(af_euas)

af_eas=read.table("af_eas_norep.chr2.windowed.weir.fst", header = T)
head(af_eas)
dim(af_eas)

eas_euas=read.table("eas_euas_norep.chr2.windowed.weir.fst", header = T)
head(eas_euas)
dim(eas_euas)

#merge data
merged=merge(af_euas,af_eas,by=c('CHROM', 'BIN_START', 'BIN_END'))
merged=merge(merged,eas_euas,by=c('CHROM', 'BIN_START', 'BIN_END'))

head(merged)
dim(merged)

#save only columns showing Weir and Cockerham's Fst estimates
Fst=merged[,c(5,8,11)]
colnames(Fst) = c('af_euas', 'af_eas', 'eas_euas')

#convert negative Fst estimates to zero 
Fst[Fst<0]=0
head(Fst)

#estimate branch lengths using Fst values
t_Fst=-log10(1-Fst)
head(t_Fst)

#compute PBS and attach it to the 'merged' dataset
merged$PBS=(t_Fst$eas_euas + t_Fst$af_eas - t_Fst$af_euas)/2
head(merged)
dim(merged)

###############
#save PBS data as a .bed file
merged$CHROM = paste('chr', merged$CHROM, sep ='')
write.table(merged[,c(1:3,13)],'PBS.bed', col.names = F, row.names = F, quote = F, sep = '\t')
###############

#create a color column, make windows intersecting w/EDAR gene transcript (start pos = 109510927 and end position = 109605676) red
merged$color = rep('gray45', dim(merged)[1])
merged$color[(merged$BIN_START >= 109510927 & merged$BIN_START <= 109605676) | (merged$BIN_END >= 109510927 & merged$BIN_END <= 109605676) ] = 'red'

#save the plot
pdf("plot_pbs.pdf",height=5,width=8)
plot(merged$PBS~merged$BIN_START,pch=20,col=merged$color,xlab="POS",ylab="PBS",las=1)
abline(h=mean(merged$PBS)+4.743332*sqrt(var(merged$PBS)), lty=2)
dev.off()


