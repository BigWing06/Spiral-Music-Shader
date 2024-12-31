public class AudioPlayer extends Node{
  Vector2 preMousePos = new Vector2(0);
  int mouseCooldown;
  int mode;
  Boolean playing = false;
  SoundFile file;
  AudioIn micInput;
  Amplitude amp;
  BeatDetector beat;
  Button playBttn;
  Button forwardBttn;
  Button backBttn;
  Button exitBttn;
  TileMap controlButtonGrid;
  PitchDetector pitch;
  FFT ftt;
  int hue = 0;
  int fttBands = 128;
  float smoothingFactor = .2;
  float[] sum = new float[this.fttBands];
  int fttShowBands = 20;
  //Rect2D testRect;
  AudioPlayer(){
  super((Node) windowManager.mainWindow, new Vector2(0), 1.0, new Vector2(10));
  
  super.sizeMode = Size.inherit;
  //this.file = file_;
  Vector2 bttnSize = new Vector2(100, 50);
  this.controlButtonGrid = new TileMap((Node)this, 5.0, bttnSize, new Vector2(0, -10), new Vector2(bttnSize.x*3, bttnSize.y));
  this.controlButtonGrid.sizeMode = Size.override;
  this.controlButtonGrid.setSize(new Vector2(bttnSize.x*3, bttnSize.y));
  this.controlButtonGrid.attachmentPos = new Vector2(0, 1);
  this.controlButtonGrid.originPos = new Vector2(0, 1);
  this.controlButtonGrid.fill = color(255, 255, 255);
  this.controlButtonGrid.processing = false;
  this.controlButtonGrid.visible = false;
  this.playBttn = new Button((Node) this.controlButtonGrid, new Vector2(1, 0), 1.0, bttnSize, "▶");
  this.playBttn.createEvent(new Event((Node)playBttn, "MousePressed", (EventCall)this::onPlayBttnClick));
  this.forwardBttn = new Button((Node) this.controlButtonGrid, new Vector2(2, 0), 1.0, bttnSize, "▶▶");
  this.forwardBttn.createEvent(new Event((Node)forwardBttn, "MousePressed", (EventCall)this::onForwardBttnClick));
  this.backBttn = new Button((Node) this.controlButtonGrid, new Vector2(), 1.0, bttnSize, "◀◀");
  this.backBttn.createEvent(new Event((Node)backBttn, "MousePressed", (EventCall)this::onBackBttnClick));
  this.exitBttn = new Button((Node) this, new Vector2(10), 1.0, bttnSize, "Exit");
  this.exitBttn.sizeMode = Size.override;
  this.exitBttn.setSize(bttnSize);
  this.exitBttn.createEvent(new Event((Node)exitBttn, "MousePressed", (EventCall)this::onExitClick));
  //this.testRect = new Rect2D(this, new Vector2(25), 5.0, new Vector2(10));
  //this.testRect.fill = color(0, 255, 0);
  //this.testRect.sizeMode = Size.override;
  }
  void setFilePlayBack(SoundObject input_){
    this.mode = 0;
    this.controlButtonGrid.processing = true;
    this.controlButtonGrid.visible = true;
    this.playing = false;
    this.playBttn.displayText.text = "▶";
    this.file = (SoundFile)input_;
    this.file.jump(0);
    this.file.pause();
    this.createAnalyzers(input_);
  }
  void createAnalyzers(SoundObject input_){
    this.amp = new Amplitude(this.parentWindow.parentPApp);
    this.amp.input(input_);
    this.beat = new BeatDetector(this.parentWindow.parentPApp);
    this.beat.input(input_);
    this.pitch = new PitchDetector(this.parentWindow.parentPApp, 0);
    this.pitch.input(input_);
    this.ftt = new FFT(this.parentWindow.parentPApp, this.fttBands);
    this.ftt.input(input_);
  }
  void setMicInput(){
    
    this.controlButtonGrid.processing = false;
    this.controlButtonGrid.visible = false;
    this.mode = 1;
    this.micInput = new AudioIn(this.parentWindow.parentPApp, 0);
    this.micInput.amp(100);
    this.createAnalyzers(this.micInput);
    
  }
  void onPlayBttnClick(EventData e){
    if (!this.playing){
      this.playing = !this.playing;
      this.playBttn.displayText.text = "‖";
      this.file.play();
    }
    else{
      this.playing = !this.playing;
      this.playBttn.displayText.text = "▶";
      this.file.pause();
    }
  }
  void onExitClick(EventData e){
    mainMenu.processing = !false;
    mainMenu.visible = !false;
    if (this.mode == 0){
      this.file.pause();
    }
    
    audioPlayer.processing = !true;
    audioPlayer.visible = !true;
  }
  void onForwardBttnClick(EventData e){
    if (this.playing){
      this.file.jump(this.file.position()+5);
    }
    
  }
  void onBackBttnClick(EventData e){
    if (this.playing){
      this.file.jump(this.file.position()-5);
    }
  }
  @Override
  void process(){
    super.process();
    if (this.mode == 0){
    if (dist(mouseX, mouseY, this.preMousePos.x, this.preMousePos.y)>1){
      this.controlButtonGrid.visible = true;
      this.exitBttn.visible = true;
      this.mouseCooldown = millis();
    }
    else if ((millis()-this.mouseCooldown>500 && this.playing == true)){
      this.controlButtonGrid.visible = false;
      this.exitBttn.visible = false;
    }
    this.preMousePos = new Vector2(mouseX, mouseY);
    }
  }
  @Override
  void draw(){
    super.draw();
    colorMode(HSB);
    //this.testRect.setSize(new Vector2(this.amp.analyze()*100));
    int ringSize = 30;
    int ringSpace = 2;
    int sizeMultiplier = 10000;
    this.ftt.analyze();
    float[] showBands = Arrays.copyOfRange(this.ftt.spectrum, 0, this.fttShowBands);
    float bandSum = 0;
    float bandMax = 0.00000000000000000000001;
    for(float num:showBands){
      bandSum = bandSum +num;
      if (num>bandMax){
        bandMax = num;
      }
    }
    
    float bandAverage = bandSum / (showBands.length-1);
    //bandMax = bandAverage *1.25;
    this.parentWindow.parentPApp.noStroke();
    for(int i=this.fttShowBands-1; i>0;i--){
      if(showBands[i]<bandAverage){
        showBands[i]=0;
      }
      //showBands[i] = (showBands[i]-bandAverage)*1/bandMax;
      sum[i] += (showBands[i] - sum[i]) * smoothingFactor;
      int brightness = int(constrain((float)this.amp.analyze(), 0.25, 1) * 255);
      hue = int(((float)this.pitch.analyze()/1000)*255);
      //hue = int(((float)this.pitch.analyze()/1000)*255)+int((int(((float)this.pitch.analyze()/1000)*255)-hue)*.75);
      this.parentWindow.parentPApp.fill(color(hue, 255, 255));
      int currentRingSize = ringSize*(i)+ringSpace*i;
      float bandWidth = constrain(sum[i]*8, 0, 1);
      this.parentWindow.parentPApp.ellipse(width/2,height/2, currentRingSize+ringSize*(bandWidth), currentRingSize+ringSize*bandWidth);
      this.parentWindow.parentPApp.fill(color(0));
      this.parentWindow.parentPApp.ellipse(width/2,height/2, currentRingSize, currentRingSize);
      

    }
    colorMode(RGB);
    
  }
}
