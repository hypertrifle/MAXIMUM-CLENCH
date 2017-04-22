package states;

// import luxe.Vector;
import luxe.States;
// import luxe.Input;


class PlayState extends State {


public function new(_config:Dynamic){
    super(_config);


}

override function init() {
        trace("Play inited");

    } //init

    override function onenter<T>( _data:T ) {
        trace("Play ENTER");

    } //onenter

    override function onleave<T>( _data:T ) {
        trace("Play LEAVE");
   
    } //onleave


    override function update(dt:Float){
        
    }

}
