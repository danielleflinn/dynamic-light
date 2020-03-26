Table table;
String string;

int num = 1024; //setting the length of array thus dividing the canvas in columns
//float[] arrayOfFloats = new float[num]; 
float[] plugLoadArray = new float[num];
float[] usageArray = new float[num];
float[] productionArray = new float[num];

 
void setup() {
  size(1024,768);
  smooth();
  
    table = loadTable("data.csv", "header");
  //println(table.getRowCount() + " total rows in table"); //prints in console total rows in CSV
  
  //create an array showing the last 8 hours of data: 1024px / 8hrs = 128px per 1hour
  //128px / 4 = 32px per 15 mins
  //4x8 = 32 data pulls in 8 hrs
  
  int pulls = 32;     //number of data pulls in all 8 hours
  int frac = 32;     //number of pixels in each section
  int val = 0;       //the exact pixel, or data point in the array
  
  for (int i = 0; i < pulls; i++) {                 //location of data value in csv file
      float nums = table.getFloat(i, "Plugload");   //gets the plugload value from csv file
      float use = table.getFloat(i, "Usage");       //gets the usage value from csv file
      float pro = table.getFloat(i, "Production");  //gets the production value from csv file
      
      for(int f = 0; f < frac; f++) {         //counts the number of times value is assigned to a pixel
          plugLoadArray[val] = nums;          //assigns value from csv to pixel in array
          usageArray[val] = use;
          productionArray[val] = pro;

          val++;
      }
  }
  //println(plugLoadArray[1]);

}
 
void draw() {
  background(#fcdc78);
 
  //// copy everything one value down
  //for (int i= num-1; i > 0; i--) {
  //  arrayOfFloats[i] = arrayOfFloats[i-1];
  //}
 
  //// new incoming value
  //float newValue = noise(frameCount*0.001)*width;
 
  //// set last value to the new value
  //arrayOfFloats[0] = newValue;
 
  //   // usage
  //for (int i=num-1; i>0; i--) {
  //  
    
  //}
  
  //usage
  //rect is drawn for each array value; each width is an equal portion of screen area; height is the percentage of area of total screen height
  // the "-" flip the graph upsidedown so production is on top
  for (int i= 0; i < num; i++) {
    noStroke();
    fill(#296196);
    rect(i, height, -width/usageArray.length, -usageArray[i]/(productionArray[i]+usageArray[i])*height);
  }
  
  // plug load
  //rect is drawn for each array value; each width is an equal portion of screen area
  //each rect starts at the top of the usage rect drawn at the corresponding array point
  // the "-" are removed here so that the rects are drawn from the top of the screen  
  for (int i= 0; i < num; i++) {
    noStroke();
    fill(#41948e);
    rect(i, height - usageArray[i]/(productionArray[i]+usageArray[i])*height, width/usageArray.length, plugLoadArray[i]/(productionArray[i]+usageArray[i])*height);
    
  }

 // delay(10);

}
