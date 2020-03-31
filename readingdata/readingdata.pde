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
  
   for (int i = 0; i < pulls; i++) {
     float plug = table.getFloat(i, "Plugload");
     plugLoadArray[val] = plug;
     val = val + (frac);
   }
   
  // println(plugLoadArray[992]);
   for (int i = 0; i < num - 1; i++) {
     float change;

     if (plugLoadArray[i] != 0) {
       float first = plugLoadArray[i];
       float second = plugLoadArray[i+frac];
       change = second - first;            //if first value is bigger this is a negative change, if second is bigger there is a positive change 
      }
     float inc = change / frac; 
     plugLoadArray[i+1] = plugLoadArray[i] + inc;
   }
}
