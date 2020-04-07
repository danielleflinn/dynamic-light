Table table;
JSONArray values;
JSONObject data;
float[][] currentState;
float[][] nextState; //the second array to be compared with the first
float[][] storeSmooth;
PGraphics export;

int pulls;
int frac;
 
void setup() {
  size(224,100);
  //println(height);
  
    
  //create an array showing the last 8 hours of data: 1024px / 8hrs = 128px per 1hour
  //128px / 4 = 32px per 15 mins
  //4x8 = 32 data pulls in 8 hrs
    
   pulls = 32;             //number of data pulls to display; whould be divisable by width and no more than width; recommended to be at least 32 for a 1024 pixel screen
   frac = width/pulls;     //number of pixels in each section
  
  currentState = new float [width][height];
  nextState = new float[width][height];
  storeSmooth = new float[width/pulls][height];


  values = loadJSONArray("data.json");
  getSmooth(storeSmooth, values.getJSONObject(0), values.getJSONObject(1));
}
 
void draw() {
  scale(1, -1);
  translate(0, -height);      //make the bottom left corner the orgin
  background(#fcdc78);
  
  //getScreenState(nextState, values);
  
  //drawScreen(nextState, currentState);
  

  //printProduction(currentState);  //exports image for AR
  //printUsage(currentState);      //exports image for AR
  
  //delay(10); //delay in seconds between each data pull; 900 if pulling every 15 minutes
  
  //need to smooth the view
  //need to make it move
  
}

void getScreenState(float[][] twoDArray, JSONArray values) { //gets the state for each cell in the 2D array to store current state
  JSONObject data; 
  float high;
  float low;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){ //this will likely be j + pulls
      data = values.getJSONObject(i);
      high = getHigh(data);
      low = getLow(data, high);
      twoDArray[i][j] = getCellState(high, low, j); //need to call the smooth function here while j is not divisable by frac
      //println("i = " + i + " j = " + j);
    }
  }
}

float getHigh(JSONObject data) { //calculates the ratio between input values and returns the hieght
  float pro = data.getFloat("Production");
  float use = data.getFloat("Usage");
  float high = use/(use+pro)*height; //multiply by height to get number of pixels that should be in usage
  return high;
}

float getLow(JSONObject data, float high) { //calculates the ratio between input values and returns the hieght
  float pro = data.getFloat("Production");
  float use = data.getFloat("Usage");
  float plug = data.getFloat("Plugload");
  float low = high - (plug/(use+pro)*height); //take the height from usage and subtract plug load height so that plug load starts at the top of usage
  return low;
}

void getSmooth(float[][] twoDArray, JSONObject data, JSONObject data2) {
  float high = getHigh(data);
  float low = getLow(data, high);
  
  for (int i = 0; i < height; i++) {
     twoDArray[0][i] = getCellState(high, low, i);  //set the states of the first column in the array
  }
  
  float high2 = getHigh(data2);
  float low2 = getLow(data, high);
  
  for (int i = 0; i < height; i++) {
    twoDArray[width/pulls-1][i] = getCellState(high2, low2, i);  //set the states of the last column in the array
  }  

  float highChange = getChange(high, high2) / frac;
  float lowChange = getChange(low, low2) / frac;

  for (int i = 1; i < width/pulls-1; i++) {
     for(int j = 1; j < height; j++) {
       high = high + highChange;
       low = low +lowChange;
       twoDArray[i][j] = getCellState(high, low, i);
     }
  } 
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

void drawScreen(float[][] nextState, float[][] currentState) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      
      if (nextState[i][j] != currentState[i][j]) {
        if (nextState[i][j] == 2) {
          noStroke();
          fill(#296196);
          square(i, j, 1);
        }
        else if (nextState[i][j] == 1) {
          noStroke();
          fill(#41948e);
          square(i, j, 1);
        }
        else {
          noStroke();
          fill(#fcdc78);
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


  
