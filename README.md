PARTIOR 
Q-1 Aircraft Senior Design Code
Virginia Polytechnic Instituste and State Univeristy (Virginia Tech), Aerospace and Ocean Engineering
2015-2016 NASA Collegiate Design Competition; "Distributed Electric Propulsion Commuter Airliner Design"
*****

Graham McLaughlin, Team Lead
Alex Brown
Kiana Duff
Alex Granata
Sean Hardy
Jake Hrovat
Emily Konoza

Point of Contact:
  Alex Granata: granataa@vt.edu
*****

File folder /PropWash/ contains the most recent codes for developing a V-H diagram for an aircraft utilizing propwash over a majority of the wing span.

  As of Version 3.5, 30 NOV 2015, files within /PropWash/ are and have the following functions:

v_h_propwash.m
  Main Script file for entire folder. All other scripts and functions are supporting to this script. 
  Calculates and graphs a Velocity-Height Diagram of the aircraft defined by prop_const.m (Constants)
  Calculates and graphs a fuel-economy contour
  Calculates and graphs stall lines, AoA for level flight, max possible level N-Turn, as well as reference 250 and 300 mph lines

**** 
Scripts that stand independant of v_h_propwash.m:

trade_props.m
  Study on summed Power of props to number of props

ld_wash_comp.m
  Comparision of Developed Cl/Cd [of propwash] to norm [i.e. parabolic Cd]

compar_wash.m
  Compares various ariplane parameters to chosen cruise conditions, [for optimizing parameters
