# Indukowane Reguły Decyzyjne — projekt Data Science w R

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?style=for-the-badge&logo=rstudio&logoColor=white)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-FF6F00?style=for-the-badge&logo=scikitlearn&logoColor=white)
![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey?style=for-the-badge)

Projekt zaliczeniowy z przedmiotu **Indukowane Reguły Decyzyjne (IRD)** — budowa
i ocena modeli klasyfikacyjnych metodą reguł decyzyjnych, z pełną analizą danych,
modelowaniem i ewaluacją jakości w środowisku **R / RStudio**.

> **Autorzy (grupa GR8):** Olga Lewandowska, Krzysztof Owczarek, Julia Cymbalista,
> Aleksandra Nowak, Mikołaj Rostkowski · Warszawa, styczeń 2024

---

## O projekcie

Celem projektu jest zbudowanie modeli klasyfikacyjnych opartych na regułach
decyzyjnych i ocena, które zmienne najlepiej wyjaśniają badane zjawisko. Praca
obejmuje pełny cykl: od przygotowania i transformacji danych, przez selekcję
zmiennych (Information Value / Weight of Evidence), po trenowanie modeli i ich
porównanie za pomocą standardowych metryk jakości.

W repozytorium znajdują się dwa elementy:

- **Raport końcowy (PDF)** — analiza decyzyjna na zbiorze HR Analytics (zmiana
  pracy specjalistów Data Science / Big Data, dane z Kaggle), z opisem problemu,
  danych, modelu i interpretacją wyników.
- **Skrypt R** — kod analizy klasyfikacyjnej (drzewa decyzyjne, las losowy,
  IV/WoE, krzywe ROC i Lift) wraz z funkcjami oceny modeli.

## Stos technologiczny

| Obszar | Narzędzia |
| --- | --- |
| Język i środowisko | R, RStudio |
| Modelowanie | `rpart`, `rpart.plot` (drzewa decyzyjne), `randomForest` (las losowy) |
| Selekcja zmiennych | `Information` (Information Value / WoE) |
| Ewaluacja | `ROCR`, `pROC`, `caret` (ROC, AUC, Lift, macierz pomyłek) |
| Manipulacja danych | `dplyr` |
| Wizualizacja | `ggplot2`, `corrplot` |

## Zastosowane metody

- Przygotowanie i czyszczenie danych, kodowanie zmiennej objaśnianej (binarnej)
- Analiza siły predykcyjnej zmiennych: **Information Value (IV)** i **Weight of Evidence (WoE)**
- Analiza korelacji i współzależności (`corrplot`)
- **Drzewa klasyfikacyjne** (`rpart`) z różnymi parametrami przycinania (`cp`)
- **Las losowy** (`randomForest`) z oceną ważności zmiennych
- Ocena jakości: dokładność (accuracy), precyzja, czułość, swoistość, **F1**, **AUC**
- Wizualizacja: krzywe **ROC**, krzywe **Lift**, histogramy rozkładów zmiennych

## Zawartość repozytorium

- `ird-projekt.R` — skrypt analizy w R (modelowanie i ewaluacja)
- `IRD_Raport_Koncowy_GR8.pdf` — pełny raport zaliczeniowy projektu

## Jak uruchomić skrypt R

1. Otwórz `ird-projekt.R` w RStudio.
2. Zainstaluj wymagane pakiety (skrypt instaluje część z nich automatycznie):
   ```r
   install.packages(c("Information", "dplyr", "ggplot2", "corrplot",
                      "rpart", "rpart.plot", "randomForest",
                      "ROCR", "pROC", "caret"))
   ```
3. Ustaw katalog roboczy (`setwd(...)`) na folder z danymi i podmień ścieżkę na własną.
4. Uruchamiaj kod sekcjami.

> Uwaga: plik z danymi (CSV) nie jest dołączony do repozytorium — wskaż własną ścieżkę
> do zbioru danych w `read.csv2(...)`.

## Źródła danych

- HR Analytics — [Kaggle: Job change of Data Scientists](https://www.kaggle.com/datasets/arashnic/hr-analytics-job-change-of-data-scientists)

## Tagi

`#DataScience` `#MachineLearning` `#RStats` `#RLang` `#DecisionTrees`
`#RandomForest` `#Classification` `#ROC` `#AUC` `#InformationValue`
`#WeightOfEvidence` `#ggplot2` `#RStudio`

## Licencja

Treść projektu udostępniona na licencji [CC BY 4.0](LICENSE) — możesz dzielić się nią
i adaptować pod warunkiem podania autorstwa.
