# Hattonlab Adhesion-Tester
This is the repository and working instructions for the linear-force tester in the HATTONLAB at the University of Toronto.

![setup](Images/Setup.png)

## Main Components

There are three main components: 

- stepper motor/motor controller (Oriental Motor)

- Force gauge (Mark-10 M4 25N)

## Accessory Components

- Linear Rail (From an old printer)
- Breadboard (Newport Aluminum 1ftx1ft Breadboard)
- Adjustable Backing Plate (Custom Milled)
- Motor-Stage Couplings (unknown)
- USB to RS-485 converter

## Force Capacity, Resolution, and Accuracy

The Mark-10 M4 25N has a working range of +-25N with a resolution of  0.01N and accurate to +-0.2% of 25N.

## Attachment Tips

The force gauge included the following attachment tips:

![image of included attachments](Images/Attachments.png)

A custom milled attachment piece has also been created to attach onto the 'flat accessory to generate a larger surface area.

![image of custom attachment](Images/customattachment.png)

## Calibration

A correlation between motor steps (pulses) and distance travelled was used to calibrate the machine:

Using the following controller configuration:

Any change to these settings will require a recalibration. 

At current: 1mm = 567pulses

Example: 
```
Metric: 50mm at 2mm/s
Pulses: 28350pulse at 1134pulse/s
```

# Operation Modes

There are two methods of control:

1. **Manual Control**: Motion and force are indepentely controlled through proprietary graphical software (simple)
2. **Script Control**: Combined control using MATLAB that allows for precise and co-dependent testing (advanced)

## Manual Control
Manual control uses proprietary software to separately control the force gauge and stepper motor. 

Why use manual control?
- It is easier to get started
- Requires no programming

### Stepper Motor Software: CRK Motion Creator

This allows you to change the gearing, jog the motor, and write scripts. [Download Link](https://www.orientalmotor.com/downloads/software.html#)

![CRK UI](Images/CRK_Motion_Creator.jpg)


### Force Gauge Software: MESUR Lite

This allows you to record data and export to excel with a single button. [Download Link](https://www.mark-10.com/instruments/software/mesurlite.html)

![MESUR UI](Images/MESUR-Lite.jpg)

### Running a Manual Test

1. Open Both MESUR Lite and CRK Motion Creator
2. Enter desired motion commands such as velocity, acceleration and distance using the calibration above
3. Jog the stepper motor to the starting postion
4. Start recording in MESUR (make sure record rate and max data points are correct)
5. Press start on the motion commands
6. Allow test to run
7. Stop recording on MESUR and export data to Excel

## Script Control

Why script control?

- **Linked Data**: Position and Load are precisely linked.
- **Load Control**: This allows you to reach precise preloads, and have motions based on the load such as stopping at failure (0 load) or reaching precise preloads.
- **Autonomous Testing**: single button to start testing can perform multiple tests, save data, and interact with tertiary devices such as pneumatics

### Running a Scripted Test

1. Write Script using the commands and examples in the Code section
2. Run the script
