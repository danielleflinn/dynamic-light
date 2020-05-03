# Recommendations

We recommend displaying 8 hours of data on the display at a time. This time range shows occupants what a full work day looks like. In the morning (the display shows 8am-12am), occupants can see how their energy interactions affect total energy as compared to when there were no occupants in the building (during the night). It also allows them to see the overall energy usage for a full work day when they leave the building at the end of their work day (the display shows 5pm-9am).

## Recommendations for data.json 

The number of json objects in the json file reflects how accurate the visual display is to the actual energy data; for 8 hours of data we recommend one data point every 15 minutes, or 32 data points. This translates to 33 json objects, since the display is always moving we need 1 extra data point to help calculate the incoming pixel values.  

The json file should then be updated every 15 minutes to provide the program with one new data point. Note that only one new object is added to the end of the file and the oldest object is taken off; the other objects between simply move down one index value. 

<bq>
For example, if we have a json array with 3 values, [0, 1, 2], when the file is updated, the new file should reflect [1, 2, 3]; with "3" being the new data value. </bq>


## Recommendations for config.json


```
{
   "test": "No", 
   "displayedDataPoints": 32,
   "dataFilePath": [your url or path here],
   "delay": 28000,
   "exportFilePathProduction": "[your path here]/Production.jpg",
   "exportFilePathUsage": "[your path here]/Usage.jpg"
}
```
