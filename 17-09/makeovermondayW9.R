

library(openxlsx)
library(tidyverse)
library(viridis)
library(scales)

setwd("./17-09")



amex_ori <- read.xlsx("AMEX 2016 Spending.xlsx", sheet = 1, detectDates = T)

amex <- amex_ori 

# amex_stats <- amex_ori %>% group_by(Category) %>% do(reults = summary(.))


# plot boxpolot with outlier
amex %>% ggplot(aes(x=Category, y=Amount, colour=Category)) + 
  geom_boxplot() + 
  scale_y_continuous(labels = dollar_format(prefix = "")) + 
  scale_color_viridis(discrete = T) + 
  theme_minimal() +
  theme(legend.position = "none"
        ) 


myIRQ <- function(Cat){
  return(amex_IQR$IQR[amex_IQR$Category == Cat])
}

# outlier
amex_IQR <- amex %>% group_by(Category) %>% summarise(IQR=IQR(Amount), sumCat = sum(Amount), countCat = n(), mean=mean(Amount))
amex_outlier <- amex %>% left_join(select(amex_IQR, Category, IQR)) %>% group_by(Category) %>%  
  filter(Amount > (1.5*IQR)| Amount < (-1.5 * IQR)) %>%  
  ungroup() 

#### plot stats w/o outliers ####
# 
amex_IQR %>% arrange(sumCat)  %>% 
  mutate(Category=factor(Category, levels = Category)) %>%
  ggplot(aes(x=Category, y="")) + 
  geom_count(aes(size = sumCat), show.legend = F, colour="dodgerblue") + 
  geom_text(aes(label=dollar_format(prefix = "\u00A3",big.mark = ",")(sumCat)), nudge_y = 0.15) + 
  scale_colour_hue()+
  theme_minimal()+
  labs(y="Summed spend", size="Spend") 


amex_IQR %>% arrange(meanCat)  %>% 
  mutate(Category=factor(Category, levels = Category)) %>%
  ggplot(aes(x=Category, y="")) + 
  geom_count(aes(size = meanCat), show.legend = F, colour="firebrick") + 
  geom_text(aes(label=dollar_format(prefix = "\u00A3",big.mark = ",")(meanCat)), nudge_y = 0.15) + 
  scale_colour_hue()+
  theme_minimal()+
  labs(y="Mean spend", size="Spend")

amex_IQR %>% arrange(countCat)  %>% 
  mutate(Category=factor(Category, levels = Category)) %>%
  ggplot(aes(x=Category, y="")) + 
  geom_count(aes(size = countCat), show.legend = F, colour="gold") + 
  geom_text(aes(label=countCat), nudge_y = 0.05) + 
  scale_colour_hue()+
  theme_minimal()+
  labs(y="Mean spend", size="Spend")

# plot outlier
amex_outlier %>% mutate(annotationValue = ifelse(Merchant ==  "BROKEN"|Merchant == "CORE", Amount+700, Amount-550)) %>% ggplot(aes(x=Category, y=Amount, colour= Category)) + 
  geom_point() +
  #geom_text(aes(y=annotationValue, label=paste(Date,Merchant, sep = ":\n")), position = "nudge", check_overlap =F, size= 3) +
  theme_minimal()+
  theme(legend.position = "none")

# create data.frame w/o outliers
amex_wo_outlier <- amex %>% setdiff(select(amex_outlier,-IQR))
amex_wo_outlier_stats <- amex_wo_outlier  %>% group_by(Category) %>% 
  summarise(sumCat = sum(Amount), countCat = n(), meanCat=mean(Amount)) %>% 
  mutate(sumCat = round(sumCat), meanCat=round(meanCat)) 



#### plot stats w/o outliers ####
# 
amex_wo_outlier_stats %>% arrange(sumCat)  %>% 
  mutate(Category=factor(Category, levels = Category)) %>%
  ggplot(aes(x=Category, y="")) + 
  geom_count(aes(size = sumCat), show.legend = F, colour="dodgerblue") + 
  geom_text(aes(label=dollar_format(prefix = "\u00A3",big.mark = ",")(sumCat)), nudge_y = 0.15) + 
  scale_colour_hue()+
  theme_minimal()+
  labs(y="Summed spend", size="Spend") 


amex_wo_outlier_stats %>% arrange(meanCat)  %>% 
  mutate(Category=factor(Category, levels = Category)) %>%
  ggplot(aes(x=Category, y="")) + 
  geom_count(aes(size = meanCat), show.legend = F, colour="firebrick") + 
  geom_text(aes(label=dollar_format(prefix = "\u00A3",big.mark = ",")(meanCat)), nudge_y = 0.15) + 
  scale_colour_hue()+
  theme_minimal()+
  labs(y="Mean spend", size="Spend")

amex_wo_outlier_stats %>% arrange(countCat)  %>% 
  mutate(Category=factor(Category, levels = Category)) %>%
  ggplot(aes(x=Category, y="")) + 
  geom_count(aes(size = countCat), show.legend = F, colour="gold") + 
  geom_text(aes(label=countCat), nudge_y = 0.15) + 
  scale_colour_hue()+
  theme_minimal()+
  labs(y="Mean spend", size="Spend")

#### plot boxplot w/o outliers ####
amex_wo_outlier %>% ggplot(aes(x=Category, y=Amount, colour= Category)) + 
  geom_boxplot() + 
  scale_y_continuous(labels = dollar_format(prefix = "\u00A3",big.mark = ",")) + 
  scale_color_viridis(discrete = T) + 
  theme_minimal()+
  theme(legend.position = "none")
