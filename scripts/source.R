# Define some useful functions

## Necessary libraries
library(tidyverse)
library(haven)
library(ggthemes)
library(ftplottools)
library(lfe)
library(stargazer)
library(tidymodels)

## Negate the %in% operator (for convenience)

`%notin%` <- Negate(`%in%`)

