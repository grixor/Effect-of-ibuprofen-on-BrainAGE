#####
# This R script computes BrainAGE on the ibuprofen dataset (Dataset 2) and
# tests for the effect of different ibuprofen dosage (placebo, 200mg, 600mg) on BrainAGE
# 
# Study: Effect of Ibuprofen on BrainAGE: a randomized, placebo-controlled, 
# dose-response exploratory study.
#
# Authors: 
    # Trang T. Le, 
    # Rayus Kuplicki
    # Hung-wen Yeh
    # Robin L. Aupperle
    # Sahib S. Khalsa
    # W. Kyle Simmons
    # Martin P. Paulus
# 
#####


rm(list = ls())
 
list.of.packages <- c("ggplot2", "dplyr", "ICC", "psych", "lmerTest", "nlme")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
 
library(dplyr)
library(ggplot2)
library(psych)
library(lmerTest)
library(ICC)
library(psych)

#####
# # Need imaging data to run this chunk
# # load("ibuprofenData.RData")
# # save(demographic.ibu, ibu.merged, Y.ibu, file = "ibuDataNoImaging.RData")
# ibu.visits <- X.ibu$visit
# ibu.subjs <- X.ibu$id
# X.valid <- data.frame(X.ibu)
# Y.valid <- data.frame(Y.ibu)
# 
# # Apply the trained SVM-based regression:
# load("trainedSVM.Rdata")
# model <- fit.svm.para
# predicted_y <- predict(model, newdata = X.valid[,])
# allIBUpredictions <- data.frame(Y.valid, predicted_y, id = X.valid[, 'id'])
# allIBUpredictions <- mutate(allIBUpredictions, error = predicted_y - age)
# 
# save(allIBUpredictions, file = "ibuResults.RData")



##### 
# Loading results
load("ibuDataNoImaging.RData")
load("ibuResults.RData")
ibu.visits <- ibu.merged$visit
ibu.subjs <- ibu.merged$id


##### 
# Check the balance of dosage sequences:
checkBal <- matrix(ibu.merged$drug, ncol = 3, byrow = T)
table(apply(checkBal, 1, function(x) paste(x, sep = "_", collapse = "_")))


#####
# Compute ICC
cat("\n\n\n\nICC used residual age: ")
ibu.icc.mat <- t(matrix(allIBUpredictions[,"error"], nrow = 3))
psych::ICC(ibu.icc.mat)


#####
# Mixed effect models: assessing AIC
lme.dat <- data.frame(ibu.merged[ibu.merged$visit %in% ibu.visits, 
                                 c("id", "ageAtScan", "drug", "normalized.mpparg")], 
                      predicted_y = allIBUpredictions$predicted_y)
lme.dat <- mutate(lme.dat, error = predicted_y - ageAtScan)
lme.dat <- merge(lme.dat, demographic.ibu[, c("id", "Gender", "bmiEst")], by = "id")
lme.dat$drug <- as.factor(lme.dat$drug)

residualAge.drug1 <- nlme::lme(error ~ drug, 
                               random = ~ 1 | id, data = lme.dat)
residualAge.drug2 <- nlme::lme(error ~ drug + Gender + bmiEst, 
                               random = ~ 1 | id, data = lme.dat)
residualAge.drug3 <- nlme::lme(error ~ drug*Gender + drug*bmiEst, 
                               random = ~ 1 | id, data = lme.dat)
(summary(residualAge.drug1))
(summary(residualAge.drug2))
(summary(residualAge.drug3))


#####
# Calculate confidence intervals
# redo residualAge.drug2 with the with the lmerTest package
# to apply the confint function
# residualAge.drug0 <- lmerTest::lmer(error ~ drug + Gender + bmiEst + (1 | id), data = lme.dat)
residualAge.drug0 <- lmerTest::lmer(error ~ drug + (1 | id), data = lme.dat) 
# updated after revision round 2, exclude gender and BMI
            
summary(residualAge.drug0)
difflsmeans(residualAge.drug0, ddf = "Kenward-Roger")
confint(residualAge.drug0, method = "profile")


#####
# Compute Cohen's D:
errorAori <- lme.dat[lme.dat$drug == "A", ]
errorBori <- lme.dat[lme.dat$drug == "B", ]
errorCori <- lme.dat[lme.dat$drug == "C", ]
pairAB <- merge(errorAori, errorBori, by = "id")
diffAB <- pairAB$error.x - pairAB$error.y
nAB <- length(diffAB)
mean(diffAB)/sd(diffAB)
pairAC <- merge(errorAori, errorCori, by = "id")
diffAC <- pairAC$error.x - pairAC$error.y
nAC <- length(diffAC)
mean(diffAC)/sd(diffAC)

cohenDsAB <- vector(mode = "numeric")
cohenDsAC <- vector(mode = "numeric")
for (i in 1:1000){
  diffABi <- sample(diffAB, size = nAB, replace = T)
  cohenDsAB <- c(cohenDsAB, mean(diffABi)/sd(diffABi))
  diffACi <- sample(diffAC, size = nAC, replace = T)
  cohenDsAC <- c(cohenDsAC, mean(diffACi)/sd(diffACi))
}
meanCohenAB <- mean(cohenDsAB)
meanCohenAC <- mean(cohenDsAC)
quantile(cohenDsAB, c(0.05, 0.95))
quantile(cohenDsAC, c(0.05, 0.95))


#####
# Plot results
lme.plot <- lme.dat
levels(lme.plot$drug) <- c("Placebo", "200mg", "600mg")
colnames(lme.plot)[3] <- "Dosage"

p <- ggplot(data = lme.plot, aes(x = ageAtScan, y = predicted_y, group = id)) + 
  geom_line(colour = "gray") +
  geom_point(aes(shape = Dosage, fill = Dosage, colour = Dosage), size = 2) + 
  geom_abline(slope = 1) + theme_bw() + 
  theme(legend.position = "right", plot.title = element_text(hjust = 0.5)) + 
  guides(col=guide_legend(ncol=2))+
  scale_shape_manual(values=c(1, 0, 4)) + #scale_color_brewer(palette = "Dark2") +
  scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9")) +
  labs(x = "Chronological Age", y = "Brain-Predicted Age", title = "Plot of brain-predicted age vs. chronological age
       of subjects in the ibuprofen study")
p


brainAGEa <- lme.dat[lme.dat$drug=="A", c("id", "error")]
brainAGEb <- lme.dat[lme.dat$drug=="B", c("id", "error")]
brainAGEc <- lme.dat[lme.dat$drug=="C", c("id", "error")]
all.brainAGE <- merge(brainAGEb, brainAGEc, by = 1)
all.brainAGE <- merge(all.brainAGE, brainAGEa, by = 1)
diff1 <- all.brainAGE$error.x - all.brainAGE$error
diff2 <- all.brainAGE$error.y - all.brainAGE$error
mybox.df <- data.frame(diff1, diff2)
mybox.df <- reshape2::melt(mybox.df)

q <- ggplot(data = mybox.df, aes(x = variable, y = value, color = variable)) +
  geom_boxplot() +
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  theme_bw() + theme(legend.position = "None", plot.title = element_text(hjust = 0.5)) + 
  labs(x = bquote(Delta ~ "Dosage"), y = "brainAGE", title = "Effect of ibuprofen dosage 
on brainAGE") +
  scale_x_discrete( labels=c("200mg-Placebo", "600mg-Placebo"))
print(q)




