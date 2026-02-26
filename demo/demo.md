
This demo showcases the **confined masonry structure** and its available features.  
For technical details, see the *[confined masonry standard page]*.

---

## 🧱 Creating a Structure

1. Click the **Create Structure** button in the extension menu.
2. Pick any points — you'll see a live preview of the structure.
3. Double‑click to automatically generate a 3D model.

*{GIF: activating structure tool, clicking points, double clicking}*

The resulting 3D model is a grouped structure containing multiple entities.  
All segment collisions are handled automatically.

*{GIF: clicking the structure group and showing entities}*

---

## 🔄 Segment Recalculation

If a clicked point intersects an existing segment, the extension recalculates that segment automatically.

*{GIF: segment recalculation}*

Press **W** to activate **Node Break**, which prevents recalculation when intersecting existing segments.

*{GIF: node break}*

---

## ⚙️ Confined Masonry Controls

### Key Commands
- **1** → Do *not* create a column on that point  
  Useful for non‑orthogonal segments.  
  See *[confined masonry standard improvements]* for ideas.

  *{GIF: pressing 1 and non‑orthogonal example}*

- **2** → Do *not* create a wall for that segment  
  *{GIF: pressing 2}*

---

## ✏️ Editing a Structure

Right‑click the structure and choose **Edit Structure**.  
This replaces the 3D model with editable lines.  
Use the SketchUp Move tool to reposition segments.  
Exiting the group automatically rebuilds the structure.

*{GIF: structure edit}*

---

## 🧩 Structure Details

The extension internally determines the real‑world components (bricks, mortar, rebar).  
To generate these as 3D models:

1. Click **Create Structure Detail** in the menu  
2. Follow the same process as before  

This produces a full detailed model.

*{GIF: structure detail}*

See the *[structure improvements page]* for future enhancements.
