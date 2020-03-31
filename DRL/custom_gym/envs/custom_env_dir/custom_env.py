# Skeleton taken from https://github.com/openai/gym/blob/master/gym/envs/classic_control/continuous_mountain_car.py

import math

import numpy as np
import torch
import gym
from gym import spaces
from gym.utils import seeding
from copy import deepcopy
import scipy.io
import pudb
from random import random
import math

class CustomEnv(gym.Env):
    metadata = {
        'render.modes': ['human', 'rgb_array'],
        'video.frames_per_second': 30
    }

    def __init__(self, goal_velocity = 0):

        self.E2B = 1.0
        self.gamma = 0.05
        self.sigma = 0.3 # Assumed
        self.d_max = 0.9 * self.E2B
        self.c_max = 0.9 * self.E2B
        self.w_c, self.w_b = 0.0, 1.0
        self.eps = 0.35
        self.k2up = 0.5
        self.k2low = 0.5
        self.counter = 0

        self.action_space = spaces.Box(
            low  = np.array([-self.d_max, 0]),
            high = np.array([self.c_max,   1]),
            dtype= np.float32)

        self.observation_space = spaces.Box(
            # state vector:  eb_t, enet_t, v_t, w_c, t
            low =  np.array([self.gamma * self.E2B,       0, 0, 0, 0]),
            high = np.array([(1 - self.gamma) * self.E2B, 1, 1, 1, 1]),
            dtype=np.float32)
        
        self.seed()
        self.reset()

        self.power_consumption = []
        for i in range(9):
            self.power_consumption.append(scipy.io.loadmat("data/"+self.file_no+"/Power_data_0."+str(i + 1)+".mat")["power_data"])
            # shape of each mat is 1 x 168

        self.temp_diff = []
        for i in range(9):
            self.temp_diff.append(scipy.io.loadmat("data/"+self.file_no+"/Temp_Diff_Desire_0."+str(i + 1)+".mat")["temp_diff_data"])
            # shape of each mat is 7 x 168

        self.power_amt = [4.5, 4.2, 4.0, 3.9, 4.0, 4.0, 4.1, 4.2, 4.4, 5.0, 5.1, 5.0, 5.1, 6.9, 6.7, 7.3, 7.5, 7.5, 8.7, 10.2, 10.4, 6.7, 6.2, 6.7, 6.5]

        self.power_pos = 0
        self.max_temp_diff = 0
        self.min_temp_diff = 0
        for each in self.temp_diff:
            for j in range(each.shape[1]):
                sum_here = sum(each[:, j])
                if sum_here > self.max_temp_diff:
                    self.max_temp_diff = sum_here
                if sum_here < self.min_temp_diff:
                    self.min_temp_diff = sum_here


    def seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def step(self, action):
        self.v = self.power_amt[self.power_pos] / max(self.power_amt)
        self.power_pos = (self.power_pos + 1) % len(self.power_amt)


        self.state[3] = int(self.state[3] * 10) / 10    # int of w_c
        if self.state[3] < 0:
            self.state[3] = 0.1
        elif self.state[3] > 0.9:
            self.state[3] = 0.9

        num_dim = self.temp_diff[int(self.state[3] * 10) - 1][:, self.counter].shape[0]
        self.state[1] = (-(self.min_temp_diff) + sum(self.temp_diff[int(self.state[3] * 10) - 1][:, self.counter])) / ((self.max_temp_diff - self.min_temp_diff))

        self.state[2] = self.v

        self.state[3] += action[1]

        self.state[0] += action[0]
        self.state[-1] = self.counter / 168

        e_b = self.state[0]
        e_net = self.state[1]
        v_T = self.state[2]
        w_e = self.state[3]
        w_c = 1 - w_e
        t = self.state[4]
        u = self.sigma * self.v


        r_b = 0
        if e_b < self.gamma * self.E2B:
            r_b = -(e_b * u + self.eps * self.E2B)
        else:
            r_b = -(e_b * u + (1 - self.eps) * self.E2B)


        r_net = 0
        if w_c > 1:
            r_net = -(e_net * u + self.k2up * (w_c - 1))
        elif w_c < 0:
            r_net = -(e_net * u + self.k2low * (0 - w_c))
        else:
            r_net = -(e_net * u)

        reward = r_net + r_b

        self.counter += 1

        # print(self.state)

        return self.state, reward, False, {}

    def reset(self):

        self.file_no = str(int(1 + random()*20))
        self.state = np.array([
            self.np_random.uniform(low=self.gamma * self.E2B, high=(1 - self.gamma) * self.E2B), # e_b
            self.np_random.uniform(low = -2, high = 2),                                          # e_net
            self.np_random.uniform(low = -2, high = 2),                                          # v_t
            self.np_random.uniform(low = 0, high = 1),                                           # w_e
            self.np_random.uniform(low = 0, high = 9999)])                                       # t
        
        self.counter = 0
        return np.array(self.state)