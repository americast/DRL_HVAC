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
import argparse

my_parser = argparse.ArgumentParser()
my_parser.add_argument('-p', '--port', action='store', type=int, required=True, help="Specify port no (must end with 1)")
my_parser.add_argument('-i', '--infer', action='store_true', help="Run inference instead of training")
my_parser.add_argument('-r2', '--reward2', action='store_true', help="Train and infer with the second reward function.")

args = my_parser.parse_args()
infer = vars(args)['infer']
r2 = vars(args)['reward2']

env = gym.make('CustomEnv-v0')
port = vars(args)['port']
# pu.db

agent = DDPGagent(env)
if infer:
    if r2:
        agent.load_model("models/zone_"+str(port)[-1]+"_r2.pth")
    else:
        agent.load_model("models/zone_"+str(port)[-1]+".pth")
    print("Model loaded!")
noise = OUNoise(env.action_space)
# pu.db
batch_size = 128
rewards = []
avg_rewards = []
env.set_port(port)
# pu.db
num_episodes = 100
if infer: num_episodes = 1
# try:
for episode in tqdm(range(num_episodes)):
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
        new_state, reward, done, _ = env.step(action, r2) 
        agent.memory.push(state, action, reward, new_state, done)
        
        if len(agent.memory) > batch_size and not infer:
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
    if infer:
        if r2:
            f = open("results/reward_"+str(port)[-1]+"_r2.txt", "w")
        else:
            f = open("results/reward_"+str(port)[-1]+".txt", "w")
        f.write("Reward: "+str(avg_rewards)+"\n")
        f.close()
    else:
        if not r2:
            plt.savefig("models/figs/updates_"+str(port)[-1]+".png")
        else:
            plt.savefig("models/figs/updates_"+str(port)[-1]+"_r2.png")
    if not infer:
        if episode > 0 and episode_reward > max(rewards[:-1]):
            if r2:
                torch.save(agent.get_model().state_dict(), "models/zone_"+str(port)[-1]+"_r2.pth")
                f = open("models/zone_"+str(port)[-1]+"_best_reward_r2.txt", "w")
                f.write("Rewards r2: "+str(rewards)+"\nEpoch: "+str(episode)+"\n")
                f.close()
            else:
                torch.save(agent.get_model().state_dict(), "models/zone_"+str(port)[-1]+".pth")
                f = open("models/zone_"+str(port)[-1]+"_best_reward.txt", "w")
                f.write("Rewards: "+str(rewards)+"\nEpoch: "+str(episode)+"\n")
                f.close()

        if r2:
            f = open("models/zone_"+str(port)[-1]+"_rewards_r2.txt", "w")
            f.write("Rewards: "+str(avg_rewards)+"\n")
            f.close()
        else:
            f = open("models/zone_"+str(port)[-1]+"_rewards.txt", "w")
            f.write("Rewards: "+str(avg_rewards)+"\n")
            f.close()


