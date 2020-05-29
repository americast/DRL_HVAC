import scipy.io
import pudb
from tqdm import tqdm
import matplotlib.pyplot as plt
import math
import argparse
import numpy as np

my_parser = argparse.ArgumentParser()
my_parser.add_argument('-m', '--mpc', action='store_true', help="Also generate mpc plot results.")
my_parser.add_argument('-c', '--combo', action='store_true', help="Also generate combo plot results.")
args = my_parser.parse_args()
mpc = vars(args)['mpc']
combo = vars(args)['combo']

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
zone_temps_combo = []

zone_temp_diffs = []
zone_temp_diffs_mpc = []
zone_temp_diffs_combo = []
for i in range(NUM_ZONES):
	zone_temps.append([])
	zone_temps_mpc.append([])
	zone_temps_combo.append([])

	zone_temp_diffs.append([])
	zone_temp_diffs_mpc.append([])
	zone_temp_diffs_combo.append([])

for i in tqdm(range(0, len(all_weather), 6)):
	temp_here = list(scipy.io.loadmat("results/Room_Temp_data_"+str(i)+".mat")["y_data"])
	if mpc: temp_here_mpc = list(scipy.io.loadmat("results/Room_Temp_data_"+str(i)+"_mpc.mat")["y_data"])
	if combo: temp_here_combo = list(scipy.io.loadmat("results/Room_Temp_data_combo_"+str(int(i/6))+".mat")["y_data"])
	
	temp_diff = list(scipy.io.loadmat("results/Temp_Diff_Desire_"+str(i)+".mat")["temp_diff_data"])
	if mpc: temp_diff_mpc = list(scipy.io.loadmat("results/Temp_Diff_Desire_"+str(i)+"_mpc.mat")["temp_diff_data"])
	if combo: temp_diff_combo = list(scipy.io.loadmat("results/Temp_Diff_Desire_combo_"+str(int(i/6))+".mat")["temp_diff_data"])
	
	all_temps = [x[0] for x in temp_here]
	if mpc: all_temps_mpc = [x[0] for x in temp_here_mpc]
	if combo: all_temps_combo = [x[0] for x in temp_here_combo]
	all_temp_diffs = [x[0] for x in temp_diff]
	if mpc: all_temp_diffs_mpc = [x[0] for x in temp_diff_mpc]
	if combo: all_temp_diffs_combo = [x[0] for x in temp_diff_combo]
	

	for j in range(NUM_ZONES):
		temp_now = all_temps[j] - 273.15 - 4.5
		if mpc: temp_now_mpc = all_temps_mpc[j] - 273.15
		if combo: temp_now_combo = all_temps_combo[j] - 273.15

		zone_temps[j].append(temp_now)
		if mpc: zone_temps_mpc[j].append(temp_now_mpc)
		if combo: zone_temps_combo[j].append(temp_now_combo)

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

		if combo:
			if temp_now_combo > 25:
				zone_temp_diffs_combo[j].append(temp_now_combo - 25)
			elif temp_now_combo < 19:
				zone_temp_diffs_combo[j].append(19 - temp_now_combo)
			else:
				zone_temp_diffs_combo[j].append(0)


# pu.db
for i, zone_temp in enumerate(zone_temps):
	plt.plot(zone_temp, label = "DRL")
	# plt.savefig("results/figs/temp_"+str(i + 1)+".png")
	if mpc:
		plt.plot(zone_temps_mpc[i], label = "MPC")
	if combo:
		plt.plot(zone_temps_combo[i], label = "Combo")
			
	plt.legend()
	plt.savefig("results/figs/temp_"+str(i + 1)+".png")
	plt.clf()

	plt.plot(zone_temp_diffs[i], label = "DRL")
	# plt.savefig("results/figs/power_"+str(i + 1)+".png")
	if mpc:
		plt.plot(zone_temp_diffs_mpc[i], label = "MPC")
	if combo:
		plt.plot(zone_temp_diffs_combo[i], label = "Combo")
	plt.legend()
	plt.savefig("results/figs/power_"+str(i + 1)+".png")
	plt.clf()

	rmse_here = []
	positions = [x - 0.2 for x in range(1, 9)]
	positions_mpc = [x for x in range(1, 9)]
	positions_combo = [x + 0.2 for x in range(1, 9)]

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

	if combo:
		rmse_here_combo = []
		for j in range(0, len(zone_temps_combo[i]), 6):
			here_chunk_combo = zone_temp_diffs_combo[i][j : j + 6]
			here_chunk_sq_combo = [x*x for x in here_chunk_combo]
			mean_here_combo = sum(here_chunk_sq_combo) / 6
			rmse_combo = mean_here_combo ** 0.5
			rmse_here_combo.append(rmse_combo)

	plt.bar(positions, rmse_here, label = "DRL", width = 0.2)
	# plt.savefig("results/figs/rmse_"+str(i + 1)+".png")
	if mpc:
		plt.bar(positions_mpc, rmse_here_mpc, label = "MPC", width = 0.2)
	if combo:
		plt.bar(positions_combo, rmse_here_combo, label = "Combo", width = 0.2)

	plt.legend()
	plt.savefig("results/figs/rmse_"+str(i + 1)+".png")
	plt.clf()

zone_temps = np.array(zone_temps)
zone_temp_diffs = np.array(zone_temp_diffs)

if mpc:
	zone_temps_mpc = np.array(zone_temps_mpc)
	zone_temp_diffs_mpc = np.array(zone_temp_diffs_mpc)

if combo:
	zone_temps_combo = np.array(zone_temps_combo)
	zone_temp_diffs_combo = np.array(zone_temp_diffs_combo)

zone_temp_avg = list(sum(zone_temps)/7)
zone_temp_diffs_avg = list(sum(zone_temp_diffs)/7)

if mpc:
	zone_temp_avg_mpc = list(sum(zone_temps_mpc)/7)
	zone_temp_diffs_avg_mpc = list(sum(zone_temp_diffs_mpc)/7)

if combo:
	zone_temp_avg_combo = list(sum(zone_temps_combo)/7)
	zone_temp_diffs_avg_combo = list(sum(zone_temp_diffs_combo)/7)

plt.plot(zone_temp_avg, label = "DRL")
# plt.savefig("results/figs/temp_"+str(i + 1)+".png")
if mpc:
	plt.plot(zone_temp_avg_mpc, label = "MPC")
if combo:
	plt.plot(zone_temp_avg_combo, label = "Combo")
		
plt.legend()
plt.savefig("results/figs/temp_avg.png")
plt.clf()


plt.plot(zone_temp_diffs_avg, label = "DRL")
# plt.savefig("results/figs/power_"+str(i + 1)+".png")
if mpc:
	plt.plot(zone_temp_diffs_avg_mpc, label = "MPC")
if combo:
	plt.plot(zone_temp_diffs_avg_combo, label = "Combo")
plt.legend()
plt.savefig("results/figs/power_avg.png")
plt.clf()


rmse_here_avg = []
positions = [x - 0.2 for x in range(1, 9)]
positions_mpc = [x for x in range(1, 9)]
positions_combo = [x + 0.2 for x in range(1, 9)]

for j in range(0, len(zone_temp_avg), 6):
	here_chunk = zone_temp_diffs_avg[j : j + 6]
	here_chunk_sq = [x*x for x in here_chunk]
	mean_here = sum(here_chunk_sq) / 6
	rmse = mean_here ** 0.5
	rmse_here_avg.append(rmse)

if mpc:
	rmse_here_avg_mpc = []
	for j in range(0, len(zone_temp_avg_mpc), 6):
		here_chunk_mpc = zone_temp_diffs_avg_mpc [j : j + 6]
		here_chunk_sq_mpc = [x*x for x in here_chunk_mpc]
		mean_here_mpc = sum(here_chunk_sq_mpc) / 6
		rmse_mpc = mean_here_mpc ** 0.5
		rmse_here_avg_mpc.append(rmse_mpc)

if combo:
	rmse_here_avg_combo = []
	for j in range(0, len(zone_temp_avg_combo), 6):
		here_chunk_combo = zone_temp_diffs_avg_combo [j : j + 6]
		here_chunk_sq_combo = [x*x for x in here_chunk_combo]
		mean_here_combo = sum(here_chunk_sq_combo) / 6
		rmse_combo = mean_here_combo ** 0.5
		rmse_here_avg_combo.append(rmse_combo)

plt.bar(positions, rmse_here_avg, label = "DRL", width = 0.2)
# plt.savefig("results/figs/rmse_"+str(i + 1)+".png")
if mpc:
	plt.bar(positions_mpc, rmse_here_avg_mpc, label = "MPC", width = 0.2)
if combo:
	plt.bar(positions_combo, rmse_here_avg_combo, label = "Combo", width = 0.2)

plt.legend()
plt.savefig("results/figs/rmse_avg.png")
plt.clf()
