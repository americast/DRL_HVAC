import scipy.io
import pudb
from tqdm import tqdm
import matplotlib.pyplot as plt
import math
import argparse

my_parser = argparse.ArgumentParser()
my_parser.add_argument('-m', '--mpc', action='store_true', help="Also generate mpc plot results.")
args = my_parser.parse_args()
mpc = vars(args)['mpc']

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
zone_temps_mpc = []
zone_temp_diffs = []
zone_temp_diffs_mpc = []
for i in range(NUM_ZONES):
	zone_temps.append([])
	zone_temps_mpc.append([])
	zone_temp_diffs.append([])
	zone_temp_diffs_mpc.append([])

for i in tqdm(range(0, len(all_weather), 6)):
	temp_here = list(scipy.io.loadmat("results/Room_Temp_data_"+str(i)+".mat")["y_data"])
	if mpc: temp_here_mpc = list(scipy.io.loadmat("results/Room_Temp_data_"+str(i)+"_mpc.mat")["y_data"])
	temp_diff = list(scipy.io.loadmat("results/Temp_Diff_Desire_"+str(i)+".mat")["temp_diff_data"])
	if mpc: temp_diff_mpc = list(scipy.io.loadmat("results/Temp_Diff_Desire_"+str(i)+"_mpc.mat")["temp_diff_data"])
	
	all_temps = [x[0] for x in temp_here]
	if mpc: all_temps_mpc = [x[0] for x in temp_here_mpc]
	all_temp_diffs = [x[0] for x in temp_diff]
	if mpc: all_temp_diffs_mpc = [x[0] for x in temp_diff_mpc]
	

	for j in range(NUM_ZONES):
		temp_now = all_temps[j] - 273.15 - 5
		if mpc: temp_now_mpc = all_temps_mpc[j] - 273.15
		zone_temps[j].append(temp_now)
		if mpc: zone_temps_mpc[j].append(temp_now_mpc)
		if temp_now > 25:
			zone_temp_diffs[j].append(temp_now - 25)
		elif temp_now < 19:
			zone_temp_diffs[j].append(19 - temp_now)
		else:
			zone_temp_diffs[j].append(0)

		if mpc:
			if temp_now_mpc > 25:
				zone_temp_diffs_mpc[j].append(temp_now_mpc - 25)
			elif temp_now_mpc < 19:
				zone_temp_diffs_mpc[j].append(19 - temp_now_mpc)
			else:
				zone_temp_diffs_mpc[j].append(0)



for i, zone_temp in enumerate(zone_temps):
	plt.plot(zone_temp, label = "DRL")
	# plt.savefig("results/figs/temp_"+str(i + 1)+".png")
	if mpc:
		plt.plot(zone_temps_mpc[i], label = "MPC")
		plt.legend()
	plt.savefig("results/figs/temp_"+str(i + 1)+".png")
	plt.clf()

	plt.plot(zone_temp_diffs[i], label = "DRL")
	# plt.savefig("results/figs/power_"+str(i + 1)+".png")
	if mpc: 
		plt.plot(zone_temp_diffs_mpc[i], label = "MPC")
		plt.legend()
	plt.savefig("results/figs/power_"+str(i + 1)+".png")
	plt.clf()

	rmse_here = []
	positions = [x - 0.1 for x in range(1, 9)]
	positions_mpc = [x + 0.1 for x in range(1, 9)]
	for j in range(0, len(zone_temp), 6):
		here_chunk = zone_temp_diffs[i][j : j + 6]
		here_chunk_sq = [x*x for x in here_chunk]
		mean_here = sum(here_chunk_sq) / 6
		rmse = mean_here ** 0.5
		rmse_here.append(rmse)

	if mpc:
		rmse_here_mpc = []
		for j in range(0, len(zone_temps_mpc[i]), 6):
			here_chunk_mpc = zone_temp_diffs_mpc[i][j : j + 6]
			here_chunk_sq_mpc = [x*x for x in here_chunk_mpc]
			mean_here_mpc = sum(here_chunk_sq_mpc) / 6
			rmse_mpc = mean_here_mpc ** 0.5
			rmse_here_mpc.append(rmse_mpc)

	plt.bar(positions, rmse_here, label = "DRL", width = 0.2)
	# plt.savefig("results/figs/rmse_"+str(i + 1)+".png")
	if mpc:
		plt.bar(positions_mpc, rmse_here_mpc, label = "MPC", width = 0.2)
		plt.legend()
	plt.savefig("results/figs/rmse_"+str(i + 1)+".png")
	plt.clf()
