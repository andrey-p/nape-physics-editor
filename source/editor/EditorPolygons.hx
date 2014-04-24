package editor;

import flixel.FlxG;
import flixel.util.FlxPoint;

import flash.display.Shape;
import nape.geom.GeomPolyList;
import nape.geom.GeomPoly;
import nape.geom.Vec2;
import nape.geom.Mat23;

typedef ExportPoint = {
    x:Float,
    y:Float
};

typedef ExportPoly = {
    ?vertices:Array<ExportPoint>
};

typedef ExportBody = {
    name:String,
    polys:Array<ExportPoly>
};

class EditorPolygons {
    var polys:GeomPolyList;
    var display:Shape;

    public function new() {
        display = new Shape();
        FlxG.addChildBelowMouse(display);
    }

    public function setPolys(p:GeomPolyList) {
        polys = p;
    }

    public function setOffset(x:Float, y:Float) {
        var matrix = new Mat23();
        matrix.tx = x;
        matrix.ty = y;
        polys.foreach(function (poly) {
            poly.transform(matrix);
        });
    }

    public function update() {
        if (polys == null || polys.length == 0) {
            return;
        }

        display.graphics.clear();
        display.graphics.beginFill(0xff0000, 0.5);
        display.graphics.lineStyle(1, 0xff0000);
        polys.foreach(function (poly) {
            var v:Vec2 = poly.current();

            display.graphics.moveTo(v.x, v.y);

            for (i in 1...poly.size()) {
                v = poly.skipForward(1).current();
                display.graphics.lineTo(v.x, v.y);
            }
        });

        display.graphics.endFill();
    }

    public function getPolyAtPoint(vec:Vec2):GeomPoly {
        if (polys == null || polys.length == 0) {
            return null;
        }

        var polysAtPoint:GeomPolyList = polys.copy().filter(function (poly) {
            return poly.contains(vec);
        });

        if (polysAtPoint.length > 0) {
            return polysAtPoint.at(0);
        } else {
            return null;
        }
    }

    public function export():ExportBody {
        var export:ExportBody = {
            name: "foo",
            polys: new Array<ExportPoly>()
        };

        polys.foreach(function (poly) {
            var exportPoly:ExportPoly = {
                vertices: new Array<ExportPoint>()
            };

            for (vert in poly) {
                exportPoly.vertices.push({
                    x: vert.x,
                    y: vert.y
                });
            }

            export.polys.push(exportPoly);
        });

        return export;
    }
}
