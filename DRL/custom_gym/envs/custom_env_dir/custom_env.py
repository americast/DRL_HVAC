# Skeleton taken from https://github.com/openai/gym/blob/master/gym/envs/classic_control/continuous_mountain_car.py

import math

import numpy as np
import torch
import gym
from gym import spaces
from gym.utils import seeding
from copy import deepcopy
import scipy.io

class CustomEnv(gym.Env):
    metadata = {
        'render.modes': ['human', 'rgb_array'],
        'video.frames_per_second': 30
    }

    def __init__(self, goal_velocity = 0):

        self.v = 1  # To be taken from data
        self.E2B = 10000.0
        self.gamma = 0.35
        self.sigma = 0.3 # Assumed
        self.d_max = 0.9 * self.E2B
        self.c_max = 0.9 * self.E2B
        self.w_c, self.w_b = 0.0, 1.0
        self.eps = 0.35
        self.k2up = 0.5
        self.k2low = 0.5
        self.counter = 0

        # self.min_action = -1.0
        # self.max_action = 1.0

        # self.min_position = -1.2
        # self.max_position = 0.6
        # self.max_speed = 0.07

        # self.low_state = np.array([self.min_position, -self.max_speed])
        # self.high_state = np.array([self.max_position, self.max_speed])

        # self.action_space = spaces.Box(low=self.min_action, high=self.max_action,shape=(1,), dtype=np.float32)
        # self.observation_space = spaces.Box(low=self.low_state, high=self.high_state,dtype=np.float32)

        # pu.db
        # spaces.Tuple([
        #     spaces.Box(low=self.gamma * self.E2B, high=(1 - self.gamma) * self.E2B, shape=(1,), dtype=np.float32),  #e_b
        #     spaces.Box(low=-np.inf, high=np.inf, shape=(1,), dtype=np.float32),  #e_net
        #     spaces.Box(low=-np.inf, high=np.inf, shape=(1,), dtype=np.float32),  #v_T
        #     spaces.Box(low=0, high=1, shape=(1,), dtype=np.float32),  #w_e
        #     spaces.Box(low=0, high=1, shape=(1,), dtype=np.float32),  #w_c
        #     spaces.Box(low=0, high=np.inf, shape=(1,), dtype=np.float32)]) #t

        # self.action_space = spaces.Box(low=self.min_action, high=self.max_action,
                                    #    shape=(1,), dtype=np.float32)

        self.action_space = spaces.Box(
            low = np.array([-self.d_max, -1, -1]),
            high = np.array([self.c_max, 1, 1]),
            dtype= np.float32)

        
        # self.observation_space = spaces.Box(low=self.low_state, high=self.high_state,
                                            # dtype=np.float32)

        self.observation_space = spaces.Box(
            low = np.array([self.gamma * self.E2B, -float(np.inf), -float(np.inf), 0, 0, 0]),
            high = np.array([(1 - self.gamma) * self.E2B, float(np.inf), float(np.inf), 1, 1, np.inf]),
            dtype=np.float32)

        self.power_consumption = []
        for i in range(9):
            self.power_consumption.append(scipy.io.loadmat("data/Power_data_0."+str(i + 1)+".mat")["power_data"])
            # shape of each mat is 1 x 168

        self.temp_diff = []
        for i in range(9):
            self.temp_diff.append(scipy.io.loadmat("data/Temp_Diff_Desire_0."+str(i + 1)+".mat")["temp_diff_data"])
            # shape of each mat is 7 x 168

        # self.f_household = open("data/household_power_consumption.txt", "r")
        # self.f_household.readline()

        self.f_power = open("data/price_per_KWH.csv", "r")
        self.f_power.readline()

        self.power_dict = {}
        self.power_amt = []
        while True:
            line_here = self.f_power.readline()
            if not line_here: break
            date, amt = line_here.split(",")
            month = date.split("-")[-2]
            yr = date.split("-")[0]
            date_str = month+"-"+yr
            self.power_dict[date_str] = float(amt)
            self.power_amt.append(float(amt))

        self.f_power.close()
        self.power_pos = 0
        self.max_temp_diff = 0
        for each in self.temp_diff:
            for j in range(each.shape[1]):
                sum_here = sum(each[:, j])
                if sum_here > self.max_temp_diff:
                    self.max_temp_diff = sum_here

        self.seed()
        self.reset()

    def seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def step(self, action):
        # line_household = self.f_household.readline()
        # date_here = line_household.split(";")[0]
        # month = date_here.split("/")[1]
        # yr = date_here.split("/")[-1]
        # self.counter += 1
        # pu.db
        # self.v = self.power_dict[month+"-"+yr]
        self.v = self.power_amt[self.power_pos] / max(self.power_amt)
        self.power_pos = (self.power_pos + 1) % len(self.power_amt)

        # sub_meter = float(line_household.split(";")[-1])

        self.state[3] = int(self.state[3] * 10) / 10

        self.state[1] = sum(self.temp_diff[int(self.state[3] * 10)][:, counter]) / self.max_temp_diff
        self.state[2] = self.v

        self.state[3] += action[1]
        # self.state[4] += action[2]

        self.state[0] += action[0]
        self.state[-1] = self.counter

        e_b = self.state[0]
        e_net = self.state[1]
        v_T = self.state[2]
        w_e = self.state[3]
        w_c = 1 - w_e
        t = self.state[4]
        r_b = 0
        u = self.sigma * self.v
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

        return self.state, reward, False, {}

    def reset(self):
        # low = np.array([self.gamma * self.E2B, -float(np.inf), -float(np.inf), 0, 0, 0])

        # high = np.array([self.gamma * self.E2B, -float(np.inf), -float(np.inf), 0, 0, 0])
        


        self.state = np.array([
            self.np_random.uniform(low=self.gamma * self.E2B, high=(1 - self.gamma) * self.E2B), # e_b
            self.np_random.uniform(low = -2, high = 2),                                          # e_net
            self.np_random.uniform(low = -2, high = 2),                                          # v_t
            self.np_random.uniform(low = 0, high = 1),                                           # w_e
            self.np_random.uniform(low = 0, high = 9999)])                                       # t
        
        # self.state = deepcopy(self.observation_space)
        self.counter = 0
        return np.array(self.state)

#    def get_state(self):
#        return self.state

    # def _height(self, xs):
    #     return np.sin(3 * xs)*.45+.55

    # def render(self, mode='human'):
    #     screen_width = 600
    #     screen_height = 400

    #     world_width = self.max_position - self.min_position
    #     scale = screen_width/world_width
    #     carwidth=40
    #     carheight=20


    #     if self.viewer is None:
    #         from gym.envs.classic_control import rendering
    #         self.viewer = rendering.Viewer(screen_width, screen_height)
    #         xs = np.linspace(self.min_position, self.max_position, 100)
    #         ys = self._height(xs)
    #         xys = list(zip((xs-self.min_position)*scale, ys*scale))

    #         self.track = rendering.make_polyline(xys)
    #         self.track.set_linewidth(4)
    #         self.viewer.add_geom(self.track)

    #         clearance = 10

    #         l,r,t,b = -carwidth/2, carwidth/2, carheight, 0
    #         car = rendering.FilledPolygon([(l,b), (l,t), (r,t), (r,b)])
    #         car.add_attr(rendering.Transform(translation=(0, clearance)))
    #         self.cartrans = rendering.Transform()
    #         car.add_attr(self.cartrans)
    #         self.viewer.add_geom(car)
    #         frontwheel = rendering.make_circle(carheight/2.5)
    #         frontwheel.set_color(.5, .5, .5)
    #         frontwheel.add_attr(rendering.Transform(translation=(carwidth/4,clearance)))
    #         frontwheel.add_attr(self.cartrans)
    #         self.viewer.add_geom(frontwheel)
    #         backwheel = rendering.make_circle(carheight/2.5)
    #         backwheel.add_attr(rendering.Transform(translation=(-carwidth/4,clearance)))
    #         backwheel.add_attr(self.cartrans)
    #         backwheel.set_color(.5, .5, .5)
    #         self.viewer.add_geom(backwheel)
    #         flagx = (self.goal_position-self.min_position)*scale
    #         flagy1 = self._height(self.goal_position)*scale
    #         flagy2 = flagy1 + 50
    #         flagpole = rendering.Line((flagx, flagy1), (flagx, flagy2))
    #         self.viewer.add_geom(flagpole)
    #         flag = rendering.FilledPolygon([(flagx, flagy2), (flagx, flagy2-10), (flagx+25, flagy2-5)])
    #         flag.set_color(.8,.8,0)
    #         self.viewer.add_geom(flag)

    #     pos = self.state[0]
    #     self.cartrans.set_translation((pos-self.min_position)*scale, self._height(pos)*scale)
    #     self.cartrans.set_rotation(math.cos(3 * pos))

    #     return self.viewer.render(return_rgb_array = mode=='rgb_array')

    # def close(self):
    #     if self.viewer:
    #         self.viewer.close()
    #         self.viewer = None
