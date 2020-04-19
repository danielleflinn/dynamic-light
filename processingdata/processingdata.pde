Table table;
JSONArray values;
JSONObject data;
PGraphics export;

float[][] currentState;
float[][] nextState; //the second array to be compared with the first
float[][] storeSmooth;

int pulls;
int frac;

int count;         //track number of times smooth function is run 
int numPulls;     //To be deleted; but will count number of pulls from the static json file so that we pull in a new data point each time

void setup() {
  size(1024,768);
  
    
  //create an array showing the last 8 hours of data: 1024px / 8hrs = 128px per 1hour
  //128px / 4 = 32px per 15 mins
  //4x8 = 32 data pulls in 8 hrs
    
  pulls = 8;             //number of data pulls to display; whould be divisable by width and no more than width; recommended to be at least 32 for a 1024 pixel screen
  frac = width/pulls;     //number of pixels in each section
  
  currentState = new float [width][height];
  nextState = new float[width][height];
  storeSmooth = new float[frac][height];


  values = loadJSONArray("data.json");
  
  getScreenState(nextState, values); //getScreenState gets initial screen state, which calls json file number of pulls times;
  
  count = 1;
  numPulls = pulls;   //set to pulls while testing with static JSON file; change this to secind to last Json object in file, thus bulling in the 2 most recent and new objects
  
  getSmooth(storeSmooth, values.getJSONObject(numPulls), values.getJSONObject(numPulls+1), 0);  //grabs the 2 most recent JSONObjects
  
}
 
void draw() {
  scale(1, -1);
  translate(0, -height);      //make the bottom left corner of screen the orgin
  background(#fcdc78);
  
  drawScreen(nextState, currentState);
  
  //printProduction(nextState);  //exports image for AR, move both into one of the if statements so the program only exports everytime new data is called from the Json.
  //printUsage(nextState);      //exports image for AR
  
  if (count == 0) {
    numPulls++;    //in final, this line to be deleted and numPulls will be a constant variable always pulling in the last 2 object / most recent objects in the json file
    getSmooth(storeSmooth, values.getJSONObject(numPulls), values.getJSONObject(numPulls+1), 0);
  }
  
  getNextState(nextState, storeSmooth, count);
  count++;
  
  if ( count == frac) {
    count = 0;
  }
  //delay(900); //delay in seconds between each data pull; 900 if pulling every 15 minutes
  
  
  //need to confirm the initial data flow is correct; 0,0 should not be 0,0 of the json file; try changing the start value of the getScreenState to "twoDArray.length - (i*frac)"
  //decide how often the print image functions should run. 
  //Currently they will export each time the 2d array is drawn, which is about every 30 seconds. 
  //Is this too much for the program?
}

void getNextState(float[][] twoDArray, float[][] storeSmooth, int count){  //a basic push 2d array function; need to fix
  for (int i = twoDArray.length -1; i > 0; i--) {  //indicates column
     for(int j = 0; j < height; j++) {  //indicates row
       twoDArray[i][j] = twoDArray[i-1][j];
     }
  }
  for(int j = 0; j < height; j++) {  //indicates row
       twoDArray[0][j] = storeSmooth[count][j];
     }
}

void getScreenState(float[][] twoDArray, JSONArray values) { //gets the state for each cell in the 2D array to store current state
  JSONObject data; 
  JSONObject data2; 
  int j = 0;
  
  for (int i = pulls; i > 0; i--) {  //calls data number of pull times
      data = values.getJSONObject(i);
      data2 = values.getJSONObject(i-1);
      getSmooth(twoDArray, data, data2, j*frac); //get smooth calculates the columns in each frac, starts with i*frac
      j++;
  }
}

void getSmooth(float[][] twoDArray, JSONObject data, JSONObject data2, int start) {   //calculates the high and low points for the pixels between the actual data points 
  float high = getHigh(data);
  float low = getLow(data, high);
  
  for (int i = 0; i < height; i++) {
     twoDArray[start][i] = getCellState(high, low, i);  //set the states of the first column in the 2d array
  }
  
  float high2 = getHigh(data2);
  float low2 = getLow(data2, high2);
 

  float highChange = (getChange(high, high2)) / frac;
  float lowChange = (getChange(low, low2)) / frac;

  for (int i = start + 1; i < start + frac; i++) {    //sets the states for the remainder of the columns between each data
     for(int j = 0; j < height; j++) {  //indicates row
       twoDArray[i][j] = getCellState(high, low, j);
     }
      high = high + highChange;
      low = low + lowChange;
  } 
}

float getHigh(JSONObject data) { //calculates the ratio between input values and returns the hieght
  float pro = data.getFloat("Production");
  float use = data.getFloat("Usage");
  return (use/(use+pro))*height; //multiply by height to get number of pixels that should be in usage
}

float getLow(JSONObject data, float high) { //calculates the ratio between input values and returns the hieght
  float pro = data.getFloat("Production");
  float use = data.getFloat("Usage");
  float plug = data.getFloat("Plugload");
  return (high - (plug/(use+pro))*height); //take the height from usage and subtract plug load height so that plug load starts at the top of usage
}

float getChange(float val, float val2) { //gets the change between 2 data values to graph the "smooth"
  return val2 - val;
}

int getCellState(float high, float low, int j) { //takes in the high (top of plug load and usage) and the low (bottom of plug load) and 
                                          //returns the state of a cell; 0, 1, or 2; 0 being yellow, 1 being green, and 2 being blue
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

void drawScreen(float[][] nextState, float[][] currentState) {      //draws the screen state
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      
      if (nextState[i][j] != currentState[i][j]) {
        if (nextState[i][j] == 2) {
          noStroke();
          fill(#296196);    //blue
          square(i, j, 1);
        }
        else if (nextState[i][j] == 1) {
          noStroke();
          fill(#41948e);    //green
          square(i, j, 1);
        }
        else {
          noStroke();
          fill(#fcdc78);    //yellow
          square(i, j, 1);
        }
        //currentState[i][j] = nextState[i][j]; //set currentState to nextState
      }
    }
  }
}

void printProduction(float[][] twoDArray) { //exports image of the screen to be used in the AR experience;  2 one for usage and one for production
  export = createGraphics(width, height);  // Create a new PGraphics object
  export.beginDraw();                   // Start drawing to the PGraphics object 
 
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
  export.save("production.jpg");       //change this String to a path to save to a folder other than where the Sketch is 
}

void printUsage(float[][] twoDArray) {     //exports image of the screen to be used in the AR experience;  2 one for usage and one for production
  export = createGraphics(width, height);  // Create a new PGraphics object
  export.beginDraw();                       // Start drawing to the PGraphics object 
 
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
  export.save("usage.jpg");             //change this String to a path to save to a folder other than where the Sketch is 
}


  
