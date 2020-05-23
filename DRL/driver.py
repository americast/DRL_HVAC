import matlab.engine
import io
from tqdm import tqdm
import os
import argparse
import pudb

my_parser = argparse.ArgumentParser()
my_parser.add_argument('-p', '--port', action='store', type=int, help="Specify port no (must end with 1)")
my_parser.add_argument('-i', '--infer', action='store_true', help="Run inference instead of training")
my_parser.add_argument('-m', '--mpc', action='store_true', help="Run the MPC variant. Port nos must not be provided if this is enabled.")
args = my_parser.parse_args()
infer = vars(args)['infer']
mpc = vars(args)['mpc']
START_PORT_NUM = vars(args)['port']

if mpc and START_PORT_NUM is not None:
	print("ERROR: Port no should not be provided with mpc enabled.")
	os.exit(1)

if not mpc and START_PORT_NUM is None:
	print("ERROR: Either port no should be provided or mpc must be enabled.")
	os.exit(1)

if START_PORT_NUM is not None and START_PORT_NUM%10 != 1:
	print("ERROR: Port no must end with 1.")
	os.exit(1)

if not mpc:
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
if infer or mpc: NUM_EPOCHS = 1

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

if mpc: infer = mpc

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

		if not mpc:
			if i == len(all_weather) - 6:
				eng.start3(1, int(infer), i, nargout = 0, stdout=io.StringIO())
			else:
				eng.start3(0, int(infer), i, nargout = 0, stdout=io.StringIO())
		else:
			if i == len(all_weather) - 6:
				eng.start3_mpc(1, int(infer), i, nargout = 0, stdout=io.StringIO())
			else:
				eng.start3_mpc(0, int(infer), i, nargout = 0, stdout=io.StringIO())


