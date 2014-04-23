package editor;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

import nape.geom.GeomPoly;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.geom.Vec2;

class PolygonEditor extends FlxTypedGroup<DraggableVertex> {

    public var dragging:Bool;

    private var shape:Polygon;
    private var currentVertex:DraggableVertex;
    private var lastX:Float;
    private var lastY:Float;

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

    private function isPolygonValid():Bool {
        // piggyback on nape's own polygon validation logic
        var vectors = new Array<Vec2>();

        for (v in members) {
            vectors.push(Vec2.weak(v.x, v.y));
        }

        var poly = GeomPoly.get(vectors);
        var isValid:Bool = poly.isSimple() && poly.isConvex();

        poly.dispose();

        return isValid;
    }

    public override function update():Void {
        if (shape != null && FlxG.mouse.justPressed) {
            var pos:FlxPoint = FlxG.mouse.getScreenPosition();
            // if a point was pressed, set that to drag
            for (v in members) {
                if (v.overlapsPoint(pos)) {
                    currentVertex = v;
                    v.startDrag();
                    break;
                }
            }

            // otherwise, if the shape was clicked, start to drag
            if (currentVertex == null && shape.contains(Vec2.weak(pos.x, pos.y))) {
                lastX = pos.x;
                lastY = pos.y;
                dragging = true;
            }
        } else if (shape != null && dragging && FlxG.mouse.pressed) {
            var pos:FlxPoint = FlxG.mouse.getScreenPosition();
            shape.localCOM.x += pos.x - lastX;
            shape.localCOM.y += pos.y - lastY;
            lastX = pos.x;
            lastY = pos.y;
        } else if (FlxG.mouse.justReleased) {
            if (currentVertex != null) {
                if (isPolygonValid()) {
                    currentVertex.commitDrag();
                } else {
                    currentVertex.rejectDrag();
                }

                currentVertex = null;
            }

            if (dragging) {
                dragging = false;
            }
        }

        super.update();

    }
}
