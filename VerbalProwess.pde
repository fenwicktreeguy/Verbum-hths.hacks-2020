


ArrayList<Projectile> activeProjectiles = new ArrayList<Projectile>();

public void hitAbility(){
  for(Operator o : players){
    
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
