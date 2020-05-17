import ComputationalGeometry.*;
import quickhull3d.*;
import template.library.*;



FabricManipulator manip = new FabricManipulator(0.35, 0.0035, 0.25, 150, 200);
FabricManipulator manip2 = new FabricManipulator(0.5, 0.0035, 0.25, 800, 200);


boolean gameStart = false;
boolean customizeStart = false;

color PLAYER_ONE = color(255,0,0);
color PLAYER_TWO = color(0,255,0);
color PLAYER_THREE = color(0,0,255);
color PLAYER_FOUR = color(0,255,255);


boolean toggle = false;
double[][] matX = new double[20][20];
double[][] matY = new double[20][20];

int[] optRot;


int passiveTimer = 0; //timing the time between the usage of passive attack to its usage


PImage img, img2, img3, img4;


int[] healthX = {40, 1220, 40, 1220};
int[] healthY = {10, 10, 840, 840};

void mousePressed(){
  
  //MAP CUSTOMIZER
  if(customizeStart && !keysPressed[32]){
  if(!toggle){
    manip.restart = true;
    manip.released = false;
    if(manip.vertexSearch(mouseX, mouseY)){
      manip.presses[manip.tempX][manip.tempY] = true;
    } else {
      manip.presses[manip.tempX][manip.tempY] = false;
    }
 } else {
    manip2.restart = true;
    manip2.released = false;
  
    if(manip2.vertexSearch(mouseX, mouseY)){
      manip2.presses[manip2.tempX][manip2.tempY] = true;
    } else {
      manip2.presses[manip2.tempX][manip2.tempY] = false;
    }
   }
  }
    
    
   if(mouseX <= 820 && mouseX >= 500 && mouseY >= 550 && mouseY <= 600){
     println("game click!");
     gameStart = true;
   }
   if(mouseX >= 520 && mouseX <= 820 && mouseY >= 620 && mouseY <= 670){
     println("customize click!");
     customizeStart = true;
   }
}

void mouseReleased(){
  String state = toggle ? "true" : "false";
  if(customizeStart && !keysPressed[32]){
  matX[manip.tempX][manip.tempY] = mouseX + 650;
  matY[manip.tempX][manip.tempY] = mouseY;
  println(state);
  if(!toggle){
    manip.released = true;
    manip.presses[manip.tempX][manip.tempY] = false;
  } else {
    manip2.released = true;
    manip2.presses[manip2.tempX][manip2.tempY] = false;
  }
  }
}


int clock = 0;


void drawImg1(){
  imageMode(CENTER);
  image(img, players.get(0).curX, players.get(0).curY);
}

void drawImg2(){
   imageMode(CENTER);
   image(img2, players.get(1).curX, players.get(1).curY);
}


void setup(){
  
  
  size(1600, 1400);
  frameRate(70);
  
  manip.create();
  manip2.create();
   for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      matX[i][j] = manip2.constsX[i][j];
      matY[i][j] = manip2.constsY[i][j];
    }
  }
  
  
  players.add(new Operator(350, 500, 15, 15, 8, 5, 20, (float)(Math.PI/10) ) );
  players.add(new Operator(1050, 500, 15, 15, 8, 5, 20, (float)(Math.PI/10) ) );
  players.add(new Operator(700, 500, 15, 15, 8, 5, 20, (float)(Math.PI/10) ) );
  players.add(new Operator(100, 500, 15, 15, 8, 5, 20, (float)(Math.PI/10) ) );
  
  optRot = new int[players.size()];
  
  img = loadImage("red_player.png");
  img2 = loadImage("blue_player.png");
  img3 = loadImage("green_player.png");
  img4 = loadImage("yellow_player.png");
}



void draw(){
 

  
  if(!gameStart){
  
   background(255);
   
   fill(0);
  textSize(40);
  text("VERBUM", (float)(600), (float)(400) );
  textSize(20);
  text("The game where words do hurt", 520, 430);
  
  
  
  fill(0);
  rect(520, 550, 300, 50);
  fill(255);
  text("START GAME", 620, 580);
  fill(0);
  rect(520, 620, 300, 50);
  fill(255);
  text("CUSTOMIZE MAP ", 590, 650);
  
  
  } else if(gameStart && !customizeStart){
  

  
  background(160);
  
  text("P1: " , 20, 20);
  text("P2: ", 1200, 20);
  text("P3: ", 20, 850);
  text("P4: ", 1200, 850);
  
  for(int i = 0; i < players.size(); i++){
    Operator op = players.get(i);
    if(op.health >= 15 && op.health <= 20){
        fill(0,255,0);
    } else if(op.health >= 10 && op.health < 15){
        fill(255,255,0);
    } else if(op.health >= 5 && op.health < 10){
      fill(255,69,0);
    } else {
      fill(255,0,0);
    }
    
    rect(healthX[i], healthY[i], 200 * (op.health/20), 10);
    fill(160);
    rect(healthX[i] + 200*(op.health/20), healthY[i], 200 - (200 * (float)(op.health/20) ), 10);
    
  }

  imageMode(CORNER);
  textAlign(CENTER);
  
  
   letterAttain();
   
   if(clock >= 200){
     letterGeneration();
     AIPlayer ai = new AIPlayer();
     optRot = ai.optimalRotations();
     clock = 0;
   } else {
     clock++;
   }
   
   

   for(Pair p : activeLetters){
      fill(255);
      ellipse(p.xc, p.yc, 30, 30);
      fill(0);
      textSize(20);
      text(p.assoc, p.xc - 4, p.yc + 12);
   }
   
   
   
   /*
   //AUTOMATION FOR DEMO
   if(activeLetters.size() > 0){
     for(int i = 0; i < optRot.length; i++){
       print("ROTATION: " + optRot[i] + " " );
     }
     println();
     
     for(int i = 0; i < players.size(); i++){
      if(optRot[i] > 0){
        players.get(i).numRot++;
        optRot[i]--;
      }
    }
     
   }
   */
   
   
   //projectiles for passive attacks
   
   if(activeProjectiles.size() > 0){
   for(int i = 0; i < activeProjectiles.size(); i++){
     activeProjectiles.get(i).timeExisted++;
     
     ArrayList<String> validStrings = players.get(1).validWords();
     
     if(activeProjectiles.get(i).attackName.equals("FIRE") ){//shoots ball of fire
       fill(255,0,0);
       activeProjectiles.get(i).curX -= cos(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velX;
       activeProjectiles.get(i).curY += sin(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velY;
       fill(173, 216, 230);
     } else if(activeProjectiles.get(i).attackName.equals("ICE")){//shoots ball of ice
       activeProjectiles.get(i).curX -= cos(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velX;
       activeProjectiles.get(i).curY += sin(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velY;
     } else if(activeProjectiles.get(i).attackName.equals("SHIELD")){//increases durability to damage, shown with yellow aura
       activeProjectiles.get(i).curX -= cos(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velX;
       activeProjectiles.get(i).curY += sin(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velY;
     } else if(activeProjectiles.get(i).attackName.equals("SPEAKER")){//increases damage to enemies
       activeProjectiles.get(i).curX -= cos(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velX;
       activeProjectiles.get(i).curY += sin(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velY;
     }
     
     activeProjectiles.get(i).angle = players.get(1).numRot * players.get(1).angularVelocity;
     if(activeProjectiles.get(i).hasLasted()){
         activeProjectiles.get(i).curX -= cos(activeProjectiles.get(i).angle - (float)(Math.PI)/2 ) * activeProjectiles.get(i).velX;
         activeProjectiles.get(i).curY += sin( activeProjectiles.get(i).angle - (float)(Math.PI/2) ) * activeProjectiles.get(i).velY;
     } else {
       activeProjectiles.remove(activeProjectiles.get(i));
       i--;
     }
   }
  }
   
   for(Projectile proj : activeProjectiles){
     ellipse(proj.curX, proj.curY, 10, 10);
   }
   
  
    
    
    
  
  
  fill(PLAYER_TWO);
  ellipse(players.get(1).curX, players.get(1).curY, 30, 30);
  line(players.get(1).curX, players.get(1).curY, players.get(1).curX - 15*cos( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ), players.get(1).curY + 15*sin( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ) );
  
  fill(PLAYER_ONE);
  ellipse(players.get(0).curX, players.get(0).curY, 30, 30);
  line(players.get(0).curX, players.get(0).curY, players.get(0).curX - 15*cos( (players.get(0).numRot * players.get(0).angularVelocity) - (float)(Math.PI/2) ), players.get(0).curY + 15*sin( (players.get(0).numRot * players.get(0).angularVelocity) - (float)(Math.PI/2) ) );
  
  fill(PLAYER_THREE);
  ellipse(players.get(2).curX, players.get(2).curY, 30, 30);
  line(players.get(2).curX, players.get(2).curY, players.get(2).curX - 15 *cos( (players.get(2).numRot * players.get(2).angularVelocity) - (float)(Math.PI/2) ), players.get(2).curY + 15*sin( (players.get(2).numRot * players.get(2).angularVelocity) - (float)(Math.PI/2) ) );
  
  fill(PLAYER_FOUR);
  ellipse(players.get(3).curX, players.get(3).curY, 30, 30);
  line(players.get(3).curX, players.get(3).curY, players.get(3).curX - 15 *cos( (players.get(3).numRot * players.get(3).angularVelocity) - (float)(Math.PI/2) ), players.get(3).curY + 15*sin( (players.get(3).numRot * players.get(3).angularVelocity) - (float)(Math.PI/2) ) );


  if(createPassive && players.get(1).trailingChars.size() > 0){
     fill(255,0,0);
    activeProjectiles.add(new Projectile(  (float)(players.get(1).curX - 21*cos( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ) ),  (float)(players.get(1).curY + 21* sin( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) )), 10, 10, 2, 40, 0, players.get(1).numRot * players.get(1).angularVelocity, "Passive") );
    println("PROJECTILE ADDED");
    createPassive = false;
    players.get(1).trailingChars.remove(players.get(1).trailingChars.get(players.get(1).trailingChars.size() - 1));
 }
  
  ArrayList<String> ret1 = players.get(0).validWords();
  ArrayList<String> ret2 = players.get(1).validWords();
  ArrayList<String> ret3 = players.get(2).validWords();
  ArrayList<String> ret4 = players.get(3).validWords();
  
  //println(ret1.size() + " " + ret2.size() + " " + ret3.size() + " " + ret4.size() );



  //println(players.get(0).numRot + " " + players.get(1).numRot );
  
   
  players.get(0).drawTail(color(255,255,255));
  players.get(1).drawTail(color(255,255,255));
  
}
  
  if(customizeStart){
   
   println("MAP CUSTOMIZATION HAS BEEN OPENED");
    
  background(255);
  text("CUSTOM MAP CONFIGURATION", 450, 30);
  
  
  if(!toggle){
    println("no toggle");
    manip.redraw();
    manip.manualMatrix();
    manip2.redraw();
  } else {
    println("toggle");
    manip.redraw();
    manip.manualMatrix();
    manip2.redraw();
    manip2.shapeMatrix(matX, matY);
  }
  
    
 }
  

    
}
 
 
 
 
 
 //makes fabric for the first minigame(maybe?)
 class FabricManipulator{
      boolean[][] presses = new boolean[10][10];
      boolean restart = false;
      
      int startX, startY;
      
      int tempX = -1;
      int tempY = -1;
      
      
      boolean released = false;
      double pcurX = 0;
      double pcurY = 0;
      double P,I,D;
      
      boolean press = false;
      
      double[][] updatedPointsX = new double[20][20];
      double[][] updatedPointsY = new double[20][20];
      
      double[][] error = new double[20][20];
      double[][] serror = new double[20][20];
      double[][] errorY = new double[20][20];
      double[][] serrorY = new double[20][20];
      boolean[][] exitThreshold = new boolean[20][20];
      boolean[][] exitThresholdY = new boolean[20][20];
      
      double[][] constsX = new double[20][20];
      double[][] constsY = new double[20][20];
      
      //attempt using this as foundation for uneven oscillations/look more into compphys book
      
      public FabricManipulator(double P, double I, double D, int startX, int startY){
         this.P = P;
         this.I = I;
         this.D = D;
         this.startX = startX;
         this.startY = startY;
      }
      
      
      public float distanceCalc(float f1, float f2, float f3, float f4){
          return sqrt(pow(f3-f1,2) + pow(f4-f2, 2));
      }
      
      void redraw(){
         
        for(int i = 0; i < 10; i++){
          for(int j = 0; j < 10; j++){
            if(i == tempX && j == tempY && presses[tempX][tempY]){
              float dist = distanceCalc((float)(updatedPointsX[i][j]), (float)(updatedPointsY[i][j]), mouseX, mouseY);
               //fill(dist, dist, dist);
               text("L", (float)(updatedPointsX[i][j]), (float)(updatedPointsY[i][j]) );
               ellipse( (float)(updatedPointsX[i][j]), (float)(updatedPointsY[i][j]), 30, 30);
            } else {
              text("L", (float)(updatedPointsX[i][j]), (float)(updatedPointsY[i][j]) );
              ellipse( (float)(updatedPointsX[i][j]), (float)(updatedPointsY[i][j]), 30, 30);
            }
            for(int k = 0; k < 10; k++){
              for(int l = 0; l < 10; l++){
                if( (k == i + 1 && l == j) || (k == i - 1 && l == j)  || (k == i && l == j + 1) || (k == i && l == j - 1) ){
                  line( (float)(updatedPointsX[i][j]), (float)(updatedPointsY[i][j]), (float)(updatedPointsX[k][l]), (float)(updatedPointsY[k][l]) );
                }
              }
            }
          }
        }
        
      }
      
      void pidX(double tempX, double tempY, int i, int j, double divFac, double addFac){
            int numExtrema = 0;
            double tempError = error[i][j];
            error[i][j] = tempX - updatedPointsX[i][j];
            
            double rate = 0;
            //if(updatedPointsX[i][j] - tempX <= 40 && !exitThreshold[i][j]){
              // rate = 1;
            if( abs( (float)(updatedPointsX[i][j] - tempX) ) >= 20 && !exitThreshold[i][j]){
              exitThreshold[i][j] = true;
            } else if(exitThreshold[i][j]){
                serror[i][j] += error[i][j];
                rate = P*(error[i][j]) + I*(serror[i][j]) + D*((error[i][j]-tempError)/2);
            } else if(exitThreshold[i][j] && error[i][j] <= 5){
              released = false;
              return;
            }
            
            //System.out.println(updatedPointsX[i][j] + " " + updatedPointsY[i][j] + " " + rate);
            
            updatedPointsX[i][j] += (rate + (divFac*addFac))/divFac;//for the case of a horizontal translation
            
        }
        
        void pidY(double tempX, double tempY, int i, int j, double divFac, double addFac){
            double tempError = errorY[i][j];
            errorY[i][j] = tempY - updatedPointsY[i][j];
            
            double rate = 0;
            //if(updatedPointsY[i][j]- tempY <= 40 && !exitThresholdY[i][j]){
                //rate = 5;
            if( abs( (float)(updatedPointsY[i][j] - tempY) )>= 20 && !exitThresholdY[i][j]){
              exitThresholdY[i][j] = true;
            } else if(exitThresholdY[i][j]){
                serrorY[i][j] += errorY[i][j];
                rate = P*(errorY[i][j]) + I*(serrorY[i][j])+ D*((error[i][j]-tempError)/2);
            } else if(exitThresholdY[i][j] && errorY[i][j] <= 5){
              return;
            }
            
            
            updatedPointsY[i][j] += (rate + (addFac*divFac))/divFac;
        }
        
        void pidMatrix(){    
            if(tempX != -1 && tempY != -1 && presses[tempX][tempY]){
              updatedPointsX[tempX][tempY] = mouseX;
              updatedPointsY[tempX][tempY] = mouseY;
            }  else if(released && tempX != -1 && tempY != -1 && !presses[tempX][tempY]){
              pidX(constsX[tempX][tempY], constsY[tempX][tempY], tempX, tempY, 2.5, 0);
              pidY(constsY[tempX][tempY], constsY[tempX][tempY], tempX, tempY, 2.5, 0);
            }
        }
        
        void manualMatrix(){
          if(tempX != -1 && tempY != -1 && presses[tempX][tempY]){
              updatedPointsX[tempX][tempY] = mouseX;
              updatedPointsY[tempX][tempY] = mouseY;
            }
        }

        void create(){
            for(int i = 0; i < 10; i++){
              int prevX = startX;
              for(int j = 0; j < 10; j++){
                startX += 50;
                updatedPointsX[i][j] = startX;
                updatedPointsY[i][j] = startY;
                constsX[i][j] = startX;
                constsY[i][j] = startY;
                matX[i][j] = random(startX, startX + 150);
                matY[i][j] = random(startX, startX + 150);
               
                //Vertices v = new Vertices(100, 100, startX, startY);
                //connections[i][j] = v;
              }
              startY += 50;
              startX = prevX;
            }
        }
        
        public boolean vertexSearch(int X, int Y){
              for(int i = 0; i < 10; i++){
                for(int j = 0; j < 10; j++){
                  if( (X >= updatedPointsX[i][j] - 30 && X <= updatedPointsX[i][j] + 30) && (Y >= updatedPointsY[i][j] - 30 && Y <= updatedPointsY[i][j] + 30) ){
                    tempX = i;
                    tempY = j;
                    return true;
                  }
                }
              }
              return false;
        }
      
        public void shapeMatrix(double[][] matX, double[][] matY){
          for(int i = 0; i < 10; i++){
            for(int j = 0; j < 10; j++){
              println(matX[i][j] + " " + matY[i][j]);
              pidX( (double)(matX[i][j]), (double)(matY[i][j]), i, j, 2.5, 0);
              pidY( (double)(matX[i][j]), (double)(matY[i][j]), i, j, 2.5, 0);
            }
          }
        }
  }
