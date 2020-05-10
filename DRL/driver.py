import matlab.engine
import io
from tqdm import tqdm

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
		for each in weather_here:
			f.write(str(each)+"\n")
		f.close()

		eng.start3(nargout = 0, stdout=io.StringIO())


