/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h" // add
#include "xiomodule.h" // add


int main(){
	init_platform();
	 u32 data;
	 XIOModule iomodule; // iomodule variable for gpi, gpo, and uart
	 u8 msg[15] = "This is a test";// buffer for sending message using XIOModule_Send
	 u8 rx_buf[10]; // receive buffer using XIOModule_Recv
	 u32 counter;
	 // example using xil_printf
	 counter = 1234;
	 xil_printf("The counter value is %d in decimal and %x in hex\n\r", counter,
	counter);
	 print("Read switches, write to LED port, and UART send and receive chars\n\r");
	 // Initialize module to obtain base address
	 data = XIOModule_Initialize(&iomodule, XPAR_IOMODULE_0_DEVICE_ID);
	 data = XIOModule_Start(&iomodule);
	 // Send 12 characters using Send
	 // Send is non-blocking so must be called in a loop, may return without sending a character
	 // unsigned int XIOModule_Send(XIOModule *InstancePtr, u8 *DataBufferPtr, unsigned int NumBytes);
	 const int count = 14;
	 int index = 0;
	 while (index < count) {
		 data = XIOModule_Send(&iomodule, &msg[index], count - index);
		 index += data;
	 }
	 xil_printf("\n\rThe number of bytes sent was %d\n\r", index);
	 // Another way to send individual characters
	 outbyte('X');
	 outbyte(0x37); // number '7'
	 outbyte('Z');
	 outbyte('\n'); // line feed
	 // Receive a character and store in rx_buf
	 // unsigned int XIOModule_Recv(XIOModule *InstancePtr, u8 *DataBufferPtr, unsigned int NumBytes);
	 while
		 ((data = XIOModule_Recv(&iomodule, rx_buf, 1)) == 0);
	 xil_printf("The number of bytes received was %d\n\r", data);
	 xil_printf("Recv: The received char was %c\n\r", rx_buf[0]);
	 // Another way to receive a single character
	 rx_buf[0] = inbyte();
	 xil_printf("inbyte: The received char was %c\n\r", rx_buf[0]);
	 while (1) {
		 data = XIOModule_DiscreteRead(&iomodule, 1); // read switches (channel 1)
		 // data = XIOModule_DiscreteRead(&iomodule, 2); // read push (channel 2)
		 XIOModule_DiscreteWrite(&iomodule, 1, data); // turn on LEDs (channel 1)
	 }
	 cleanup_platform();
	 return 0;
}
