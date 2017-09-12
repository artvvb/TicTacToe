# TicTacToe

This project was initially written for the WSU Hackathon in February 2015.

Uses Vivado 2016.4 targetting a Digilent Nexys4 FPGA board

In order to program this project onto your board, follow the tutorial found here: https://reference.digilentinc.com/learn/programmable-logic/tutorials/github-demos/start

To use:

  plug into VGA monitor
  
  play (users alternate placing pieces using the d-pad buttons, navigate the cells using U/D/R/L, submit a move using C)
  
  when a player has won, an led will light up, and the winning line will be highlighted in green on the display
  
  press the cpu_resetn button to start a new game

TODO:
Provide source for png/bmp to ".hex" converter. I currently only include the resulting file, should provide an image viewable in an editor and source to create an executable to process said image into a file that Vivado can use.
