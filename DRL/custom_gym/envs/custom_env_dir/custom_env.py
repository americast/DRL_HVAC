# Skeleton taken from https://github.com/openai/gym/blob/master/gym/envs/classic_control/continuous_mountain_car.py

import math
import sys
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
import socket

class CustomEnv(gym.Env):
    metadata = {
        'render.modes': ['human', 'rgb_array'],
        'video.frames_per_second': 30
    }

    def set_port(self, port = 10001):
        self.s = socket.socket()
        host = socket.gethostbyname("localhost")
        self.s.bind((host, port))
        self.s.listen(1)


    def __init__(self):
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
            # state vector:  eb_t,                       v_t, T_1, T_2, T_3, T_4, T_5, T_6, T_7, T_del, w_t
            low =  np.array([self.gamma * self.E2B,       0,   0,   0,   0,   0,   0,   0,   0,    0,    0]),
            high = np.array([(1 - self.gamma) * self.E2B, 1,   1,   1,   1,   1,   1,   1,   1,    1,    1]),
            dtype=np.float32)

        
        self.seed()
        # # self.reset()

        # # self.power_consumption = []
        # self.power_consumption = scipy.io.loadmat("data/"+self.file_no+"/Power_data_0.5.mat")["power_data"]
        # # shape of each mat is 1 x 168

        # # self.room_temp = []
        # self.room_temp = scipy.io.loadmat("data/"+self.file_no+"/Room_Temp_data_0.5.mat")["y_data"]
        # # shape of each mat is 7 x 168

        # # self.air_flow = []
        # self.air_flow = scipy.io.loadmat("data/"+self.file_no+"/Air_Flow_Rate_data_0.5.mat")["u_data"]
        # # shape of each mat is 7 x 168

        # # self.temp_diff = []
        # self.temp_diff = scipy.io.loadmat("data/"+self.file_no+"/Temp_Diff_Desire_0.5.mat")["temp_diff_data"]
        # # shape of each mat is 7 x 168

        # self.amb_temp = []
        # f = open("data/weather.txt")
        # while True:
        #     line = f.readline()
        #     if not line.strip():
        #         break
        #     self.amb_temp.append(float(line.strip()))
        # f.close()

        self.power_amt = [4.5, 4.2, 4.0, 3.9, 4.0, 4.0, 4.1, 4.2, 4.4, 5.0, 5.1, 5.0, 5.1, 6.9, 6.7, 7.3, 7.5, 7.5, 8.7, 10.2, 10.4, 6.7, 6.2, 6.7, 6.5]

        self.power_pos = 0
        # self.max_temp = 0
        # self.min_temp = 0
        # self.num_dim = self.room_temp[0].shape[0]

        # for j in range(self.room_temp.shape[1]):
        #     sum_here = sum(self.room_temp[:, j]) / self.num_dim
        #     if sum_here > self.max_temp:
        #         self.max_temp = sum_here
        #     if sum_here < self.min_temp:
        #         self.min_temp = sum_here

        # for each in self.amb_temp:
        #     if each > self.max_temp:
        #         self.max_temp = each
        #     if each < self.min_temp:
        #         self.min_temp = each

        # self.max_temp_diff = 0
        # self.min_temp_diff = 0

        # for j in range(self.temp_diff.shape[1]):
        #     sum_here = sum(self.temp_diff[:, j])
        #     if sum_here > self.max_temp_diff:
        #         self.max_temp_diff = sum_here
        #     if sum_here < self.min_temp_diff:
        #         self.min_temp_diff = sum_here




    def seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def step(self, action):
        del_b = action[0]
        del_m = action[1]
        self.conn.sendall(str.encode(str(action[1])))
        self.conn.close()

        # For next step

        self.conn, addr = self.s.accept()
        k = str(self.conn.recv(1024))[2:-2] # converts bytes to str
        temp_state = []

        for i, each in enumerate(k.split(" ")):
            temp_state.append(float(each[:-1]) / 40)
            if i == 6: break

        done = int(k.split(" ")[-1])

        if done: done = True
        else: done = False

        w_del = 0
        if temp_state[0] * 40 < 19:
            w_del = 19 - temp_state[0] * 40
        if temp_state[0] * 40 > 25:
            w_del = temp_state[0] * 40 - 25



        self.state[0] += action[0]  # E_B

        self.state[1] = self.power_amt[self.power_pos] / max(self.power_amt) # v
        self.power_pos = (self.power_pos + 1) % len(self.power_amt)

        # self.state[1] = (-(self.min_temp_diff) + sum(self.temp_diff[:, self.counter])) / ((self.max_temp_diff - self.min_temp_diff))

        w_out = 0
        for i in range(6):
            w_out += float(self.all_weather_file.readline().strip())

        w_out /= 6

        self.state = list(self.state[:2]) + temp_state + [w_del / 40] + [w_out / 40]


        # Reward function

        
        # self.state[-1] = self.counter / 168

        e_b = self.state[0]
        e_net = self.state[-1]
        v_T = self.state[1]
        # w_e = self.state[3]
        # w_c = 1 - w_e
        # t = self.state[4]
        u = self.sigma * v_T


        r_b = 0
        if e_b < self.gamma * self.E2B:
            r_b = -(e_b * u + self.eps * self.E2B)
        else:
            r_b = -(e_b * u + (1 - self.eps) * self.E2B)


        # r_net = 0
        # if w_c > 1:
        #     r_net = -(e_net * u + self.k2up * (w_c - 1))
        # elif w_c < 0:
        #     r_net = -(e_net * u + self.k2low * (0 - w_c))
        # else:
        #     r_net = -(e_net * u)

        reward = r_b

        self.counter += 1

        # print(self.state)
        if done == True:
            self.all_weather_file.close()

        return np.array(self.state), reward, done, {}

    def reset(self):
        self.all_weather_file = open("data/weather_all.txt", "r")
        self.conn, addr = self.s.accept()
        k = str(self.conn.recv(1024))[2:-2] # converts bytes to str
        # pu.db
        f = open("debug", "w")
        f.write(str(len(k))+"\n"+k+"\n")
        f.close()
        temp_state = []

        for i, each in enumerate(k.split(" ")):
            temp_state.append(float(each[:-1]) / 40)
            if i == 6: break

        w_del = 0
        if temp_state[0] * 40 < 19:
            w_del = 19 - temp_state[0] * 40
        if temp_state[0] * 40 > 25:
            w_del = temp_state[0] * 40 - 25

        w_out = 0
        for i in range(6):
            w_out += float(self.all_weather_file.readline().strip())

        w_out /= 6

        self.state = np.array([
            self.np_random.uniform(low=self.gamma * self.E2B, high=(1 - self.gamma) * self.E2B), # e_b
            self.power_amt[self.power_pos] / max(self.power_amt),  # v_t
            *temp_state,
            w_del / 40,
            w_out / 40
            ])
        self.power_pos = (self.power_pos + 1) % len(self.power_amt)
        # self.file_no = str(int(1 + random()*20))
        # self.state = np.array([
        #     self.np_random.uniform(low=self.gamma * self.E2B, high=(1 - self.gamma) * self.E2B), # e_b
        #     self.np_random.uniform(low = -2, high = 2),                                          # e_net
        #     self.np_random.uniform(low = -2, high = 2),                                          # v_t
        #     self.np_random.uniform(low = 0, high = 1),                                           # w_e
        #     self.np_random.uniform(low = 0, high = 9999)])                                       # t
        
        self.counter = 0
        return np.array(self.state)
        self.all_weather_file = open("weather_all.txt", "r")