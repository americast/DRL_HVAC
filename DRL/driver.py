import matlab.engine
import io
from tqdm import tqdm
import os


f = open("port_init", "r")
port_num = f.readline().strip()
START_PORT_NUM = int(port_num)
f.close()

for i in range(7):
	print("Starting RL learner at port "+str(START_PORT_NUM + i))
	os.system("python3 main.py "+str(START_PORT_NUM + i)+" &")


NUM_EPOCHS = 1

weather_file = open("data/weather_all.txt", "r")

eng = matlab.engine.start_matlab()
eng.addpath(r"./data/", nargout = 0)

all_weather = []
while True:
    line = weather_file.readline()
    if not line:
        break
    all_weather.append(float(line.strip()))
weather_file.close()
weather_file = open("data/weather_all.txt", "r")

for _ in range(NUM_EPOCHS):
	for i in tqdm(range(0, len(all_weather), 6)):
		weather_here = all_weather[i: i + 6]
		f = open("data/weather.txt", "w")
		weather_sum = 0
		for each in weather_here:
			weather_sum += float(each)
		weather_sum /= 6
		f.write(str(weather_sum)+"\n")
		f.close()

		if i == len(all_weather) - 1:
			eng.start3(1, nargout = 0, stdout=io.StringIO())
		else:
			eng.start3(0, nargout = 0, stdout=io.StringIO())


