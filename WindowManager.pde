WindowManager root;
PApplet mainPApp = this;
public class WindowManager {
  List<Character>keyList=new ArrayList<>();
  ArrayList<ChildWindow> childWindows = new ArrayList<ChildWindow>();
  EventManager eventManager;
  Window mainWindow;
  WindowManager() {
    root = this;
    this.mainWindow = new Window(mainPApp);
    this.setupDebug();
    this.mainWindow.fill = color(255);
    this.eventManager = new EventManager();
  }
  void callReady() {
    mainWindow.process();
    mainWindow.ready();
    for (ChildWindow window : this.childWindows) {
      window.window.process();
      window.window.ready();
    }
  }

  void run() {
    this.eventManager.evaluateVitalEvents();
    mainWindow.process();
    mainWindow.draw();
  }
  void setupDebug() {
    if (debugOptions.contains(Debug.hierarchyWindow)) {
      new HierarchyWindow();
    }
  }
  Window createWindow(Vector2 initialSize_, Vector2 initialPos_, String name_) {
    ChildWindow newWindow = createChildWindow(initialSize_, initialPos_, name_);
    return newWindow.window;
  }
  ChildWindow createChildWindow(Vector2 initialSize_, Vector2 initialPos_, String name_) {
    ChildWindow newWindow = new ChildWindow(initialSize_, initialPos_, name_);
    this.childWindows.add(newWindow);
    return newWindow;
  }
}
public class ChildWindow extends PApplet {
  Vector2 initialSize;
  Vector2 initialPos;
  String name;
  Window window;
  public ChildWindow(Vector2 initialSize_, Vector2 initialPos_, String name_) {
    super();

    root.childWindows.add(this);
    initialSize = initialSize_;
    initialPos = initialPos_;
    name = name_;
    createSubWindow();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    super.surface.setSize((int)this.initialSize.x, (int)this.initialSize.y);
    super.surface.setLocation((int)this.initialPos.x, (int)this.initialPos.y);
  }
  void createSubWindow() {
    this.window = new Window(this);
    this.window.name = this.name;
  }
  public void setup() {

    surface.setTitle(this.name);
  }
  @Override
    public void draw() {
    //tempLog(str(mouseX)+"  " + str(mouseY));
    this.window.process();
    this.window.draw();
  }
  public void windowResized() {
  }
}
void keyPressed() {
  root.eventManager.runEventType(new EventData("KeyPressed").setKey(key));
}
void keyReleased() {
  root.eventManager.runEventType(new EventData("KeyReleased").setKey(key));
}
void mousePressed() {
  root.eventManager.runEventType(new EventData("MousePressed").setMouseBtn(mouseButton).setMousePos(new Vector2(mouseX, mouseY)));
}
void mouseReleased() {
  root.eventManager.runEventType(new EventData("MouseReleased").setMouseBtn(mouseButton).setMousePos(new Vector2(mouseX, mouseY)));
}  
public enum Debug {
  adoptionLog, positionDots, collisionLog, hierarchyWindow
};
List<Debug> debugOptions = Arrays.asList(new Debug[]{});
void log(Object message, Debug option) {
  if (debugOptions.contains(option)) {
    print("\n[DEBUG] " + message);
  }
}
void tempLog(Object message) {
  print("\n<<<<[TEMP DEBUG]>>>>> " + message);
}
