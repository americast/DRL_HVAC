import math

import numpy as np

import gym
from gym import spaces
from gym.utils import seeding
from copy import deepcopy

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

        self.min_action = -1.0
        self.max_action = 1.0
        self.min_position = -1.2
        self.max_position = 0.6
        self.max_speed = 0.07
        self.goal_position = 0.45 # was 0.5 in gym, 0.45 in Arnaud de Broissia's version
        self.goal_velocity = goal_velocity
        self.power = 0.0015

        self.low_state = np.array([self.min_position, -self.max_speed])
        self.high_state = np.array([self.max_position, self.max_speed])

        self.viewer = None

        # self.action_space = spaces.Box(low=self.min_action, high=self.max_action,
                                    #    shape=(1,), dtype=np.float32)

        self.action_space = spaces.Box(
            low = np.array([-self.d_max, -1, -1]),
            high = np.array([self.c_max, 1, 1]),
            # low = -1,
            # high = 1,
            # shape=(1,),
            dtype= np.float32)

        
        # self.observation_space = spaces.Box(low=self.low_state, high=self.high_state,
                                            # dtype=np.float32)

        self.observation_space = spaces.Box(
            low = np.array([self.gamma * self.E2B, -float(np.inf), -float(np.inf), 0, 0, 0]),
            high = np.array([(1 - self.gamma) * self.E2B, float(np.inf), float(np.inf), 1, 1, np.inf]),
            dtype=np.float32)

        self.seed()
        self.reset()

    def seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def step(self, action):

        # position = self.state[0]
        # velocity = self.state[1]
        # force = min(max(action[0], -1.0), 1.0)

        # velocity += force*self.power -0.0025 * math.cos(3*position)
        # if (velocity > self.max_speed): velocity = self.max_speed
        # if (velocity < -self.max_speed): velocity = -self.max_speed
        # position += velocity
        # if (position > self.max_position): position = self.max_position
        # if (position < self.min_position): position = self.min_position
        # if (position==self.min_position and velocity<0): velocity = 0

        # done = bool(position >= self.goal_position and velocity >= self.goal_velocity)

        # reward = 0
        # if done:
        #     reward = 100.0
        # reward-= math.pow(action[0],2)*0.1

        # self.state = np.array([position, velocity])
        # pu.db
        self.state[3] += action[1]
        self.state[4] += action[2]

        self.state[0] += action[0]
        e_b = self.state[0]
        e_net = self.state[1]
        v_T = self.state[2]
        w_e = self.state[3]
        w_c = self.state[4]
        t = self.state[5]

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
            self.np_random.uniform(low=self.gamma * self.E2B, high=(1 - self.gamma) * self.E2B), 
            self.np_random.uniform(low = -2, high = 2),
            self.np_random.uniform(low = -2, high = 2),
            self.np_random.uniform(low = 0, high = 1),
            self.np_random.uniform(low = 0, high = 1),
            self.np_random.uniform(low = 0, high = 9999)])
        
        # self.state = deepcopy(self.observation_space)
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