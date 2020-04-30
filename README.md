# Dynamic Light Overview
 
This program uses the open source platform Processing. The program takes in 3 different data values from a JSON array and compares them to calculate a ratio that is then displayed in a visual graph of color and shape. 


## Customize

### config.json

1. Open the config.json file found in the "data" folder

2. "Test": Set this to "N". 
    
3. "displayedDataPoints": Set this to the number of data points you want to display at a time.

4. "dataFilePath": Set this to the api url or the path of the json data

5.  "delay": (time displayed in seconds/1024) * 1000 = delay in milliseconds.<br/>
    (1024 = pixel width of display)

The final 2 variables are the file paths which will need to be accessible by the AR experiences.

6. "exportFilePathProduction": [filepath]/Production.jpg.

7. "exportFilePathUsage": [filepath]/Usage.jpg

### JSON data

The program is designed to get json data from an api or json file. The json data should be updated on regular intervals. 

The json data formatting: <br/>

<code>
[ 
  { 
    "Production": 0, 
    "Usage": 162.3564, 
    "Plugload": 8.8689
  }, 
  { 
    "Production": 0,
    "Usage": 124.1661,
    "Plugload": 8.8424
  }
]
</code>
<br/>
- number of json objects = "displayedDataPoints" + 1. 
- jsonarray[0] = the oldest data, jsonarray[jsonarray.size()] == most recent data
- frequency of update: (time/displayedDataPoints) 

Example: if the display is showing 8 hours of data with 32 data points, the json data should be updated every 15 minutes and should contain 33 data values.



## Alternative Run Method

You can run the program in test mode with a larger amount of json data and update the file less frequently. 

For example, the json data could contain 24 hours of data, with 96 json objects (one object for every 15 minutes). 
The program would only display 32 of these data points at a time (8 hours), pulling in one object every 15 minutes. 
The program would reach the end of the data file about 24 hours later. 

In this model the data on the screen would reflect the previous day's energy performance, which is not ideal. 
We recommend showing the current day's values by using the method noted above. 

To use the alternative run method, follow the steps bellow:

1. Set all variables in config file as you normally would (see above). 
2. Change "Test" to "Y"