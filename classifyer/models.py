# -*- coding: utf-8 -*-
# Модели
#
# Author: Egor Panfilov
#

import csv
import numpy as np
import matplotlib.pyplot as plt
from collections import OrderedDict

from sklearn.cross_validation import train_test_split, ShuffleSplit
from sklearn.metrics import confusion_matrix
from sklearn.learning_curve import learning_curve

# from sklearn.linear_model import RidgeClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
# from sklearn.svm import LinearSVC, SVC
from skll import metrics
from copy import deepcopy

# Путь к CSV с признаками
CSV_FEATURES = "../data/A03T.preprocessed.csv"


def _unpack_features_csv(samples=None):
    d = dict()
    for hdr in ['v12', 'v13', 'v14',
                'v23', 'v24', 'v34', 'c']:
        d[hdr] = []
    if not samples:
        samples = float('inf')

    # Форматируем данные о признаках
    with open(CSV_FEATURES, 'r') as f:
        reader = csv.DictReader(f, delimiter=',')
        for idx, entry in enumerate(reader):
            if idx >= samples:
                break
            for k in sorted(entry.keys()):
                tmp = float(entry[k])
                # Добавляем в дата-фрейм
                d[k].append(tmp)
    return d


def _dict_to_arrays(d):
    x_vec = None
    for k in (x for x in sorted(d.keys()) if
              x not in ['c']):
        if x_vec is None:
            x_vec = np.array(d[k])
        else:
            x_vec = np.vstack((x_vec, np.array(d[k])))

    x_vec = np.swapaxes(x_vec, 0, 1)
    y_vec = np.array(d['c'])
    return x_vec, y_vec


if __name__ == "__main__":
    n_all = 288

    dftrs = _unpack_features_csv()

    # Объединяем данные CSV и создаем вектора признаков и наблюдений
    x_all, y_all = _dict_to_arrays(dftrs)

    # Создаем тренировочное и тестовое множества
    x_train, x_test, y_train, y_test = \
        train_test_split(x_all, y_all, train_size=0.8)

    # Настраиваем модели
    models = OrderedDict()

    # models['rc'] = dict()
    # models['rc']['title'] = 'RigdeClassifier'
    # models['rc']['cl'] = RidgeClassifier(class_weight='auto')
    #
    # models['dt'] = dict()
    # models['dt']['title'] = 'DecisionTree'
    # models['dt']['cl'] = DecisionTreeClassifier()

    models['rf'] = dict()
    models['rf']['title'] = 'RandomForest'
    models['rf']['cl'] = RandomForestClassifier(n_estimators=10)

    # models['svm_lin'] = dict()
    # models['svm_lin']['title'] = 'SVM Linear'
    # models['svm_lin']['cl'] = LinearSVC(class_weight='auto')
    #
    # models['svm_rbf'] = dict()
    # models['svm_rbf']['title'] = 'SVM RBF'
    # models['svm_rbf']['cl'] = SVC(class_weight='auto', kernel='rbf', gamma=0.00001)

    # Обучаем модели
    for m in models.keys():
        models[m]['cl'].fit(x_train, y_train)

    # Прогнозируем
    for t in models.keys():
        models[t]['pred'] = models[t]['cl'].predict(x_test)

    # Строим матрицы неточностей
    for t in models.keys():
        models[t]['cm'] = confusion_matrix(y_test, models[t]['pred'])

    kappa = []
    # for idx in range(100):
    #     models['rf'] = dict()
    #     models['rf']['title'] = 'RandomForest'
    #     models['rf']['cl'] = RandomForestClassifier(n_estimators=100)
    #
    #     x_train, x_test, y_train, y_test = \
    #         train_test_split(x_all, y_all, train_size=0.8)
    #
    #     # Обучаем модели
    #     for m in models.keys():
    #         models[m]['cl'].fit(x_train, y_train)
    #
    #     # Прогнозируем
    #     for t in models.keys():
    #         models[t]['pred'] = models[t]['cl'].predict(x_test)
    #
    #     tmp = metrics.kappa(y_test, models['rf']['pred'])
    #     print(tmp)
    #     kappa.append(tmp)
    # print(sum(kappa) / len(kappa))

    tmp = metrics.kappa(y_test, models['rf']['pred'])
    print(tmp)

    # quit()

    # Визуализируем
    models_num = len(models)

    fig, axes = plt.subplots(nrows=2, ncols=models_num, squeeze=False)
    if True:
        # Строим confusion матрицы
        for (name, cm), ax in zip([(x['title'], x['cm'])
                                   for x in models.values()],
                                  axes.flat[:models_num]):
            m = ax.matshow(cm, cmap='Oranges')
            ax.set_title(name)
            ax.set_ylabel('True label')
            ax.set_xlabel('Predicted label')

            ax.set_xticks(np.linspace(0, 3, 4))
            ax.set_yticks(np.linspace(0, 3, 4))
            ax.grid('off')
            ax.xaxis.tick_top()

            for i in range(4):
                for j in range(4):
                    ax.text(j, i, '{:.2f}'.format(cm[i, j]),
                            size='medium',
                            ha='center', va='center')

        cv = ShuffleSplit(n_all, n_iter=100, test_size=0.2, random_state=0)
        train_sizes = np.linspace(.1, 1.0, 5)

        for (name, mdl), ax in zip([(x['title'], x['cl'])
                                    for x in models.values()],
                                   axes.flat[models_num:]):
            train_sizes, train_scores, test_scores = learning_curve(
                mdl, x_all, y_all, cv=cv, train_sizes=train_sizes
            )
            ax.set_xlabel('Score')

            train_scores_mean = np.mean(train_scores, axis=1)
            train_scores_std = np.std(train_scores, axis=1)
            test_scores_mean = np.mean(test_scores, axis=1)
            test_scores_std = np.std(test_scores, axis=1)
            ax.grid()

            ax.fill_between(train_sizes, train_scores_mean - train_scores_std,
                            train_scores_mean + train_scores_std, alpha=0.1,
                            color="r")
            ax.fill_between(train_sizes, test_scores_mean - test_scores_std,
                            test_scores_mean + test_scores_std, alpha=0.1, color="g")
            ax.plot(train_sizes, train_scores_mean, 'o-', color="r",
                    label="Training score")
            ax.plot(train_sizes, test_scores_mean, 'o-', color="g",
                    label="Cross-validation score")

            ax.legend(loc="best")

            ax.set_ylim((0.0, 1.05))

    # plt.tight_layout()
    plt.show()
