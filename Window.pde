public class Window extends Node {
  String childrenHierarchyText="";
  PApplet parentPApp;
  Boolean debug = false;
  ArrayList<Node[]> adoptionList = new ArrayList<Node[]>(); // First node (key) is for adopter, second (value) is adoptee
  ArrayList<Node[]> unadoptionList = new ArrayList<Node[]>(); // First node (key) is for unadopter, second (value) is unadoptee
  ArrayList<Node> masterNodeList = new ArrayList<Node>();
  Window(PApplet parentPApp_) {
    super();
    this.parentPApp = parentPApp_;
    super.pos = new Vector2(0, 0);
    super.size = new Vector2(this.parentPApp.width, this.parentPApp.height);
    //super.size = new Vector2(width, height);
  }
  @Override
    Vector2 getRootPosition() {
    return new Vector2(0, 0);
  }
  @Override
    Vector2 getPosition() {
    return new Vector2(0, 0);
  }
  String getChildrenHierarchyText() {
    return this.childrenHierarchyText;
  }
  void evaluateAdoptions() {
    for (Node[] pair : this.unadoptionList) {
      Node oldParent = pair[0];
      Node unadoptee = pair[1];
      log("Unadopted: "+unadoptee + "  -->  "+ oldParent, Debug.adoptionLog);
      oldParent.unadopt(unadoptee);
    }

    for (Node[] pair : this.adoptionList) {
      Node newParent = pair[0];
      Node adoptee = pair[1];
      log("Adopted: "+adoptee + "  -->  "+ newParent, Debug.adoptionLog);
      newParent.adopt(adoptee);
      if (!(masterNodeList.contains(adoptee))){
        masterNodeList.add(adoptee);
      }
      if (pair[0]==null){
        masterNodeList.remove(adoptee);
      }
    }
    if (this.unadoptionList.size() != 0 || this.adoptionList.size() != 0) {
      this.childrenHierarchyText = this.printChildren();
    }
    this.unadoptionList = new ArrayList<Node[]>();
    this.adoptionList = new ArrayList<Node[]>();
  }
  @Override
    void process() {
    super.size = new Vector2(this.parentPApp.width, this.parentPApp.height);
    this.evaluateAdoptions();
    ArrayList<Float> layersList = new ArrayList<Float>(this.layerMap.keySet());
    Collections.sort(layersList);
    for (Float layer : layersList) {
      for (Node node : this.layerMap.get(layer)) {
        if (node.processing) {
          node.process();
        }
      }
    }
  }
}
