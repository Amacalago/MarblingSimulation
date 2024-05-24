# MarblingSimulation/*

Marbling Simulation 

Inspired by a paper by Aubrey Jaffer
https://people.csail.mit.edu/jaffer/Marbling/index#TOC

May 2024

*/

/* TODO

color picker
background change button
partial tining
natural ink movement

vortex/tining animations

*/
PVector startTine, endTine;

ArrayList<Drop> inkDrops = new ArrayList();
ArrayList<Slider> sliders = new ArrayList();
int enterMode = 0;
void setup() {
  size(900, 600);

  //for (int i = 0; i < 20; i++) {
  //  addDrop(new Drop(width/2, height/2, 50));
  //}

  //slider(min, max, pos.x, pos.y, initialVal, increment, name)
  sliders.add(new Slider(20, 80, 20, 35, 20, 10, "displacement"));
  sliders.add(new Slider(1, 10, 100, 35, 5, 1, "roundedness"));
}

void addDrop(Drop newDrop) {
  for (Drop d : inkDrops) {
    d.marble(newDrop);
  }

  inkDrops.add(newDrop);
}


void mousePressed() {
  //Drop newDrop = new Drop(mouseX, mouseY);
  //addDrop(newDrop);
  startTine = new PVector(mouseX, mouseY);
}

void mouseClicked() {
  boolean sliderClicked = false;
  for (Slider s : sliders) {
    if (s.checkClicked()) {
      System.out.println(s.name);
      s.update(mouseY);
      sliderClicked = true;
    }
  }

  if (!sliderClicked) {
    switch(enterMode) {
    case 0:
      addDrop(new Drop(mouseX, mouseY));
      break;

    case 1:
      for (Drop d : inkDrops) {
        d.vortex(new PVector(mouseX, mouseY), 50, 1, 50);
      }
      break;
    }
  }
}

void mouseReleased() {
  endTine = new PVector(mouseX, mouseY);

  for (Drop d : inkDrops) {
    d.tine(startTine, PVector.sub(endTine, startTine), sliders.get(0).getValue(), sliders.get(1).getValue());
  }
}

void keyPressed() {
  switch(key) {
  case 'd':
    enterMode = 0;
    System.out.println("switched to ink drop mode");
    break;

  case 'v':
    enterMode = 1;
    System.out.println("switched to vortex mode");
    break;

  case BACKSPACE:
    inkDrops.clear();
    break;
  }
}

void draw() {
  background(0);

  Drop outOfFrame = null;
  for (Drop d : inkDrops) {
    boolean shown  = d.show();
    //d.update(random(-1, 1), random(-1,1));
    if (!shown) {
      outOfFrame = d;
      System.out.println("removed");
    }
  }

  inkDrops.remove(outOfFrame);

  for (Slider s : sliders) {
    s.show();
  }

  text("click to add ink [D]rop or [V]ortex", 10, height - 50);
  text("press V for vortex mode", 10, height - 40);
  text("press D for drop mode", 10, height - 30);
  text("drag and release mouse to tine", 10, height - 20);
  text("press BACKSPACE to clear board", 10, height - 5);

  text("tine parameters", 10, 10);
}
