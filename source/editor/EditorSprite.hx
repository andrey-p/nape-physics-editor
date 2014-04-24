package editor;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;

import iso.BitmapDataIso;
import iso.IsoBody;

import nape.shape.Shape;
import nape.shape.ShapeType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.geom.MarchingSquares;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;

typedef ExportPoint = {
    x:Float,
    y:Float
};

typedef ExportShape = {
    type:String, // "circle" or "polygon"
    position:ExportPoint,
    ?radius:Float,
    ?vertices:Array<ExportPoint>
};

typedef ExportBody = {
    name:String,
    shapes:Array<ExportShape>
};

class EditorSprite extends FlxNapeSprite {
    function new(?x:Float, ?y:Float) {
        super(x, y, null, false);
    }

    public function generatePolys():GeomPolyList {
        var iso:BitmapDataIso = new BitmapDataIso(pixels);
        var granularity:Vec2 = Vec2.weak(8, 8);
        var quality:Int = 2;
        var simplification:Float = 2;

        var originalPolys = MarchingSquares.run(iso.iso, iso.bounds, Vec2.weak(8, 8), 2);
        var polys:GeomPolyList = new GeomPolyList();

        for (p in originalPolys) {
            p.simplify(simplification).convexDecomposition(true, polys);
        }
        
        return polys;
    }

    public function export():ExportBody {
        var export:ExportBody = {
            name: "foo",
            shapes: new Array<ExportShape>()
        };

        body.shapes.foreach(function (shape) {
            if (shape.isCircle()) {
                var circle:Circle = shape.castCircle;

                export.shapes.push({
                    type: "circle",
                    position: {
                        x: circle.localCOM.x,
                        y: circle.localCOM.y
                    },
                    radius: circle.radius
                });
            } else if (shape.isPolygon()) {
                var poly:Polygon = shape.castPolygon;
                var exportPoly:ExportShape = {
                    type: "polygon",
                    position: {
                        x: poly.localCOM.x,
                        y: poly.localCOM.y
                    },
                    vertices: new Array<ExportPoint>()
                };

                poly.localVerts.foreach(function (vert) {
                    exportPoly.vertices.push({
                        x: vert.x,
                        y: vert.y
                    });
                });

                export.shapes.push(exportPoly);
            }
        });

        return export;
    }
}
