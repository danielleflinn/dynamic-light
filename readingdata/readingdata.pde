Table table;
String string;

void setup() {

  table = loadTable("data.csv", "header");
  println(table.getRowCount() + " total rows in table");

//for (TableRow row : table.rows()) {
//    double nums = row.getDouble("Production");
//    println(nums);
//    }

 int size = table.getRowCount();
    int[] array = new int[size];        
    int i = 0;
    for (TableRow row : table.rows()) {
        int nums = row.getInt("Production");
       // println(nums);
        array[i] = nums;
        i++;
    }
    println(array);
}
