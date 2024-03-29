# -*- coding: utf-8 -*-
"""Regression.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1tMVMKBDLn5itpLkQOb-oJ_2mcUJykGUV
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

dataset = pd.read_csv('pythoninput_final.csv')
dataset.head()

x = dataset.drop(['Response'], axis = 1)
y = dataset['Response']

from sklearn.model_selection import train_test_split
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.2, random_state = 42)

pip install mlxtend --upgrade

from mlxtend.feature_selection import SequentialFeatureSelector as sfs
from sklearn.linear_model import LinearRegression
lreg = LinearRegression()
sfs1 = sfs(lreg, k_features = 5, forward = True, verbose = 2, scoring = 'neg_mean_squared_error')
sfs1 = sfs1.fit(x_train, y_train)

feat_names = list(sfs1.k_feature_names_)
print(feat_names)

new_train_data = x_train[feat_names]
print(new_train_data)
new_train_data.head()

from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(new_train_data, y_train)

from sklearn.ensemble import RandomForestRegressor
regressor = RandomForestRegressor()
regressor.fit(new_train_data, y_train)

from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
regressor = SVR()
regressor.fit(new_train_data, y_train)
parameters = [{'C': [0.25, 0.5, 0.75, 1, 10, 20, 50, 100], 'kernel': ['rbf', 'linear'], 'gamma': [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]}]
grid_search = GridSearchCV(estimator = regressor,
                           param_grid = parameters,
                           scoring = 'r2',
                           cv = 10,
                           n_jobs = -1)
grid_search.fit(new_train_data, y_train)
best_parameters = grid_search.best_params_
print("Best Parameters:", best_parameters)

from sklearn.svm import SVR
regressor = SVR(kernel = 'rbf', gamma = 0.1, C = 0.75)
regressor.fit(new_train_data, y_train)

y_pred_train = regressor.predict(new_train_data)
y_pred_train

from sklearn.metrics import r2_score,mean_squared_error, mean_absolute_error
mse_train = mean_squared_error(y_train, y_pred_train)
RMSE_train = np.sqrt(mse_train)
rsq_train = r2_score(y_train, y_pred_train)
mae_train = mean_absolute_error(y_train, y_pred_train)
print(RMSE_train)
print(rsq_train)
print(mae_train)

new_test_data = x_test[feat_names]
#print(new_test_data)

y_pred_test = regressor.predict(new_test_data)
y_pred_test

from sklearn.metrics import r2_score,mean_squared_error,mean_absolute_error
mse_test = mean_squared_error(y_test, y_pred_test)
RMSE_test = np.sqrt(mse_test)
rsq_test = r2_score(y_test, y_pred_test)
mae_test = mean_absolute_error(y_test, y_pred_test)
print(RMSE_test)
print(rsq_test)
print(mae_test)
