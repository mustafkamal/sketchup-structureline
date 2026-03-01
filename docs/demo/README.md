# Demo

This demo showcases the general features of this extension using the [confined masonry structure](https://github.com/mustafkamal/sketchup-structureline/tree/main/src/structure_line/contractor/structure/standard/confined_masonry) type. The gifs might take a while to load.

## Structure 

To create a structure, you can click the “Create Structure” button in the extension menu and pick any points you want. It will show the preview of the structure you will build. Double click to automatically create a 3D model representation of the structure.

![activating structure tool, clicking points, double clicking](videos/001.%20activating%20structure%20tool,%20clicking%20points,%20double%20clicking.gif)

The resulting 3D model is a SketchUp group containing multiple entities inside.

![clicking the structure group and showing entities](videos/002.%20clicking%20the%20structure%20group%20and%20showing%20entities.gif)

If a clicked point intersects an existing segment, the extension recalculates that segment automatically.

![segment recalculation](videos/003.%20segment%20recalculation.gif)

Press **W** to activate **Node Break**, which prevents recalculation when intersecting existing segments.

![node break](videos/004.%20node%20break.gif)

Every structure you’ve made can be reposition if you right-click a structure grop and click the ‘Edit Structure’ 
option. This will enter the structure group and replace the structure 3D model with a set of lines. You can use the native Move tool to move these lines and the structure will follow. If you exit the group, the structure will be rebuilt.

![structure edit](videos/005.%20structure%20edit.gif)

## Command keys 

Some structures have certain key commands that will determine its behaviour.
For example if you press **1** for a confined masonry structure, it will not create a column on your next click

![pressing ‘1’ and non-orthogonal](videos/006.%20pressing%20‘1’%20and%20non-orthogonal.gif)

If you press **2** it will not create a wall on your next click.

![pressing ‘2’ no walls](videos/007.pressing%20‘2’%20no%20walls.gif)

## Components

In the background, the extension has determined the components (bricks, mortar, rebar) that make up this structure in real life. If the user wishes to see these components in SketchUp (for rendering purpose or any other reason), they can click the ‘Create Structure Detail’ in the extension menu and do as above. This will create a full detailed 3D model of all the components that made up the structure.

![structure detail](videos/008.%20structure%20detail.gif)

Every component is in its own group. This will make it possible to extract the material BQ of the structure (this 
feature is still in development).

![component group](videos/009.%20component%20group.gif)
