
import luxe.GameConfig;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;

import luxe.Screen.WindowEvent;

import phoenix.Texture;
import phoenix.BitmapFont;

import luxe.resource.Resource.AudioResource;


import states.*;

class Main extends luxe.Game {

    public static var machine:States;
    public static var atlasTexture:Texture;
    public static var atlasData:Dynamic;
    public static var font:BitmapFont;

    public var gameResolution:Vector;
    public var zoomRatio:Vector;
    public var zoom:Float;

    public var music:AudioResource;

    override function config(config:GameConfig) {

        config.window.title = 'LD 38';
        config.window.width = 1280;
        config.window.height = 700;
        config.window.fullscreen = false;
        config.window.resizable = false;

        gameResolution = new Vector(1280,700);
        zoomRatio = new Vector(0,0);
       
        config.preload.textures.push({ id:'assets/textures_src/idle/idle_000.png' });
        config.preload.fonts.push({ id:'assets/font_bold_ld.fnt' });

        config.preload.textures.push({id:"assets/atlas.png"});
        config.preload.textures.push({id:"assets/players.png"});
        config.preload.textures.push({id:"assets/player2.png"});
        config.preload.textures.push({id:"assets/bar.png"});
        config.preload.textures.push({id:"assets/hud.png"});
        config.preload.textures.push({id:"assets/star.png"});
        config.preload.textures.push({id:"assets/impact.png"});
        config.preload.textures.push({id:"assets/title.png"});

        config.preload.textures.push({id:"assets/fist.png"});
        config.preload.textures.push({id:"assets/pickup.png"});
        config.preload.textures.push({id:"assets/blood.png"});
        config.preload.textures.push({id:"assets/planet/planet_000.png"});


        config.preload.sounds.push({id:"assets/Sound/music.ogg",is_stream:false});

        config.preload.sounds.push({id:"assets/Sound/dash.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/jump.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/pickup1.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/pickup2.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/playerhit.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/punch.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/scoredown.wav",is_stream:false});
        config.preload.sounds.push({id:"assets/Sound/scoreup.wav",is_stream:false});

        config.preload.jsons.push({id:"assets/playerAnimations.json"});
        config.preload.jsons.push({id:"assets/fistAnimations.json"});

        return config;

    } //config

    override function ready() {

        //set up any input bindings!
        Luxe.input.bind_key('p1left', Key.left); 
        Luxe.input.bind_key('p1right', Key.right);
        Luxe.input.bind_key('p1jump', Key.up);
        Luxe.input.bind_key('p1dash', Key.down);
        Luxe.input.bind_key('p1fistleft', Key.leftbracket); 
        Luxe.input.bind_key('p1fistright', Key.rightbracket);
        // Luxe.input.bind_gamepad('p1fistleft', 9, 0);
        // Luxe.input.bind_gamepad('p1fistright', 10, 0);
        // Luxe.input.bind_gamepad('p1jump', 0, 0);
        // Luxe.input.bind_gamepad('p1dash', 1, 0);

        Luxe.input.bind_key('p2left', Key.key_a); 
        Luxe.input.bind_key('p2right', Key.key_d);
        Luxe.input.bind_key('p2jump', Key.key_w);
        Luxe.input.bind_key('p2dash', Key.key_s);
        Luxe.input.bind_key('p2fistleft', Key.key_c); 
        Luxe.input.bind_key('p2fistright', Key.key_v);
        // Luxe.input.bind_gamepad('p2fistleft', 9, 1);
        // Luxe.input.bind_gamepad('p2fistright', 10, 1);
        // Luxe.input.bind_gamepad('p2jump', 0, 1);
        // Luxe.input.bind_gamepad('p2dash', 1, 1);


        Luxe.renderer.clear(new Color().rgb(0x27022f));
        Luxe.renderer.clear_color = new Color().rgb(0x27022f);
        




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
        machine.set('menu');

        music = Luxe.resources.audio('assets/Sound/music.ogg');
        
        Luxe.audio.loop(music.source, 0.2);


    } //ready

    public static function playSound(ref:String){
        var snd = Luxe.resources.audio('assets/Sound/'+ref+'.wav');
        Luxe.audio.play(snd.source);

    }

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            if(machine.current_state.name == "menu"){
                Luxe.shutdown();
            } else {
                machine.set("menu");
            }
        }

        if(event.keycode == Key.space) {
            // machine.destroy();
            // machine = new States({ name:'statemachine' });
            // machine.add(new MenuState({ name:'menu', game:this }));
            // machine.add(new PlayState({ name:'play', game:this }));
            // //goto our tests state
            // machine.set('play');
        }

    } //onkeyup

    override function update(delta:Float) {

    } //update

override function onwindowsized( e:WindowEvent ):Void {

//     trace("resize", Luxe.screen);
  
//   zoomRatio.x = Math.floor(Luxe.screen.w / gameResolution.x);
//   zoomRatio.y = Math.floor(Luxe.screen.h / gameResolution.y);
  
//   //get the smallest zoom ratio between zoomRatio.x and zoomRatio.y, and limit it to be greater or equal  1
//   zoom = Math.floor(Math.max(0, Math.min(zoomRatio.x, zoomRatio.y)));

//   var width = gameResolution.x * zoom;
//   var height = gameResolution.y * zoom;
//   var x = (Luxe.screen.w / 2) - (width / 2);
//   var y = (Luxe.screen.h / 2) - (height / 2);

//   Luxe.camera.viewport.set(x, y, width, height);
  
}

} //Main
