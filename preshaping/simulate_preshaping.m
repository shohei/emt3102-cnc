clear; close all; clc;

tau = 0.1;%sec
tau1 = 0.063;%sec

wn = 100;%rad/s
zeta = 0.05;

deltaT = pi/(wn*sqrt(1-zeta^2))
K = exp(-zeta*pi/sqrt(1-zeta^2))

cruise_time = 1;%sec

target_velocity = 1;%m/s
original_accel_time = 0.1;%sec
original_step_value = target_velocity / original_accel_time;

shortened_step_time = 0.0628;%sec
shortened_step_value = target_velocity / shortened_step_time;

initial_delay = 0.1;%sec

a1 = original_step_value

a2 = shortened_step_value * 1/(1+K)
b2 = shortened_step_value
c2 = shortened_step_value * K/(1+K)


