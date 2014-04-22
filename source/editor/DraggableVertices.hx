package editor;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;

import nape.geom.GeomPoly;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.geom.Vec2;

class DraggableVertices extends FlxTypedGroup<DraggableVertex> {

    public var dragging:Bool;

    private var shape:Polygon;
    private var currentVertex:DraggableVertex;

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
        if (FlxG.mouse.justPressed) {
            for (v in members) {
                if (v.overlapsPoint(FlxG.mouse.getScreenPosition())) {
                    dragging = true;
                    currentVertex = v;
                    v.startDrag();
                    break;
                }
            }
        } else if (dragging && FlxG.mouse.justReleased) {
            if (isPolygonValid()) {
                currentVertex.commitDrag();
            } else {
                currentVertex.rejectDrag();
            }

            dragging = false;
        }

        super.update();

    }
}
