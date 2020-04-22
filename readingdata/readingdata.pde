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
     float plug = table.getFloat(i, "Production");
     plugLoadArray[val] = plug;
     val = val + (frac);
   }
   plugLoadArray[num-1] = table.getFloat(frac, "Production"); //sets the final value of the array
   //goes back through array and increments each point every frac number of points
   
   for (int i = 0; i < num - 1; i++) {        //TODO we need to figure out how to keep this loop from overriding the fraction values.
    
      if (i % frac == 0 &&  i < num - frac) {  
         first = plugLoadArray[i];
         second = plugLoadArray[i+frac];          //need to get this to run and not get to 1024
         inc = (second - first) / frac;
         plugLoadArray[i+1] = plugLoadArray[i] + inc;
         i++;
         while ( i % frac != 0 && i + 1 % frac != 0) { //or try && i + 1 == 0;
           plugLoadArray[i+1] = plugLoadArray[i] + inc;
           i++;
          }
          i--;
       }
       else if ( i == num - frac) {    //will only run for the last frac number of values in the array
         first = plugLoadArray[i];
         second = plugLoadArray[num-1];
         inc = (second - first) / frac;
         plugLoadArray[i+1] = plugLoadArray[i] + inc;
         i++;
         while ( i < num -2) {     //why is this setting the last value
           plugLoadArray[i+1] = plugLoadArray[i] + inc;
           i++;
          }
        }
    }  
  println(plugLoadArray);
}
