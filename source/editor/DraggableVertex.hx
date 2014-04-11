package editor;

import flixel.FlxSprite;
import flixel.FlxG;

import nape.geom.Vec2;

class DraggableVertex extends FlxSprite {
    private var napeVertex:Vec2;
    private var predragX:Float;
    private var predragY:Float;
    private var dragging:Bool;

    private static var SIZE:Int = 6;


    function new(x:Float, y:Float, v:Vec2):Void {
        napeVertex = v;
        dragging = false;
        super(x - SIZE / 2, y - SIZE / 2);

        makeGraphic(SIZE, SIZE, 0x99ffffff);
    }

    public function startDrag():Void {
        dragging = true;
        predragX = x;
        predragY = y;
    }

    public function commitDrag():Void {
        napeVertex.x += x - predragX;
        napeVertex.y += y - predragY;
        dragging = false;
    }

    public function rejectDrag():Void {
        x = predragX;
        y = predragY;
        dragging = false;
    }

    public override function update():Void {
        super.update();

        if (dragging) {
            x = FlxG.mouse.screenX;
            y = FlxG.mouse.screenY;
        }
    }

    public override function destroy():Void {
        napeVertex = null;
        super.destroy();
    }
}
