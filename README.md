Introduction à la régression linéaire régularisées
================

L’objet de ce module est de présenter une introduction aux méthodes
régularisées qui sont devenues un outil indispensable à l’analyse de
données, en particulier issues des sciences du vivant. Il vise également
à fournir aux étudiants des compétences pratiques quant à l’utilisation
de ces méthodes à l’aide du logiciel `R`.

## Programme

Les deux journées commenceront par 3 heures de cours

  - Jour 1: les limites du modèles linéaires; la régression stepwise;
    introduction à la régularisation
  - Jour 2: la régularisation ridge, le lasso et leurs variantes pour le
    modèle linéaire

Les après-midi sont consacrées à des séances machines. Les méthodes
régularisées classiques seront évaluées sur des données simulées dont
le protocoles sera mis en place par les étudiants. Des données issues de
la génomique seront ensuite analysées.

L’évaluation se fera sous la forme d’un rapport associé au séances
machines et d’un projet d’analyse, à rendre avant

## Documents

  - [Les slides du cours]()
  - [l’énoncé des travaux dirigés]()

## Logiciel

Pour les tutoriaux, privilégiez une version récente de `R`
(<https://cran.r-project.org>) et Rstudio
(<http://rstudio.com/products/rstudio/download>).

VOus aurez également besoin des packages suivants:

``` r
install.packages("tidyverse") # manipulation et visualisation de données
install.packages("Matrix")    # 
install.packages("pbmcapply") # Calcul parallèle facile
install.packages("glmnet")    # lasso, ridge, elastic-net 
install.packages("grplasso")  # group-lasso
install.packages("picasso")   # méthode non convexe
install.packages("stabs")     # sélection stable par rééchantillonage
```
