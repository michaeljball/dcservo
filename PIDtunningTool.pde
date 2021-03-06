// simple tool for testing the PID response using some of the features of new firmware (S command returns the last encoder positions from last X command
// by misan 2015
// it is a loop of moves X100 .. X0 .. X100 .. X0 ...
// "P",  "I" or "D" keys increase existing PID values
// p i d keys decrease respective values
// it draws "almost" in real time motor response

import java.util.*; 
import processing.serial.*;

Serial myPort;      // The serial port

float kp=3, ki=1, kd=0.01;
void setup() {
  size(600, 400);
  // create a font with the third font available to the system:
  PFont myFont = createFont(PFont.list()[2], 14);
  textFont(myFont);
  frameRate(1);
  // List all the available serial ports:
  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
}

void draw() {
  strokeWeight(1);
  background(255,100); stroke(255,0,0);
  line(0,400-300,600,400-300); 
  strokeWeight(.1);
  for(int i=1;i<6;i++) line(i*100,0,i*100,400);
  delay(500);
  stroke(0,0,255); strokeWeight(2); 
  while(myPort.available()>0) print(char(myPort.read()));
  
  myPort.write('X');
  myPort.write('1');
  myPort.write('0');  
  myPort.write('0');
  myPort.write('\r');
  myPort.write('\n');
  delay(500);
  myPort.write('S');
  myPort.write('\r');
  myPort.write('\n');
  delay(500);
  String s="";
  while(myPort.available()>0) s+=char(myPort.read());
  
  //println(s);
  
  Scanner sc = new Scanner(s);
  
  int x=0; 
  while(sc.hasNextInt()) {
    point(x++, 400-3*sc.nextInt());
  }

  myPort.write('X');
  //myPort.write('0'); 
  //myPort.write('0');  
  myPort.write('0'); 
  myPort.write('\r');
  myPort.write('\n');
  delay(0);
}

void keyPressed() {
  if(key=='P') {
    kp+=1; 
      myPort.write('P');
      String out=""+kp; for(int i=0; i<out.length();i++) myPort.write(out.charAt(i));
      myPort.write('\r');
      myPort.write('\n');
      println("P="+kp);
  } 
  if(key=='p')  {
    kp-=1; kp=max(0,kp);
      myPort.write('P');
      String out=""+kp; for(int i=0; i<out.length();i++) myPort.write(out.charAt(i));
      myPort.write('\r');
      myPort.write('\n');
      println("P="+kp);
  } 
  if(key=='D') 
   {
    kd+=0.01; 
      myPort.write('D');
      String out=""+kd; for(int i=0; i<out.length();i++) myPort.write(out.charAt(i));
      myPort.write('\r');
      myPort.write('\n');
      println("D="+kd);
  } 
  if(key=='d')  {
    kd-=0.01; kd=max(0,kd);
      myPort.write('D');
      String out=""+kd; for(int i=0; i<out.length();i++) myPort.write(out.charAt(i));
      myPort.write('\r');
      myPort.write('\n');
      println("D="+kd);
  } 
  if(key=='I')  {
    ki*=2; 
      myPort.write('I');
      String out=""+ki; for(int i=0; i<out.length();i++) myPort.write(out.charAt(i));
      myPort.write('\r');
      myPort.write('\n');
      println("I="+ki);
  } 
  if(key=='i')  {
    ki/=2; 
      myPort.write('I');
      String out=""+ki; for(int i=0; i<out.length();i++) myPort.write(out.charAt(i));
      myPort.write('\r');
      myPort.write('\n');
      println("I="+ki);
  } 
}
        
