import scipy.io
import pudb
from tqdm import tqdm
import matplotlib.pyplot as plt

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
for i in range(NUM_ZONES):
	zone_temps.append([])
for i in tqdm(range(0, len(all_weather), 6)):
	temp_here = list(scipy.io.loadmat("results/Room_Temp_data_"+str(i)+".mat")["y_data"])
	all_temps = [x[0] for x in temp_here]
	for j in range(NUM_ZONES):
		zone_temps[j].append(all_temps[j])

for i, zone_temp in enumerate(zone_temps):
	plt.plot(zone_temp)
	plt.savefig("results/figs/temp_"+str(i + 1)+".png")
	plt.clf()


