from gym.envs.registration import register
register(id='CustomEnv-v0',
    entry_point='envs.custom_env_dir:CustomEnv'
)
