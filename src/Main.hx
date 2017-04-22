
import luxe.GameConfig;
import luxe.Input;
import luxe.States;


import states.*;

class Main extends luxe.Game {

    public static var machine:States;

    override function config(config:GameConfig) {

        config.window.title = 'LD 38';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

        return config;

    } //config

    override function ready() {

        //set up any input bindings!
        Luxe.input.bind_key('fire', Key.space); // keyboard
        Luxe.input.bind_gamepad('fire',1,0);


        //set up our state machine.
        machine = new States({ name:'statemachine' });
        machine.add(new MenuState({ name:'menu', game:this }));
        machine.add(new PlayState({ name:'play', game:this }));
        //goto our tests state
        machine.set('menu');


    } //ready

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(delta:Float) {

    } //update

} //Main
