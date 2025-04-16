library(tidymodels)
library(palmerpenguins)

set.seed(17)
data(penguins)
penguins <- drop_na(penguins)
split_penguins <- initial_split(penguins, prop = 0.7)

split_train <- training(split_penguins)
split_test <- testing(split_penguins) 

nrow(split_train) * 1/10
split_folds <- vfold_cv(split_train, v = 10)

print(split_folds)
