package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flash.display.BitmapData;

import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;

import nape.phys.Body;
import nape.shape.ShapeList;
import nape.geom.Vec2;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;

#if sys
import systools.Dialogs;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
#end

import editor.EditorSprite;
import editor.PolygonEditor;
import editor.EditorPolygons;
import haxe.Json;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxNapeState
{
    private var text:FlxText;
    private var loadBtn:FlxButton;
    private var makeBodyBtn:FlxButton;
    private var exportBtn:FlxButton;
    private var sprite:EditorSprite;
    private var polygonEditor:PolygonEditor;
    private var editorPolygons:EditorPolygons;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        napeDebugEnabled = true;
        FlxNapeState.debug.thickness = 2.0;

        text = new FlxText(10, 10, FlxG.width - 20, "Click to load image");
        loadBtn = new FlxButton(10, FlxG.height - 50, "Load", onLoadClick);
        makeBodyBtn = new FlxButton(100, FlxG.height - 50, "Make body", onMakeBodyClick);
        exportBtn = new FlxButton(200, FlxG.height - 50, "Export", onExport);
        sprite = new EditorSprite(100, 100);
        polygonEditor = new PolygonEditor();
        editorPolygons = new EditorPolygons();

        add(text);
        add(loadBtn);
        add(sprite);
        add(polygonEditor);
	}

    private function onLoadClick():Void {
#if sys
        var filters:FILEFILTERS = { count: 2, descriptions: ["PNG files", "JPEG files"], extensions: ["*.png", "*.jpg;*.jpeg"]};
        var imgs:Array<String> = Dialogs.openFile("open file", "please open file", filters);

        if (imgs != null && imgs.length > 0) {
            text.text = "path to img: " + imgs[0];

            var bmpData:BitmapData = BitmapData.load(imgs[0]);

            sprite.pixels = bmpData;

            add(makeBodyBtn);
            remove(exportBtn);
        }
#end
    }

    private function onMakeBodyClick():Void {
        var polys:GeomPolyList = sprite.generatePolys();
        editorPolygons.setPolys(polys);
        editorPolygons.setOffset(sprite.x, sprite.y);

        add(exportBtn);
    }

    private function onExport():Void {
        var exportedBody:ExportBody = sprite.export();
        var json:String = Json.stringify(exportedBody);
        
        text.text = "json is: \n\n" + json;
    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
        editorPolygons.update();

        if (FlxG.mouse.justReleased && !polygonEditor.dragging) {
            var point:Vec2 = Vec2.get(FlxG.mouse.screenX, FlxG.mouse.screenY);
            var poly:GeomPoly = editorPolygons.getPolyAtPoint(point);

            if (poly != null) {
                polygonEditor.selectPoly(poly);
            }
        }
	}	
}
