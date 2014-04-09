package;

import haxe.Json;

import nape.phys.Body;
import nape.shape.Shape;
import nape.shape.ShapeType;
import nape.shape.Circle;
import nape.shape.Polygon;

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

class Serializer {
    public function new():Void {}

    public function serialize(body:Body):String {
        var export:Dynamic = {};
        export.bodies = new Array<ExportBody>();

        export.materials = "default"; // these can be defined later on

        export.bodies.push({
            name: "foo",
            shapes: new Array<Dynamic>()
        });
        body.shapes.foreach(function (shape) {
            if (shape.isCircle()) {
                var circle:Circle = shape.castCircle;

                export.bodies[0].shapes.push({
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

                export.bodies[0].shapes.push(exportPoly);
            }
        });

        var exportJson:String = Json.stringify(export);

        return exportJson;
    }
}
