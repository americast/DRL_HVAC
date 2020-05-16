import sys
import gym
import envs
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from DDPG import DDPGagent
from utils import *
import pudb
from tqdm import tqdm
import torch

env = gym.make('CustomEnv-v0')
port = int(str(sys.argv[1]))

agent = DDPGagent(env)
noise = OUNoise(env.action_space)
# pu.db
batch_size = 128
rewards = []
avg_rewards = []
env.set_port(port)


# try:
for episode in tqdm(range(500)):
    # print("*****************************************************")
    # print("*****************************************************")
    # print("*****************************************************")
    # print("*****************************************************")
    # print("*****************************************************")
    # print("*****************************************************")
    # print("*****************************************************")
    # print("*****************************************************")
    state = env.reset()
    noise.reset()
    episode_reward = 0
    # step = 0

    for step in range(48):
        action = agent.get_action(state)
        action = noise.get_action(action, step)
        new_state, reward, done, _ = env.step(action) 
        agent.memory.push(state, action, reward, new_state, done)
        
        if len(agent.memory) > batch_size:
            agent.update(batch_size)        
        
        state = new_state
        episode_reward += reward

        if done:
            env.return_action(action)
            sys.stdout.write("episode: {}, reward: {}, average _reward: {} \n".format(episode, np.round(episode_reward, decimals=2), np.mean(rewards[-10:])))
            break

    rewards.append(episode_reward)
    avg_rewards.append(np.mean(rewards[-10:]))
# except:
#     pass

    plt.plot(rewards)
    plt.plot(avg_rewards)
    plt.plot()
    plt.xlabel('Episode')
    plt.ylabel('Reward')
    plt.savefig("updates_"+str(port)[-1]+".png")
    torch.save(agent.get_model().state_dict(), "models/"+str(episode)+".pth")


