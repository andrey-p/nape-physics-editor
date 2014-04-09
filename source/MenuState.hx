package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flash.display.BitmapData;

#if sys
import systools.Dialogs;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
#end

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
    private var text:FlxText;
    private var btn:FlxButton;
    private var sprite:FlxSprite;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        text = new FlxText(10, 10, FlxG.width - 10, "Click to load image");
        btn = new FlxButton(10, 30, "Load", onClick);
        sprite = new FlxSprite();

        sprite.x = 100;
        sprite.y = 100;

        add(text);
        add(btn);
        add(sprite);
        
		super.create();
	}

    private function onClick():Void {
#if sys
        var filters:FILEFILTERS = { count: 2, descriptions: ["PNG files", "JPEG files"], extensions: ["*.png", "*.jpg;*.jpeg"]};
        var imgs:Array<String> = Dialogs.openFile("open file", "please open file", filters);

        if (imgs != null && imgs.length > 0) {
            text.text = "path to img: " + imgs[0];

            var bmpData:BitmapData = BitmapData.load(imgs[0]);

            sprite.pixels = bmpData;
        }

        
#end
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
	}	
}
