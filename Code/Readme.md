# Writing Commands

The first step is to connect the instruments through serial connection.

Here is a Matlab function that connects the force gauge and stepper motor.

```matlab
function [force_gauge, step_motor] = connect_instruments()
%connect_instruments Connects Mark-10 force gauge and step motor

    % These serial ports should be changed depending on the computer

    % Connect Force Gauge
    force_gauge = serial('COM6');
    force_gauge.Baudrate = 115200;
    fopen(force_gauge);

    % Connect Step Motor
    step_motor = serial('COM7');
    fopen(step_motor);
    step_motor.RecordDetail ='Verbose';
    record(step_motor)
end
```

## Stepper Motor Commands

The full list of commands can be found in Section 13 Command List from the Controller Operating Manual.

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

The code does not currently use the following commands but they might be useful

| Command | Function               |
| ------- | ---------------------- |
| MEN     | Wait for Motion to end |
| WAIT    | Time delay (seconds)   |

**IMPORTANT**:The absolute position is reset to 0 if unplugged. Therefore,  if using the MA command, it is **EXTREMELY** important to check the starting position before starting a MATLAB script. In future versions,  'home seeking' would solve this issue. 

### Example: 

Move the force gauge back 15mm at 2mm/s with minimal ramp up time. The original pulse position is 117000.

Distance Method (dont use if possible):

```matlab
fprintf(step_motor, 'TA 0.1') % ramp up time
fprintf(step_motor, 'TD 0.1') % ramp down time
fprintf(step_motor, 'VS 1132'); % starting velocity 2mm/s * 566pulse/mm = 1132
fprintf(step_motor, 'VR 1132'); % running velocity
fprintf(step_motor, 'DIS -120000'); % distance to travel -15mm * 566pulse/mm = 8490
fprintf(step_motor, 'MI'); % start motion
```

Abosolute Movement Method (preffered):

```matlab
fprintf(step_motor, 'TA 0.1') % ramp up time
fprintf(step_motor, 'TD 0.1') % ramp down time
fprintf(step_motor, 'VS 1132'); % starting velocity 2mm/s * 566pulse/mm = 1132
fprintf(step_motor, 'VR 1132'); % running velocity
fprintf(step_motor, 'MA &s\n',num2str(117000-8490)); % distance to travel -15mm * 566pulse/mm = 8490.. 

```

*During early testing, it was found that the stepper motor would sometimes miss move commands. This can be hazerdous to the machine if the motor moves bi-directionally. For example, the force gauge may ram into the substrate and overload if a 'move back' command is missed, leading to two sequental 'move forward commands'. Therefore, it is recommended to use position commands (MA) instead of distance commands (MI).*

## Force Gauge Commands

Once connected, the force gauge will return the current load when asked.

Sample Code:

```matlab
fprintf(force_gauge,char('?',13,10));
resp = fscanf(force_gauge);
```

This snippet writes a serial command to the force gauge, asking for the current char. It then reads the reponse and stores the force as 'resp'.





