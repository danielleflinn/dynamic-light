Table table;

int num = 1024; //setting the length of array thus dividing the canvas in columns
float[] plugLoadArray = new float[num];
float[] usageArray = new float[num];
float[] productionArray = new float[num];

//create an array showing the last 8 hours of data: 1024px / 8hrs = 128px per 1hour
  //128px / 4 = 32px per 15 mins
  //4x8 = 32 data pulls in 8 hrs
  
  int pulls = 32;     //number of data pulls in all 8 hours
  int frac = 32;     //number of pixels in each section
 
void setup() {
  size(1024,768);
  
  table = loadTable("data.csv", "header");
  //println(table.getRowCount() + " total rows in table"); //prints in console total rows in CSV
  
  int val = 0;
  
  float plugInc = 0;
  float useInc = 0;
  float proInc = 0;
  
  float plug1 = 0;
  float plug2 = 0;
  float use1 = 0;
  float use2 = 0;
  float pro1 = 0;
  float pro2 = 0;
  
   for (int i = 0; i < pulls; i++) {            //sets the initial data pulls in the array every frac times
     float plug = table.getFloat(i, "Plugload");
     float use = table.getFloat(i, "Usage");
     float pro = table.getFloat(i, "Production");
     
     plugLoadArray[val] = plug;
     usageArray[val] = use;
     productionArray[val] = pro;
     
     val = val + (frac);
   }
   plugLoadArray[num-1] = table.getFloat(frac, "Plugload"); //sets the final value of the array
   usageArray[num-1] = table.getFloat(frac, "Usage"); //sets the final value of the array
   productionArray[num-1] = table.getFloat(frac, "Production"); //sets the final value of the array

   //goes back through array and increments each point every frac number of points
   
   for (int i = 0; i < num - 1; i++) {        //TODO we need to figure out how to keep this loop from overriding the fraction values.
    
      if (i % frac == 0 &&  i < num - frac) {  
         plug1 = plugLoadArray[i];
         plug2 = plugLoadArray[i+frac];          //need to get this to run and not get to 1024
         plugInc = (plug1 - plug2) / frac;
         plugLoadArray[i+1] = plugLoadArray[i] + plugInc;
         
         use1 = usageArray[1];
         use2 = usageArray[i +frac];
         useInc = (use1 - use2) / frac;
         usageArray[i+1] = usageArray[i] + useInc;

         pro1 = productionArray[1];
         pro2 = productionArray[i +frac];
         proInc = (pro1 - pro2) / frac;
         productionArray[i+1] = productionArray[i] + proInc;
         
         i++;
         while ( i % frac != 0 && i + 1 % frac != 0) { //or try && i + 1 == 0;
           plugLoadArray[i+1] = plugLoadArray[i] + plugInc;
           usageArray[i+1] = usageArray[i] + useInc;
           productionArray[i+1] = productionArray[i] + proInc;

           i++;
          }
          i--;
       }
       else if ( i == num - frac) {    //will only run for the last frac number of values in the array
         plug1 = plugLoadArray[i];
         plug2 = plugLoadArray[num-1];
         plugInc = (plug1 - plug2) / frac;
         plugLoadArray[i+1] = plugLoadArray[i] + plugInc;
         
         use1 = usageArray[1];
         use2 = usageArray[num-1];
         useInc = (use1 - use2) / frac;
         usageArray[i+1] = usageArray[i] + useInc;

         pro1 = productionArray[1];
         pro2 = productionArray[num-1];
         proInc = (pro1 - pro2) / frac;
         productionArray[i+1] = productionArray[i] + proInc;
         
         i++;
         while ( i < num -2) {     //why is this setting the last value
           plugLoadArray[i+1] = plugLoadArray[i] + plugInc;
           usageArray[i+1] = usageArray[i] + useInc;
           productionArray[i+1] = productionArray[i] + proInc;
           i++;
          }
        }
    } 
}
 
void draw() {
  background(#fcdc78);
  
  //usage
  //rect is drawn for each array value; each width is an equal portion of screen area; height is the percentage of area of total screen height
  // the "-" flip the graph upsidedown so production is on top
  for (int i = 0; i < num; i++){
    noStroke();
    fill(#296196);
    rect(i, height, -width/num, -usageArray[i]/(productionArray[i] + usageArray[i]) * height); //TODO figure out why these ratios are coming out to be greater than 1
  }
  // plug load
  //rect is drawn for each array value; each width is an equal portion of screen area
  //each rect starts at the top of the usage rect drawn at the corresponding array point
  // the "-" are removed here so that the rects are drawn from the top of the screen  
  for (int i= 0; i < num; i++) {
    noStroke();
    fill(#41948e);
    rect(i, height - usageArray[i]/(productionArray[i]+usageArray[i])*height, width/num, plugLoadArray[i]/(productionArray[i]+usageArray[i])*height); //TODO figure out why these ratios are coming out to be greater than 1
  }
   
  //// copy everything one value down; moves the graph
  //for (int i= num-1; i > 0; i--) {
  //  plugLoadArray[i] = plugLoadArray[i-1];
  //  usageArray[i] = usageArray[i-1];
  //  productionArray[i] = productionArray[i-1];
  //}
  ////println(plugLoadArray[0]);
  
  ////println(pulls);
  //pulls++;

  //// new incoming value
  //float newPlug = table.getFloat(pulls, "Plugload");
  //float newUsage = table.getFloat(pulls, "Usage");
  //float newPro = table.getFloat(pulls, "Production");

  // plugLoadArray[0] = newPlug;
  // usageArray[0] = newUsage;
  // productionArray[0] = newPro;

  // // for (int i = 0; i <= frac; i++) {
      
  // //     if ( i == frac) {
  // //     plugLoadArray[i] = newPlug;
  // //     usageArray[i] = newUsage;
  // //     productionArray[i] = newPro;
  // // }
  // //   // set first value to the new value 
  // //   plugLoadArray[i] = random(newPlug, plugLoadArray[frac]); //random for smoothing
  // //   usageArray[i] = random(newUsage, usageArray[frac]);
  // //   productionArray[i] = random(newPro, usageArray[frac]);

  //delay(10);

}
