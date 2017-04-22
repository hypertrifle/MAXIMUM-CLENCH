package states;

import entities.Player;

import luxe.States;
import luxe.Color;
import luxe.Rectangle;
import phoenix.BitmapFont;
import phoenix.geometry.Geometry;

// import luxe.Input;

import phoenix.Texture.FilterType;


class PlayState extends State {

    public var PlayerOne:Player;
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

        world = Luxe.draw.circle(
            {
                x : Luxe.screen.w/2,
                y : Luxe.screen.h/2,
                r:Contants.worldSize

        });

        PlayerOne = new Player({playerNumber:1});
       

    
        

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
    }

    override function onleave<T>( _data:T ) {
        trace("Play LEAVE");
   
    } //onleave


    override function update(dt:Float){
        if(ready){
            // spr.rotation_z += 50 * dt;
        }
    }

}
