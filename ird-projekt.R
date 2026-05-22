rm(list=ls())

getwd()

install.packages("Information")
library(Information)
library(dplyr)
library(ggplot2)
install.packages("corrplot")
library(corrplot)

setwd("C:/Moje Projekty w R/Indukowane Reguły Decyzyjne")

dane <-  read.csv2(file = "schooldropout.csv", header = TRUE, sep = ",", dec = ".")

#mydata.cor = cor(nowedane)

dane$ge <- ifelse(dane$Target == "Enrolled", 1 , 0)


nowedane <- filter(.data = dane, dane$ge == 0)


nowedane$dropout <- ifelse(nowedane$Target == "Dropout", 1 , 0)

nowedane <- nowedane[-36]
nowedane <- nowedane[-35]


nowedane <- nowedane[-31]
nowedane <- nowedane[-29]
nowedane <- nowedane[-28]
nowedane <- nowedane[-27]
nowedane <- nowedane[-26]

nowedane <- nowedane[-25]
nowedane <- nowedane[-23]
nowedane <- nowedane[-22]
nowedane <- nowedane[-21]
nowedane <- nowedane[-20]


IV <- create_infotables(data=nowedane, y="dropout", bins=10, parallel=FALSE)
IV_Value = data.frame(IV$Summary)
sumaziv <- c("Suma", sum(IV_Value$IV))
IV_Value <-  rbind(IV_Value, sumaziv)

ggplot() + geom_histogram(aes(nowedane$dropout)) + labs(title = "Histogram opuszczeń", x = "1 - opuszczone, 0 - nieopuszczone", y = "Ilość zmiennych każdego rodzaju") + 
  theme(plot.title = element_text(hjust = 0.5))



myData <- abs(rnorm(1000))
binwidth <- 0.55
# create plot    
library(ggplot2)   # CRAN version 2.2.1 used

zmienna = nowedane$Age.at.enrollment
n_bins <- length(ggplot2:::bin_breaks_width(range(zmienna), width = binwidth)$breaks) - 1L
ggplot() + geom_histogram(aes(zmienna), binwidth = binwidth, fill = rainbow(n_bins), position = "dodge") + labs(title = "Histogram zmiennej Age at enrollment", x = "Wiek w którym rozpoczęto studia", y = "Ilość") + 
  theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(labels = scales::number_format(accuracy = 0.2)) + 
  geom_line(aes(zmienna, nowedane$Marital.statuscheck), color = "black")
  

agg_tbl <- nowedane %>% group_by(Age.at.enrollment) %>% 
  summarise(valued = sum(dropout),
            .groups = 'drop')

nowedane$Marital.statuscheck <- agg_tbl$valued[match(zmienna, agg_tbl$Age.at.enrollment)]

####################################################################################################
# neutralny kod 
# nazwa kolumny z tabelki nowe dane
##########################################Zmiany##########################################

#nazwa danych + nazwa kolumny -> nowedane$nazwa kolumny
w = nowedane$Application.mode


####### group_by(nazwa kolumny)

agg_tbl <- nowedane %>% group_by(Application.mode) %>% 
  summarise(valued = sum(dropout),
            .groups = 'drop')

# agg_tbl$nazwa kolumny

l = agg_tbl$Application.mode

#####################################################################

nowedane$check <- agg_tbl$valued[match(w, l)]

ggplot(nowedane) + geom_histogram( aes(w)) + 
  labs(title = "Rozkład zmiennnej Martial Status i rozkład klasy pozytywnej", x = "Wartość zmiennej", y = "Częstość") + xlim(0.5,6.5) + 
  geom_line(aes(w, nowedane$check), color = "red") + theme()


#######################################################################################
#####################################################################################

library(rpart)
library(rpart.plot)

set.seed(1)
train_proportion <- 0.7
train_index <- runif(nrow(nowedane)) < train_proportion
train <- nowedane[train_index,]
test <- nowedane[!train_index,]

# budujemy i porownujemy 2 drzewa klasyfikacyjne
d.klas1 <- rpart(dropout~ ., data = train, method = "class", cp = 0.01)
d.klas2 <- rpart(dropout~., data = train, method = "class", cp = 0.005)
#plot(d.klas, margin = 0.2)
#text(d.klas, pretty = 0)
rpart.plot(d.klas1, under=FALSE, cex = 0.7)

rpart.plot(d.klas2, under=FALSE, cex = 0.65)





# 3) Macierz pomylek + statystyki oceniajace jakosc modeli
CM <- list()
CM[["d.klas1"]] <- table(predict(d.klas1, new = test, type = "class"), test$dropout)
CM[["d.klas2"]] <- table(predict(d.klas2, new = test, type = "class"), test$dropout)

EvaluateModel <- function(classif_mx)
{
  # Sciagawka: https://en.wikipedia.org/wiki/Sensitivity_and_specificity#Confusion_matrix
  true_positive <- classif_mx[1,1]
  true_negative <- classif_mx[2,2]
  condition_positive <- sum(classif_mx[ ,1])
  condition_negative <- sum(classif_mx[ ,2])
  predicted_positive <- sum(classif_mx[1, ])
  predicted_negative <- sum(classif_mx[2, ])
  # Uzywanie zmiennych pomocniczych o sensownych nazwach
  # ulatwia zrozumienie, co sie dzieje w funkcji
  accuracy <- (true_positive + true_negative) / sum(classif_mx)
  MER <- 1 - accuracy # Misclassification Error Rate
  # inaczej: MER < - (false_positive + false_positive) / sum(classif_mx)
  precision <- true_positive / predicted_positive
  sensitivity <- true_positive / condition_positive # inaczej - Recall / True Positive Rate (TPR)
  specificity <- true_negative / condition_negative
  F1 <- (2 * precision * sensitivity) / (precision + sensitivity)
  return(list(accuracy = accuracy, 
              MER = MER,
              precision = precision,
              sensitivity = sensitivity,
              specificity = specificity,
              F1 = F1))
  # Notacja "accuracy = accuracy" itd. jest potrzebna,
  # zeby elementy listy mialy nazwy.
}

EvaluateModel(CM[["d.klas1"]])
EvaluateModel(CM[["d.klas2"]])

#########################################################################################


library(randomForest)










varImpPlot(rf, cex = 0.55, title("Random Forest") )



EvaluateModel <- function(classif_mx)
{
  # Sciagawka: https://en.wikipedia.org/wiki/Sensitivity_and_specificity#Confusion_matrix
  true_positive <- classif_mx[1,1]
  true_negative <- classif_mx[2,2]
  condition_positive <- sum(classif_mx[ ,1])
  condition_negative <- sum(classif_mx[ ,2])
  # Uzywanie zmiennych pomocniczych o sensownych nazwach
  # ulatwia zrozumienie, co sie dzieje w funkcji
  accuracy <- (true_positive + true_negative) / sum(classif_mx)
  sensitivity <- true_positive / condition_positive
  specificity <- true_negative / condition_negative
  return(list(accuracy = accuracy, 
              sensitivity = sensitivity,
              specificity = specificity))
  # Notacja "accuracy = accuracy" itd. jest potrzebna,
  # zeby elementy listy mialy nazwy.
}



rf_classif_mx <- table(predict(rf, new = test, type = "class"), test$dropout)
EvaluateModel(rf_classif_mx)

# Dla porownania: drzewo klasyfikacyjne (powtorzenie z poprzednich zajec)

dtree <- rpart(income ~., data = train,  method = "class")
dtree_classif_mx <- table(predict(dtree, new = test, type = "class"), test$income)
EvaluateModel(dtree_classif_mx)

# Ale jakie AUC dla drzewa?
prognoza_ciagla <- predict(dtree, newdata = test)
prognoza_ciagla <- as.vector(prognoza_ciagla[,2])
(perf_auc <- performance(prediction(prognoza_ciagla, test$income),"auc")@y.values[[1]])

# A jakie bedzie dla lasu losowego?

## wykresy diagnostyczne - znow powtorka

forecast <- predict(rf, newdata = test, type = "prob")[,2]
plottingData <- prediction(forecast, test$dropout)

# krzywa ROC - potrzebuje "ciaglej" prognozy
plot(performance(plottingData,"tpr","fpr"),lwd=2, colorize=T) 

#AUC (Area Under Curve) - pole pod krzywa ROC
performance(plottingData,"auc")@y.values[[1]]
# skladnia obiektowa: @ zamiast $, [[1]] do wyciagniecia elementu z listy

# Sensitivity/specificity plots ~ trade-off
plot(performance(plottingData ,"sens","spec"),lwd=2) 

# Lift chart
plot(performance(plottingData ,"lift","rpp"),lwd=2, col = "darkblue") 



EvaluateModel <- function(classif_mx){
  true_positive <- classif_mx[2, 2]
  true_negative <- classif_mx[1, 1]
  condition_positive <- sum(classif_mx[ , 2])
  condition_negative <- sum(classif_mx[ , 1])
  predicted_positive <- sum(classif_mx[2, ])
  predicted_negative <- sum(classif_mx[1, ])
  
  accuracy <- (true_positive + true_negative) / sum(classif_mx)
  MER <- 1 - accuracy # Misclassification Error Rate
  # inaczej: MER < - (false_positive + false_positive) / sum(classif_mx)
  precision <- true_positive / predicted_positive
  sensitivity <- true_positive / condition_positive # inaczej - Recall / True Positive Rate (TPR)
  specificity <- true_negative / condition_negative
  F1 <- (2 * precision * sensitivity) / (precision + sensitivity)
  return(list(accuracy = accuracy, 
              MER = MER,
              precision = precision,
              sensitivity = sensitivity,
              specificity = specificity,
              F1 = F1))
}

CM <- list()
CM[["rf"]] <- table(predict(rf, new = test, type = "class"), as.factor(test$dropout))


lapply(CM, EvaluateModel)
sapply(CM, EvaluateModel)









library(ROCR)
library(dplyr)
library(randomForest)
library(caret)
library(pROC)

rf <- randomForest(as.factor(dropout) ~., data = train, ntree = 100, importance = TRUE)


# Predykcje na zbiorze testowym
predictions <- predict(rf, test, type = "prob")[,2]  # Prawdopodobieństwa dla klasy pozytywnej

# Dodanie predykcji do zbioru testowego
test$predicted_prob <- predictions

# Tworzenie obiektu prediction
pred <- prediction(predictions, test$dropout)

# Tworzenie obiektu performance dla krzywej lift
perf <- performance(pred, "lift", "rpp")  # "rpp" to rate of positive predictions

# Rysowanie krzywej lift
plot(perf, main="Krzywa Lift dla zmiennej dropout (Random Forest)", col="blue")

roc_obj <- roc(test$dropout, predictions)

# Wyświetlanie podstawowych informacji o krzywej ROC
print(roc_obj)

# Rysowanie krzywej ROC
plot(roc_obj, main = "Krzywa ROC dla zmiennej dropout (Random Forest)", col = "blue")


plot(roc_obj1, main = "Krzywa ROC dla zmiennej dropout cp = 0.01", col = "blue")
plot(roc_obj2, main = "Krzywa ROC dla zmiennej dropout cp = 0.005", col = "blue")




sum(nowedane$dropout)



###############################################################################3
# Predykcje na zbiorze testowym
predictions1 <- predict(d.klas1, test, type = "prob")[,2]  # Prawdopodobieństwa dla klasy pozytywnej

# Dodanie predykcji do zbioru testowego
test$predicted_prob1 <- predictions1

# Tworzenie obiektu prediction
pred1 <- prediction(predictions1, test$dropout)

# Tworzenie obiektu performance dla krzywej lift
perf1 <- performance(pred1, "lift", "rpp")  # "rpp" to rate of positive predictions

roc_obj1 <- roc(test$dropout, predictions1)

# Wyświetlanie podstawowych informacji o krzywej ROC
print(roc_obj1)




# Rysowanie krzywej lift
plot(perf1, main="Krzywa Lift dla zmiennej dropout cp = 0.01", col="blue")


danekorelacja <- select(nowedane, Course,Daytime.evening.attendance,Displaced,Debtor,Tuition.fees.up.to.date,Gender,Scholarship.holder,Age.at.enrollment,Curricular.units.1st.sem..grade.,Curricular.units.2nd.sem..grade. )

macierz_korelacji <- cor(danekorelacja)

# Krok 3: Wyświetl macierz korelacji
print(macierz_korelacji)



#######################################################################################3333
# Predykcje na zbiorze testowym
predictions2 <- predict(d.klas2, test, type = "prob")[,2]  # Prawdopodobieństwa dla klasy pozytywnej

# Dodanie predykcji do zbioru testowego
test$predicted_prob2 <- predictions2

# Tworzenie obiektu prediction
pred2 <- prediction(predictions2, test$dropout)

# Tworzenie obiektu performance dla krzywej lift
perf2 <- performance(pred2, "lift", "rpp")  # "rpp" to rate of positive predictions

roc_obj2 <- roc(test$dropout, predictions2)


plot(perf2, main="Krzywa Lift dla zmiennej dropout cp = 0.005", col="blue")


ggplot() + geom_line(aes(1-roc_obj$specificities, roc_obj$sensitivities), col = "red") + 
  geom_line(aes(1-roc_obj1$specificities,roc_obj1$sensitivities), col = "blue") + geom_line(aes(1-roc_obj2$specificities,roc_obj2$sensitivities), col = "black") +
labs(title = "Porównanie Krzywych ROC dla RF, M1, M2", x = "True Positive (red = rf, black = M1, blue = M2)", y = "False Positive") + theme(plot.title = element_text(hjust = 0.5))
  
  


#######################################################################################3333
#######################################################################################3333
#######################################################################################3333

  





