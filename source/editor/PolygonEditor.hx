package editor;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

import nape.geom.GeomPoly;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.geom.Mat23;

class PolygonEditor extends FlxTypedGroup<DraggableVertex> {

    public var dragging:Bool;

    private var currentPoly:GeomPoly;
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

        currentPoly = null;
    }

    public function selectPoly(poly:GeomPoly):Void {
        deselect();

        // I'm sorta assuming everything is a polygon
        // this is clearly a bad idea and needs to be rectified
        // ...
        // at some point in the future
        currentPoly = poly;

        for (v in currentPoly) {
            var sprite:DraggableVertex = new DraggableVertex(v.x, v.y, v);
            add(sprite);
        }
    }

    private function isPolygonValid():Bool {
        return currentPoly.isSimple() && currentPoly.isConvex();
    }

    public override function update():Void {
        if (currentPoly != null && FlxG.mouse.justPressed) {
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
            if (currentVertex == null && currentPoly.contains(Vec2.weak(pos.x, pos.y))) {
                lastX = pos.x;
                lastY = pos.y;
                dragging = true;
            }
        } else if (currentPoly != null && dragging && FlxG.mouse.pressed) {
            var pos:FlxPoint = FlxG.mouse.getScreenPosition();
            var matrix:Mat23 = Mat23.translation(pos.x - lastX, pos.y - lastY);
            currentPoly.transform(matrix);

            lastX = pos.x;
            lastY = pos.y;
        } else if (FlxG.mouse.justReleased) {
            if (currentVertex != null) {
                currentVertex.commitDrag();

                if (!isPolygonValid()) {
                    currentVertex.revertDrag();
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
