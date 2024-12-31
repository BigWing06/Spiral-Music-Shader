public class MainMenu extends Node {
  Text2D mainMenuTitleText;
  Button openFileButton;
  Button testFileButton;
  Boolean flipToPlayer = false;
  String fileStr;
  MainMenu() {
    super((Node) windowManager.mainWindow, new Vector2(0), 2.0, new Vector2(10));
    super.sizeMode = Size.inherit;
    this.fill = color(0);
    this.openFileButton = new Button((Node) this, new Vector2(0, 100), 1.0, new Vector2(80, 50), "Load File");
    this.openFileButton.sizeMode = Size.override;
    this.openFileButton.attachmentPos = new Vector2(0);
    this.openFileButton.originPos = new Vector2(0);
    this.openFileButton.createEvent(new Event((Node)openFileButton, "MousePressed", (EventCall)this::onOpenBttnClick));
    this.testFileButton = new Button((Node) this, new Vector2(0, -100), 1.0, new Vector2(80, 50), "Mic Input");
    this.testFileButton.sizeMode = Size.override;
    this.testFileButton.attachmentPos = new Vector2(0);
    this.testFileButton.originPos = new Vector2(0);
    this.testFileButton.createEvent(new Event((Node)testFileButton, "MousePressed", (EventCall)this::onMicInput));
  }
  void switchToAudioPlayer(SoundObject sound){
    mainMenu.processing = false;
    mainMenu.visible = false;
    audioPlayer.processing = true;
    audioPlayer.visible = true;
    audioPlayer.setFilePlayBack(sound);
  }
  void onMicInput(EventData e){
    mainMenu.processing = false;
    mainMenu.visible = false;
    audioPlayer.processing = true;
    audioPlayer.visible = true;
    audioPlayer.setMicInput();
  }
  
  void onOpenBttnClick(EventData e){
  JFileChooser fileChooser = new JFileChooser();
  
  // Optional: Set the dialog to open at a specific directory (default is the home directory)
  try{
    fileChooser.setCurrentDirectory(new File(sketchPath() + "/Songs"));
  }
  catch(Exception ex){
    fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
  }
  
  // Open the file chooser dialog
  int returnValue = fileChooser.showOpenDialog(null);
  
  // Check if the user selected a file (not canceled)
  if (returnValue == JFileChooser.APPROVE_OPTION) {
    // Get the selected file
    File selectedFile = fileChooser.getSelectedFile();
    
    // Print the file path (or process it)
    try{
    this.switchToAudioPlayer(new SoundFile(this.parentWindow.parentPApp,selectedFile.toString()));
    }catch(Exception ex){
      JOptionPane.showMessageDialog(null, "That is not a supported file", "Error", JOptionPane.ERROR_MESSAGE);
    }
    
    // You can use the file path here for further processing
    // For example, load the file or use its content
  } else {
    JOptionPane.showMessageDialog(null, "No File was Selected", "Error", JOptionPane.ERROR_MESSAGE);
  }
  }
}
