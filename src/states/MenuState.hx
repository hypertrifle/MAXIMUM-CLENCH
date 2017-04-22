package states;

// import luxe.Vector;
import luxe.States;
import luxe.Color;
// import luxe.Input;

import mint.Canvas;
import mint.focus.Focus;
import mint.render.luxe.LuxeMintRender;
import mint.layout.margins.Margins;



class MenuState extends State {

  var canvas: Canvas;
  var focus:  Focus;


public function new(_config:Dynamic){
    super(_config);

}

override function init() {
        trace("Menu inited");
        

    } //init

override function onenter<T>( _data:T ) {
    trace("Menu ENTER");
    
    var layout = new Margins();
    
    var auto_canvas = new AutoCanvas(Luxe.camera.view, {
            name:'canvas',
            rendering: new LuxeMintRender(),
            options: { color:new Color(1,1,1,0.0) },
            scale: 1,
            x: 0, y:0, w: Luxe.screen.w/1, h: Luxe.screen.h/1
        });

        auto_canvas.auto_listen();
        canvas = auto_canvas;

    focus = new Focus(canvas);


    var play_button = new mint.Button({
      parent: canvas,
      name: 'play_button',
      x: Luxe.screen.mid.x - (320 / 2), y: 295, w: 320, h: 64,
      text: 'Play Game',
      text_size: 28,
      options: { },
      onclick: function(_, _) {
        Main.machine.set("play");
      }
    });

    layout.margin(play_button,null,top,fixed,10);

    var exit_button = new mint.Button({
      parent: canvas,
      name: 'exit_button',
      x: Luxe.screen.mid.x - (320 / 2), y: 0, w: 320, h: 64,
      text: 'Exit',
      text_size: 28,
      options: { },
      onclick: function(_, _) {
        Luxe.core.shutdown();
      }
    });

    layout.margin(exit_button,play_button,top,fixed,64+32);
    


    } //onenter

    override function onleave<T>( _data:T ) {
        trace("Menu LEAVE");
         canvas.destroy();
   
    } //onleave

    override function update(elapsed:Float) {
        // focus.
    }

}
