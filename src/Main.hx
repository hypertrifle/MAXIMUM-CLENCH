
import luxe.GameConfig;
import luxe.Input;
import luxe.States;


import phoenix.Texture;
import phoenix.BitmapFont;

import luxe.importers.texturepacker.TexturePackerData;
import luxe.importers.texturepacker.TexturePackerJSON;
import luxe.importers.texturepacker.TexturePackerSpriteAnimation;


import states.*;

class Main extends luxe.Game {

    public static var machine:States;
    public static var atlasTexture:Texture;
    public static var atlasData:Dynamic;
    public static var font:BitmapFont;

    override function config(config:GameConfig) {

        config.window.title = 'LD 38';
        config.window.width = 1280;
        config.window.height = 700;
        config.window.fullscreen = false;
       
        config.preload.textures.push({ id:'assets/textures_src/idle/idle_000.png' });
        config.preload.fonts.push({ id:'assets/font_bold_ld.fnt' });

        config.preload.textures.push({id:"assets/atlas.png"});
        config.preload.textures.push({id:"assets/players.png"});

        config.preload.textures.push({id:"assets/fist.png"});
        config.preload.textures.push({id:"assets/fist.png"});

        config.preload.jsons.push({id:"assets/playerAnimations.json"});
        config.preload.jsons.push({id:"assets/fistAnimations.json"});

        return config;

    } //config

    override function ready() {

        //set up any input bindings!
        Luxe.input.bind_key('fire', Key.space); // keyboard
        Luxe.input.bind_key('p1left', Key.left); 
        Luxe.input.bind_key('p1right', Key.right);
        Luxe.input.bind_key('p1jump', Key.up);
        Luxe.input.bind_key('p1fistleft', Key.key_q); 
        Luxe.input.bind_key('p1fistright', Key.key_w);

        // Luxe.input.bind_key('p1jump', Key.up);


        Luxe.input.bind_gamepad('p1fistleft', 9, 0);
        Luxe.input.bind_gamepad('p1fistright', 10, 0);
        Luxe.input.bind_gamepad('p1jump', 0, 0);

        




        //set constants

        //texture
        atlasTexture  = Luxe.resources.texture('assets/atlas.png');

        //load out atlas object
        // var atlasJson  = Luxe.resources.json('assets/playerAnimations.json').asset.json;
        // var atlasDataRaw:TexturePackerData = TexturePackerJSON.parse( atlasJson );
        // atlasData = TexturePackerSpriteAnimation.parse( atlasDataRaw, 'all' );

        // trace("atlas data", atlasData);

        //load out font
        font = Luxe.resources.font('assets/font_bold_ld.fnt');


        //set up our state machine.
        machine = new States({ name:'statemachine' });
        machine.add(new MenuState({ name:'menu', game:this }));
        machine.add(new PlayState({ name:'play', game:this }));
        //goto our tests state
        machine.set('play');


    } //ready

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(delta:Float) {

    } //update

} //Main
