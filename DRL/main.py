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

env = gym.make('CustomEnv-v0')

agent = DDPGagent(env)
noise = OUNoise(env.action_space)
# pu.db
batch_size = 128
rewards = []
avg_rewards = []

# try:
for episode in tqdm(range(50)):
    state = env.reset()
    noise.reset()
    episode_reward = 0
    
    for step in range(167):
        action = agent.get_action(state)
        action = noise.get_action(action, step)
        new_state, reward, done, _ = env.step(action) 
        agent.memory.push(state, action, reward, new_state, done)
        
        if len(agent.memory) > batch_size:
            agent.update(batch_size)        
        
        state = new_state
        episode_reward += reward

        if step == 499:
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
plt.show()

