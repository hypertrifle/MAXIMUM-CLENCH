package states;

// import luxe.Vector;
import luxe.States;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;

import mint.Canvas;
import mint.focus.Focus;
import mint.render.luxe.LuxeMintRender;
import mint.layout.margins.Margins;

import phoenix.BitmapFont;

import phoenix.geometry.TextGeometry;
import luxe.Rectangle;
import phoenix.Texture.FilterType;


class MenuState extends State {

  var canvas: Canvas;
  var focus:  Focus;
  var title:Sprite;
  var text: TextGeometry;

    public var stars:Array<Sprite>;

    public var starDirection:Vector;



public function new(_config:Dynamic){
    super(_config);
    stars = new Array<Sprite>();
    starDirection = new Vector(50,100);

}

override function init() {
        trace("Menu inited");
        

    } //init

override function onenter<T>( _data:T ) {
    trace("Menu ENTER");

        var starTexture = Luxe.resources.texture("assets/star.png");

        for(i in 0...200){
            var scale = 1 / Luxe.utils.random.int(1,5);
            var star = new Sprite({
                pos:new Vector(Math.random()*Luxe.screen.width,Math.random()*Luxe.screen.height),
                scale: new Vector(scale,scale,1),
                texture:starTexture,
                depth:0
            });
            stars.push(star);
        }



    var introTexture = Luxe.resources.texture("assets/title.png");

    title = new Sprite({
            name:'title',
            pos : Luxe.screen.mid,
            texture:introTexture,
            scale: new Vector(1,1,1),
            size : new Vector(512,512),
            origin: new Vector(256,256,0),
            depth:1
    });
            Main.playSound("punch");



    var introAnim = new SpriteAnimation({ name:'anim' });
    title.events.listen("end.anim", function(e){
        Luxe.camera.shake(10);
    });
    title.add(introAnim);
    introAnim.add_from_json('
            {
                "play" : {
                    "frame_size":{ "x":"512", "y":"512" },
                    "frameset": ["1-16"],
                    "events" : [{"frame":1, "event":"end.anim"}],
                    "loop": "false",
                    "speed": "20"
                }
            }
        ');
    introAnim.animation = "play";
    introAnim.play();

        text = Luxe.draw.text({
            font: Main.font,
            text : "PRESS A TO GET FISTED",
            bounds : new Rectangle(0, 0, Luxe.screen.w * 0.99, Luxe.screen.h * 0.98),
            color : new Color().rgb(0xfcc53a),
            align : TextAlign.center,
            align_vertical : TextAlign.bottom,
            point_size : 50,
            depth: 100
        });
        
        text.texture.filter_mag = FilterType.nearest;




    
    // var layout = new Margins();
    
    // var auto_canvas = new AutoCanvas(Luxe.camera.view, {
    //         name:'canvas',
    //         rendering: new LuxeMintRender(),
    //         options: { color:new Color(1,1,1,0.0) },
    //         scale: 1,
    //         x: 0, y:0, w: Luxe.screen.w/1, h: Luxe.screen.h/1
    //     });

    //     auto_canvas.auto_listen();
    //     canvas = auto_canvas;

    // focus = new Focus(canvas);


    // var play_button = new mint.Button({
    //   parent: canvas,
    //   name: 'play_button',
    //   x: Luxe.screen.mid.x - (320 / 2), y: 295, w: 320, h: 64,
    //   text: 'Play Game',
    //   text_size: 28,
    //   options: { },
    //   onclick: function(_, _) {
    //     Main.machine.set("play");
    //   }
    // });

    // layout.margin(play_button,null,top,fixed,10);

    // var exit_button = new mint.Button({
    //   parent: canvas,
    //   name: 'exit_button',
    //   x: Luxe.screen.mid.x - (320 / 2), y: 0, w: 320, h: 64,
    //   text: 'Exit',
    //   text_size: 28,
    //   options: { },
    //   onclick: function(_, _) {
    //     Luxe.core.shutdown();
    //   }
    // });

    // layout.margin(exit_button,play_button,top,fixed,64+32);
    


    } //onenter

    override function onleave<T>( _data:T ) {
        trace("Menu LEAVE");
        //  canvas.destroy();
        title.destroy();
        for(i in 0...stars.length){
            stars[i].destroy();

        }
        stars = new Array<Sprite>();
        text.visible = false;
   
    } //onleave

    override function update(dt:Float) {
            //update start field
            for(i in 0...stars.length){
                var st = stars[i];
                st.pos.x += starDirection.x*st.scale.x*dt;
                st.pos.y += starDirection.y*st.scale.y*dt;

                if(st.pos.x < 0){ st.pos.x += Luxe.screen.width; }
                if(st.pos.x > Luxe.screen.width){ st.pos.x -= Luxe.screen.width; }

                if(st.pos.y < 0){ st.pos.y += Luxe.screen.height; }
                if(st.pos.y > Luxe.screen.height){ st.pos.y -= Luxe.screen.height; }

                }
            


        if(Luxe.input.inputreleased('p1jump') || Luxe.input.inputreleased('p2jump')){
            Main.machine.set("play");
        }
    }

}
