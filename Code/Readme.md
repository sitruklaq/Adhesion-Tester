# Writing Scripts

The first step is to connect the instruments through serial connection.

An example can be found in the connect_instruments.m file.

## Stepper Motor Control 
The full list of commands can be found in Section 13 Command List from the [Controller Operating Manual](Components/HP-P024-4.pdf).

However, these are some of the most utilized commands:

| Command | Function                                                     |
| ------- | ------------------------------------------------------------ |
| TA / TD | Acceleration and deceleration time, respectively             |
| DIS     | Distance to move in pulses. Define this before the MI command |
| VS / VR | Starting Velocity and running velocity, respectively         |
| MA      | Move Absolute. Moves to                                      |
| MI      | Move Incrementally (start motion) and continue until distance has been achieved |
| PSTOP   | Panic stop: Hard stop, system state after stop is defined by ALMACT |
| HSTOP   | Hard stop: stop as quickly as possible                       |
| SSTOP   | Soft stop: controlled deceleration over time                 |


The code does not currently use the followign commands but they might be useful

| Command | Function               |  
| ------- | ---------------------- | 
| MEN     | Wait for Motion to end |   
| WAIT    | Time delay (seconds)   | 

Operations sent to the stepper motor controller are in this syntax "(Command) (Parameter))
Example:
to move

**NOTE**:The absolute position is reset to 0 if unplugged. Therefore,  if using the MA command, it is **EXTREMELY** important to check the starting position before starting a MATLAB script. In future, addition of 'home seeking' would solve this issue. 

## Force Gauge Operation

Once connected, the force gauge will return the current load when asked.

Sample Code:

```matlab
fprintf(force_gauge,char('?',13,10));
resp = fscanf(force_gauge);
```

This snippet writes a serial command to the force gauge, asking for the current char. It then reads the reponse and stores it as 'resp'.

## A Note on Move Commands 

There are two ways to make the stage move, distance or position.

Preferable Method:

During early testing, it was found that the stepper motor would sometimes miss move commands. This can be hazerdous to the machine if the motor moves bi-directionally. For example, the force gauge may ram into the substrate and overload if a 'move back' command is missed, leading to two sequental 'move forward commands'. Therefore, it is recommended to use position commands (MA) instead of distance commands (MI).

Example:

Want to move the force gauge forward 10000 steps then back 10000 steps. The initial 'home' position is 15100 steps. 

Incorrect Method:

DIS 10000

MI

wait...

DIS -10000

MI

Correct method:

MA 161000 **

wait....

MA 151000

**this can be scripted in MATLAB to be home + movement distance (MA (home+dis))







