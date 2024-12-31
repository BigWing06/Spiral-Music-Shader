public class TileMap extends Node {
  HashMap<Vector2, Node> tileMap = new HashMap<Vector2, Node>();
  Vector2 scale;
  TileMap(Node parent_, Float layer_, Vector2 scale_, Vector2 pos_, Vector2 size_) {
    super(parent_, pos_, layer_, size_.multiply(scale_));
    this.scale = scale_;
  }
    Vector2 getChildLocation(Node child_) {
    return this.posToLoc(child_.getRelativePosition());
  }
  @Override
    void setChildPosition(Node child_, Vector2 pos_) {
    //this.tileMap.remove(child_.pos);
    child_.pos = this.locToPos(pos_);
    this.tileMap.put(this.posToLoc(child_.getRelativePosition()), child_);
  }
  void unadopt(Vector2 loc_) {
    Node child = tileMap.get(loc_);
    tileMap.remove(loc_);
  }
  Node get(Vector2 loc_) {
    if (tileMap.keySet().contains(loc_)) {
      return tileMap.get(loc_);
    }
    return null;
  }
  @Override
    void adopt(Node child_) {
    super.adopt(child_);
    this.tileMap.put(this.posToLoc(child_.getRelativePosition()), child_);
    child_.parent = this;
    if(child_.sizeMode != Size.override){
    child_.sizeMode = Size.inherit;
    }
  }
  @Override
    Vector2 getSize() {
    return  this.scale;
  }
  Vector2 posToLoc(Vector2 pos_) {
    return pos_.divide(this.scale);
  }
  Vector2 locToPos(Vector2 loc_) {
    return loc_.multiply(this.scale);
  }
}
