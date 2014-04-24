package editor;

import iso.BitmapDataIso;
import iso.IsoBody;

import flixel.FlxSprite;

import nape.geom.MarchingSquares;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;

class EditorSprite extends FlxSprite {
    function new(?x:Float, ?y:Float) {
        super(x, y);
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
}
