# DRL work

## Requirements

`Python 3.6+` required.

Package requirements:  

```
pudb
gym
torch
```

Install them using

```bash
$ pip3 install pudb
$ pip3 install gym
$ pip3 install torch==1.3.1+cpu torchvision==0.4.2+cpu -f https://download.pytorch.org/whl/torch_stable.html # CPU-only variant
```
## Dataset

Create a directory named `DRL/data/` and place files from the following two links there:  

* [Data_for_UCI_named.csv](https://drive.google.com/file/d/1FD94EPju0MJVcIbU5adO51as7_MWTdV4/view?usp=drive_web)
* [household_power_consumption.txt](https://drive.google.com/file/d/1i-COvbDSLBoAgWeurD-pYhUTft7nenm2/view?usp=drive_web)

## Installation

Go to the `DRL/custom_gym` directory and issue `$ pip3 install -e .`  

## Run the code

Go to the `DRL` directory and issue `$ python3 main.py`
The code will run for 50 episodes before plotting the reward. If a plot is desired earlier, simply issue SIGINT.

## Explanations of the files

`DRL/main.py`: Calls all the other modules and runs them by and by.  
`DRL/model.py`: Contains DL models for actor and critic.  
`DRL/DDPG.py`: Calls and updates the actor and critic modules.  
`DRL/utils.py`: Addon implementations (noise, memory and normalisation).  
`DRL/custom_gym/envs/custom_env_dir/custom_env.py`: Gym environment (the `step` function contains action implementation and reward).  
