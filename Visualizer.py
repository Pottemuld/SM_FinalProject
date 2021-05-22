import matplotlib as mpl
import numpy as np

mpl.use('agg')

import matplotlib.pyplot as plt

knn25_time = [262.97, 266.44, 243.33, 260.16, 269.03, 285.03, 266.22, 281.60, 269.12, 260.55]
knn276_time = [251.63, 266.57, 265.76, 271.30, 271.30, 263.80, 257.88, 244.08, 269.09, 349.72]
forest_time = [64.98, 65.75, 66.42, 65.75, 66.19, 65.95, 65.81, 65.75, 66.09, 67.12]

knn25_accuracy = [0.934, 0.931, 0.934, 0.930, 0.929, 0.931, 0.932, 0.930, 0.933, 0.933]
knn276_accuracy = [0.847, 0.847, 0.846, 0.837, 0.849, 0.854, 0.851, 0.849, 0.836, 0.850]
forest_accuracy = [0.895, 0.890, 0.890, 0.895, 0.888, 0.889, 0.892, 0.892, 0.890, 0.889]

time_data_to_plot = [knn25_time, knn276_time, forest_time]
accuracy_data_to_plot = [knn25_accuracy, knn276_accuracy, forest_accuracy]

fig = plt.figure(1, figsize=(9, 6))
plt.xlabel("Algorithm")
plt.ylabel("Time")


ax = fig.add_subplot(111)

bp = ax.boxplot(time_data_to_plot)
plt.xticks([1, 2, 3], [ 'kNN (k = 25)', 'kNN (k = 276)', 'Random Forest'])

fig.savefig("time_plot.png", bbox_inches='tight')
ax.cla()
ax = fig.add_subplot(111)

plt.xlabel("Algorithm")
plt.ylabel("Accuracy")


bp = ax.boxplot(accuracy_data_to_plot)
plt.xticks([1, 2, 3], [ 'kNN (k = 25)', 'kNN (k = 276)', 'Random Forest'])
fig.savefig("accuracy_plot.png", bbox_inches='tight')

