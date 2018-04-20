import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm

x = np.arange(-5, 5, 0.0665)
y = np.arange(-2.5, 2.5, 0.06)
x, y = np.meshgrid(x, y)
r = np.sqrt(x*x+y*y)
z = np.exp(-r/4)*np.sin(5*r) / 1.5
z -= np.amin( z )
z /= np.amax( z )
z *= (-y+3.0)/5

plt.imsave( "drop.png", z, cmap=cm.gray )
