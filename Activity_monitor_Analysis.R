activity<-read.csv("activity.csv",na.strings = "NA")

activity$date<-as.Date(activity$date,"%Y-%m-%d")

AC_by_day<-aggregate(activity$steps,by=list(activity$date),FUN="sum",na.rm=TRUE)

names(AC_by_day)<-c("date","total.steps")

library(ggplot2)
g<-qplot(total.steps,data=AC_by_day,binwidth=500)

g+labs(title="Total Steps per Day")

dev.copy(png,"plot1.png")
dev.off()

StpMean<-mean(AC_by_day$total.steps,na.rm=TRUE)

StpMedian<-median(AC_by_day$total.steps,na.rm=TRUE)


#________________________________________________-

AC_by_Int<-aggregate(activity$steps,by=list(activity$interval),FUN="mean",na.rm=TRUE)
names(AC_by_Int)<-c("Interval","steps")

qplot(AC_by_Int$Interval,AC_by_Int$steps,
         geom=c("line"),
         xlab="Interval Order",ylab="Average steps across all days"
      )

dev.copy(png,"plot2.png")
dev.off()

IntStepMax<-AC_by_Int[which.max(AC_by_Int$steps),1]

#--------------------------------------------------

Num_NA<-sum(is.na(activity$steps))

ind_NA<-which(is.na(activity$steps)==TRUE)
activity2<-activity

for (i in ind_NA) {
      activity2$steps[i]<-AC_by_Int$steps[AC_by_Int$Interval==activity2$interval[i]]
}

sum(is.na(activity2))

AC_by_day2<-aggregate(activity2$steps,by=list(activity2$date),FUN="sum",na.rm=TRUE)

names(AC_by_day2)<-c("date","total.steps")

g<-qplot(total.steps,data=AC_by_day2,binwidth=500)

g+labs(title="Total Steps per Day after Adding Missing Values")

dev.copy(png,"plot3.png")
dev.off()

StpMean2<-mean(AC_by_day2$total.steps,na.rm=TRUE)

StpMedian2<-median(AC_by_day2$total.steps,na.rm=TRUE)

#------------------------------------------------------
tmp<-weekdays(activity2$date)
tmp2<-sapply(tmp,function(x) {
              if (x=="Saturday"|x=="Sunday") "Weekend"
              else   "Weekday"
})

activity2<-cbind(activity,tmp,tmp2)

names(activity2)[4:5]<-c("Weekday.name","Weekday")

AC_by_Int2<-aggregate(activity2$steps,by=list(activity2$Weekday, activity$interval),FUN="mean",na.rm=TRUE)
names(AC_by_Int2)<-c("Weekday","Interval","steps")

AC_by_Int2$Weekday<-as.factor(AC_by_Int2$Weekday)

g<-ggplot(AC_by_Int2,aes(Interval,steps))
g+geom_line()+facet_grid(Weekday~.)

dev.copy(png,"plot4.png")
dev.off()


