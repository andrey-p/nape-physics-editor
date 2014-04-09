package iso;

/**
 * Directly lifted from Luca Deltodesco's sample for generating bodies out of bitmap data
 * https://github.com/deltaluca/www.napephys.com/blob/gh-pages/samples/BodyFromGraphic/BodyFromGraphic.hx
 */

class DisplayObjectIso implements IsoFunction {
    public var displayObject:DisplayObject;
    public var bounds:AABB;

    public function new(displayObject:DisplayObject) {
        this.displayObject = displayObject;
        this.bounds = AABB.fromRect(displayObject.getBounds(displayObject));
    }

    public function iso(x:Float, y:Float) {
        // Best we can really do with a generic DisplayObject
        // is to return a binary value {-1, 1} depending on
        // if the sample point is in or out side.

        return (displayObject.hitTestPoint(x, y, true) ? -1.0 : 1.0);
    }
}
