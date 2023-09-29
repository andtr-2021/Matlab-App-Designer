# Matlab-App-Designer

To set up the seriaml communitcatoin betwen the Matlab App and the microcontroller (MCU), we need to configure the port and the baurd rate:
- s = serialport('COM14', 9600);
- configureTerminator(s, "CR/LF"); // terminated by a CR/LF sequence.
- data = readline(s); // readline funciton to read data from the mcu.
- flush(s); // clear the previous reading

![image](https://github.com/andtr-2021/Matlab-App-Designer/assets/79509067/f5f2f4e7-6afb-4e39-9e8f-af70824d465b)


Then in the while loop, configure the readline funciton to read the data:

- data = str2double(strsplit(s , ',')); // seperate the data by the deliminator - comma
- data = data(1) // time 
- data = data(2) // loadcell data
- app.loadcellValue.Text = double2str(data(2)) // display the data on matlab's label

![image](https://github.com/andtr-2021/Matlab-App-Designer/assets/79509067/290da19f-eccc-4637-8ae7-199ae05b6447)


To plot a line graph:

- h2 = animatedline(app.UIAxesOfRollAngle, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf);
- addpoints(h2, timeInSecond, data(2)); % roll

![image](https://github.com/andtr-2021/Matlab-App-Designer/assets/79509067/30a38a6b-cd82-4514-8b1a-eecf0322f2dc)

To plot a IMU Orientation 3D Rendering Graph:

- As the system just launches: 

![image](https://github.com/andtr-2021/Matlab-App-Designer/assets/79509067/defd53f0-2bae-488b-aa75-7ebad5c3e2a9)

- As the system works:

![image](https://github.com/andtr-2021/Matlab-App-Designer/assets/79509067/ffe5578c-7f0c-495f-a88f-8458804ebc29)


