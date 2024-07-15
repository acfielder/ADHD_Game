extends Node2D
class_name wcstView

var timer

var user : UserModel

var wcst_controller : wcstController

var base_cards : Array

var card_art : Array


# Called when the node enters the scene tree for the first time.
func _ready():

	#pins[i].pin_pressed.connect(_on_pin_pressed_test)
	
	$base_card_1.connect("card_pressed",_card_press_detected)
	$base_card_2.connect("card_pressed",_card_press_detected)
	$base_card_3.connect("card_pressed",_card_press_detected)
	$base_card_4.connect("card_pressed",_card_press_detected)
	
	base_cards = [$base_card_1,$base_card_2,$base_card_3,$base_card_4]

	user = User_Data_Manager.load_resource()
	
	user.reset_wcst_data()
	
	wcst_controller = wcstController.new(self,user)
	
	timer = $Timer
	
	card_art = load_cards("res://Art/WCST/cards")
	
	var to_call: Callable = response_timer_timeout
	timer.timeout.connect(to_call)


func update_visual_info():
	$session_info/Score.text = "Score: " + str(wcst_controller.get_score())
	$session_info/Phase.text = "Phase: " + str(wcst_controller.get_phase())
	$session_info2/Trial.text = "Trial: " + str(wcst_controller.get_trial())
	$session_info2/BestRT.text = "Best RT: " + str(wcst_controller.get_best_rt())
	
func update_rule():
	var rule_text = wcst_controller.get_current_rule_string()
	$RuleCard/Label.text = rule_text
	match rule_text:
		"Shape":
			$RuleCard/RuleIcon.texture = load("res://Art/WCST/shape_outline.png")
		"Color":
			$RuleCard/RuleIcon.texture = load("res://Art/WCST/color_splat.png")
		"Count":
			$RuleCard/RuleIcon.texture = load("res://Art/WCST/number_symbol.png")

#starting point for when a card press is detected
func _card_press_detected(card):
	wcst_controller.card_sort_attempt_detected(card.get_card_info_string())
		
	
#choose the card arts to be passed to the base cards to set their textures
func set_base_cards(phase: int):
	if phase == 1:
		var vals
		$base_card_1.choose_set_properties("one","circle","green")
		vals = $base_card_1.get_card_info_string()
		$base_card_1.give_card_texture(create_art_string(vals))
		
		$base_card_2.choose_set_properties("two","square","blue")
		vals = $base_card_2.get_card_info_string()
		$base_card_2.give_card_texture(create_art_string(vals))
		
		$base_card_3.choose_set_properties("three","triangle","purple")
		vals = $base_card_3.get_card_info_string()
		$base_card_3.give_card_texture(create_art_string(vals))
		
	if phase == 2:
		var vals
		$base_card_1.choose_set_properties("one","square","green")
		vals = $base_card_1.get_card_info_string()
		$base_card_1.give_card_texture(create_art_string(vals))
		
		$base_card_2.choose_set_properties("two","star","blue")
		vals = $base_card_2.get_card_info_string()
		$base_card_2.give_card_texture(create_art_string(vals))
		
		$base_card_3.choose_set_properties("three","circle","orange")
		vals = $base_card_3.get_card_info_string()
		$base_card_3.give_card_texture(create_art_string(vals))
		
		$base_card_4.choose_set_properties("four","triangle","purple")
		vals = $base_card_4.get_card_info_string()
		$base_card_4.give_card_texture(create_art_string(vals))
	
	#var vals
	#$base_card_1.choose_set_properties("one")
	#vals = $base_card_1.get_card_info_string()
	#$base_card_1.give_card_texture(create_art_string(vals))
	
	#$base_card_2.choose_set_properties("two")
	#vals = $base_card_2.get_card_info_string()
	#$base_card_2.give_card_texture(create_art_string(vals))
	
	#$base_card_3.choose_set_properties("three")
	#vals = $base_card_3.get_card_info_string()
	#$base_card_3.give_card_texture(create_art_string(vals))
	
	#if phase == 2:
	#	$base_card_4.show()
	#	$base_card_4.choose_set_properties("four")
	#	vals = $base_card_4.get_card_info_string()
	#	$base_card_4.give_card_texture(create_art_string(vals))

func create_art_string(info: Array):
	return "res://Art/WCST/cards/" + info[0] + "_" + info[1] + "_" + info[2] + ".png"
	
#set the texture of the trial card
func set_trial_card_texture(info: Array):
	var path = create_art_string(info)
	$trial_card.give_card_texture(path)
	return path
	
func give_phase_instruction(phase: int):
	$SpeechBubble.show()
	match phase:
		1: #phase one has three base cards
			$SpeechBubble/Feedback.text = "Phase 1 only has 3\npiles to sort to"
		2: #phase 2 has four base cards
			$SpeechBubble/Feedback.text = "Phase 2 has 4\n piles to sort to"
	await get_tree().create_timer(2).timeout
	$SpeechBubble.hide()
	
func prompt_phase_one():
	$PhaseBegin1.show()
	
func setup_phase_one():
	#this can be anything specific to the phase
	$base_card_4.hide()
	set_base_cards(1)
	await give_phase_instruction(1)
	
func end_phase_one():
	flip_cards_to_back()
	$PhaseBegin2.show()
	#display a feedback of sorts?
	
	#ideally cards would flip away at end of phase 1
func setup_phase_two():
	$base_card_4.show()
	flip_cards_to_back()
	await give_phase_instruction(2)
	set_base_cards(2)

#ends the second phase 
func end_phase_two():
	flip_cards_to_back()
	
#may not be much here as end phase two covers a lot
func end_session():
	flip_cards_to_back()
	var report_load = load("res://Report/Report.tscn")
	#breakpoint below
	#var report = report_load.instantiate()
	#report.position = Vector2(-250,0)
	#report.setup_report(2,sequence_controller.get_performances(),sequence_controller.get_scores())
	

	
func flip_cards_to_back():
	for card in base_cards:
		card.give_card_texture("res://Art/WCST/card_back.png")
	$trial_card.give_card_texture("res://Art/WCST/card_back.png")
	
func display_rule(rule: String):
	$RuleCard/Label.text = "Rule:\n" + rule
	
#shows speech bubble and gives feedback in it
func display_speech_feedback(feedback_type: int):
	$SpeechBubble.show()
	match feedback_type:
		0: #correctly sort card
			$SpeechBubble/Feedback.text = "Good work!"
		1: #incorrectly sort card
			$SpeechBubble/Feedback.text = "Ah, wrong pile.\nCheck the rule"
		2: #ran out of time to sort
			$SpeechBubble/Feedback.text = "Need to sort quicker!"
		3: #set aside, still needed it - incorrect
			$SpeechBubble/Feedback.text = "Wait! we needed that!"
		4: #correctly set aside
			$SpeechBubble/Feedback.text = "Good work, we don't\nneed that right now"	
	await get_tree().create_timer(1).timeout
	$SpeechBubble.hide()
	
	
func create_run_timer(duration: float):
	if timer.time_left > 0:
		timer.stop()
	#var to_call: Callable = response_timer_timeout
	timer.set_wait_time(duration)
	#timer.timeout.connect(to_call)
	timer.start()


#change to load the actual card files if needbe, change func name, call from ready
func load_cards(folder_path):
	var image_files = []
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if file_name.ends_with(".png"):
				image_files.append(folder_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return image_files
	
	
func response_timer_timeout():
	if !wcst_controller.get_if_pressed():
		wcst_controller.sort_timer_timeout()

#give game instructions
func give_instructions():
	$game_instructions.show()
	await get_tree().create_timer(4).timeout
	$game_instructions.hide()


func _on_begin_pressed():
	wcst_controller.begin_session()
	$SessionBegin.hide()
	

func _on_begin_phase_pressed(): #pphase 2
	wcst_controller.begin_phase_two()
	$PhaseBegin2.hide()
	
func _on_begin_phase_1_pressed(): #phase 1
	wcst_controller.begin_phase_one()
	$PhaseBegin1.hide()
