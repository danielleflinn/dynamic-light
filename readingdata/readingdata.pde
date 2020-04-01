Table table;
String string;

int num = 1024; //setting the length of array thus dividing the canvas in columns
float[] plugLoadArray = new float[num];

void setup() {

  table = loadTable("data.csv", "header");
  //println(table.getRowCount() + " total rows in table");
   
  int pulls = 32;
  int frac = 32;
  int val = 0;
  float first = 0;
  float second = 0;
  float inc = 0;
   for (int i = 0; i < pulls; i++) {            //sets the initial data pulls in the array every frac times
     float plug = table.getFloat(i, "Plugload");
     plugLoadArray[val] = plug;
     val = val + (frac);
   }
   
   //goes back through array and increments each point every frac number of points
   
   for (int i = 0; i < num - 1; i++) {        //TODO we need to figure out how to keep this loop from overriding the fraction values.
     first = plugLoadArray[i];
    
    if (i % frac == 0 &&  i < num - frac) {    
       second = plugLoadArray[i+frac];          //need to get this to run and not get to 1024
       inc = (second - first) / frac;
       plugLoadArray[i+1] = plugLoadArray[i] + inc;
       i++;
       while ( i % frac != 0 && i + 1 % frac != 0) { //or try && i + 1 == 0;
         plugLoadArray[i+1] = plugLoadArray[i] + inc;
         i++;
       }
    }  
    //else if ( i > num - frac) {            //to catch the final edge case
    //   second = plugLoadArray[num-1];
    //   inc = (second - first) / frac;
    //   while ( i % frac != 0 && i + 1 % frac != 0) { //or try && i + 1 == 0;
    //     plugLoadArray[i+1] = plugLoadArray[i] + inc;
    //   }
    //}
    //else if (i % frac != 0 && i +1 % frac != 0) { 
       
    //}
    //else {
    //  first = 0;
    //  second = 0;
    //}
    
    //change = second - first;            //if first value is bigger this is a negative change, if second is bigger there is a positive change  
    
    //if ( change != 0) {
    //  float inc = change / frac;
    //  //println(inc + " " + i);
        
    //  plugLoadArray[i+1] = plugLoadArray[i] + inc; 
    //  //println(plugLoadArray[i+1]);
    //  }
   }
  println(plugLoadArray[33]);
}
