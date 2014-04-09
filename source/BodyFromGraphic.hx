package;

/**
 *
 * Sample: Body From Graphic
 * Author: Luca Deltodesco
 *
 * Using MarchingSquares to generate Nape bodies
 * from both a BitmapData and a standard DisplayObject.
 *
 */

import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

// Template class is used so that this sample may
// be as concise as possible in showing Nape features without
// any of the boilerplate that makes up the sample interfaces.
import Template;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageQuality;

@:bitmap("cog.png") class Cog extends BitmapData {}
class BodyFromGraphic extends Template {
    function new() {
        super({
            gravity : Vec2.get(0, 600),
            noReset : true
        });
    }

    override function init() {
        var w = stage.stageWidth;
        var h = stage.stageHeight;

        stage.quality = StageQuality.LOW;

        createBorder();

        // Create some Bodies generated from a Bitmap (the cogs)
        // With a body generated from a DisplayObject inside
        // (the intersected circles).
        var cogIso = new BitmapDataIso(new Cog(0,0), 0x80);
        var cogBody = IsoBody.run(cogIso, cogIso.bounds);

        function circles() {
            var displayObject = new Sprite();
            displayObject.graphics.lineStyle(0,0,0);
            displayObject.graphics.beginFill(0, 1);
            displayObject.graphics.drawCircle(-10, 17.32, 30);
            displayObject.graphics.drawCircle(-10, -17.32, 30);
            displayObject.graphics.drawCircle(20, 0, 30);
            displayObject.graphics.endFill();
            return displayObject;
        }
        var objIso = new DisplayObjectIso(circles());
        // Flash requires an object to be on stage for hitTestPoint used
        // by the iso-function to work correctly. SIGH.
        addChild(objIso.displayObject);
        var objBody = IsoBody.run(objIso, objIso.bounds);
        removeChild(objIso.displayObject);

        for (i in 0...4) {
        for (j in 0...2) {
            var body = cogBody.copy();
            body.position.setxy(100 + 200*i, 400 - 200*j);
            body.space = space;

            var graphic:DisplayObject = cogIso.graphic();
            graphic.alpha = 0.6;
            addChild(graphic);
            body.userData.graphic = graphic;

            body = objBody.copy();
            body.position.setxy(100 + 200*i, 400 - 200*j);
            body.space = space;

            graphic = circles();
            graphic.alpha = 0.6;
            addChild(graphic);
            body.userData.graphic = graphic;
        }}
    }

    override function postUpdate(deltaTime:Float) {
        // Update positions for Flash graphics.
        for (body in space.liveBodies) {
            var graphic:Null<DisplayObject> = body.userData.graphic;
            if (graphic == null) continue;

            var graphicOffset:Vec2 = body.userData.graphicOffset;
            var position:Vec2 = body.localPointToWorld(graphicOffset);
            graphic.x = position.x;
            graphic.y = position.y;
            graphic.rotation = (body.rotation * 180/Math.PI) % 360;
            position.dispose();
        }
    }

    static function main() {
        flash.Lib.current.addChild(new BodyFromGraphic());
    }
}

