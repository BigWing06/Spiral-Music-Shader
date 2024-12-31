public class Button extends Node{
  Text2D displayText;
  Vector2 padding;
  color defaultFill;
  color onHoverFill;
  color onClickFill;
  Button(Node parent_, Vector2 pos_, float layer_, Vector2 size_, String text_){
    super(parent_, pos_, layer_, size_);
    this.setDefaultColors();
    this.displayText = new Text2D(this, new Vector2(), text_, super.size.y*.8, 1.0);
    this.displayText.attachmentPos = new Vector2();
    this.displayText.textAlign = new Vector2(CENTER);
    this.displayText.fill = color(255);
    
    this.padding = new Vector2(this.displayText.fontSize/5);
    
    super.setSize(new Vector2((this.displayText.text.length()*this.displayText.fontSize)/2+this.padding.x, this.displayText.fontSize+this.padding.y));
    super.fill = color(this.defaultFill);
    super.strokeColor = color(255);
    super.strokeWeight = 8;
    super.createEvent(new Event(this,"MousePressed", this::onMouseClicked));
    super.createEvent(new Event(this,"MouseReleased", this::onMouseReleased));
    super.createEvent(new Event(this,"MouseHover",this::onMouseHover));
    super.createEvent(new Event(this,"MouseLeave",this::onMouseLeave));
  }
  void setDefaultColors(){
   this.defaultFill = color(0);
   this.onHoverFill = color(50);
   this.onClickFill = color(100);
  }
  @Override
  void ready(){
  }
  void onMouseClicked(EventData e){
    super.fill = this.onClickFill;
  }
  void onMouseReleased(EventData e){
   if (super.mouseOver){
     super.fill = this.onHoverFill;
   }else{
     super.fill = this.defaultFill; 
   } 
  }
  void onMouseHover(EventData e){
    super.fill = this.onHoverFill;
  }
  void onMouseLeave(EventData e){
   super.fill = this.defaultFill; 
    
  }
}
