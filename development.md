## TODO
- sprint feedback (camera)
- slide
- crouch slowdown (decide)

## BUGS 
- cant (not know how) make arcs with not 90 angle

## CHANGES - to consider
- do path limit all time - ensures in boundaries if moved, allows shrinking limit consistently

### RECORD LATER
- uncrouch under roof - inside it (not get stuck good at least)
- sprint while crouch without key down (toggle) - block


# TASKS
5) EXTRA WEAPON - AND PICKUP (from ground)
6) EXAMPLE MAP WITH PATH

### FUTURE DEV
- path: add current (and id) attrib - allow multiple
- zones: area3d with trigger - next level preload, allow custom effects inc changing / disabling path
- use getcurrentnode and each pathNode to run specific functions - use variable to function -> not work multiplayer without passing player to most path functions

### TO REMEMBER (warnings)
- dont have curve in 1 axis into curve in another - leave a straight like if on same axis
- gun anims affect useLocation - bad if use it inbetween shots, add separate node3d for anim?
