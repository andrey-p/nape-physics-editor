nape-physics-editor
===================

Physics body editor for Nape and HaxeFlixel

*NOTE: this is very rough and broken and is currently just a proof of concept.*

Vague roadmap
-----

Tools to edit bodies need to be built first:

- Add polygon editing tools: draw polygon, add/remove vertices, flip, stuff like that.
- Add the ability to edit materials for each polygon (since each polygon is a separate shape)
- Add exporting to a JSON interchange format which contains not only the polygon information for each shape but also materials and the image added. My idea is to avoid custom file formats - so you can create your polygons based on an image, save the JSON file, load from the JSON file again and the workspace looks exactly the same.
- Create a Flixel library that loads the JSON file and creates the FlxNapeSprites.

At this point the tool should be able to create single bodies and reuse them in games. Now things can get more interesting:

- Add scenes - basically a collection of bodies with position and rotation.
- Add the ability to create joins between those bodies
- Add the ability to nest scenes within scenes.

After the second one of those three the tool should be able to create, for example, a complex ragdoll-type figure. After the third one, you've got yourself the beginnings of a decent level editor.
