package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import phoenix.Texture;
import phoenix.Texture.FilterType;
import luxe.components.sprite.SpriteAnimation;


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


public function new(options:PlayerOptions){

    if(options.playerNumber != null){
        this.playerNumber = options.playerNumber;
    }

    texture_src = Luxe.resources.texture('assets/players.png');
    texture_src.filter_mag = FilterType.nearest;
    super({
            name:'player1',
            texture : texture_src,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(64,64),
            origin: new Vector(32,64,0)
            // centered: true,
        });

}

override function init(){

    super.init();

    velocity = 0;

    trace("loading player");

    var animationData = Luxe.resources.json('assets/playerAnimations.json').asset.json;

    var animations = new SpriteAnimation({ name:'anim' });
    this.add(animations);
    animations.add_from_json_object( animationData );

        animations.animation = "run"+playerNumber;
        animations.play();


    // playAnimation("run");


    //called when loaded

    //set up animations

    
}
  
  override function update(dt:Float){
  	super.update(dt);

      //input
        if(Luxe.input.inputdown('p1left')) {
            this.flipx = false;
            velocity -=10;
            if(velocity < -maxSpeed) velocity = -maxSpeed;
        } else if (Luxe.input.inputdown('p1right')) {
            this.flipx = true;
            velocity +=10;
            if(velocity > maxSpeed) velocity = maxSpeed;
        } else {
            //decellerate
            var vec = Math.min(Math.max(velocity,-1), 1); // either 1 / -1;
            velocity -= vec*5;

        }




        //apply physics
        this.pos.x += (velocity)* dt;

  }//update

  public function playAnimation(ref:String){
        animations.animation = ref+playerNumber;
        animations.play();

  }




}