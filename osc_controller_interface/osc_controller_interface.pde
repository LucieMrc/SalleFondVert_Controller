/*
This is a template to run on a desktop computer
- you can "scan" the network for devices to communicate with
- you can the connect to one device and send it some values

You cannot run this example, and the "receiver_processing_template.pde" on the same machine 
 */

import oscP5.*;
import netP5.*;
import themidibus.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

String ip = "127.0.0.1";
int inPort = 12000;
int outPort = 10000;

boolean AUTO_DISCOVERY = true;
ArrayList<Client> available_clients;
int selected_client = -1;

String[] pages = {"Settings", "Lyres", "PAR"}; // name of the pd patch to use as layout
PFont font ;
int patchWidth = 1700;
int patchHeight = 900;

// customisation stuff

color cBack = #1C1B1F; // background
color cGuiback = #27007A;  // gui background
color cGuifront = #715D9D; // gui foreground
color cCaption = #D9D1EB; // texts around
int fontSize = 16;
int eltHeight = 50;

GUI g;

MidiBus myBus; // The MidiBus

int lastNumber, lastValue;

void setup() {
  size(1700, 900);

  font = createFont("arial", fontSize);


  oscP5 = new OscP5(this, inPort);
  myRemoteLocation = new NetAddress(ip, outPort);



  g = new GUI(50, pages);
  available_clients = new ArrayList();


  // add tab for each pd patch and populate it
  for (int i = 1; i < pages.length; i ++) { 
    String[] patch = loadStrings(pages[i] +".pd");
    // populate the tab with gui elements
    parse_patch(patch, i);
  }

  create_settings();
  
  MidiBus.list();
  myBus = new MidiBus(this, 1, 1);
}


void draw() {
  background(cBack);
  g.updateControllers();
  if (AUTO_DISCOVERY) auto_discovery();

}

void keyReleased() {
  g.forwardKeyEvent(key);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);

  lastNumber = number;
  lastValue = int(map(value, 0, 127, 0, 255));
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
