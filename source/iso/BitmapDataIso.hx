package iso;

import nape.geom.IsoFunction;
import nape.geom.AABB;
import flash.display.Bitmap;
import flash.display.BitmapData;

/**
 * Directly lifted from Luca Deltodesco's sample for generating bodies out of bitmap data
 * https://github.com/deltaluca/www.napephys.com/blob/gh-pages/samples/BodyFromGraphic/BodyFromGraphic.hx
 */

class BitmapDataIso {
    public var bitmap:BitmapData;
    public var alphaThreshold:Float;
    public var bounds:AABB;

    public function new(bitmap:BitmapData, alphaThreshold:Float = 0x80) {
        this.bitmap = bitmap;
        this.alphaThreshold = alphaThreshold;
        bounds = new AABB(0, 0, bitmap.width, bitmap.height);
    }

    public function graphic() {
        return new Bitmap(bitmap);
    }

    public function iso(x:Float, y:Float) {
        // Take 4 nearest pixels to interpolate linearly.
        // This gives us a smooth iso-function for which
        // we can use a lower quality in MarchingSquares for
        // the root finding.

        var ix = Std.int(x); var iy = Std.int(y);
        //clamp in-case of numerical inaccuracies
        if(ix<0) ix = 0; if(iy<0) iy = 0;
        if(ix>=bitmap.width)  ix = bitmap.width-1;
        if(iy>=bitmap.height) iy = bitmap.height-1;

        // iso-function values at each pixel centre.
        var a11 = alphaThreshold - (bitmap.getPixel32(ix,iy)>>>24);
        var a12 = alphaThreshold - (bitmap.getPixel32(ix+1,iy)>>>24);
        var a21 = alphaThreshold - (bitmap.getPixel32(ix,iy+1)>>>24);
        var a22 = alphaThreshold - (bitmap.getPixel32(ix+1,iy+1)>>>24);

        // Bilinear interpolation for sample point (x,y)
        var fx = x - ix; var fy = y - iy;
        return a11*(1-fx)*(1-fy) + a12*fx*(1-fy) + a21*(1-fx)*fy + a22*fx*fy;
    }
}
