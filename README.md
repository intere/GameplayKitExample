# GameplayKit Example

The purpose of this project is to demonstrate some basic GameplayKit concepts.  Though the project is a "universal" app, I've really only implement a MacOS app for it (so far).

## GameplayKit concepts
This app demonstrates the following GameplayKit concepts:
* Entities and Components
* State Machines
* Pathfinding

## The Game itself
The game is not complete, it's just a demo to demonstrate some basic capabilities of GameplayKit, not a full pacman clone
* There's currently no way to complete a level (yet)
* There's currently only a single level implemented
* No respawn limit (lives)
* The "ghosts" walk through each other and are not incredibly smart as it were
* There are issues with the collisions very soon after moving from flee to defeated (hint: They can kill you when they're in the defeated / respawn state)

`Yep, it's got bugs and unfinished business...`


## Game Controls
* Use the arrow keys on your keyboard to control our hero
