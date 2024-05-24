class Drop {
  PVector pos;
  PVector[] shapePoints;
  int numOfPoints = 7500;
  float radius;
  color c;

  Drop(float x, float y) {
    this(x, y, 100);
  }

  Drop(float x, float y, float r) {
    pos = new PVector(x, y);

    shapePoints = new PVector[numOfPoints];
    //radius = random(30,80);
    radius = r;

    for (int i = 0; i < numOfPoints; i++) {
      shapePoints[i] = new PVector(radius*cos(i * TWO_PI / numOfPoints) + x
        , radius*sin(i * TWO_PI / numOfPoints)+ y);
    }
    c = color(random(255), random(180, 230), random(256));
  }

  void marble(Drop newDrop) {
    for (PVector p : shapePoints) {
      PVector C = newDrop.pos;
      PVector cMinusPos = PVector.sub(p, C);
      float denom = pow(cMinusPos.mag(), 2);
      float k = sqrt(1 + ((radius*radius)/denom));
      p.set(cMinusPos.mult(k).add(C));
    }
  }

  void tine(PVector startPoint, PVector v, float z, float c) {
    float u = 1/pow(2, 1/c);
    v.normalize();
    for (PVector p : shapePoints) {
      PVector pMinusStart = PVector.sub(p, startPoint);
      PVector normal = v.copy().rotate(HALF_PI);
      float d = abs(pMinusStart.dot(normal));
      p.add(v.copy().setMag(z * pow(u, d)));
    }
  }

  void vortex(PVector center, float z, float u, float r) {
    for (PVector p : shapePoints) {
      float h = PVector.sub(p, center).mag();

      if (h > 1) {
        float l = (z * pow(u, -r)) * pow(u, h);
        float a = l / h;

        PVector pMinusC = PVector.sub(p, center);
        PVector displacement = new PVector(
          pMinusC.x*cos(a) + pMinusC.y*sin(a),
          -pMinusC.x*sin(a) + pMinusC.y*cos(a)
          );

        p.set(PVector.add(center, displacement));
      }
    }
  }

  void update(float vx, float vy) {
    for (PVector p : shapePoints) {
      p.add(vx, vy);
    }
  }

  boolean show() {
    fill(c);
    noStroke();
    strokeWeight(5);
    beginShape();
    boolean shown = false;

    for (PVector p : shapePoints) {
      if (p.x > 0 && p.x < width && p.y > 0 && p.y < height) {
        shown =  true;
      }
      vertex(p.x, p.y);
    }

    endShape(CLOSE);
    return shown;
  }
}
