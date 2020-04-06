Table table;
JSONArray values;
JSONObject data;
float[][] currentState;


//create an array showing the last 8 hours of data: 1024px / 8hrs = 128px per 1hour
  //128px / 4 = 32px per 15 mins
  //4x8 = 32 data pulls in 8 hrs
  
  //int pulls = 32;     //number of data pulls in all 8 hours
  //int frac = 32;     //number of pixels in each section
 
void setup() {
  size(700,500);
  //println(height);
  
  //float[][] nextState = new float [height][width];
  currentState = new float [width][height];

  values = loadJSONArray("data.json");
  
  //JSONObject data = values.getJSONObject(0); 
  
  //float pro = data.getFloat("Production");
  //float use = data.getFloat("Usage");
  //float plug = data.getFloat("Plugload");

  //println(pro + " of Pro, " + use + " of Use, " + plug + " of Plug");
  
}
 
void draw() {
  background(#fcdc78);
  
  getScreenState(currentState, values);
  
  drawScreen(currentState);
}

void getScreenState(float[][] twoDArray, JSONArray values) { //gets the state for each cell in the 2D array to store current state
  JSONObject data; 
  float high;
  float low;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      data = values.getJSONObject(i);
      high = getHigh(data);
      low = getLow(data, high);
      twoDArray[i][j] = getCellState(high, low, j); 
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


void drawScreen(float[][] twoDArray) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++){
      if (twoDArray[i][j] == 2) {
        noStroke();
        fill(#296196);
        square(i, j, 1);
      }
      else if (twoDArray[i][j] == 1) {
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

void printScreen(float[][] twoDArray) { //exports image of the screen to be used in the AR experience; look into writting 2 of these. One for production and one for usage.
  
  
}
