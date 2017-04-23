package states;

import entities.Player;

import luxe.States;
import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import phoenix.Texture;
import phoenix.Texture.FilterType;
import luxe.components.sprite.SpriteAnimation;
import luxe.Color;
import luxe.Rectangle;
import phoenix.BitmapFont;
import phoenix.geometry.Geometry;
import phoenix.geometry.TextGeometry;


import luxe.tween.Actuate;
import luxe.tween.easing.*;

// import luxe.Input;

import phoenix.Texture.FilterType;


class PlayState extends State {

    public var PlayerOne:Player;
    public var PlayerTwo:Player;
    public var ready:Bool = false;
    public var world:Sprite;

    public var bloodTexture:Texture;

    public var blood:Sprite;

    public var text:TextGeometry;

public function new(_config:Dynamic){
    super(_config);


}

override function init() {
        trace("Play inited");

    } //init



    override function onenter<T>( _data:T ) {
        trace("Play ENTER");

        Luxe.events.listen("fist.punch",fistSmash);

        bloodTexture = Luxe.resources.texture("assets/blood.png");
        bloodTexture.filter_mag = FilterType.nearest;

        //build our planet?

        // var world = Luxe.

        Contants.worldSize = Luxe.screen.height/3.5;
        Contants.worldCirc = 2*Math.PI*Contants.worldSize;
        trace("world radius:"+ Contants.worldSize);
        trace("world Circumfrence:"+ Contants.worldCirc);

        var world_texture:Texture = Luxe.resources.texture("assets/planet/planet_000.png");
        world = new Sprite({
            texture: world_texture,
            pos: Luxe.screen.mid,
            centered:true
        });


        // world = Luxe.draw.circle(
        //     {
        //         x : Luxe.screen.w/2,
        //         y : Luxe.screen.h/2,
        //         r:Contants.worldSize,
        //         color: new Color(172/256,172/256,172/256)
                

        // });

        PlayerOne = new Player({playerNumber:1});
        PlayerTwo = new Player({playerNumber:2});
       

    
        

        //now that we have some fonts, lets write something
        text = Luxe.draw.text({
            font: Main.font,
            text : "LD38",
            bounds : new Rectangle(0, 0, Luxe.screen.w * 0.99, Luxe.screen.h * 0.98),
            color : new Color().rgb(0xFF00AA),
            align : TextAlign.right,
            align_vertical : TextAlign.bottom,
            point_size : 10
        });

        text.texture.filter_mag = FilterType.nearest;


        ready = true;


    } //onenter

    public function fistSmash(data:Dynamic){
        trace("smash", data);
        Luxe.camera.shake(0.8*data.power);


        //lets see if we hit anyone

        var angle = normaliseAngle(data.angle);

        var min = angle - ((50/Contants.worldCirc)*360);
        var max = angle + ((50/Contants.worldCirc)*360);

        var p1angle = normaliseAngle(PlayerOne.rotation_z);
        var p2angle = normaliseAngle(PlayerTwo.rotation_z);

        if(!PlayerOne.dead && p1angle < max && p1angle > min  ){
            trace("kill green");
            spawnBlood(PlayerOne.rotation_z);
            PlayerOne.hit();
        }
        if(!PlayerTwo.dead && p2angle < max && p2angle > min  ){
            spawnBlood(PlayerTwo.rotation_z);
            PlayerTwo.hit();
        }
    }

    public function normaliseAngle(angle:Float){
        var an = angle%360;
        return (an <0)? an +360 : an;
    }

    public function spawnBlood(angle:Float){

        if(blood != null){
            blood.destroy();
        }
        blood = new Sprite({
            name:'blood',
            texture : bloodTexture,
            pos : Luxe.screen.mid,
            scale: new Vector(1,1,1),
            size : new Vector(128,128),
            origin: new Vector(64,Contants.worldSize+64,0),
            depth:3,
            rotation_z:angle,
        });

    blood.events.listen("end.anim",function(e){
            // blood.destroy();
        });

    var anim = new SpriteAnimation({ name:'anim' });
    blood.add(anim);
    anim.add_from_json('
            {
                "play" : {
                    "frame_size":{ "x":"128", "y":"128" },
                    "frameset": ["1-19"],
                    "events" : [{"frame":19, "event":"end.anim"}],
                    "loop": "false",
                    "speed": "30"
                }
            }
        ');
    anim.animation = "play";
    anim.play();

    }

    override function onleave<T>( _data:T ) {
        trace("Play LEAVE");

        //destoy everything please

        PlayerOne.destroy();
        PlayerTwo.destroy();
        world.destroy();
        // text.
        ready = false;
        

   
    } //onleave

    public function returnCamera(){
        Actuate.tween(Luxe.camera.pos,0.2,{x:0,y:0},true).ease(Bounce.easeInOut);
    }


    override function update(dt:Float){
        if(ready){
            // spr.rotation_z += 50 * dt;

            handlePhysics();
        }
    }

    

    public function handlePhysics(){
        //check if players collide?
        //player body width = 20; height = 50;

        var xdif:Float = Math.abs( normaliseAngle(PlayerOne.rotation_z) - normaliseAngle(PlayerTwo.rotation_z));
        
        var ydif:Float = Math.abs( PlayerOne.worldPosition.y - PlayerTwo.worldPosition.y);

        if(xdif < 5 && ydif < 50){

            if(Math.abs(PlayerOne.velocity) == 600 && Math.abs(PlayerTwo.velocity) != 600 ){
                PlayerTwo.setDizzy();
            } else if(Math.abs(PlayerOne.velocity) != 600 && Math.abs(PlayerTwo.velocity) == 600 ){
                PlayerOne.setDizzy();
            } else if(Math.abs(PlayerOne.velocity) == 600 && Math.abs(PlayerTwo.velocity) == 600 ){
                //one or more dashers.
                if(PlayerOne.animations.frame > PlayerTwo.animations.frame && !PlayerTwo.dizzy){
                    //playerone wins
                    PlayerTwo.setDizzy();
                } else if (!PlayerOne.dizzy) {
                    //playertwo wins
                    PlayerOne.setDizzy();
                }
            } else {
                // else we need to seperate the players
                var toSeperate = 5 - xdif;

                if(normaliseAngle(PlayerOne.rotation_z) > normaliseAngle(PlayerTwo.rotation_z)){
                    //player one is clockwise to player 2
                    PlayerOne.worldPosition.x += toSeperate*2;
                    PlayerTwo.worldPosition.x -= toSeperate*2;
                } else {
                    //player 2 is clockwise to player 1
                    PlayerOne.worldPosition.x -= toSeperate*2;
                    PlayerTwo.worldPosition.x += toSeperate*2;
                }

            }

        }


    }

}
