package entities;

import luxe.Sprite;
import luxe.components.sprite.SpriteAnimation;
import luxe.Vector;
import phoenix.Texture;

class Pickup extends Sprite {

    public var anim:SpriteAnimation ;
    public var dead:Bool = false;
    public var pickedUp:Bool = false;
    public var worldPosition:Vector;

override public function new(_:Dynamic){

    var tex:Texture = Luxe.resources.texture("assets/pickup.png");
    super({name:"pickups"+_.i,
            texture : tex,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(32,32),
            origin: new Vector(16,Contants.worldSize+16,0),
            depth:20
            // centered: true,
        });

        worldPosition = new Vector(0,0);

    events.listen("intro.complete", function(e:Dynamic){
        this.anim.animation = "idle";
    });

    events.listen("kill.complete", function(e:Dynamic){
        trace("end me");
        this.dead = true;
    });

    anim = new SpriteAnimation({ name:'anim' });
    add(anim);
    anim.add_from_json('
            {
                "spawn" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["1-16"],
                    "events" : [{"frame":16, "event":"intro.complete"}],
                    "loop": "true",
                    "speed": "20"
                },
                "idle" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["17-29"],
                    "events" : [{"frame":16, "event":"intro.complete"}],
                    "loop": "true",
                    "speed": "20"
                },
                "kill" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["29-36"],
                    "events" : [{"frame":36, "event":"kill.complete"}],
                    "loop": "true",
                    "speed": "20"
                }
            }
        ');
    anim.animation = "spawn";
    anim.play();

}

public function spawn(angle:Float, height:Float){
    worldPosition.y = height;
    this.dead = false;
    this.pickedUp = false;
    this.rotation_z = angle;
    this.visible = true;
    this.origin.y = Contants.worldSize + 32 + height;
    anim.animation = "spawn";
    anim.play();

}

public function pickup(){
    this.pickedUp = true;
    this.anim.animation = "kill";
}

override function init(){
    super.init();
}



}