
import oscP5.*;
import netP5.*;
import ketai.sensors.*;

OscP5 oscP5;
NetAddress myRemoteLocation;



int inPort = 12000;
int outPort = 10000;
String ip = "127.0.0.1";

// Change the following line to add your controllers
String[] pages = {"Settings","lyres_avant", "lyres_milieu","lyres_arriere","PAR", "preset"}; // name of the pd patch to use as layout

// customisation stuff
PFont font ; // needs to loaded it in the setup below
color cBack = #1C1B1F; // background
color cGuiback = #27007A;  // gui background
color cGuifront = #715D9D; // gui foreground
color cCaption = #D9D1EB; // texts around
int fontSize = 16;
int eltHeight = 50;


boolean AUTO_DISCOVERY = true;
// end of custom stuff
ArrayList<Client> available_clients;
int selected_client = -1;


GUI g;
int patchWidth = 900;
int patchHeight = 1200;


void setup() {
  fullScreen();
  orientation(PORTRAIT);

  // load a custom font
  font = createFont("arial", fontSize);
  textSize(fontSize);


  oscP5 = new OscP5(this, inPort);
  myRemoteLocation = new NetAddress(ip, outPort);

  available_clients = new ArrayList();
  g = new GUI(eltHeight, pages);

  // add tab for each pd patch and populate it
  for (int i = 1; i < pages.length; i ++) { 
    String[] patch = loadStrings(pages[i] +".pd");
    // populate the tab with gui elements
    parse_patch(patch, i);
  }

  create_settings();
  //create_sensorTab();
}


void draw() {
  background(cBack);
  g.updateControllers();

  if (AUTO_DISCOVERY) auto_discovery();

}

void keyReleased() {
  g.forwardKeyEvent(key);
}
