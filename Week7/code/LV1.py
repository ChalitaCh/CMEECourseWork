#!/usr/bin/env python3

"""This script illustrates the numerical integration using Python language. 
The Lotka-Volterra model, a predator-prey system, is used as an example in this script"""

__appname__ = 'LV model'
__author__ = 'Chalita Chomkatekaew chalita.chomkatekaew20@ic.ac.uk'
__version__ = '0.0.1'


#Import the package(s)

import scipy as sc
import scipy.integrate as integrate
import numpy as np
import matplotlib.pylab as p
import sys

"""
The Lotka-Volterra model

A predator-prey system in two-dimensional space (e.g on land)

Equation

dR/dt = rR - aCR 
dC/dt = -zC + eaCR

- C and R are consumer (e.g. predator) and resource (e.g. prey) population
abundances (either number x area-1)

- r in the intrinsic (per-capita) growth rate (time-1)

- a is per-capita "search rate" for the resource (area x time-1)

- z is mortality rate (time-1) and e is the consumer's efficiency in converting
resource to consumer biomass
"""

#Defined function

def dCR_dt(pops, t=0):
    """ Function for The Lotka-Volterra model

    A predator-prey system in two-dimensional space"""
    
    R = pops[0] #call the first element of pops as R
    C = pops[1] #call the second element of pops as C
    dRdt = r * R - a * R *C
    dCdt = - z * C + e * a * R * C

    return np.array([dRdt, dCdt])

#Assign the parameter values

r = 1.
a = 0.1
z = 1.5
e = 0.75

t = np.linspace(0, 15, 1000) #sub-divisions of time to 1000 points

def main(argv):

    """Main function to integrate the LV function defined previously and data visualisation
    to illustrate the consumer-resource population dynamics"""

    #Set the initial conditions for the two populations

    R0 = 10 #10 resourcest
    C0 = 5 #5 consumers
    RC0 = np.array([R0, C0])

    #Numerically integrate this system with starting conditions

    print("Analysing the prey-predator system using The Lotka-Volterra model....")
    print("The intrinsic growth rate (r) is : ", r, "time-1")
    print("The search rate for resource (a) is : ", a, "area x time-1")
    print("The mortality (z) is : ", z, "time-1")
    print("The onsumer's efficiency in converting resource to consumer biomass (e) is: ", e)

    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output= True)

    #Plot and visualising the results

    #open an empty figure object

    print("Plotting the Consumer-Resource population dynamics over time...")

    f1 = p.figure()

    p.plot(t, pops[:, 0], 'g-', label = 'Resource density') #plot t vs pops resources (first column) in green
    p.plot(t, pops[:,1], 'b-', label = 'Consumer density') #plot t vs pops Consumers (second column)
    p.grid() #use a grid as a theme
    p.legend(loc = 'best')
    p.xlabel('Time')
    p.ylabel('Population density')
    p.title('Consumer-Resource population dynamics')

    f1.savefig('../results/LV_model1.pdf') #Save figures

    #open another empty figure object

    print("Plotting the Consumer-Resource population dynamics...")

    f2 = p.figure()
    p.plot(pops[:, 0], pops[:, 1], 'r-')
    p.grid()
    p.xlabel('Resource density')
    p.ylabel('Consumer density')
    p.title('Consumer-Resource population dynamics')

    f2.savefig('../results/LV_model1_1.pdf')

    print("Done!!")

    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)