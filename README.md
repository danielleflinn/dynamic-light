# dynamic light
 
The current program "dynamiclight" references a static json file that includes mock data. To make the program display a more accurate visual representation of the current data, the json file the program references needs to be updated in regular intervals. The instructions below outline what needs to be changed to in the program to work with a new json file. It also includes detail on how to customize the program for different sized displays, number of data points, and time range displahyed.

## setup()

-set the size of the display area using size("width", "height") \s\s
-set the number of data points you want to be reflected in the display, by defining “pulls”; this should be 1 value less than the length of the json file \s\s
-set the “values” json array by adding the file path as a string \s\s
-set the “numPulls” variable to the index value of the second to last json object from the data file \s\s

## draw()

-this is a constantly looping function \s\s
-in the first if statement, the “numPulls++” should be deleted; as the data file that the program references should be automatically updated (from external export) before each time the file is referenced thus, numPulls will be a static value. \s\s
-set the delay to (time in seconds/width) = delay in seconds * 1000 = delay in milliseconds. \s\s

## printProduction() & printUsage()

-these functions export the current image displayed; change the final line to the correct path destination so the AR experiences can reference these

## JSON file:

The json file to be referenced should be formatted the following way:\s\s
[\s\s
  {\s\s
    "Production": 0,\s\s
    "Usage": 162.3564,\s\s
    "Plugload": 8.8689\s\s
  },\s\s
  {\s\s
    "Production": 0,\s\s
    "Usage": 124.1661,\s\s
    "Plugload": 8.8424\s\s
  }\s\s
]\s\s
\s\s
-The number of json objects in the file should be equal to the pulls variable in the processing program plus 1.\s\s
-The first object in the file should be the oldest; with the final object in the file the most recent data values.\s\s
-Make sure the export writing this file, exports and overwrites the file every time/pulls so that the file is ready when the processing program accesses it for new data.