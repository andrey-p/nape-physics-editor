package editor;

import flixel.group.FlxGroup;
import flixel.FlxSprite;

import nape.shape.Shape;
import nape.shape.Polygon;
import nape.geom.Vec2;

class DraggableVertices extends FlxGroup {

    public var dragging:Bool;

    private var shape:Polygon;
    private var squareSize:Int = 4;

    function new():Void {
        super();
    }

    public function deselect():Void {
        for (v in members) {
            v.destroy();
        }

        clear();

        shape = null;
    }

    public function selectShape(s:Shape):Void {
        deselect();

        // I'm sorta assuming everything is a polygon
        // this is clearly a bad idea and needs to be rectified
        // ...
        // at some point in the future
        shape = s.castPolygon;

        shape.worldVerts.foreach(function (v:Vec2) {
            var sprite:FlxSprite = new FlxSprite(v.x - squareSize / 2, v.y - squareSize / 2);
            sprite.makeGraphic(squareSize, squareSize, 0x99ffffff);
            add(sprite);
        });
    }
}
