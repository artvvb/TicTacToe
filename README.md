# TicTacToe

This project was initially written for the WSU Hackathon in February 2015.

Can be compiled using Xilinx ISE or Vivado targetting a Digilent Nexys4, not tested on any other devices (which would require different constraint files).

To use, add the source to a Vivado project (or ISE, but that would require translation of the XDC to UCF) and synthesize/implement/generate a bitstream. Program the bitstream onto a Nexys4 with a monitor attached to the VGA connector. Control through D-Pad push buttons.

TODO:
Provide source for png/bmp to ".hex" converter. I currently only include the resulting file, should provide an image viewable in an editor and source to create an executable to process said image into a file that Vivado can use.
