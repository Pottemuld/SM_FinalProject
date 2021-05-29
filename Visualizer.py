import matplotlib as mpl

mpl.use('agg')

import matplotlib.pyplot as plt

################################################## All Persons In ######################################################
api_knn25_time = [262.97, 266.44, 243.33, 260.16, 269.03, 285.03, 266.22, 281.60, 269.12, 260.55]
api_knn276_time = [251.63, 266.57, 265.76, 271.30, 271.30, 263.80, 257.88, 244.08, 269.09, 349.72]
api_forest_time = [64.98, 65.75, 66.42, 65.75, 66.19, 65.95, 65.81, 65.75, 66.09, 67.12]

api_knn25_accuracy = [0.934, 0.931, 0.934, 0.930, 0.929, 0.931, 0.932, 0.930, 0.933, 0.933]
api_knn276_accuracy = [0.847, 0.847, 0.846, 0.837, 0.849, 0.854, 0.851, 0.849, 0.836, 0.850]
api_forest_accuracy = [0.895, 0.890, 0.890, 0.895, 0.888, 0.889, 0.892, 0.892, 0.890, 0.889]

api_time_data_to_plot = [api_knn25_time, api_knn276_time, api_forest_time]
api_accuracy_data_to_plot = [api_knn25_accuracy, api_knn276_accuracy, api_forest_accuracy]

################################################## Disjunct ############################################################
dj_knn25_time = [266.53, 319.06, 319.55, 322.17, 321.94, 320.01, 477.94, 391.13, 307.36, 364.14]
dj_knn276_time = [389.36, 512.79, 475.38, 337.50, 356.55, 303.83, 324.58, 308.00, 252.50, 253.15]
dj_forest_time = [74.69, 69.57, 67.45, 67.14, 68.89, 83.97, 76.09, 74.80, 76.61, 77.05]

dj_knn25_accuracy = [0.617625, 0.671000, 0.765900, 0.728900, 0.818500, 0.813600, 0.951000, 0.866100, 0.837750, 0.920125]
dj_knn276_accuracy = [0.568625, 0.640200, 0.706700, 0.675700, 0.766700, 0.730800, 0.905000, 0.825400, 0.760000, 0.882125]
dj_forest_accuracy = [0.543875, 0.634400, 0.652600, 0.578600, 0.777600, 0.827800, 0.929500, 0.861200, 0.781875, 0.875125]

dj_time_data_to_plot = [dj_knn25_time, dj_knn276_time, dj_forest_time]
dj_accuracy_data_to_plot = [dj_knn25_accuracy, dj_knn276_accuracy, dj_forest_accuracy]

########################################################################################################################
fig = plt.figure(1, figsize=(9, 6))

plt.xlabel("Algorithm")
plt.ylabel("Time")
plt.ylim(0, 550)


ax = fig.add_subplot(111)

bp = ax.boxplot(api_time_data_to_plot)
plt.xticks([1, 2, 3], [ 'kNN (k = 25)', 'kNN (k = 276)', 'Random Forest'])

fig.savefig("api_time_plot.png", bbox_inches='tight')

########################################################################################################################
ax.cla()
ax = fig.add_subplot(111)

plt.xlabel("Algorithm")
plt.ylabel("Accuracy")
plt.ylim(0.50, 1)

bp = ax.boxplot(api_accuracy_data_to_plot)
plt.xticks([1, 2, 3], [ 'kNN (k = 25)', 'kNN (k = 276)', 'Random Forest'])
fig.savefig("api_accuracy_plot.png", bbox_inches='tight')

########################################################################################################################
ax.cla()
ax = fig.add_subplot(111)

plt.xlabel("Algorithm")
plt.ylabel("Time")
plt.ylim(0, 550)

bp = ax.boxplot(dj_time_data_to_plot)
plt.xticks([1, 2, 3], [ 'kNN (k = 25)', 'kNN (k = 276)', 'Random Forest'])
fig.savefig("disjunct_time_plot.png", bbox_inches='tight')

########################################################################################################################
ax.cla()
ax = fig.add_subplot(111)

plt.xlabel("Algorithm")
plt.ylabel("Accuracy")
plt.ylim(0.50, 1)

bp = ax.boxplot(dj_accuracy_data_to_plot)
plt.xticks([1, 2, 3], [ 'kNN (k = 25)', 'kNN (k = 276)', 'Random Forest'])
fig.savefig("disjunct_accuracy_plot.png", bbox_inches='tight')
