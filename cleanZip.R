library(tidyverse)

data <- read_csv("parsed1.csv")
zip <- data$zip
bail_amount <- data$bail_amount
# Create new data frame
dat_new <- data.frame(zip=zip, bail_amount=bail_amount)
dat_new <- na.omit(dat_new)
write.csv(dat_new,"zipVsBailAmount.csv")#, row.names = FALSE)

#print(zip)

