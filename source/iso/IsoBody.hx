package iso;

import nape.geom.IsoFunction;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.geom.MarchingSquares;
import nape.phys.Body;
import nape.shape.Polygon;

/**
 * Directly lifted from Luca Deltodesco's sample for generating bodies out of bitmap data
 * https://github.com/deltaluca/www.napephys.com/blob/gh-pages/samples/BodyFromGraphic/BodyFromGraphic.hx
 */

class IsoBody {
    public static function run(iso:IsoFunctionDef, bounds:AABB, granularity:Vec2=null, quality:Int=2, simplification:Float=1.5) {
        var body = new Body();

        if (granularity==null) granularity = Vec2.weak(8, 8);
        var polys = MarchingSquares.run(iso, bounds, granularity, quality);
        for (p in polys) {
            var qolys = p.simplify(simplification).convexDecomposition(true);
            for (q in qolys) {
                body.shapes.add(new Polygon(q));

                // Recycle GeomPoly and its vertices
                q.dispose();
            }
            // Recycle list nodes
            qolys.clear();

            // Recycle GeomPoly and its vertices
            p.dispose();
        }
        // Recycle list nodes
        polys.clear();

        // Align body with its centre of mass.
        // Keeping track of our required graphic offset.
        var pivot = body.localCOM.mul(-1);
        body.translateShapes(pivot);

        body.userData.graphicOffset = pivot;
        return body;
    }
}
