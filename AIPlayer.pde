

///automation of gameplay for demo(since i am 1 person group and the game has upwards of 4 players


class AIPlayer{
  
  
  //basic strategy for this will be choose the closest character and navigate to it, and move set for each of them for the demo will be set to FIRE, MILL, ICE, SWORD
  
  public int[] optimalRotations(){
    
    int[] ret = new int[players.size()];
    
    int ct = 0;
    for(Operator o: players){
      
        Pair closestLetter = new Pair(-1,-1,'.');
        float distance = 1000000000;
        for(int i = 0; i < activeLetters.size(); i++){
          distance = min(distance, dist(o.curX, o.curY, activeLetters.get(i).xc, activeLetters.get(i).yc));
          if(distance == dist(o.curX, o.curY, activeLetters.get(i).xc, activeLetters.get(i).yc)){
            closestLetter = activeLetters.get(i);
          }
        }
        float cang = (o.numRot * o.angularVelocity)  % (float)(2 * Math.PI);
        float optAng = atan( ((o.curY - closestLetter.yc)/(o.curX - closestLetter.xc) ) );
        
        line(o.curX, o.curY, closestLetter.xc, closestLetter.yc);
        
        
        float res = optAng - cang;
        if(optAng - cang < 0){
          res = (float)(2*Math.PI) + res;
        }
        int numRotations = (int)((res)/o.angularVelocity);
        ret[ct] = numRotations;
        ct++;
    }
    return ret;
  }
 
  
}
