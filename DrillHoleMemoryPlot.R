require(ggplot2)
require(reshape2)

log1<-"log911nopoly.csv"
log2<-"log911large.csv"

name1<-"noaccel"
name2<-"accel"

log1 <- read.delim(log1, stringsAsFactors=FALSE)
log2 <- read.delim(log2, stringsAsFactors=FALSE)

log1_row<-nrow(log1)
log2_row<-nrow(log2)

# Trim both data.frame to same size
if(log1_row < log2_row)
{
  log2<-log2[1:log1_row,]
} else
{
  log1<-log1[1:log2_row,]
}
  
 


# Create sequence for minimum
maxnum<-min(log1_row,log2_row)
num <- seq(from=1,to=maxnum)

# Create empty data frames
handles<-data.frame(matrix(ncol=0,nrow=maxnum))
vm<-data.frame(matrix(ncol=0,nrow=maxnum))
ws<-data.frame(matrix(ncol=0,nrow=maxnum))
commit<-data.frame(matrix(ncol=0,nrow=maxnum))

# Copy columns to new dataframe
handles[[1]]<-num
handles[[2]]<-log1$HANDLES
handles[[3]]<-log2$HANDLES

# Copy columns to new dataframe
vm[[1]]<-num
vm[[2]]<-log1$VM
vm[[3]]<-log2$VM

# Copy columns to new dataframe
ws[[1]]<-num
ws[[2]]<-log1$WS
ws[[3]]<-log2$WS

# Copy columns to new dataframe
commit[[1]]<-num
commit[[2]]<-log1$COMMITSIZE
commit[[3]]<-log2$COMMITSIZE

# Rename column names
colnames(handles)<-c("id",name1,name2)
colnames(vm)<-c("id",name1,name2)
colnames(ws)<-c("id",name1,name2)
colnames(commit)<-c("id",name1,name2)

# Reshape dataframe using melt to plot properly using ggplot2
handles<-melt(handles,id.vars=c("id"))
vm<-melt(vm,id.vars=c("id"))
ws<-melt(ws,id.vars=c("id"))
commit<-melt(commit,id.vars=c("id"))

p1<- ggplot(ws,aes(x=id,y=value, color=variable),geom="smooth")+geom_line()+geom_smooth(method="lm")+xlab("time")+ylab("Kb")+ggtitle("Working Set")
p2<- ggplot(vm,aes(x=id,y=value, color=variable),geom="smooth")+geom_line()+geom_smooth(method="lm")+xlab("time")+ylab("Kb")+ggtitle("Virtual Memory")
p3<- ggplot(commit,aes(x=id,y=value, color=variable),geom="smooth")+geom_line()+geom_smooth(method="lm")+xlab("time")+ylab("Kb")+ggtitle("Commit Size")
p4<- ggplot(handles,aes(x=id,y=value, color=variable),geom="smooth")+geom_line()+geom_smooth(method="lm")+xlab("time")+ylab("Kb")+ggtitle("Handles")
