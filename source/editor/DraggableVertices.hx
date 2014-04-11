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

    private function isPolygonConvex():Bool {
            // check if it's a convex polygon, taken from SO:
            // http://stackoverflow.com/a/1881201/484538

            var v1:DraggableVertex;
            var v2:DraggableVertex;
            var v3:DraggableVertex;
            var dx1:Float;
            var dy1:Float;
            var dx2:Float;
            var dy2:Float;
            var zComponents:Array<Float> = new Array<Float>();
            for (i in 0...members.length) {
                v1 = members[i];
                v2 = members[i + 1];
                if (v2 == null) {
                    v2 = members[members.length - i];
                }
                v3 = members[i + 2];
                if (v3 == null) {
                    v3 = members[members.length - i + 1];
                }

                dx1 = v2.x - v1.x;
                dy1 = v2.y - v1.y;
                dx2 = v3.x - v2.x;
                dy2 = v3.y - v2.y;
                zComponents.push(dx1 * dy2 - dy1 * dx2);
            }

            // check if all the components are either negative or positive
            // ... there must be a more elegant way of doing this
            var positiveZComponents:Array<Float> = zComponents.filter(function (i):Bool {
                return i >= 0;
            });

            trace(positiveZComponents.length);
            trace(zComponents.length);

            return positiveZComponents.length == zComponents.length
                || positiveZComponents.length == 0;
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
            if (isPolygonConvex()) {
                currentVertex.commitDrag();
            } else {
                currentVertex.rejectDrag();
            }

            dragging = false;
        }

        super.update();

    }
}
