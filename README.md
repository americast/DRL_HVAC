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

## Run the code

Go to the `DRL` directory and issue `$ python3 main.py`
The code will run for 500 episodes, and keep plotting the reward at `DRL/updates.png`.

## Explanations of the files

`DRL/main.py`: Calls all the other modules and runs them by and by.  
`DRL/model.py`: Contains DL models for actor and critic.  
`DRL/DDPG.py`: Calls and updates the actor and critic modules.  
`DRL/utils.py`: Addon implementations (noise, memory and normalisation).  
`DRL/custom_gym/envs/custom_env_dir/custom_env.py`: Gym environment (the `step` function contains action implementation and reward).  
