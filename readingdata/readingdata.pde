Table table;
String string;

int num = 1024; //setting the length of array thus dividing the canvas in columns
float[] plugLoadArray = new float[num];

void setup() {

  table = loadTable("data.csv", "header");
  //println(table.getRowCount() + " total rows in table");



 //int size = table.getRowCount();
 //   int[] array = new int[size];        
 //   int i = 0;
 //   for (TableRow row : table.rows()) {
 //       int nums = row.getInt("Plugload");
 //      println(nums);
 //       array[i] = nums;
 //       i++;
 //   }
    //println(array.length + " is the length ");
   // println(array);
   
  int pulls = 32;
  int frac = 32;
  int val = 0;
  
  for (int i = 0; i < pulls; i++) { //location of data value in csv
      float nums = table.getFloat(i, "Plugload"); //gets the plugload value from csv file
     // println(nums);
      for(int f = 0; f < frac; f++) { //counts the number of times value is assigned to a pixel
          plugLoadArray[val] = nums;
         // println(plugLoadArray[f] + " is the " + val + "place in array");
          val++;
      }
    // println(nums);
  }
  
    println(plugLoadArray[0]);

}
