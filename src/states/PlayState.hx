package states;

import entities.Player;

import luxe.States;
import luxe.Vector;
import luxe.Color;
import luxe.Rectangle;
import phoenix.BitmapFont;
import phoenix.geometry.Geometry;

import luxe.tween.Actuate;
import luxe.tween.easing.*;

// import luxe.Input;

import phoenix.Texture.FilterType;


class PlayState extends State {

    public var PlayerOne:Player;
    public var PlayerTwo:Player;
    public var ready:Bool = false;
    public var world:Geometry;

public function new(_config:Dynamic){
    super(_config);


}

override function init() {
        trace("Play inited");

    } //init



    override function onenter<T>( _data:T ) {
        trace("Play ENTER");

        Luxe.events.listen("fist.punch",fistSmash);

        //build our planet?

        // var world = Luxe.

        Contants.worldSize = Luxe.screen.height/3.5;
        Contants.worldCirc = 2*Math.PI*Contants.worldSize;
        trace("world radius:"+ Contants.worldSize);

        world = Luxe.draw.circle(
            {
                x : Luxe.screen.w/2,
                y : Luxe.screen.h/2,
                r:Contants.worldSize,
                color: new Color(172/256,172/256,172/256)
                

        });

        PlayerOne = new Player({playerNumber:1});
        PlayerTwo = new Player({playerNumber:2});
       

    
        

        //now that we have some fonts, lets write something
        var text = Luxe.draw.text({
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

        //  var destination = new Vector(Math.cos((data.angle/57.2958)-90)*100, Math.sin((data.angle/57.2958)-90)*100);
        // Actuate.tween(Luxe.camera.pos,0.4,{x:Luxe.camera.pos.x+ destination.x,y:Luxe.camera.pos.y+ destination.y},true).onComplete(returnCamera);
    }

    override function onleave<T>( _data:T ) {
        trace("Play LEAVE");
   
    } //onleave

    public function returnCamera(){
        Actuate.tween(Luxe.camera.pos,0.2,{x:0,y:0},true).ease(Bounce.easeInOut);
    }


    override function update(dt:Float){
        if(ready){
            // spr.rotation_z += 50 * dt;
        }
    }

}
