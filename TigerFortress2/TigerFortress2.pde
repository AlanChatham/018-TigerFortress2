

int SIZE_X = 800;
int SIZE_Y = 600;

int IMAGE_OFFSET_X = 50;
int IMAGE_OFFSET_Y = 50;

int iox = IMAGE_OFFSET_X;
int ioy = IMAGE_OFFSET_Y;

PImage PlayfieldImage;


int ENEMY_FRAME_RESET = 900000;
int FramesUntilEnemySpawn = ENEMY_FRAME_RESET;

int SniperFramesUntilMove = 90;
int ScoutFramesUntilMove = 30;
int HeavyFramesUntilMove = 60;


int SHOT_POWER_INCREMENT = 1;
int SHOT_POWER_RESET = 100;
int SHOT_POWER_MAX = 200;
int ShotPower = SHOT_POWER_RESET;
int ShotCooldown = 0;
int SHOT_COOLDOWN_RESET = 30;


int[][] Sniper0PositionArray = { {355+iox, 64+ioy} };
int[][] Sniper1PositionArray = { {400+iox, 64+ioy} };
int[][] ScoutPositionArray = { {210+iox, 64+ioy}, {325+iox, 150+ioy}, {391+iox, 196+ioy}, {167+iox, 230+ioy} };
int[][] HeavyPositionArray = { {218+iox, 150+ioy}, {362+iox, 207+ioy}, {467+iox, 400+ioy}, {267+iox, 473+ioy} };

int[][][] ReticlePositions = { {ScoutPositionArray[0], Sniper0PositionArray[0], Sniper1PositionArray[0]},
                               {HeavyPositionArray[0], ScoutPositionArray[1]},
                               {ScoutPositionArray[3], HeavyPositionArray[1], ScoutPositionArray[2]},
                               {HeavyPositionArray[3], HeavyPositionArray[2]}
                             };
                               
int[][][] ReticleOffsets = { { {0,0}, {0,0}, {0,0} },
                             { {0,0}, {0,0}, {0,0} },
                             { {0,0} },
                             { {0,0}, {0,0} }
                           };
                           
int ShotPowerX = 20;
int ShotPowerY = 100;
int ShotPowerVerticalOffset = 8;
int ShotPowerBarWidth = 3;
int ShotPowerWidthIncrement = 2;
int ShotPowerBarStrokeWidth = 5;

int ReticleX = 0;
int ReticleY = 0;
int ReticleDiameter = 40;
                               
ArrayList<Enemy> EnemyArray;

boolean Fired = false;

color DarkBlu = color(82,124,154);
color LightBlu = color(153,194,216);

void setup(){
  size(SIZE_X, SIZE_Y);
  frameRate(30);
  PlayfieldImage = loadImage("playfield.jpg");
  
  EnemyArray = new ArrayList<Enemy>();
  EnemyArray.add( new Sniper(0));
  EnemyArray.add( new Scout());
  EnemyArray.add( new Heavy());
}

void draw(){
  image(PlayfieldImage, 0, 0);
  // Draw the reticle
  noFill();
  stroke(0);
  ellipse(ReticlePositions[ReticleY][ReticleX][0], ReticlePositions[ReticleY][ReticleX][1], ReticleDiameter, ReticleDiameter);

  // Fire! This gets set in a key listener event
  if (Fired == true && ShotCooldown == 0){
    println("Fired! Power: " + ShotPower);
    // Let's see if we hit anything...
    for (int i = 0; i < EnemyArray.size(); i++){
      int x = ReticlePositions[ReticleY][ReticleX][0];
      int y = ReticlePositions[ReticleY][ReticleX][1];
      Enemy enemy = EnemyArray.get(i);
      if (enemy.position[0] == x && enemy.position[1] == y){
        println("Hit enemy #" + i);
        enemy.health -= ShotPower;
        if (enemy.health <= 0){
          EnemyArray.remove(i);
          break;
        }
      }
    }
    
    // This way we only fire once per spacebar
    Fired = false;
    ShotCooldown = SHOT_COOLDOWN_RESET;
    ShotPower = SHOT_POWER_RESET;
  }
  
  // Rifle behavior
  // If we're cooling down, do that and block charging
  if (ShotCooldown > 0){
    ShotCooldown--;
  } else { //Otherwise, start shot charging
    ShotPower += SHOT_POWER_INCREMENT;
    if (ShotPower >= SHOT_POWER_MAX){
      ShotPower = SHOT_POWER_MAX;
    }
  }
  
  //Rifle Power Graphic
  if (ShotCooldown <= 0){
    int barsToDraw = ((ShotPower - SHOT_POWER_RESET) / 20) + 1;
    stroke(50);
    strokeWeight(ShotPowerBarWidth);
    strokeCap(SQUARE);
    for (int i = 0; i < barsToDraw; i++){
      int y = ShotPowerY - (ShotPowerVerticalOffset * i);
      line(ShotPowerX, y, ShotPowerX + ShotPowerBarWidth + (ShotPowerWidthIncrement * i), y);
    }    
  }

  
  // Update enemies
  for (int i = 0; i < EnemyArray.size(); i++){
    Enemy enemy = EnemyArray.get(i);
    enemy.Update();
    // And if one gets too close, kill the player
    if (enemy.ordinalPosition >= enemy.positionArray.length){
      println("You died!");
    }
  }
  
  // If an enemy gets too close
  
  // Create a new enemy every so often
  FramesUntilEnemySpawn--;
  if (FramesUntilEnemySpawn <= 0){
    float random = random(9);
    if (random <= 3){
      EnemyArray.add(new Scout());
    } else if (random <= 6){
      EnemyArray.add(new Heavy());
    } else if (random <= 8){
      EnemyArray.add(new Sniper(0));
    } else {
      EnemyArray.add(new Sniper(1));
    }
    FramesUntilEnemySpawn = ENEMY_FRAME_RESET;
  }
}

void mousePressed(){
  println("X:" + mouseX + " Y:" + mouseY);
}

void keyPressed(){
  // Handle spacebar for firing
  if (key == ' '){
    Fired = true;
  }
  // Handle arrow keys to move the reticle
  if (key == CODED) {
    if (keyCode == UP && ReticleY > 0) {
      ReticleY--;        
      // Adjust to make sure we're not out of bounds on our X
      if ( ReticleX >= ReticlePositions[ReticleY].length){
        ReticleX = ReticlePositions[ReticleY].length - 1;
      }
    } else if (keyCode == DOWN && ReticleY < ReticlePositions.length - 1) {
      ReticleY++;
      // Adjust to make sure we're not out of bounds on our X
      if ( ReticleX >= ReticlePositions[ReticleY].length){
        ReticleX = ReticlePositions[ReticleY].length - 1;
      }
    } else if (keyCode == LEFT && ReticleX > 0){
      ReticleX--;
    } else if (keyCode == RIGHT && ReticleX < ReticlePositions[ReticleY].length - 1){
      ReticleX++;
    }
  }
}

// Classes for enemies
public abstract class Enemy{
  
  protected int framesUntilMove;
  protected int currentFrame = 0;
  public int health;
  public int[] position;
  protected int[][] positionArray;
  public int ordinalPosition = 0;
  // If an enemy gets to positionArray.length, then player loses
  
  // Set up some defaults to set common attributes
  protected void setEnemyDefaults(){
    
  }
  
  public void Update(){
    // Update frame and position info
    this.currentFrame++;
    // Move if it's been long enough
    if (this.currentFrame >= this.framesUntilMove){
      currentFrame = 0;
      ordinalPosition += 1;
      // If we've still got movement path left, change position
      // Otherwise, we'll check ordinalPosition against ordinalPositionMax in our draw loop
      //  to see if we should kill the player
      if (ordinalPosition < positionArray.length){
        position = positionArray[ordinalPosition];
      }
    }
    this.Draw();
  }
  
  public abstract void Draw();
}

public class Sniper extends Enemy{
  public Sniper(int position){
    // this.ordinalPosition = 0;
    if (position == 0){
      this.positionArray = Sniper0PositionArray;
    }
    else {
      this.positionArray = Sniper1PositionArray;
    }  
    this.position = this.positionArray[ordinalPosition];
    this.framesUntilMove = SniperFramesUntilMove;
    this.health = 100;
  }
  
  public Sniper(){
    this(0);
  }
  
  void Draw(){
    fill(LightBlu);
    stroke(DarkBlu);
    rect(this.position[0], this.position[1], 20, 20);
  } 
}

public class Scout extends Enemy{
  public Scout(){
    this.positionArray = ScoutPositionArray;
    this.position = positionArray[ordinalPosition];
    this.framesUntilMove = ScoutFramesUntilMove;
    this.health = 100;
  }
  
  public void Draw(){
    fill(LightBlu);
    stroke(DarkBlu);
    rect(this.position[0], this.position[1], 10, 20);
  }
}

public class Heavy extends Enemy{
  public Heavy(){
    this.positionArray = HeavyPositionArray;
    this.position = positionArray[ordinalPosition];
    this.framesUntilMove = HeavyFramesUntilMove;
    this.health = 200;
  }
  
  public void Draw(){
    fill(LightBlu);
    stroke(DarkBlu);
    rect(this.position[0], this.position[1], 30, 30);
  }
}


