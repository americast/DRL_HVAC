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
import custom_env_combo
# import universe
# import CustomEnvCombo

def main(infer = False):
    env = custom_env_combo.CustomEnvCombo()

    agent = DDPGagent(env)
    noise = OUNoise(env.action_space)
    # pu.db
    batch_size = 128
    rewards = []
    avg_rewards = []

    if infer:
        agent.load_model("models/combo.pth")
        print("Model loaded!")

    num_episodes = 100
    if infer: num_episodes = 1

    # try:
    for episode in tqdm(range(num_episodes)):
        print("\n")
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
        
        for step in tqdm(range(48)):
            action = agent.get_action(state)
            action = noise.get_action(action, step)
            new_state, reward, done, _ = env.step(action, step, infer) 
            agent.memory.push(state, action, reward, new_state, done)
            
            if not infer and len(agent.memory) > batch_size:
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
        if not infer:
            plt.plot(rewards)
            plt.plot(avg_rewards)
            plt.plot()
            plt.xlabel('Episode')
            plt.ylabel('Reward')
            plt.savefig("models/figs/updates_combo.png")
            if episode > 0 and episode_reward > max(rewards[:-1]):
                torch.save(agent.get_model().state_dict(), "models/combo.pth")
                print("Model saved!")
                f = open("models/combo_best_reward.txt", "w")
                f.write("Rewards: "+str(rewards)+"\nEpoch: "+str(episode)+"\n")
                f.close()
            f = open("models/combo_avg_rewards.txt", "w")
            f.write("Rewards: "+str(avg_rewards)+"\n")
            f.close()
        else:
            f = open("results/combo_reward.txt", "w")
            f.write("Reward: "+str(avg_rewards)+"\n")
            f.close()

