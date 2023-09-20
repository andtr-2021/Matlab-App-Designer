# Matlab-App-Designer

To set up the seriaml communitcatoin betwen the Matlab App and the microcontroller (MCU), we need to configure the port and the baurd rate:
- s = serialport('COM14', 9600);
- configureTerminator(s, "CR/LF"); // terminated by a CR/LF sequence.
- data = readline(s); // readline funciton to read data from the mcu.
- flush(s); // clear the previous reading

Then in the while loop, configure the readline funciton to read the data:

- data = str2double(strsplit(s , ',')); // seperate the data by the deliminator - comma
- data = data(1) // time 
- data = data(2) // loadcell data
- app.loadcellValue.Text = double2str(data(2)) // display the data on matlab's label

To plot a line graph:

- h2 = animatedline(app.UIAxesOfRollAngle, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf);
- addpoints(h2, timeInSecond, data(2)); % roll

