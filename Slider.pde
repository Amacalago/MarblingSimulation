class Slider {
  PVector currPos, sliderPos;
  float minValue, maxValue;
  float sliderHeight;
  float knobWidth, knobHeight;
  float margin;
  float increment;

  float currValue;

  String name;

  Slider(float min, float max, float x, float y) {
    this(min, max, x, y, (min+max)/2);
  }

  Slider(float min, float max, float x, float y, float initialValue) {
    this(min, max, x, y, initialValue, .01, "Slider " + (sliders.size() + 1));
  }

  Slider(float min, float max, float x, float y, float initialValue, float inc, String n) {
    minValue = min;
    maxValue = max;
    currValue = initialValue;

    sliderHeight = 100;
    knobWidth = 30;
    knobHeight = 10;
    margin = 5;
    increment = inc;

    sliderPos = new PVector(x, y);
    currPos = new PVector(x, map(initialValue, min, max, y + sliderHeight, y));

    name = n;
  }

  boolean checkClicked() {
    boolean clickedKnob = abs(mouseX - sliderPos.x) + margin < knobWidth/2.0 && abs(mouseY - sliderPos.y) + margin < knobHeight/2.0;
    boolean clickedSlider = abs(mouseX - sliderPos.x) <= knobWidth/2.0 && mouseY < sliderPos.y + sliderHeight + 20 && mouseY > sliderPos.y - 20;

    return clickedKnob || clickedSlider;
  }

  float getValue() {
    return currValue;
  }

  void update(float y) {
    
    float maxIndex =  (maxValue- minValue)/increment;
    float currStep = floor(map(y, sliderPos.y, sliderPos.y + sliderHeight, maxIndex, 0));
    
    currPos.set(currPos.x, map(currStep, 0, maxIndex, sliderPos.y + sliderHeight, sliderPos.y));

    currValue = map(currStep, 0, maxIndex, minValue, maxValue);

    if (currValue < minValue) {
      update(sliderPos.y + sliderHeight);
    } else if (currValue > maxValue) {
      update(sliderPos.y);
    }
  }

  void show() {
    stroke(255);
    strokeWeight(3);
    line(sliderPos.x, sliderPos.y, sliderPos.x, sliderPos.y + sliderHeight);
    stroke(2);
    stroke(100);
    fill(255);
    rectMode(CENTER);
    rect(currPos.x, currPos.y, knobWidth, knobHeight, 5);

    text(name, sliderPos.x - 5, sliderPos.y - 10);
    text(currValue, sliderPos.x + knobWidth/2, currPos.y);
  }
}
