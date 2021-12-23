import java.util.*;  // For Lists.
import ddf.minim.*;  // For audio samples.

float targetX, targetY ; // X and Y positions of target.
float targetXCrit, targetYCrit;
float targetSize = random(30, 80 ); // Diameter of target.
float targetSizeCrit = targetSize / 5;
color targetColor;
color targetColor2;
color targetHighlight ; // Color of target when highlighted.
color backgroundColor = 0;
float scopeSize = 600;
boolean targetOver = false;
boolean targetOverCrit = false;
boolean targetOverScope = false;
boolean smgEquipped = false;
boolean scopeEnabled = false;
boolean zoomEnabled = false;
PImage hit;
PImage hitCrit;
Minim minim;
AudioPlayer hitSound;
AudioPlayer missSound;
List<String> hitList = new ArrayList<String>();
List<String> missList = new ArrayList<String>();
float hitAmount;
float missAmount;
float hitPercent;


void setup() {
  size(400, 400, P3D);
  targetColor = color(255);
  targetColor2 = color(#F70B0B);
  targetHighlight = color(204);
  targetX = random(width);
  targetY = random(height);
  targetXCrit = targetX;
  targetYCrit = targetY;
  ellipseMode(CENTER);
  hitCrit = loadImage("HitMarkerCritical.png");
  hit = loadImage("HitMarker.png");
  minim = new Minim(this);
}

void draw() {
  background(backgroundColor);
  cursor(CROSS);
  strokeWeight(4);
  update();
  
  if (targetOver) {
    fill(targetHighlight);
  } else {
    fill(targetColor);
  }
  
  stroke(targetColor);
  fill(targetColor2);
  ellipse(targetX, targetY, targetSize, targetSize);
  ellipse(targetX, targetY, targetSize/1.7, targetSize/1.7);
  ellipse(targetXCrit, targetYCrit, targetSizeCrit, targetSizeCrit);
  
  hitAmount = hitList.size();
  missAmount = missList.size();
  
  fill(255);
  textSize(20);
  text("Hit%:", 10, 30);
  
  text("Hits:", 10, 55);
  text(String.format("%.0f", hitAmount), 90, 55);
  text("Misses:", 10, 80);
  text(String.format("%.0f", missAmount), 90, 80);
  
  if (hitList.size() != 0 | missList.size() != 0) {
    hitPercent = (hitAmount / (hitAmount + missAmount)) * 100;
    text(String.format("%.1f", hitPercent), 90, 30);
  }
}

void update() {
  if (overTarget(targetX, targetY, targetSize)) {
    targetOver = true;
    if (overTarget(targetXCrit, targetYCrit, targetSizeCrit) ) {
      targetOverCrit = true;  
    } else {
      targetOverCrit = false;
    }
  } else {
    targetOver = false;
    targetOverCrit = false;
  }
  
  if (scopeEnabled) {
    scope();
    if (!zoomEnabled) {
      enableZoom();
    } else {
      disableZoom();  
    }
    if (targetInScope(targetX, targetY, targetSize)) {
      targetOverScope = true;
      text("I GOT YOU IN MY SIGHT", 10, 100);
    } else {
      targetOverScope = false;
    }
  }
}

void enableZoom() {
  targetSize = 2 * targetSize;
  zoomEnabled = true;
}

void disableZoom() {
  targetSize = targetSize / 2;
  zoomEnabled = false;  
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (smgEquipped) {
      m1Held();
    } else {
      m1Pressed();  
    }
  } else {
    /*
    // right click sound.
    if (!smgEquipped) {
      smgEquipped = true;
    } else {
      smgEquipped = false;
    }
    */
    if (scopeEnabled) {
      scopeEnabled = false;
    } else {
      scopeEnabled = true;  
    }
  }
}

void scope() {
  stroke(#A9A9A9);
  fill(#D3D3D3);
  ellipse(mouseX, mouseY, scopeSize, scopeSize);
  //stroke(#F70B0B);
  stroke(backgroundColor);
}

void m1Pressed() {
  if (targetOver) {
    if (!targetOverCrit) {
      image(hit, mouseX-25, mouseY-25, hit.width/10, hit.height/10);
    } else {
      image(hitCrit, mouseX-25, mouseY-25, hitCrit.width/10, hitCrit.height/10);
    }
    
    hitSound = minim.loadFile("gunShot.mp3");
    hitSound.setGain(-10);
    hitSound.play();
    
    // Adds new location and position for target after it's hit.
    targetSize = random(30, 80);
    targetSizeCrit = targetSize / 5;
    targetX = random(width);
    targetY = random(height);
    targetXCrit = targetX;
    targetYCrit = targetY;
    
    hitList.add("hit");
    
  }
  else {
    missSound = minim.loadFile("missShot.mp3");
    missSound.setGain(-10);
    missSound.play();
    
    missList.add("miss");
  }
}

void m1Held() {
  
}

boolean overTarget(float x, float y, float diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2) {
    return true;
  } else {
    return false;
  }
}

boolean targetInScope(float x, float y, float diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2) {
    return true;
  } else {
    return false;
  }
}
