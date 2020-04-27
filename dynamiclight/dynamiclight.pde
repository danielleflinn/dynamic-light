//config variables
private String test;
private int displayedDataPoints; 
private String dataFilePath;
private int delay;
private String exportFilePathProduction;
private String exportFilePathUsage;

private JSONArray values;
private JSONObject data;

private float[][] currentScreenState;   
private float[][] nextScreenState;     
private float[][] storeDifState;       //a temporary array holding the states for pixels between 2 data displayedDataPoints

private int numPixelsPerPoint;    
private int countPixels;                 
private int numDisplayedDataPoints; 

PGraphics export;

void setup() {
  size(1024,768);         //the resolution of the panels or display 
  background(#fcdc78);
  
  JSONObject config = loadJSONObject("config.json");
  loadConfig(config);
          
  numPixelsPerPoint = width/displayedDataPoints;    
  
  currentScreenState = new float [width][height]; 
  nextScreenState = new float[width][height];
  storeDifState = new float[numPixelsPerPoint][height];          //sets the temp array to be the size of pixels between each data point

  values = loadJSONArray(dataFilePath);    //energy data 
  
  intScreenState(nextScreenState, values); 
  
  countPixels = 1;
  numDisplayedDataPoints = displayedDataPoints;   
  
  calcDifState(storeDifState, values.getJSONObject(numDisplayedDataPoints), values.getJSONObject(numDisplayedDataPoints+1), 0);  
  
}
 
void draw() {
  scale(1, -1);
  translate(0, -height);      //make the bottom left corner of screen the orgin

  drawScreen(nextScreenState, currentScreenState);
  
  exportProduction(nextScreenState);  
  exportUsage(nextScreenState);      
  
  if (countPixels == 0) {
    if (test.equals("Y")) {
      test();
    }
    calcDifState(storeDifState, values.getJSONObject(numDisplayedDataPoints), values.getJSONObject(numDisplayedDataPoints+1), 0);
  }

  calcNextState(nextScreenState, storeDifState, countPixels);
  countPixels++;
    
  if ( countPixels == numPixelsPerPoint) {
    countPixels = 0;
  }
    
  delay(delay);  
}

private void loadConfig(JSONObject config) {
    
  test = config.getString("test");
  displayedDataPoints = config.getInt("displayedDataPoints");  
  dataFilePath = config.getString("dataFilePath");
  delay = config.getInt("delay");
  exportFilePathProduction = config.getString("exportFilePathProduction");
  exportFilePathUsage = config.getString("exportFilePathUsage");
  
}

private void intScreenState(float[][] twoDArray, JSONArray values) { 
  JSONObject data; 
  JSONObject data2; 
  int j = 0;
  
  for (int i = displayedDataPoints; i > 0; i--) {  
      data = values.getJSONObject(i);
      data2 = values.getJSONObject(i-1);
      calcDifState(twoDArray, data, data2, j*numPixelsPerPoint);
      j++;
  }
}

private void test() {     
      numDisplayedDataPoints++;    
}

private void calcNextState(float[][] twoDArray, float[][] storeDifState, int countPixels){  //takes column of pixels from storeDifState and adds to calcNextState
  for (int i = twoDArray.length -1; i > 0; i--) {  
     for(int j = 0; j < height; j++) {  
       twoDArray[i][j] = twoDArray[i-1][j];
     }
  }
  for(int j = 0; j < height; j++) {  
       twoDArray[0][j] = storeDifState[countPixels][j];
     }
}

private void calcDifState(float[][] twoDArray, JSONObject data, JSONObject data2, int start) {   //calculates the high and low points for the pixels between the actual data points 
  float high = getHigh(data);
  float low = getLow(data, high);
  
  for (int i = 0; i < height; i++) {
     twoDArray[start][i] = getCellState(high, low, i);  //set the states of the first column in the 2d array
  }
  
  float high2 = getHigh(data2);
  float low2 = getLow(data2, high2);
 

  float highChange = (getChange(high, high2)) / numPixelsPerPoint;
  float lowChange = (getChange(low, low2)) / numPixelsPerPoint;

  for (int i = start + 1; i < start + numPixelsPerPoint; i++) {    //sets the states for the remainder of the columns between each data point
     for(int j = 0; j < height; j++) {               
       twoDArray[i][j] = getCellState(high, low, j);
     }
      high = high + highChange;
      low = low + lowChange;
  } 
}

private float getHigh(JSONObject data) { 
  float pro = data.getFloat("Production");
  float use = data.getFloat("Usage");
  return (use/(use+pro))*height; 
}

private float getLow(JSONObject data, float high) { 
  float pro = data.getFloat("Production");
  float use = data.getFloat("Usage");
  float plug = data.getFloat("Plugload");
  return (high - (plug/(use+pro))*height);
}

float getChange(float val, float val2) { 
  return val2 - val;
}

int getCellState(float high, float low, int j) { //takes in the high (top of plug load and usage) and the low (bottom of plug load) and 
                                                //returns the state of a cell; 0 = yellow, 1 = green, and 2 = blue
  if (j < low) {
    return 2;
  }
  else if (j < high) {
    return 1;
  }
  else {
    return 0;
  }
}

private void drawScreen(float[][] nextScreenState, float[][] currentScreenState) {     
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      
      if (nextScreenState[i][j] != currentScreenState[i][j]) {
        if (nextScreenState[i][j] == 2) {
          noStroke();
          fill(#296196);    //blue
          square(i, j, 1);
        }
        else if (nextScreenState[i][j] == 1) {
          noStroke();
          fill(#41948e);    //green
          square(i, j, 1);
        }
        else {
          noStroke();
          fill(#fcdc78);    //yellow
          square(i, j, 1);
        }
        nextScreenState[i][j] = nextScreenState[i][j];
      }
    }
  }
}

private void exportProduction(float[][] twoDArray) { 
  export = createGraphics(width, height);  
  export.beginDraw();                   
 
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      if (twoDArray[i][j] == 2) {
        export.noStroke();
        export.fill(#A9A9A9);
        export.square(i, j, 1);
      }
      else if (twoDArray[i][j] == 1) {
        export.noStroke();
        export.fill(#D3D3D3);
        export.square(i, j, 1);
      }
      else {
        export.noStroke();
        export.fill(#fcdc78);
        export.square(i, j, 1);
      }
    }
  }
  export.endDraw();                     
  export.save(exportFilePathProduction);       
}

private void exportUsage(float[][] twoDArray) {     
  export = createGraphics(width, height);  
  export.beginDraw();                       
 
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      if (twoDArray[i][j] == 2) {
        export.noStroke();
        export.fill(#296196);
        export.square(i, j, 1);
      }
      else if (twoDArray[i][j] == 1) {
        export.noStroke();
        export.fill(#41948e);
        export.square(i, j, 1);
      }
      else {
        export.noStroke();
        export.fill(#D3D3D3);
        export.square(i, j, 1);
      }
    }
  }
  export.endDraw();                     
  export.save(exportFilePathUsage);             
}


  
