% recordPhysio.m
% Set of functions for recording physio output during a scan at BIAC 5
%
% version: 2/24/12 - jjm
%
% Note:
% These functions have been written to read from the analog channels 
% specified at http://wiki.biac.duke.edu/biac:experimentalcontrol:biac5hardware
% If you experience errors, check with that site to make sure the channels
% haven't changed
%
% Currently, these functions utilize the DAQ toolbox for Matlab (in fact,
% they're mainly just a convenient all-in-one wrapper for the fncs we'd
% use the most).Unfortunately, it is only available for Windows. If you wish 
% to record physio meaures in OSX, check out the DAQ toolkit that comes 
% packaged with PsychToolBox. Unfortunately, that toolkit only works with 
% OSX. The incompatibility is due to the way windows handles PsychHID. The 
% PTB forums hint that there will be an update soon which will allow 
% complete portablity between operating systems. Until then....
%
% USAGE:
%   To initialize the analog recording object:
%       myObject = recordPhysio('init')
%
%   To start recording from all channels:
%       myObject = recordPhysio('start', myObject)
% 
%   To stop recording:
%       myObject = recordPhysio('stop', myObject)
%
%   To retrieve all collected data and timestamps:
%       myOutPut = recordPhysio('getData', myObject)
%       
%       *myOutPut will be a structure containing a DATA field (n_datapts x
%       n_channels vector of recorded data), and a TIMES field (n_datapts
%       x 1 vector of timestamps)


function out = recordPhysio(subfunc, varargin)
% general parent function for all recordPhysio subfunctions
if nargin == 2
    ai = varargin{1};
end

% figure out which subfunction to run
if strcmp(subfunc, 'init')
    out = initializePhysio();
elseif strcmp(subfunc, 'start')
    out = startPhysio(ai);
elseif strcmp(subfunc, 'stop');
    out = stopPhysio(ai);
elseif strcmp(subfunc, 'getData');
    out = getData(ai);
else
    disp(['cannot find input option: ' subfunc]); 
end


function ai = initializePhysio()

% device info
adaptor = 'mcc';                % measurement computing A/D box name
id = 0;                         % id num of A/D box

% create object
ai = analoginput(adaptor, id);

% channels to record from:
% see http://wiki.biac.duke.edu/biac:experimentalcontrol:biac5hardware
% settings (as of 2/24/12):
% CHANNEL:  DEVICE:
%   0           Biopac Respiration Belt
%   1           Biopac GSR
%   2           Biopac EEG
%   3           Biopac Cardiac (pulse)
%   4           Biopac Cardiac (OxSat)
%   5           Scanner Trigger (input from scanner)
addchannel(ai, 0, 'respChannel');          % add resp channel, give it a convenient name
addchannel(ai, 3, 'pulseChannel');         % add pulse channel, give it a convenient name
addchannel(ai, 5, 'scannerTrigger');	   % add scanner trigger channel, give it a convenient name

% configure object recording parameters:
set(ai, 'SampleRate', 100);             % sampling rate (in Hz)
set(ai, 'SamplesPerTrigger', Inf);       % numbers of samples to collect after start. 'Inf' for continuous collection (until stop)

function ai = startPhysio(ai)
% function to begin recording from all specified channels. Record times
% will be referenced against the time at which this is called
start(ai)

function ai = stopPhysio(ai)
% function to stop recording from all specified channels.
stop(ai)

function recordedPhysio = getData(ai)
% function to retrieve all data collected (and timestamps) from the
% specified channels. Will return a struct with 2 fields: 
% DATA - (n_datapts x n_channels vector of recorded data)
% TIMES - (n_datapts x 1 vector of timestamps)
[data, times] = getdata(ai, ai.SamplesAcquired);
recordedPhysio.data = data;
recordedPhysio.times = times;














