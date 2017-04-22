package states;

import entities.Player;

import luxe.Vector;
import luxe.States;
import luxe.Sprite;
import luxe.Color;
import luxe.Rectangle;
import phoenix.BitmapFont;
import phoenix.geometry.TextGeometry;

import luxe.components.sprite.SpriteAnimation;

import luxe.importers.texturepacker.TexturePackerData;
import luxe.importers.texturepacker.TexturePackerJSON;
import luxe.importers.texturepacker.TexturePackerSpriteAnimation;



// import luxe.Input;

import phoenix.Texture.FilterType;


class PlayState extends State {

    public var PlayerOne:Player;
    public var ready:Bool = false;

public function new(_config:Dynamic){
    super(_config);


}

override function init() {
        trace("Play inited");

    } //init



    override function onenter<T>( _data:T ) {
        trace("Play ENTER");

        //build our planet?

        // var world = Luxe.

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

    override function onleave<T>( _data:T ) {
        trace("Play LEAVE");
   
    } //onleave


    override function update(dt:Float){
        if(ready){
            // spr.rotation_z += 50 * dt;
        }
    }

}
