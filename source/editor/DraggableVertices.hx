package editor;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;

import nape.shape.Shape;
import nape.shape.Polygon;
import nape.geom.Vec2;

class DraggableVertices extends FlxTypedGroup<DraggableVertex> {

    public var dragging:Bool;

    private var shape:Polygon;

    function new():Void {
        dragging = false;
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

        var offsetX = shape.body.position.x;
        var offsetY = shape.body.position.y;

        shape.localVerts.foreach(function (v:Vec2) {
            var sprite:DraggableVertex = new DraggableVertex(v.x + offsetX, v.y + offsetY, v);
            add(sprite);
        });
    }

    public override function update():Void {
        super.update();

        if (FlxG.mouse.justPressed) {
            for (v in members) {
                if (v.overlapsPoint(FlxG.mouse.getScreenPosition())) {
                    dragging = true;
                    v.startDrag();
                    break;
                }
            }
        } else if (dragging && FlxG.mouse.justReleased) {
            dragging = false;
        }
    }
}
