public class Vector2 {
  float x;
  float y;
  int id;
  Vector2() {
    this.createVector(0, 0);
  }
  Vector2(Number x_, Number y_) {
    this.createVector(x_, y_);
  }
  Vector2(Number x_) {
    this.createVector(x_, x_);
  }
  private void createVector(Number x_, Number y_) {
    this.x=x_.floatValue();
    this.y=y_.floatValue();
    this.id = int(str(int(this.x))+str(int(this.y)));
  }
  Vector2 multiply(float factor) {
    return new Vector2(this.x*factor, this.y*factor);
  }
  Vector2 multiply(Vector2 factor) {
    return new Vector2(this.x*factor.x, this.y*factor.y);
  }
  Vector2 divide(float factor) {
    return new Vector2(this.x/factor, this.y/factor);
  }
  Vector2 divide(Vector2 factor) {
    return new Vector2(this.x/factor.x, this.y/factor.y);
  }
  Vector2 add(Vector2 num) {
    return new Vector2(this.x+num.x, this.y+num.y);
  }
  Vector2 inverse() {
    return new Vector2(this.x*-1, this.y*-1);
  }
  @Override
    public boolean equals(java.lang.Object o) {
    if (o==this) {
      return true;
    }
    if (!(o instanceof Vector2)) {
      return false;
    }
    Vector2 v = (Vector2) o;
    return (v.x == this.x && v.y == this.y);
  }
  @Override
    public int hashCode() {
    return (int)this.id;
  }
  @Override
    String toString() {
    return ("Vector 2: " + this.x + "  " + this.y);
  }
}
public class EventData {
  Character k = null;
  Vector2 mousePos = null;
  Integer mouseBtn = null;
  String type = null;
  EventData(String type_){
    this.type = type_;
  }
  EventData setKey(Character k_){
    this.k = k_;
    return this;
  }
  EventData setMousePos(Vector2 mousePos_){
    this.mousePos = mousePos_;
    return this;
  }
  EventData setMouseBtn(Integer mouseBtn_){
    this.mouseBtn = mouseBtn_;
    return this;
  }
}
@FunctionalInterface
  interface Method {
  void run();
}
