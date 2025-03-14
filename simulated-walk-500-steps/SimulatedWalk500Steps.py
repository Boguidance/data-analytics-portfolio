import numpy as np

# Game: What are the odds you will reach 60 steps in Empire State Building?
# This simulates a walk up the stairs with a random seed, up to 500 times. The rules are:
# Must take 500 steps. Each step roll dice, 1 to 6. Rolling 1 means taking one step back. Roll of 2-5 means taking +1 step.
# Roll of 6 means a new roll; that new roll is amount of steps.
# An additional chance of clumsiness; a 0.001 chance that you will trip and fall, going back to step 0.

np.random.seed(123)
# Simulate random walk 500 times
all_walks = []
for i in range(500) :
    random_walk = [0]
    for x in range(100) :
        step = random_walk[-1]
        dice = np.random.randint(1,7)
        if dice <= 2:
            step = max(0, step - 1)
        elif dice <= 5:
            step = step + 1
        else:
            step = step + np.random.randint(1,7)
        if np.random.rand() <= 0.001 :
            step = 0
        random_walk.append(step)
    all_walks.append(random_walk)

# Create and plot np_aw_t
np_aw_t = np.transpose(np.array(all_walks))

# Select last row from np_aw_t: ends
ends = np_aw_t[-1, :]

import matplotlib.pyplot as plt
plt.hist(ends)
plt.show()