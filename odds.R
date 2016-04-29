#devtools::install_github("hadley/ggplot2")
#devtools::install_github("hadley/tidyr")
library(ggplot2)
library(tidyr)
library(RColorBrewer)
odds <- read.csv("odds.csv")
odds <- gather(odds, X)
odds[,2] <- substring(odds[,2], 2)
colnames(odds) <- c("Team","Pick","Probability")
odds$Pick <- as.numeric(odds$Pick)
odds$Probability <- as.numeric(odds$Probability) * .01
odds$Team <- as.character(odds$Team)
odds$Team <- factor(odds$Team, levels = odds[1:14,1])
odds$Team <- factor(odds$Team, levels=rev(levels(odds$Team)))
odds$Pick <- factor(odds$Pick, levels = 1:14)
getPalette = colorRampPalette(brewer.pal(11, "Spectral"))(14)
odds$Probability <- ifelse(is.na(odds$Probability),0,odds$Probability)

g <- ggplot(odds, aes(Team))
g <- g + geom_bar(aes(x = Team, y = Probability, fill = Pick),alpha=0.9,stat="identity")  
g <- g + scale_y_continuous(expand = c(0, 0), breaks = seq(0, 1, by = 0.1),1,name="Probability", labels=scales::percent) +
    labs(x=NULL, y=NULL, title="2016 NHL Draft Lottery Probabilities",
         caption="@mikeleeco") +
    coord_flip() +
    scale_fill_manual(values = getPalette)

g <- g  + theme(
  axis.text.x = element_text(size=14,margin=margin(b=5),color = "black"),
  axis.title.x = element_text(size=18),
  plot.subtitle = element_text(size=14),
  plot.caption = element_text(size=18,margin = margin(t=2, b=5),face = "italic"),
  axis.text.y = element_text(size=18,colour = "black"),
  axis.ticks.y=element_blank(),
  axis.ticks.x=element_blank(),
  plot.title = element_text(size=30,margin = margin(b=10)),
  panel.border=element_blank(),
  panel.grid.major.x=element_line(color="#2b2b2b", linetype="dotted", size=0.15),
  panel.grid.major.y=element_blank(),
  legend.text = element_text(size=14),
  legend.title = element_text(size=18),
  legend.key = element_rect(fill="#DCDCDC",colour = "#DCDCDC"),
  legend.background = element_rect(fill="#DCDCDC"),
  panel.background = element_rect(fill="#DCDCDC"),
  plot.background = element_rect(fill="#DCDCDC")
)
g
