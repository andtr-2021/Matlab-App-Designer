# Matlab-App-Designer

To set up the seriaml communitcatoin betwen the Matlab App and the microcontroller (MCU), we need to configure the port and the baurd rate:
s = serialport('COM14', 9600);
configureTerminator(s, "CR/LF"); // terminated by a CR/LF sequence.
data = readline(s); // readline funciton to read data from the mcu.
flush(s); // clear the previous reading
