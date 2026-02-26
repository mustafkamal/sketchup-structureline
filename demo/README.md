This demo showcases the general features of this extension using the confined masonry structure. 

## Structure 

To create a structure, you can click the “Create Structure” button in the extension menu and pick any points you want. It will show the preview of the structure you will build. Double click to automatically create a 3D model representation of the structure.

*{GIF: activating structure tool, clicking points, double clicking}*

The resulting 3D model is a grouped structure containing multiple entities.  
All segment collisions are handled automatically.

*{GIF: clicking the structure group and showing entities}*

If a clicked point intersects an existing segment, the extension recalculates that segment automatically.

*{GIF: segment recalculation}*

Press **W** to activate **Node Break**, which prevents recalculation when intersecting existing segments.

*{GIF: node break}*

Every structure you’ve made can be reposition if you right-click and click the ‘Edit Structure’ option. This will enter the structure group and replace the structure 3D model with a set of lines. You can use the native Move tool to move these lines and the structure will follow. If you exit the group, the structure will be rebuilt.

*{GIF: structure edit}*

## Command keys 

Some structures have certain key commands that will determine its behaviour.
For example if you press **1** for a confined masonry structure, it will not create a column on your next click

{Gif of pressing ‘1’ and non-orthogonal}

If you press **2** it will not create a wall on your next click.

{Gif of pressing ‘2’}

## Components

In the background, the extension has determined the components (bricks, mortar, rebar) that make up this structure in real life. If the user wishes to see these components in SketchUp (for rendering purpose or any other reason), they can click the ‘Create Structure Detail’ in the extension menu and do as above. This will create a full detailed 3D model of all the components that made up the structure.

*{GIF: structure detail}*
