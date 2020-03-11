int num = 1024; //setting the length of array thus dividing the canvas in columns
float[] arrayOfFloats = new float[num]; 
 
void setup() {
  size(1024,768);
  smooth();
}
 
void draw() {
  background(#fcdc78);
 
  // copy everything one value down
  for (int i= num-1; i > 0; i--) {
    arrayOfFloats[i] = arrayOfFloats[i-1];
  }
 
  // new incoming value
  float newValue = noise(frameCount*0.001)*width;
 
  // set last value to the new value
  arrayOfFloats[0] = newValue;
 
  // red line
  for (int i= num -1; i > 0; i--) {
    noStroke();
    fill(#41948e);
    square(width*i/arrayOfFloats.length+width/num/2,height-arrayOfFloats[i]*.8,width);
  }
  
    // blue line
  for (int i=num-1; i>0; i--) {
    noStroke();
    fill(#296196);
    square(width*i/arrayOfFloats.length+width/num/2,height-arrayOfFloats[i]/2,width);
    
  }
  delay(10);

}
