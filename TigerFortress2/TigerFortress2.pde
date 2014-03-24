

int SIZE_X = 800;
int SIZE_Y = 600;

int IMAGE_OFFSET_X = 50;
int IMAGE_OFFSET_Y = 50;

int iox = IMAGE_OFFSET_X;
int ioy = IMAGE_OFFSET_Y;

int Score = 0;


/* @pjs preload="playfield.jpg, Lightning.png, Sniper0.png, Sniper1.png,
Scout0.png, Scout1.png, Scout2.png, Scout3.png, Heavy0.png, Heavy1.png, Heavy2.png,
Heavy3.png, Sniper0Reticle.png, Sniper1Reticle.png, Scout0Reticle.png,
Scout1Reticle.png, Scout2Reticle.png, Scout3Reticle.png, Heavy0Reticle.png,
Heavy1Reticle.png, Heavy2Reticle.png, Heavy3Reticle.png"; */
PImage PlayfieldImage;


int ENEMY_FRAME_RESET = 90;
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


int PLAYING = 0;
int GAME_OVER = 1;
int SHOW_ALL = 2;

int State = PLAYING;

int GAME_OVER_FRAME_RESET = 120;
int GameOverFrames = GAME_OVER_FRAME_RESET;

int[][] Sniper0PositionArray = { {387+iox, 15+ioy} };
int[][] Sniper1PositionArray = { {345+iox, 8+ioy} };
int[][] ScoutPositionArray = { {200+iox, 15+ioy}, {260+iox, 20+ioy}, {426+iox, 105+ioy}, {38+iox, 153+ioy} };
int[][] HeavyPositionArray = { {190+iox, 115+ioy}, {333+iox, 159+ioy}, {404+iox, 285+ioy}, {200+iox, 351+ioy} };

int[][][] ReticlePositions = { {ScoutPositionArray[0], ScoutPositionArray[1], Sniper1PositionArray[0], Sniper0PositionArray[0]},
                               {HeavyPositionArray[0], HeavyPositionArray[1], ScoutPositionArray[2]},
                               {ScoutPositionArray[3],HeavyPositionArray[3], HeavyPositionArray[2]}
                             };

PImage Sniper0Image;
PImage Sniper1Image;
PImage Scout0Image;
PImage Scout1Image;
PImage Scout2Image;
PImage Scout3Image;
PImage Heavy0Image;
PImage Heavy1Image;
PImage Heavy2Image;
PImage Heavy3Image;

PImage Sniper0ReticleImage;
PImage Sniper1ReticleImage;
PImage Scout0ReticleImage;
PImage Scout1ReticleImage;
PImage Scout2ReticleImage;
PImage Scout3ReticleImage;
PImage Heavy0ReticleImage;
PImage Heavy1ReticleImage;
PImage Heavy2ReticleImage;
PImage Heavy3ReticleImage;

PImage Lightning;

                           
PImage[] Sniper0ImageArray;
PImage[] Sniper1ImageArray;
PImage[] ScoutImageArray;
PImage[] HeavyImageArray;
PImage[][] ReticleImageArray;
                           
int ShotPowerX = 20 + IMAGE_OFFSET_X;
int ShotPowerY = 200 + IMAGE_OFFSET_Y;
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


import ddf.minim.*;

Minim minim;
AudioSample HighNote;
AudioSample LowNote;

void setup(){
  size(SIZE_X, SIZE_Y);
  frameRate(30);
  // Sound
  minim = new Minim(this);
  HighNote = minim.loadSample("highbeep.mp3", 512);
  LowNote = minim.loadSample("lowbeep.mp3", 512);
  // Images....
  PlayfieldImage = loadImage("playfield.jpg");
  Lightning = loadImage("Lightning.png");
  
  Sniper0Image = loadImage("Sniper0.png");
  Sniper1Image = loadImage("Sniper1.png");
  Scout0Image = loadImage("Scout0.png");
  Scout1Image = loadImage("Scout1.png");
  Scout2Image = loadImage("Scout2.png");
  Scout3Image = loadImage("Scout3.png");
  Heavy0Image = loadImage("Heavy0.png");
  Heavy1Image = loadImage("Heavy1.png");
  Heavy2Image = loadImage("Heavy2.png");
  Heavy3Image = loadImage("Heavy3.png");
  
  Sniper0ReticleImage = loadImage("Sniper0Reticle.png");
  Sniper1ReticleImage = loadImage("Sniper1Reticle.png");
  Scout0ReticleImage = loadImage("Scout0Reticle.png");
  Scout1ReticleImage = loadImage("Scout1Reticle.png");
  Scout2ReticleImage = loadImage("Scout2Reticle.png");
  Scout3ReticleImage = loadImage("Scout3Reticle.png");
  Heavy0ReticleImage = loadImage("Heavy0Reticle.png");
  Heavy1ReticleImage = loadImage("Heavy1Reticle.png");
  Heavy2ReticleImage = loadImage("Heavy2Reticle.png");
  Heavy3ReticleImage = loadImage("Heavy3Reticle.png");
  
  PImage[] sniper0ImageArray = {Sniper0Image};
  Sniper0ImageArray = sniper0ImageArray;
  PImage[] sniper1ImageArray = {Sniper1Image};
  Sniper1ImageArray = sniper1ImageArray;
  PImage[] scoutImageArray = {Scout0Image, Scout1Image, Scout2Image, Scout3Image};
  ScoutImageArray = scoutImageArray;
  PImage[] heavyImageArray = {Heavy0Image, Heavy1Image, Heavy2Image, Heavy3Image};
  HeavyImageArray = heavyImageArray;
  PImage[][] reticleImageArray = { {Scout0ReticleImage, Scout1ReticleImage, Sniper1ReticleImage, Sniper0ReticleImage},
                                   {Heavy0ReticleImage, Heavy1ReticleImage, Scout2ReticleImage},
                                   {Scout3ReticleImage, Heavy3ReticleImage, Heavy2ReticleImage} };
  ReticleImageArray = reticleImageArray;
 
  
  EnemyArray = new ArrayList<Enemy>();
//  EnemyArray.add( new Sniper(0));
//  EnemyArray.add( new Scout());
//  EnemyArray.add( new Heavy());
}


void draw(){
  tint(255, 200);
  image(PlayfieldImage, IMAGE_OFFSET_X, IMAGE_OFFSET_Y);
  
  if (State == GAME_OVER){
    if (GameOverFrames > 0){
      GameOverFrames--;
      // Loop through the enemy array to find the killer, and make him flash
      for(int i = 0; i < EnemyArray.size(); i++){
        Enemy enemy = EnemyArray.get(i);
        if (enemy.ordinalPosition >= enemy.positionArray.length && GameOverFrames % 30 > 15){
          enemy.Draw();
        }
      }
    }
    // Once we're done, reset things.
    else{
      EnemyArray.clear();
      State = PLAYING;
      Score = 0;
    }
  }
  
  if (State == SHOW_ALL){
    for (int i = 0; i < ReticleImageArray.length; i++){
      for (int j = 0; j < ReticleImageArray[i].length; j++){
        image(ReticleImageArray[i][j], ReticlePositions[i][j][0], ReticlePositions[i][j][1]);
      }
    }
    
    for (int i = 0; i < Sniper0ImageArray.length; i++){
      image(Sniper0ImageArray[i], Sniper0PositionArray[i][0], Sniper0PositionArray[i][1]);
    }
    for (int i = 0; i < Sniper1ImageArray.length; i++){
      image(Sniper1ImageArray[i], Sniper1PositionArray[i][0], Sniper1PositionArray[i][1]);
    }
    for (int i = 0; i < ScoutImageArray.length; i++){
      image(ScoutImageArray[i], ScoutPositionArray[i][0], ScoutPositionArray[i][1]);
    }
    for (int i = 0; i < HeavyImageArray.length; i++){
      image(HeavyImageArray[i], HeavyPositionArray[i][0], HeavyPositionArray[i][1]);
    }
   
  }
  if (State == PLAYING){
     // Update enemies
    for (int i = 0; i < EnemyArray.size(); i++){
      Enemy enemy = EnemyArray.get(i);
      enemy.Update();
      // And if one gets too close, kill the player
      if (enemy.ordinalPosition >= enemy.positionArray.length){
        State = GAME_OVER;
        GameOverFrames = GAME_OVER_FRAME_RESET;
      }
    }
    
    // Create a new enemy every so often
    FramesUntilEnemySpawn--;
    if (FramesUntilEnemySpawn <= 0){
      float rand = random(9);
      if (rand <= 3){
        EnemyArray.add(new Scout());
      } else if (rand <= 6){
        EnemyArray.add(new Heavy());
      } else if (rand <= 8){
        EnemyArray.add(new Sniper(0));
      } else {
        EnemyArray.add(new Sniper(1));
      }
      FramesUntilEnemySpawn = ENEMY_FRAME_RESET;
      LowNote.trigger();
    }
    
    // Draw the reticle
    image(ReticleImageArray[ReticleY][ReticleX], ReticlePositions[ReticleY][ReticleX][0], ReticlePositions[ReticleY][ReticleX][1]);
  
    // Fire! This gets set in a key listener event
    if (Fired == true && ShotCooldown == 0){
      // Let's see if we hit anything...
      for (int i = 0; i < EnemyArray.size(); i++){
        int x = ReticlePositions[ReticleY][ReticleX][0];
        int y = ReticlePositions[ReticleY][ReticleX][1];
        Enemy enemy = EnemyArray.get(i);
        if (enemy.position[0] == x && enemy.position[1] == y){
          Score++;
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
      image(Lightning, ShotPowerX, ShotPowerY - 80);
    }
  
    
   
  }
}

void mousePressed(){
 // println("X:" + (mouseX-iox) + " Y:" + (mouseY-ioy));
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
      if (this.ordinalPosition % 2 == 0){
        HighNote.trigger();
      }
      else{
        LowNote.trigger();
      }
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
  private int id;
  
  public Sniper(int position){
    // this.ordinalPosition = 0;
    if (position == 0){
      this.id = 0;
      this.positionArray = Sniper0PositionArray;
    }
    else {
      this.id = 1;
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
    if (this.id == 0){
      if (this.ordinalPosition < Sniper0ImageArray.length){
        image(Sniper0ImageArray[ordinalPosition], this.position[0], this.position[1]);
      }
      // So we can flash the enemy if it kills you
      if (this.ordinalPosition >= Sniper0ImageArray.length){
        image(Sniper0ImageArray[Sniper0ImageArray.length-1], this.position[0], this.position[1]);
      }
    }
    else{
      if (this.ordinalPosition < Sniper1ImageArray.length){
        image(Sniper1ImageArray[ordinalPosition], this.position[0], this.position[1]);
      }
      // So we can flash the enemy if it kills you
      if (this.ordinalPosition >= Sniper1ImageArray.length){
        image(Sniper1ImageArray[Sniper1ImageArray.length-1], this.position[0], this.position[1]);
      }
    }
//    fill(LightBlu);
//    stroke(DarkBlu);
//    rect(this.position[0], this.position[1], 20, 20);
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
    if (this.ordinalPosition < ScoutImageArray.length){
      image(ScoutImageArray[ordinalPosition], this.position[0], this.position[1]);
    }
    // So we can flash the enemy if it kills you
    if (this.ordinalPosition >= ScoutImageArray.length){
      image(ScoutImageArray[ScoutImageArray.length-1], this.position[0], this.position[1]);
    }
   // fill(LightBlu);
   // stroke(DarkBlu);
   // rect(this.position[0], this.position[1], 10, 20);
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
    if (this.ordinalPosition < HeavyImageArray.length){
      image(HeavyImageArray[ordinalPosition], this.position[0], this.position[1]);
    }
    // So we can flash the enemy if it kills you
    if (this.ordinalPosition >= HeavyImageArray.length){
      image(HeavyImageArray[HeavyImageArray.length-1], this.position[0], this.position[1]);
    }
    //fill(LightBlu);
    // stroke(DarkBlu);
    //rect(this.position[0], this.position[1], 30, 30);
  }
}


