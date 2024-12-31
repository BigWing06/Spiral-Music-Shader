import java.util.concurrent.Callable;
@FunctionalInterface
  interface Condition {
  boolean evaluate(EventData event, Node n);
}
@FunctionalInterface
  interface EventCall {
  void evaluate(EventData e);
}
HashMap<String, Condition> eventMap = new HashMap<String, Condition>();
public class EventManager {
  List<String> vitalEvents = Arrays.asList(new String[]{"MouseHover", "MouseLeave"});
  HashMap<String, ArrayList<Event>> events = new HashMap<String, ArrayList<Event>>();
  ArrayList<Event> eventsList = new ArrayList<Event>();
  EventManager() {//Generates event map
    eventMap.put("KeyPressed", (event, node)->event.k!=null);
    eventMap.put("KeyReleased", (event, node)->event.k!=null);
    eventMap.put("MousePressed", (event, node)->event.mouseBtn!=null&&node.checkCollision(event.mousePos));
    eventMap.put("MouseReleased", (event, node)->event.mouseBtn!=null&&node.checkCollision(event.mousePos));
    eventMap.put("MouseHover", (event, node)->node.checkCollision(event.mousePos)&&node.mouseOver==false);
    eventMap.put("MouseLeave", (event, node)->!node.checkCollision(event.mousePos)&&node.mouseOver==true);
  }
  void evaluateVitalEvents() {
    for (String event : vitalEvents) {
      this.runEventType(new EventData(event).setMousePos(new Vector2(mouseX,mouseY)));
    }
  }
  void createEvent(Event event_) {
    if (!events.keySet().contains(event_.name)) {
      events.put(event_.name, new ArrayList<Event>());
    }
    events.get(event_.name).add(event_);
    eventsList.add(event_);
  }
  void removeEvent(Event event_) {
    if (eventsList.contains(event_)) {
      events.remove(event_.name);
      eventsList.remove(event_);
    } else {
      throw new RuntimeException("ERROR ON REMOVE EVENT: Event not in list");
    }
  }
  void runEventType(EventData event_) {
    if (events.keySet().contains(event_.type)) {
      for (Event event : events.get(event_.type)) {
        event.listen(event_);
      }
    }
  }
}
public class Event {
  Node node;
  String name;
  EventCall method;
  Condition condition;
  Event(Node node_, String name_, EventCall method_) {
    if (!eventMap.keySet().contains(name_)) {
      throw new RuntimeException("Invalid Event Type: " + name_);
    }
    this.node=node_;
    this.name=name_;
    this.method = method_;
    this.condition = eventMap.get(name_);
  }
  void listen(EventData event) {
    if (condition.evaluate(event, this.node)) {
      this.method.evaluate(event);
      if(this.node.vitalEventDefaults.keySet().contains(event.type)){
      this.node.vitalEventDefaults.get(event.type).run();
      }
    }
  }
}
