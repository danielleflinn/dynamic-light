# Dynamic Light Overview
 
This program uses the open source platform Processing to run. The program takes in 3 different data values and compares them to calculate a ration that is then displayed in a visual graph throught color and shape. 

The program references a json file to pull in a set amount of data. This file should be updated on regular intervals. For example, if the display is showing 8 hours of data with 32 data points (one data value for every 15 minutes), the json data file should be updated every fifteen minutes and should contain 33 data values (see below for more details).

Alternatively, you can run the program in test mode with a large data file and update the file less frequently. For example, the data file could contain 24 hours of data points showing values every 15 minutes (a total of 96 json objects). However, the program would only display 32 of these data points at a time (8 hours) and would pull in 15 minutes of data every 15 minutes. Thus, reaching the end of the data file about 24 hours later. However, in this model the data on the screen would reflect the previous day's energy performacne. We recommend showing the current day's values. 

## Customize Program

Open the config.json file found in the "data" folder. Here is where you can customize the program.

  - "Test": 
   Set this to "N". Use "Y" only while testing with a static data file that has at least 24hours of data points. Make sure you update the file and reset the program, before reaching the end of this file, otherwise the program will get an "index out of bounds" error. 

  - "displayedDataPoints": 
   Set this to the number of data points you want to display. This should be 1 value less than the length of the data json file.

  - "dataFilePath": 
   Set this to the path of the data json file you wish the program to reference.

  - "delay": 
   Set this to your desired delay for the program in miliseconds. This controls the speed at witch pixels move across the screen. For the program to work correctly; this value should follow this formula: (time in seconds/width) = delay in seconds * 1000 = delay in milliseconds.

  - "exportFilePathProduction": 
   Set this to the file path to where the exports of the display can be referenced by the AR experiences. Make sure the path ends in "Production.jpg".

  - "exportFilePathUsage":
   Set this to the file path to where the exports of the display can be referenced by the AR experiences. Make sure the path ends in "Usage.jpg"

## Data JSON File

The json file to be referenced should be formatted the following way: <br/>

<code>
[ <br/>
  { <br/>
    "Production": 0, <br/>
    "Usage": 162.3564, <br/>
    "Plugload": 8.8689<br/>
  }, <br/>
  { <br/>
    "Production": 0,<br/>
    "Usage": 124.1661,<br/>
    "Plugload": 8.8424<br/>
  }<br/>
]<br/>
</code>

- The number of json objects in the file should be equal to the "displayedDataPoints" variable in the config file plus 1. <br/>
- The first object in the file should be the oldest; with the final object in the file the most recent data values.
- Make sure the program writing this file will export and overwrite this file every (time/displayedDataPoints) so that the file is ready when the processing program accesses it for new data.

## Function Explainations

### setup()

- sets the size of the display area using size("width", "height") 
- loads the config file
- sets variables based on the config file
- loads the data file
- calculates the initial screen state
- calculates the first dif state between most recent 2 data points

### draw()

- this is a constantly looping function <br/>
- draws the screen
- exports images of the screen
- checks to see if config file is testing with static data file
- calls calc next state
- counts this display 1 time, resents to zero if equal to numPixelsPerPoint
- delays length of time as defined by config file


### loadConfig 

- takes in the config json object
- sets variables based on the contents of this file

### intScreenState

- takes in 2D array for nextScreenState and the json array of data
- uses the first series of objects to calculat the first state of the screen
- this is only run once on program startup

### test()

- only to be run when using a large static data file; see "Customize Program" above
- increases variable that defines which json object is being called by 1

### calcNextState

- takes in two 2D arrays, one holding the current screen state and one holding the temp calc difference state, and an int countPixels, which defines how many times this function has been called since referencing the data json file.
- takes a row fromt he temp 2D array and adds it to the current screen state 2D array

### calcDifState

- takes in one 2D array, 2 json objects, and an int which defines the where the start index. Which should be 0 for any call to this function, other than the call intScreenState makes.
- calculates the ratio between the 3 numbers in each json object
- takes the difference between the 2 resulting ratios
- assigns a value to each index in 2d array index based on calculated ratios, increminting the differnece between the ratios evenly

### getHigh

- takes in 1 json object
- returns the ratio between usage and total energy (usage + production) multiplied by height of display

### getLow

- takes in 1 json object and 1 float value, defined as high
- returns the difference between high variable and the ratio between plugload and total usage multiplied by the height of display

### getChange

- takes in 2 variables
- returns the difference between the variables

### getCellState

- takes in a high and low variable and and the int of an index
- returns 0, 1, 2 based on if the index is above, between, or below the high and low variables

### drawScreen

- takes in the nextScreenState and currentScreenState 2D arrays to compare
- tells only the pixels in nextScreenState that are different than currentScreenState to change color
- thus display doesn't have to redraw each pixel each time the program runs, but only redraws the pixels that are changing.

### exportProduction

- takes in the a 2D array and exports that state of the screen to an image with usage grayed out

### exportUsage

- takes in the a 2D array and exports that state of the screen to an image with production grayed out
