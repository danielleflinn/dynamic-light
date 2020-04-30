
# Function Explanations

### setup()

Inputs: None
Output: None

- sets the size of the display area using size("width", "height") 
- loads the config and data files
- calculates the initial screen state

### draw()

Inputs: None
Output: None

- this is a constantly looping function
- calls other functions to run program


### loadConfig 

Inputs: JSONObject 
Output: None

- sets variables based on the contents of json object

### intScreenState

Inputs: float[][] 2dArray, JSONArray values
Output: None

- uses the first series of objects to calculate the first state of the screen
- this is only run once on program startup

### test()

Inputs: None
Output: None

- only to be run when using a large static data file; see "Customize Program" above
- increases variable that defines which json object is being called by 1

### calcNextState

Inputs: float[][] 2dArray, float[][] temp, int count
Output: None

- takes a row from the temp 2D array and adds it to the other 2D array (current screen)

### calcDifState

Inputs: float[][] 2dArray, JSONObject one, JSONObject two, int start
Output: None

- calculates the ratio between the 3 values in each json object
- takes the difference between the 2 resulting ratios
- assigns a value to each index in 2d array 

### getHigh

Inputs: JSONObject data
Output: float high 

- calculates ratio between values

### getLow

Inputs: JSONObject data, float high
Output: float low

- calculates ratio between values and subtracts from high

### getChange

Inputs: float high, float low
Output: float difference

- returns the difference between the variables

### getCellState

Inputs: float high, float low
Output: int state

- returns 0, 1, 2 based on if the index is above, between, or below the high and low variables

### drawScreen

Inputs: float[][] 2dArray, float[][] second2dArray
Output: None

- compares each index, if different draws that pixel on screen

### exportProduction

Inputs: float[][] 2dArray
Output: None

- exports that screen state to an image with production area grayed out

### exportUsage

Inputs: float[][] 2dArray
Output: None

- exports that screen state to an image with usage area grayed out