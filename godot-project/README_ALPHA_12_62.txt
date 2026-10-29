Pizza Panic Alpha 12.62 — HUD Lilita One binding + Initial mapper entry

The HUD countdown, stars, and visitors (also level and coins) explicitly use
res://assets/fonts/LilitaOne-Regular.ttf when available.

IMPORTANT: The font is not bundled. Download Lilita One Regular yourself
from https://fonts.google.com/specimen/Lilita+One and place the TTF as:
assets/fonts/LilitaOne-Regular.ttf

If this file is missing, Godot uses its fallback font.

The Graphics Mapper now includes a separate Initial background picker entry.
Main Menu still has its existing image path and the opening navigation logic
was NOT yet modified; these are separate steps to implement after confirming
the desired static screen assets and buttons.

Your gameplay state and table layout files are otherwise unchanged.
