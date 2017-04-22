package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import phoenix.Texture;
import phoenix.Texture.FilterType;
import luxe.components.sprite.SpriteAnimation;
import luxe.tween.Actuate;


typedef PlayerOptions = {

  >SpriteOptions,
@:optional var playerNumber:Int;

}


class Player extends Sprite {

    public var playerNumber:Int;

    public var texture_src:Texture;

    public var animations:SpriteAnimation;

    public var velocity:Float;

    private var maxSpeed:Float = 200;
    private var ACCELLERATION:Float = 20;
    private var DECELERATION:Float = 10;


    public var worldPosition:Float = 0;

    public var ready:Bool = false;

    public var fist:Sprite;
    public var fistPosition:Float;
    public var fistVelocity:Float;

    public var fistPulling:Bool = false;
    public var fistPower:Float = 0;


public function new(options:PlayerOptions){

    if(options.playerNumber != null){
        this.playerNumber = options.playerNumber;
    }

    texture_src = Luxe.resources.texture('assets/players.png');
    texture_src.filter_mag = FilterType.nearest;
    super({
            name:'player'+playerNumber,
            texture : texture_src,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(64,64),
            origin: new Vector(32,64+Contants.worldSize,0)
            // centered: true,
        });

}

override function init(){

    super.init();

    velocity = 0;
    worldPosition = 0;

    fistVelocity = 0;
    fistPosition = 0;

    var fistTexture:Texture = Luxe.resources.texture("assets/fist/fist_000.png");
    fistTexture.filter_mag = FilterType.nearest;
    
    fist = new Sprite({
            name:'player'+playerNumber+'Fist',
            texture : fistTexture,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(256,512),
            origin: new Vector(128,512+Contants.worldSize+128,0)
            // centered: true,
        });


    trace("loading player");

    var animationData = Luxe.resources.json('assets/playerAnimations.json').asset.json;

    animations = new SpriteAnimation({ name:'anim' });
    this.add(animations);
    animations.add_from_json_object( animationData );

    animations.play();

    ready = true;
    
}
  
  override function update(dt:Float){
  	super.update(dt);

      if(!ready){
          return;
      }
      

      //input
        if(Luxe.input.inputdown('p'+playerNumber+'left')) {
            playAnimation("run");
            this.flipx = false;
            velocity -=ACCELLERATION;
            if(velocity < -maxSpeed) velocity = -maxSpeed;
        } else if (Luxe.input.inputdown('p'+playerNumber+'right')) {
            playAnimation("run");
            this.flipx = true;
            velocity +=ACCELLERATION;
            if(velocity > maxSpeed) velocity = maxSpeed;
        } else {
            playAnimation("idle");
            //decellerate
            var vec = Math.min(Math.max(velocity,-1), 1); // either 1 / -1;
            if(Math.abs(velocity) > DECELERATION){
                velocity -= vec*DECELERATION;
            } else {
                velocity = 0;
                
            }

        }

        //input fist
        if(Luxe.input.inputdown("p"+playerNumber+"fistleft") && Luxe.input.inputdown("p"+playerNumber+"fistright")){
            //fist being pulled back
            fistVelocity = 0;
            fistPulling = true;
            fistPower += 20*dt;
            this.fist.origin.y = 512+Contants.worldSize+128 + fistPower;

        } else if(Luxe.input.inputdown("p"+playerNumber+"fistleft")){
            fistVelocity -=ACCELLERATION;
            if(fistVelocity < -maxSpeed) fistVelocity = -maxSpeed;
        } else if (Luxe.input.inputdown("p"+playerNumber+"fistright")){
            fistVelocity +=ACCELLERATION;
            if(fistVelocity > maxSpeed) fistVelocity = maxSpeed;
        } else if(fistPulling){
            //do a punch
            fistPulling = false;
            Luxe.events.fire("fist.player"+playerNumber+".punch",{power:fistPower});
            fistPower = 0;
            Actuate.tween(fist.origin,0.1,{y:512+Contants.worldSize},true).onComplete(resetFist);


        }



        //apply physics
        worldPosition += (velocity)* dt;
        fistPosition += (fistVelocity)* dt;

        //position our dude based on our world position!

        var worldPositionScaled = worldPosition / 25; // scaled better so world circumfrence is position 0-1
        var worldFistPositionScaled = fistPosition / 25; // scaled better so world circumfrence is position 0-1


         fist.rotation_z = Math.PI*2 * worldFistPositionScaled;
         this.rotation_z = Math.PI*2 * worldPositionScaled;

  }//update

  public function playAnimation(ref:String){
      if(animations.animation != ref+playerNumber){
        animations.animation = ref+playerNumber;        
      }

  }

  public function resetFist(){
      
      Actuate.tween(fist.origin,0.3,{y:512+Contants.worldSize+128},true);
  }




}