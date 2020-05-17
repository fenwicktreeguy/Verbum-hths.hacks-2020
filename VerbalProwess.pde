


ArrayList<Projectile> activeProjectiles = new ArrayList<Projectile>();

public void hitAbility(){
  for(Projectile p: activeProjectiles){
    for(int i = 0; i < players.size(); i++){
      Operator o = players.get(i);
      if(dist(o.curX, o.curY, p.curX, p.curY) <= 15){
          println("PLAYER " + (i + 1) + " has been hit!");
          o.health -= p.damage;
      }
    }
  }
}

class Projectile{
  float curX, curY;
  float velX, velY;
  float damage, duration;
  float timeExisted;
  float angle;
  
  String attackName;
  
  public Projectile(float curX, float curY, float velX, float velY, float damage, float duration, float timeExisted, float angle, String attackName){
    this.curX = curX;
    this.curY = curY;
    this.velX = velX;
    this.velY = velY;
    this.damage = damage;
    this.duration = duration;
    this.timeExisted = timeExisted;
    this.angle = angle;
    this.attackName = attackName;
  }
  
  public boolean hasLasted(){
    return timeExisted <= duration;
  }
  
}
