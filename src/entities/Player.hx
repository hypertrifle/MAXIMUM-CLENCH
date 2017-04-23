package entities;

import luxe.Sprite;
import luxe.Color;
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

    public var energy:Float = 1;

    public var texture_src:Texture;

    public var animations:SpriteAnimation;

    public var velocity:Float;
    public var prevVelocity:Float;
    public var jumpVelocity:Float;

    private var maxSpeed:Float = 200;
    private var ACCELLERATION:Float = 1200;
    private var DECELERATION:Float = 600;

    private var hud:Sprite;
    public var hudanim:SpriteAnimation;


    public var worldPosition:Vector;

    public var ready:Bool = false;

    public var fist:Sprite;
    public var powerBar:Sprite;
    public var fistPosition:Float;
    public var fistVelocity:Float;

    public var fistPulling:Bool = false;
    public var fistPower:Float = 0;

    public var jumping:Bool = false;
    public var dashing:Bool = false;
    public var dizzy:Bool = false;
    
    public var dead:Bool = false;
    public var physicSize:Vector = new Vector(20,50); 

public function new(options:PlayerOptions){

    if(options.playerNumber != null){
        this.playerNumber = options.playerNumber;
    }

    if(this.playerNumber == 1){
        texture_src = Luxe.resources.texture('assets/players.png');

    } else {
        texture_src = Luxe.resources.texture('assets/player2.png');
        
    }
    texture_src.filter_mag = FilterType.nearest;
    super({
            name:'player'+playerNumber,
            texture : texture_src,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(64,64),
            origin: new Vector(32,64+Contants.worldSize,0),
            depth:1
            // centered: true,
        });

        events.listen("dash.end", dashEnd);
        events.listen("dash.coolend", dashEndAfterCooldown);

        events.listen('*', function(e){
            // trace( e.event );
        });

}

override function init(){

    super.init();

    velocity = 0;
    jumpVelocity = 0;
    worldPosition = new Vector(0,0,0);

    fistVelocity = 0;
    fistPosition = 0;
    if(playerNumber > 1){
        worldPosition.x += playerNumber *200;
        fistPosition += playerNumber *200;
    }


    var fistTexture:Texture = Luxe.resources.texture("assets/fist.png");
    fistTexture.filter_mag = FilterType.nearest;
    
    fist = new Sprite({
            name:'player'+playerNumber+'Fist',
            texture : fistTexture,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(256,512),
            origin: new Vector(128,512+Contants.worldSize+128,0),
            depth:2*playerNumber
            // centered: true,
        });
        //78 x 7

    var bar_text = Luxe.resources.texture("assets/bar.png");
    powerBar = new Sprite({
            name:'player'+playerNumber+'power',
            pos : Luxe.screen.mid,
            texture:bar_text,
            scale: new Vector(0,1,1),
            size : new Vector(78,7),
            origin: new Vector(78/2 - 13,0,0),
            depth:4*playerNumber,
            color:new Color().rgb(0xfcc53a)
    });

    var fistAnimationsData = Luxe.resources.json('assets/fistAnimations.json').asset.json;
    var fistanimations = new SpriteAnimation({ name:'anim' });
    this.fist.add(fistanimations);
    fistanimations.add_from_json_object( fistAnimationsData );
    fistanimations.animation = "idle"+playerNumber;
    fistanimations.play();



    trace("loading player");

    var animationData = Luxe.resources.json('assets/playerAnimations.json').asset.json;

    animations = new SpriteAnimation({ name:'anim' });
    this.add(animations);
    animations.add_from_json_object( animationData );

    animations.play();

    var hud_texture = Luxe.resources.texture("assets/hud.png");
    hud = new Sprite({
            name:'player'+playerNumber+'hud',
            pos : Luxe.screen.mid,
            texture:hud_texture,
            scale: new Vector(1,1,1),
            size : new Vector(400,400),
            origin: new Vector(200,200,0),
            depth:25
    });


    hudanim = new SpriteAnimation({ name:'anim' });
    hud.add(hudanim);
    hudanim.add_from_json('
            {
                "0" : {
                    "frame_size":{ "x":"400", "y":"400" },
                    "frameset": ["1"],
                    "loop": "true",
                    "speed": "1"
                },
                "1" : {
                    "frame_size":{ "x":"400", "y":"400" },
                    "frameset": ["2"],
                    "loop": "true",
                    "speed": "1"
                },
                "2" : {
                    "frame_size":{ "x":"400", "y":"400" },
                    "frameset": ["3"],
                    "loop": "true",
                    "speed": "1"
                },
                "3" : {
                    "frame_size":{ "x":"400", "y":"400" },
                    "frameset": ["4"],
                    "loop": "true",
                    "speed": "1"
                },
                "4" : {
                    "frame_size":{ "x":"400", "y":"400" },
                    "frameset": ["5"],
                    "loop": "true",
                    "speed": "1"
                },
                "5" : {
                    "frame_size":{ "x":"400", "y":"400" },
                    "frameset": ["6"],
                    "loop": "true",
                    "speed": "1"
                }
            }
        ');
    hudanim.animation = "0";
    hudanim.play();

    if(playerNumber == 1){
        hud.flipx = true;
    }

    ready = true;



    
}

public function endJump(){
    jumping = false;
}

public function hit(){
    visible = false;
    dead = true;
    Actuate.timer(2).onComplete(function(){
        rotation_z = Math.random()*360;
        visible = true;
        dead = false;
    });
}

public function score(){
    trace("PICKUP!");

    energy =Math.min(0.1+energy, 1);
    updateEnergyBar();
}


public function updateEnergyBar(){
    Actuate.tween(powerBar.scale, 0.4,{x:energy},true);
    // powerBar.scale.x = energy;
}
  
  override function update(dt:Float){
  	super.update(dt);

      if(!ready){
          return;
      }

    //   if(dizzy){
    //       return;
    //   }
      
      //input
        if(Luxe.input.inputpressed('p'+playerNumber+'jump') && !jumping && !dizzy){
            
            playAnimation("jump");
            jumping = true;
            jumpVelocity = 400;
            
        }

        if(Luxe.input.inputdown('p'+playerNumber+'dash') && !dashing && !dizzy){
           
            if(!jumping){
                //ground dash
                prevVelocity = velocity;
                velocity = flipx? 600 : -600;
                playAnimation("floordash");

            } else {
                //air dash
                // trace("AIR DSAH");
                prevVelocity = velocity;
                velocity = flipx? 600 : -600;
                playAnimation("dash");
            }
            dashing = true;
        }

        if(dashing || dizzy){

        if(dizzy){
            color.a = (color.a == 0.5)? 1 : 0.5;
        }

        }else if(Luxe.input.inputdown('p'+playerNumber+'left') || Luxe.input.gamepadaxis(playerNumber - 1,0) < -0.3) {
            playAnimation("run");
            this.flipx = false;
            velocity -=(ACCELLERATION*dt);
            if(velocity < -maxSpeed && !dashing) velocity = -maxSpeed;
        } else if (Luxe.input.inputdown('p'+playerNumber+'right') || Luxe.input.gamepadaxis(playerNumber - 1,0) > 0.3) {
            playAnimation("run");
            this.flipx = true;
            velocity +=(ACCELLERATION*dt);
            if(velocity > maxSpeed && !dashing) velocity = maxSpeed;
        } else {
            playAnimation("idle");
            //decellerate
            var vec = Math.min(Math.max(velocity,-1), 1); // either 1 / -1;
            if(Math.abs(velocity) > (DECELERATION*dt)){
                velocity -= vec*(DECELERATION*dt);
            } else {
                velocity = 0;
                
            }

        }

        //input fist
        if( Luxe.input.inputdown("p"+playerNumber+"fistleft") && Luxe.input.inputdown("p"+playerNumber+"fistright")){
            
            if(energy > 0.3){
                //fist being pulled back
                fistVelocity = 0;
                fistPulling = true;
                fistPower += 20*dt;
                this.fist.origin.y = 512+Contants.worldSize+128 + fistPower;
            }

        }else if(energy > 0.01*dt && Luxe.input.inputdown("p"+playerNumber+"fistleft")){
            energy -= 0.01*dt;
            updateEnergyBar();
            fistVelocity -=ACCELLERATION*dt;
            if(fistVelocity < -maxSpeed/2) fistVelocity = -maxSpeed/2;
        } else if (energy > 0.01*dt &&Luxe.input.inputdown("p"+playerNumber+"fistright")){
            energy -= 0.01*dt;
            updateEnergyBar();
            fistVelocity +=ACCELLERATION*dt;
            if(fistVelocity > maxSpeed/2) fistVelocity = maxSpeed/2;
        }  else if(fistPulling){
            energy -= 0.3;
            updateEnergyBar();
            //do a punch
            fistPulling = false;
            Actuate.tween(fist.origin,0.1,{y:512+Contants.worldSize},true).onComplete(resetFist);


        } else {
            var vec = Math.min(Math.max(fistVelocity,-1), 1); // either 1 / -1;
            if(Math.abs(fistVelocity) > (DECELERATION*dt)){
                fistVelocity -= vec*(DECELERATION*dt);
            } else {
                fistVelocity = 0;
                
            }

        }





        //apply physics
        worldPosition.x += (velocity)* dt;

        if(Math.abs(velocity) != 600){
            worldPosition.y = Math.max(0, worldPosition.y + (jumpVelocity*dt));
            
            if(worldPosition.y > 5){
                jumpVelocity -=20;
            } else {
                worldPosition.y = 0;
                jumping = false;
                jumpVelocity = 0;
            }
        }
        origin.y = 64+Contants.worldSize + worldPosition.y;




        fistPosition += (fistVelocity)* dt;

        //position our dude based on our world position!

        var worldPositionScaled = worldPosition.x / 25; // scaled better so world circumfrence is position 0-1
        var worldFistPositionScaled = fistPosition / 25; // scaled better so world circumfrence is position 0-1


         powerBar.origin.y = fist.origin.y-342;
         fist.rotation_z = powerBar.rotation_z = Math.PI*2 * worldFistPositionScaled;
         this.rotation_z = Math.PI*2 * worldPositionScaled;

  }//update

  public function playAnimation(ref:String){
      if((animations.animation != ref) && !dashing && (!jumping || ref == "dash" )){
        //   trace(ref);
        animations.animation = ref;        
      }

  }



  public function resetFist(){
       Luxe.events.fire("fist.punch",{power:fistPower, player:playerNumber, angle: fist.rotation_z});
       fistPower = 0;

      Actuate.tween(fist.origin,1,{y:512+Contants.worldSize+128},true);
  }

  public function smash(){
      trace("player: "+playerNumber+ " got smashed");
  }

  public function dashEnd(_:Dynamic):Void{
      velocity = prevVelocity;
      if((velocity < 0 && flipx) || (velocity>0 && !flipx)){
          velocity *= -1;
      }
  }
public function dashEndAfterCooldown(_:Dynamic):Void{
      dashing = false;
}

public function setDizzy(){
    // trace("im dizzy"+playerNumber);
    dashing = false;
    dizzy = true;
    // color.a = 0.5;
    animations.animation = "dizzy";
    // this.worldPosition.y = 0;
    this.velocity = 0;
    // origin.y = 64+Contants.worldSize + worldPosition.y;

    Actuate.timer(3).onComplete (function(){
        dizzy = false;
        color.a = 1;
        
    });
}

override public function destroy(?_from_parent:Bool):Void{

    fist.destroy();
    super.destroy(_from_parent);
}
  




}