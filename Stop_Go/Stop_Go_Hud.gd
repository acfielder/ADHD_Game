extends Node2D
class_name StopGoHud

var left_default_arrow: Texture
var right_default_arrow: Texture
var left_green_arrow: Texture
var right_green_arrow: Texture
var red_x: Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	left_default_arrow = load("res://Art/stop_go/arrow_cues/left_gray_arrow.png")
	right_default_arrow = load("res://Art/stop_go/arrow_cues/right_gray_arrow.png")
	left_green_arrow = load("res://Art/stop_go/arrow_cues/left_green_arrow.png")
	right_green_arrow = load("res://Art/stop_go/arrow_cues/right_green_arrow.png")
	red_x = load("res://Art/stop_go/arrow_cues/red_x.png")
	
	
	#testing!!
	#highlight_direction(2)
	#await get_tree().create_timer(2).timeout 
	#reset_highlights()
	#highlight_direction(1)
	#await get_tree().create_timer(2).timeout 
	#highlight_direction(0)
	#await get_tree().create_timer(2).timeout
	#reset_highlights()
	
	#display_evidence("res://Art/filler_images/green_image.png",0)
	#await get_tree().create_timer(2).timeout
	#clear_trial()
	#display_evidence("res://Art/filler_images/green_image.png", 1)
	#await get_tree().create_timer(2).timeout
	#clear_trial()
	#display_evidence("res://Art/filler_images/green_image.png", 2)

	

#displays the evidence cue on the correct side
#0-center for stop, 1-left, 2-right
func display_evidence(png_path: String, direction: int):
	var texture = load(png_path) #may not need to load if already used in another scene
	$cue_pop_up.texture = texture
	#may need to reset size depending on art
	var viewport_size = get_viewport().size
	match direction:
		0:
			$cue_pop_up.position = viewport_size / 2
		1:
			$cue_pop_up.position = Vector2(viewport_size.x/4,viewport_size.y/2)
		2:
			$cue_pop_up.position = Vector2(viewport_size.x/4*3,viewport_size.y/2)
		_:
			print("unable to set evidence cue")
	
#clears cue sprite texture and calls for highlight clearing
func clear_trial():
	$cue_pop_up.texture = null
	$cue_pop_up.position = Vector2(0,0)
	reset_highlights()
	
#highlight clearer arrow cue
#0- stop, 1-left, 2-right
func highlight_direction(cue: int):
	match cue:
		0:
			$top_bar/left_arrow.texture = red_x
			$top_bar/right_arrow.texture = red_x
		1:
			$top_bar/left_arrow.texture = left_green_arrow
		2:
			$top_bar/right_arrow.texture = right_green_arrow
		_:
			print("failed to change arrow highlights")
	
#reset textures to defaults 
func reset_highlights():
	$top_bar/left_arrow.texture = left_default_arrow
	$top_bar/right_arrow.texture = right_default_arrow

