extends Control
## Interactive layout test. The campaign scene and saves remain untouched.
const ROOM = preload("res://assets/restaurant_approved_8tables.png")
const CANVAS := Vector2(1672, 941)
const TABLES := [Vector2(651,273),Vector2(968,273),Vector2(654,427),Vector2(968,427),Vector2(642,585),Vector2(975,585),Vector2(644,785),Vector2(1011,785)]
var unlocked := 6
var selected := -1
var occupied := [false,false,false,false,false,false,false,false]
var message := "Tap a table to seat a party • Tables 7–8 unlock with expansion"
var message_time := 0.0

func _ready() -> void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 mouse_filter = Control.MOUSE_FILTER_STOP

func _process(delta: float) -> void:
 if message_time > 0.0:
  message_time -= delta
  if message_time <= 0.0:
   message = "Tap tables to seat or clear parties • Expansion controls at bottom"
   queue_redraw()

func _draw() -> void:
 var scale_factor: float = minf(size.x/CANVAS.x,size.y/CANVAS.y)
 var origin := (size-CANVAS*scale_factor)*0.5
 draw_set_transform(origin,0.0,Vector2.ONE*scale_factor)
 draw_texture_rect(ROOM,Rect2(Vector2.ZERO,CANVAS),false)
 for i in range(TABLES.size()):
  var center: Vector2 = TABLES[i]
  if i >= unlocked:
   continue
  if occupied[i]:
   draw_arc(center,86.0,0.0,TAU,48,Color("50f4a0"),6.0,true)
   draw_circle(center+Vector2(75,-49),18,Color("178348"))
   draw_string(ThemeDB.fallback_font,center+Vector2(69,-42),"✓",HORIZONTAL_ALIGNMENT_LEFT,-1,21,Color.WHITE)
  if selected == i:
   draw_arc(center,94.0,0.0,TAU,48,Color("fff3a4"),7.0,true)
 # The approved screenshot is a visual background, so UI controls are deliberately placed over it.
 draw_rect(Rect2(425,865,850,66),Color(0.14,0.08,0.04,0.92),true)
 draw_string(ThemeDB.fallback_font,Vector2(447,893),message,HORIZONTAL_ALIGNMENT_LEFT,815,20,Color.WHITE)
 draw_string(ThemeDB.fallback_font,Vector2(447,921),"VISUAL LAYOUT TEST • Active tables: %d / 8" % unlocked,HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("ffe7a8"))
 draw_rect(Rect2(1290,844,163,72),Color("278c48"),true)
 draw_rect(Rect2(1464,844,163,72),Color("8b4937"),true)
 draw_string(ThemeDB.fallback_font,Vector2(1304,888),"+ TABLE",HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color.WHITE)
 draw_string(ThemeDB.fallback_font,Vector2(1479,888),"- TABLE",HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color.WHITE)
 draw_set_transform(Vector2.ZERO)

func _gui_input(event: InputEvent) -> void:
 var pointer: Vector2
 if event is InputEventScreenTouch:
  if not event.pressed: return
  pointer=event.position
 elif event is InputEventMouseButton:
  if not event.pressed or event.button_index != MOUSE_BUTTON_LEFT: return
  pointer=event.position
 else:
  return
 var factor: float = minf(size.x/CANVAS.x,size.y/CANVAS.y)
 if factor <= 0.0: return
 var p: Vector2 = (pointer-(size-CANVAS*factor)*0.5)/factor
 if Rect2(1290,844,163,72).has_point(p):
  unlocked=mini(8,unlocked+1)
  _say("Expansion unlocked table %d" % unlocked)
 elif Rect2(1464,844,163,72).has_point(p):
  if unlocked > 6:
   occupied[unlocked-1]=false
   unlocked-=1
  _say("Preview set to %d active tables" % unlocked)
 else:
  for i in range(TABLES.size()):
   if p.distance_to(TABLES[i]) < 92.0:
    if i >= unlocked:
     _say("Table %d is locked until expansion" % (i+1))
    else:
     selected=i
     occupied[i]=not occupied[i]
     _say("Table %d: %s" % [i+1,"party seated" if occupied[i] else "party cleared"])
    break
 queue_redraw()

func _say(value: String) -> void:
 message=value
 message_time=4.0
