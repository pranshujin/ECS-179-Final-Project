# Wave Function Collapse Algorithm Summary

The Wave Function Collapse algorithm - originally by Maxim Gumin on GitHub - is a procedural generation method used to create maps, pixel art, and tile patterns that look similar to an example input. Even though the name comes from quantum mechanics, the actual idea is pretty straightforward once you break it down.

The algorithm works by treating every cell in a grid as undecided at the start. Each cell begins with a list of all possible tiles it could become. The algorithm then slowly reduces these possibilities by applying rules about which tiles can be next to which. These rules usually come from analyzing a sample image or tileset.

In practice, there are two main ways people use the WFC algorithm. One version learns patterns by scanning an example image and figuring out which tiles tend to appear next to each other. The other version, which is more common in small game projects, skips the image analysis part and simply uses a set of rules defined by the developer. 


The key parts of the algorithm are -

### **1. Superposition**

Every cell starts with all tile options available. Nothing is set in stone yet.

### **2. Constraints or Adjacency Rules**

The WFC algorithm uses rules that say which tiles are allowed to touch. For example, water tiles might only be allowed next to other water or sand ones, while walls must be above floors. These rules keep the final output looking correct.

### **3. Entropy and Choosing a Cell**
Entropy in WFC basically means - how many choices are left for this cell? Cells with fewer choices have lower entropy. The algorithm always chooses the lowest entropy cell next because it is the most constrained and least likely to cause conflicts.

### **4. Collapse Step**
When a cell is chosen, the algorithm randomly picks one tile from that cell’s remaining possibilities. Now that tile is locked in for that position.

### **5. Propagation**
Once a tile is fixed, its neighbors may no longer be allowed to keep some of their options. WFC goes to each neighbor and removes any tiles that would break the adjacency rules. If a neighbor changes, its neighbors must be updated as well; this spreads outward like a chain reaction.

### **6. Success or Failure**
If every cell eventually collapses to exactly one valid tile, then the algorithm succeeds. If any cell ends up with zero valid tiles, then the algorithm has hit a contradiction and usually restarts.

---

## **Why the WFC Algorithm Is Useful**
* It creates an output that looks structured even though it’s generated randomly.
* It only needs a small sample image to learn patterns.
* It works well for tile based games, pixel art, and level generation.

For this project, I am using the second version of the WFC algorithm where I manually define tile adjacency rules rather than generating them from an image. The algorithm will generate a 10 x 10 map in Godot and allow the user to create new maps through a UI button.

