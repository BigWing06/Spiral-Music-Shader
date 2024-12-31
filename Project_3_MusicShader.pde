import java.util.*;
import javax.swing.*;
import java.io.File;
import javax.swing.JOptionPane;
import processing.sound.*;
WindowManager windowManager;
Vector2 windowSize = new Vector2(1000, 900);
MainMenu mainMenu;
AudioPlayer audioPlayer;
//HashMap<Integer, ElementTile> elemTiles = new HashMap<Integer, ElementTile>();
//int elemId = 0;
void settings() {
  
  size((int)windowSize.x, (int)windowSize.y);
}

void setup() {
  //surface.setResizable(true);
  windowManager = new WindowManager();
  mainMenu = new MainMenu();
  audioPlayer = new AudioPlayer();
  audioPlayer.visible = false;
  audioPlayer.processing = false;
  //Button testBttn = new Button((Node) windowManager.mainWindow, new Vector2(100), 1.0, new Vector2(50), "fjaoijdsoijfaosjdj");
  //testBttn.createEvent(new Event((Node)testBttn, "MousePressed", (EventCall)this::test));
  windowManager.callReady();
  windowManager.mainWindow.fill = color(0, 0, 0);
}
void draw() {
  windowManager.run();
}
