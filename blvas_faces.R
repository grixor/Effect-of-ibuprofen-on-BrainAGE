rm(list = ls())
library(reshape2)
library(lme4)

blvas_data <- read.csv('BLVAS.csv')
blvas_data$drug <- NA
subjToExclude <- names(which(table(blvas_data$record_id) < 3))
blvas_data <- blvas_data[!(blvas_data$record_id %in% subjToExclude), ]

blvas_data$drug[blvas_data$drugadm_type_1 == 1] <- 'A'
blvas_data$drug[blvas_data$drugadm_type_1 == 2] <- 'B'
blvas_data$drug[blvas_data$drugadm_type_1 == 3] <- 'C'
blvas_data$drug <- factor(blvas_data$drug)

blvas_data$blvas_dif_1 <- blvas_data$blvaspost_1 - blvas_data$blvaspre_1
blvas_data$blvas_dif_2 <- blvas_data$blvaspost_2 - blvas_data$blvaspre_2
blvas_data$blvas_dif_3 <- blvas_data$blvaspost_3 - blvas_data$blvaspre_3
blvas_data$blvas_dif_4 <- blvas_data$blvaspost_4 - blvas_data$blvaspre_4
blvas_data$blvas_dif_5 <- blvas_data$blvaspost_5 - blvas_data$blvaspre_5
blvas_data$blvas_dif_6 <- blvas_data$blvaspost_6 - blvas_data$blvaspre_6
blvas_data$blvas_dif_7 <- blvas_data$blvaspost_7 - blvas_data$blvaspre_7
blvas_data$blvas_dif_8 <- blvas_data$blvaspost_8 - blvas_data$blvaspre_8
blvas_data$blvas_dif_9 <- blvas_data$blvaspost_9 - blvas_data$blvaspre_9
blvas_data$blvas_dif_10 <- blvas_data$blvaspost_10 - blvas_data$blvaspre_10
blvas_data$blvas_dif_11 <- blvas_data$blvaspost_11 - blvas_data$blvaspre_11
blvas_data$blvas_dif_12 <- blvas_data$blvaspost_12 - blvas_data$blvaspre_12
blvas_data$blvas_dif_13 <- blvas_data$blvaspost_13 - blvas_data$blvaspre_13
blvas_data$blvas_dif_14 <- blvas_data$blvaspost_14 - blvas_data$blvaspre_14
blvas_data$blvas_dif_15 <- blvas_data$blvaspost_15 - blvas_data$blvaspre_15
blvas_data$blvas_dif_16 <- blvas_data$blvaspost_16 - blvas_data$blvaspre_16
blvas_data$wbpre_pain <- as.numeric(as.character(blvas_data$wbpre_pain)) #because one person responded "Low", convert that to NA and others from factor to numeric
blvas_data$pain_dif <- blvas_data$wbpost_pain - blvas_data$wbpre_pain

blvasSmall <- dplyr::select(blvas_data, 1, dplyr::starts_with("blvas_dif_"))
blvasSmall$drug <- blvas_data$drug
blvasPain <- merge(blvasSmall, blvas_data[, c("record_id", "drug", "pain_dif")], by = c("record_id", "drug"))
blvasPainMelt <- melt(blvasPain, id.vars=c("record_id", "drug"))
this_model <- lmer(value ~ drug + (1|record_id) + (1|variable), data = blvasPainMelt)
summary(this_model)
anova(this_model, ddf = "Kenward-Roger")
confint(this_model, method = "profile")

