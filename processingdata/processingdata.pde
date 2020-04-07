Table table;
JSONArray values;
JSONObject data;
float[][] currentState;
float[][] nextState; //the second array to be compared with the first

PGraphics export;

int pulls;
int frac;
 
void setup() {
  size(1024,768);
  //println(height);
  
    
  //create an array showing the last 8 hours of data: 1024px / 8hrs = 128px per 1hour
  //128px / 4 = 32px per 15 mins
  //4x8 = 32 data pulls in 8 hrs
    
   pulls = 32;             //number of data pulls to display, no more than 1024; recommended to be at least 32
   frac = width/pulls;     //number of pixels in each section
  
  currentState = new float [width][height];
  nextState = new float[width][height];

  values = loadJSONArray("data.json");
  
  
  
}
 
void draw() {
  scale(1, -1);
  translate(0, -height);      //make the bottom left corner the orgin
  background(#fcdc78);
  
  getScreenState(nextState, values);
  
  drawScreen(nextState, currentState);
  
  //printProduction(currentState);
  //printUsage(currentState);
  
  //delay(10); //delay in seconds between each data pull; 900 if pulling every 15 minutes
  
  //need to smooth the view
  //need to define the nextState 2D array
  //need to compare with currentState;
  //need to 
  
}

void getScreenState(float[][] twoDArray, JSONArray values) { //gets the state for each cell in the 2D array to store current state
  JSONObject data; 
  float high;
  float low;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){ //this will likely be j 
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

float getChange(float val, float val2) { //gets the change between 2 data values to graph the "smooth"
  
  float num = val + val2;
  return num;
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
  export.endDraw();                     // Stop drawing to the PGraphics object 
  export.save("production.jpg");
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
  export.endDraw();                     // Stop drawing to the PGraphics object 
  export.save("usage.jpg");
}


  
