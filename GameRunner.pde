import java.util.*;


//VERBUM: the game where words do hurt ( a play on the old addage "Sticks and stones may break my bones, but words will never hurt me" )

//structured minigames(one occur potentially on a  graph? (games on graphs are always fun) )

//NOTE IN ORDER TO START THE GAME, PRESS SPACE BAR AND CLICK AT THE SAME TIME

//Queue<Move> queue = new LinkedList<Move>();
boolean[] keysPressed = new boolean[256];
ArrayList<Operator> players = new ArrayList<Operator>();


ArrayList<Pair> activeLetters = new ArrayList<Pair>(); 

String gameSeed;



void letterGeneration(){
  float distance = dist(players.get(0).curX, players.get(0).curY, players.get(1).curX, players.get(1).curY);
  float cX = (players.get(0).curX + players.get(1).curX)/2;
  float cY = (players.get(0).curY + players.get(1).curY)/2;
  
  int randomLetter = (int)(random(65, 91));
  
  
  float randAng = random(0, (float)(Math.PI * 2) );
  
  float newPointX = cX + (distance/2) * cos(randAng);
  float newPointY = cY + (distance/2) * sin(randAng);
  
  
  float randDist = random(20, 400);
  
  activeLetters.add(new Pair(  (float)(newPointX - randDist/(Math.sqrt(2))), (float)(newPointY + randDist/(Math.sqrt(2) )), (char)(randomLetter) ));
}


void letterAttain(){
   for(int i = 0; i < activeLetters.size(); i++){
     if(dist(activeLetters.get(i).xc, activeLetters.get(i).yc, players.get(0).curX, players.get(0).curY) <= 20){
       Operator op = players.get(0);
        op.addCharacter(activeLetters.get(i));
       activeLetters.remove(activeLetters.get(i));
       i--;
     } else if(dist(activeLetters.get(i).xc, activeLetters.get(i).yc, players.get(1).curX, players.get(1).curY) <= 20){
       Operator op = players.get(1);
       op.addCharacter(activeLetters.get(i));
       activeLetters.remove(activeLetters.get(i));
       i--;
     } else if(dist(activeLetters.get(i).xc, activeLetters.get(i).yc, players.get(2).curX, players.get(2).curY) <= 20){
       Operator op = players.get(2);
       op.addCharacter(activeLetters.get(i));
       activeLetters.remove(activeLetters.get(i));
     } else if(dist(activeLetters.get(i).xc, activeLetters.get(i).yc, players.get(3).curX, players.get(3).curY) <= 20){
       Operator op = players.get(3);
       op.addCharacter(activeLetters.get(i));
       activeLetters.remove(activeLetters.get(i));
       i--;
     }
    }
  }




float threshold(float curVal, float decVal, boolean sign){
  if(sign){
    if(curVal - decVal < 0){
      return curVal;
    } else {
      return curVal - decVal;
    }
  } else {
    if(curVal + decVal >= 1400){
      return curVal;
    } else {
      return curVal + decVal;
    }
  }
}



boolean createPassive = false;
void keyPressed(){
  keysPressed[keyCode] = true;

  if(keyCode == 84){
    createPassive = true;
  }
  
  

  if(keyCode == 81){//FIRE
    activeProjectiles.add( new Projectile(  (float)(players.get(1).curX - 21*cos( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ) ),  (float)(players.get(1).curY + 21* sin( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) )), 10, 10, 6, 40, 0, players.get(1).numRot * players.get(1).angularVelocity, "FIRE") );
    players.get(1).trailingChars.remove(players.get(1).trailingChars.get(players.get(1).trailingChars.size() - 1));  
} else if(keyCode == 87){//ICE
    activeProjectiles.add( new Projectile(  (float)(players.get(1).curX - 21*cos( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ) ),  (float)(players.get(1).curY + 21* sin( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) )), 10, 10, 6, 40, 0, players.get(1).numRot * players.get(1).angularVelocity, "ICE" ) );
    players.get(1).trailingChars.remove(players.get(1).trailingChars.get(players.get(1).trailingChars.size() - 1)); 
} else if(keyCode == 69){//SHIELD
    activeProjectiles.add( new Projectile(  (float)(players.get(1).curX - 21*cos( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ) ),  (float)(players.get(1).curY + 21* sin( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) )), 10, 10, 6, 40, 0, players.get(1).numRot * players.get(1).angularVelocity, "SHIELD" ) );
    players.get(1).trailingChars.remove(players.get(1).trailingChars.get(players.get(1).trailingChars.size() - 1));  
} else if(keyCode == 82){//SPEAKER
    activeProjectiles.add( new Projectile(  (float)(players.get(1).curX - 21*cos( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) ) ),  (float)(players.get(1).curY + 21* sin( (players.get(1).numRot * players.get(1).angularVelocity) - (float)(Math.PI/2) )), 10, 10, 6, 40, 0, players.get(1).numRot * players.get(1).angularVelocity, "SPEAKER") );
    players.get(1).trailingChars.remove(players.get(1).trailingChars.get(players.get(1).trailingChars.size() - 1));  
}
  

  if(keyCode == 66 && !customizeStart){
    println("TOGGLE");
    toggle = true;
  }
  
  imageMode(CENTER);
  for(int i = 0; i < keysPressed.length; i++){
    if(keysPressed[i]){
        if(i == 87){
            players.get(0).curY -= cos(players.get(0).numRot * players.get(0).angularVelocity) * players.get(0).velY;
            players.get(0).curX -= sin(players.get(0).numRot * players.get(0).angularVelocity) * players.get(0).velX;
        } else if(i == 8){
            players.get(0).numRot++;
        } else if(i == 38){
          if(players.get(1).curX > 0 && players.get(1).curX < 1200 && players.get(1).curY > 30 && players.get(1).curY <= 810 ){
             players.get(1).curY -= cos(players.get(1).numRot * players.get(1).angularVelocity) * players.get(1).velY; 
             players.get(1).curX -= sin(players.get(1).numRot * players.get(1).angularVelocity) * players.get(1).velX; 
          }
        } else if(i == 32){ 
           players.get(1).numRot++;
        }
    }
  }
}

void keyReleased(){
  keysPressed[keyCode] = false;
  translate(0,0);
} 

class Operator{
  float curX, curY;
  float velX, velY;
  float angularVelocity;
  float strength;
  float maxCharCarry;
  float numRot = 0;
  float health;
  
  ArrayList<Pair> trailingChars = new ArrayList<Pair>();
  
  public Operator(float curX, float curY, float velX, float velY, float strength, float maxCharCarry, float health, float angularVelocity){
    this.curX = curX;
    this.curY = curY;
    this.velX = velX;
    this.velY = velY;
    this.maxCharCarry = maxCharCarry;
    this.angularVelocity = angularVelocity;
    this.health = health;
  }
  
  void addCharacter(Pair p){
    trailingChars.add(p);
  }
  
  void drawTail(color LETTER_COLOR){
    float sx = curX;
    float sy = curY;
    for(int i = 0; i < trailingChars.size(); i++){
      fill(LETTER_COLOR);
      float angle = numRot * angularVelocity;
      line(sx, sy, sx - 45*cos(angle + (float)( (Math.PI )/2) ), sy+45*sin(angle + (float)( (Math.PI)/2 ) ) );
      ellipse(sx - 45*cos(angle + (float)( ( Math.PI)/2 ) ), sy + 45*sin(angle + (float)( (Math.PI)/2 ) ), 30, 30);
      fill(0);
      textSize(20);
      textAlign(CENTER);
      text(trailingChars.get(i).assoc, (sx - 45*cos(angle + (float)( (Math.PI)/2) )) , sy + 45*sin(angle + (float)( (Math.PI)/2 ) ) );
      

      sx -= 45*cos(angle + (float)( (Math.PI)/2 ) );
      sy += 45*sin(angle + (float)( ( Math.PI)/2 ) );
    }
  }
  
  
  //makes tail act as a whip
  void wordTailPhysics(){
    
  }
  
  
  
  //consider what is done already or consider actually forming the words and reading the word directly for the AI demo
  ArrayList<String> validWords(){
    String[] fileContents = loadStrings("game_words.txt");
    
   
    ArrayList<String> ans = new ArrayList<String>();
    String charState = "";
    
    for(int i = 0; i < trailingChars.size(); i++){
      charState += trailingChars.get(i).assoc;
    }
    
    for(String s : fileContents){
        boolean[] charSeen = new boolean[92];
        for(int j = 0; j < charState.length(); j++){
          charSeen[(int)(charState.charAt(j))] = true;
        }
        boolean res = true;
        for(int j = 0; j < s.length(); j++){
          if(!charSeen[(int)(s.charAt(j))] ){
            res = false;
            break;
          }
        }
        if(res && s.length() > 0){
          println(s);
          ans.add(s);
        }
      }
      return ans;
    }

 }


class Pair{
  float xc, yc;
  char assoc;
  public Pair(float xc, float yc, char assoc){
    this.xc = xc;
    this.yc = yc;
    this.assoc = assoc;
  }
}



//pattern matching for the characters accumulated
public class KMP{
    private final int R;       // the radix
    private final int m;       // length of pattern
    private int[][] dfa; 
    public KMP(String pat) {
        this.R = 256;
        this.m = pat.length();

        // build DFA from pattern
        dfa = new int[R][m]; 
        dfa[pat.charAt(0)][0] = 1; 
        for (int x = 0, j = 1; j < m; j++) {
            for (int c = 0; c < R; c++) 
                dfa[c][j] = dfa[c][x];     // Copy mismatch cases. 
            dfa[pat.charAt(j)][j] = j+1;   // Set match case. 
            x = dfa[pat.charAt(j)][x];     // Update restart state. 
        } 
    } 

    /**
     * Preprocesses the pattern string.
     *
     * @param pattern the pattern string
     * @param R the alphabet size
     */
    public KMP(char[] pattern, int R) {
        this.R = R;
        this.m = pattern.length;

        // build DFA from pattern
        int m = pattern.length;
        dfa = new int[R][m]; 
        dfa[pattern[0]][0] = 1; 
        for (int x = 0, j = 1; j < m; j++) {
            for (int c = 0; c < R; c++) 
                dfa[c][j] = dfa[c][x];     // Copy mismatch cases. 
            dfa[pattern[j]][j] = j+1;      // Set match case. 
            x = dfa[pattern[j]][x];        // Update restart state. 
        } 
    } 

    /**
     * Returns the index of the first occurrrence of the pattern string
     * in the text string.
     *
     * @param  txt the text string
     * @return the index of the first occurrence of the pattern string
     *         in the text string; N if no such match
     */
     
     /*
    public int search(String txt) {

        // simulate operation of DFA on text
        int n = txt.length();
        int i, j;
        for (i = 0, j = 0; i < n && j < m; i++) {
            j = dfa[txt.charAt(i)][j];
        }
        if (j == m) return i - m;    // found
        return n;                    // not found
    }
    */

    public int search(char[] text) {

        // simulate operation of DFA on text
        int n = text.length;
        int i, j;
        for (i = 0, j = 0; i < n && j < m; i++) {
            j = dfa[text[i]][j];
        }
        if (j == m) return i - m;    // found
        return n;                    // not found
    }
}
