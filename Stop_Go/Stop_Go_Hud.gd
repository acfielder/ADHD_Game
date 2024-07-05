extends Node2D
class_name StopGoHud

signal begin_session
signal key_press

var left_default_arrow: Texture
var right_default_arrow: Texture
var left_green_arrow: Texture
var right_green_arrow: Texture
var red_x: Texture

enum State {MOVE, TRIAL}
var hud_state = State.MOVE



# Called when the node enters the scene tree for the first time.
func _ready():
	left_default_arrow = load("res://Art/stop_go/arrow_cues/left_gray_arrow.png")
	right_default_arrow = load("res://Art/stop_go/arrow_cues/right_gray_arrow.png")
	left_green_arrow = load("res://Art/stop_go/arrow_cues/left_green_arrow.png")
	right_green_arrow = load("res://Art/stop_go/arrow_cues/right_green_arrow.png")
	red_x = load("res://Art/stop_go/arrow_cues/red_x.png")
	
	#$BeginSession.connect("pressed", self, "_on_Button_pressed")
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

#runs basic visuals of trial
func setup_trial(path: String, direction: int):
	hud_state = State.TRIAL
	display_directions(direction)
	display_evidence(path,direction)
	highlight_direction(direction)
	
	
func display_directions(feedback_type: int):
	$Feedback_box.show()
	if feedback_type == 1 || feedback_type == 2:
		$Feedback_box/feedback.text = "Collect the evidence!"
	elif feedback_type == 0:
		$Feedback_box/feedback.text = "Stop! Evidence is unsafe to collect!"
	
#updates session specific info in the hud
func update_visual_info(score: int, current_trial: int, best_rt: float, level: int):
	$top_bar/InfoBox_Score/ScoreNum.text = str(score)
	$top_bar/InfoBox_Trial/TrialNum.text = str(current_trial)
	$top_bar/InfoBox_RT/RTLabel.text = str(best_rt)
	$top_bar/InfoBox_Level/LevelNum.text = str(level)

#displays the evidence cue on the correct side
#0-center for stop, 1-left, 2-right
func display_evidence(png_path: String, direction: int):
	var texture = ResourceLoader.load(png_path) #may not need to load if already used in another scene, check again
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
	hud_state = State.MOVE
	$cue_pop_up.texture = null
	$cue_pop_up.position = Vector2(0,0)
	reset_highlights()
	$Feedback_box.hide()
	
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

func display_feedback_text(feedback: String):
	$Feedback_box.show()
	$Feedback_box/feedback.text = feedback
	await get_tree().create_timer(2.5).timeout
	$Feedback_box.hide()


#when the first start button is pressed and the session begins
func _on_begin_session_pressed():
	emit_signal("begin_session")
	$top_bar/ColorRect.hide()
	
func _input(event):
	if hud_state == State.TRIAL:
		if event is InputEventKey:
			if event.pressed:
				if event.keycode == KEY_S:
					emit_signal("key_press",1)
				elif event.keycode == KEY_D:
					emit_signal("key_press",2)
#signal needs connected to stop_go_world which will then call the controller's trial_key_pressed() which would take the response and see if its right based on the model
