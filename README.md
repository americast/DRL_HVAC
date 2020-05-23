# DRL work

Optimising electricity expenditure in an HVAC system under dynamic electricity pricing scheme and weather conditions.

## Requirements

`Python 3.6` or `3.7` required. `Matlab R2014b+` required.

Python package requirements:  

```
pudb
gym
torch
```

Matlab addon requirements:
```
optimtool
Control System Toolbox
```

Install the python packages using

```bash
$ pip3 install pudb
$ pip3 install gym
$ pip3 install torch==1.3.1+cpu torchvision==0.4.2+cpu -f https://download.pytorch.org/whl/torch_stable.html # CPU-only variant
```

Also, install the Matlab Engine API for Python. Instruction can be found [here](https://in.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).
## Dataset

Data is generated via the Matlab files. They are called directly from Python.

## Installation

Go to the `DRL/custom_gym` directory and issue `$ pip3 install -e .`  

## Training the DRL
Go to the `DRL` directory and issue `$ python3 driver.py -p <port no>` to train. Seven RL models run in parallel at ports provided at command-line flag, as well as the next six ports. A small help section may be accessed using `python3 driver.py -h`.  
The code will run for 100 episodes, and keep plotting the reward as `DRL/models/figs/updates_<zone>.png` at every step.  
The best model for each zone shall be saved in the `DRL/models/` directory.

## Inference and Results of DRL
Add a flag `-i` to the command to perform inference i.e., `$ python3 driver.py -p <port no> -i`. The results shall be stored in `DRL/results/` directory. In order to obtain plots (and make the results easily interpretable), issue the command `python3 plot_gen.py`. All the commands are to be issued from the `DRL/` directory.

## Results from MPC
Add a flag `-m` to obtain results from the MPC-based controller i.e., `$ python3 driver.py -m`. The results shall be stored in `DRL/results/` directory. In order to obtain plots (and make the results easily interpretable), issue the command `python3 plot_gen.py -m`. Again, all the commands are to be issued from the `DRL/` directory.

## Trained models and results
Trained model files and interpretable results (plots only) have been provided in the `DRL/models/` and `DRL/results/` directory respectively. In order to obtain the full results, run the commands as instructed above.

## Description of the files
`DRL/driver.py`: Calls the seven RL models one by one in parallel, generates weather data for each step and triggers the matlab code to start.  
`DRL/caller.py`: The matlab code sends the state data to this file, which in turn sends them to the RL models which wait for the data over TCP sockets.  
`DRL/main.py`: Calls all the other modules and runs them by and by.  
`DRL/model.py`: Contains DL models for actor and critic.  
`DRL/DDPG.py`: Calls and updates the actor and critic modules.  
`DRL/utils.py`: Addon implementations (noise, memory and normalisation).  
`DRL/plot_gen.py`: Generates plots for easy interpretation of the results.  
`DRL/custom_gym/envs/custom_env_dir/custom_env.py`: Gym environment (the `step` function contains action implementation and reward).  
