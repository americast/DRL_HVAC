import scipy.io
import pudb
from tqdm import tqdm
import matplotlib.pyplot as plt
import math

NUM_ZONES = 7
all_weather = []
weather_file = open("data/weather_all.txt", "r")
while True:
    line = weather_file.readline()
    if not line:
        break
    all_weather.append(float(line.strip()))
weather_file.close()

zone_temps = []
zone_temp_diffs = []
for i in range(NUM_ZONES):
	zone_temps.append([])
	zone_temp_diffs.append([])

for i in tqdm(range(0, len(all_weather), 6)):
	temp_here = list(scipy.io.loadmat("results/Room_Temp_data_"+str(i)+".mat")["y_data"])
	temp_diff = list(scipy.io.loadmat("results/Temp_Diff_Desire_"+str(i)+".mat")["temp_diff_data"])
	all_temps = [x[0] for x in temp_here]
	all_temp_diffs = [x[0] for x in temp_diff]
	for j in range(NUM_ZONES):
		temp_now = all_temps[j] - 273.15 - 10
		zone_temps[j].append(temp_now)
		if temp_now > 25:
			zone_temp_diffs[j].append(temp_now - 25)
		elif temp_now < 19:
			zone_temp_diffs[j].append(19 - temp_now)
		else:
			zone_temp_diffs[j].append(0)




for i, zone_temp in enumerate(zone_temps):
	plt.plot(zone_temp)
	plt.savefig("results/figs/temp_"+str(i + 1)+".png")
	plt.clf()

	plt.plot(zone_temp_diffs[i])
	plt.savefig("results/figs/power_"+str(i + 1)+".png")
	plt.clf()

	rmse_here = []
	positions = [x for x in range(1, 9)]
	for j in range(0, len(zone_temp), 6):
		here_chunk = zone_temp_diffs[i][j : j + 6]
		here_chunk_sq = [x*x for x in here_chunk]
		mean_here = sum(here_chunk_sq) / 6
		rmse = mean_here ** 0.5
		rmse_here.append(rmse)

	plt.bar(positions, rmse_here)
	plt.savefig("results/figs/rmse_"+str(i + 1)+".png")
	plt.clf()
