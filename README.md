# recordPhysio

Set of functions for recording physio output during a scan at BIAC 5

version: 2/24/12 - jjm

## Note:
 These functions have been written to read from the analog channels specified at http://wiki.biac.duke.edu/biac:experimentalcontrol:biac5hardware
If you experience errors, check with that site to make sure the channels haven't changed
 
Currently, these functions utilize the DAQ toolbox for Matlab (in fact, they're mainly just a convenient all-in-one wrapper for the fncs we'd use the most). Unfortunately, it is only available for Windows. If you wish to record physio meaures in OSX, check out the DAQ toolkit that comes packaged with PsychToolBox. Unfortunately, that toolkit only works with OSX. The incompatibility is due to the way windows handles PsychHID. The PTB forums hint that there will be an update soon which will allow complete portablity between operating systems. Until then....

## USAGE:
   To initialize the analog recording object:
       myObject = recordPhysio('init')

   To start recording from all channels:
       myObject = recordPhysio('start', myObject)
 
   To stop recording:
       myObject = recordPhysio('stop', myObject)

   To retrieve all collected data and timestamps:
       myOutPut = recordPhysio('getData', myObject)
       
       *myOutPut will be a structure containing a DATA field (n_datapts x
       n_channels vector of recorded data), and a TIMES field (n_datapts
       x 1 vector of timestamps)
