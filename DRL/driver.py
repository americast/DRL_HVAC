import matlab.engine
import io
from tqdm import tqdm
import os
import argparse

my_parser = argparse.ArgumentParser()
my_parser.add_argument('-p', '--port', action='store', type=int, required=True, help="Specify port no (must end with 1)")
my_parser.add_argument('-i', '--infer', action='store_true')
args = my_parser.parse_args()
infer = vars(args)['infer']
START_PORT_NUM = vars(args)['port']

if START_PORT_NUM%10 != 1:
	print("ERROR: Port no must end with 1.")
	os.exit(1)

f = open("port_init", "w")
f.write(str(START_PORT_NUM)+"\n")
f.close()

for i in range(7):
	if infer:
		print("Starting RL inference at port "+str(START_PORT_NUM + i))
	else:
		print("Starting RL learner at port "+str(START_PORT_NUM + i))
	if infer:
		os.system("python3 main.py -p "+str(START_PORT_NUM + i)+" -i &")
	else:
		os.system("python3 main.py -p "+str(START_PORT_NUM + i)+" &")


NUM_EPOCHS = 100
if infer: NUM_EPOCHS = 1

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
		# print("Here: "+str(i) +"/"+str(len(all_weather))+"\n\n")
		weather_here = all_weather[i: i + 6]
		f = open("data/weather.txt", "w")
		weather_sum = 0
		for each in weather_here:
			weather_sum += float(each)
		weather_sum /= 6
		f.write(str(weather_sum)+"\n")
		f.close()

		if i == len(all_weather) - 6:
			eng.start3(1, int(infer), i, nargout = 0, stdout=io.StringIO())
		else:
			eng.start3(0, int(infer), i, nargout = 0, stdout=io.StringIO())


