extends Node3D
class_name StopGoWorld


var stop_go_controller : StopGoController
var user : UserModel 

var evidence_files: Array = []
var stop_signals: Array = []


var timer : Timer
var last_connection = null

signal mini_game_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	$StopGoHud.connect("begin_session",on_session_begin)
	$StopGoHud.connect("key_press",on_trial_key_press)
	$StopGoHud.connect("exit_game", on_exit_game)
	user = User_Data_Manager.load_resource()
	
	
	
	#user.reset_stop_go_data()
	
	
	
	stop_go_controller = StopGoController.new(self,user)
	
	evidence_files = load_cues("res://Art/stop_go/go_evidence/")
	stop_signals = load_cues("res://Art/stop_go/stop_signals/")
	
	timer = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#load all go evidence options
func load_cues(folder_path):
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

#upon player beginning the session, allow movement and trigger controller
func on_session_begin():
	$Player.change_player_state(1)
	stop_go_controller.begin_session()
	
#updates the info presented to the user about the session
func update_visual_info():
	var score = stop_go_controller.get_current_score()
	var current_trial = stop_go_controller.get_current_trial_num()
	var best_RT = stop_go_controller.get_best_RT()
	var level = stop_go_controller.get_current_level()
	$StopGoHud.update_visual_info(score,current_trial,best_RT,level)
	
#create and run a timer to create walking intervals, reaction time timers, and view timers
func run_timer(timer_type: int, duration: float):
	if last_connection != null:
		timer.disconnect("timeout",last_connection)
	#if current_timer:
		#current_timer = null
	if timer.time_left > 0:
		timer.stop()
	var to_call: Callable
	match timer_type:
		0: #interval timer
			to_call = on_interval_timeout
		1: #go triral response timer
			to_call = on_go_rt_timeout
		2: #ssdtimer
			to_call = on_ssd_timeout
		3: #stop timer
			to_call = on_stop_timeout
		_:
			print("unable to create timer")
	last_connection = to_call
	timer.set_wait_time(duration)
	timer.timeout.connect(to_call)
	timer.start()
	#Utilities.start_timer(self,duration,to_call)
	
#when the trial's walking interval ends - begins actual trial
func on_interval_timeout():
	#current_timer = null
	print("interval timer ended")
	$Player.change_player_state(0)
	stop_go_controller.begin_visual_trial()

#when allotted time to respond runs out and trial will come to an end
func on_go_rt_timeout():
	if !stop_go_controller.get_if_pressed():
		#current_timer = null
		print("there wasnt a press - timer timeout " + str(stop_go_controller.model.current_trial))
		$Player.change_player_state(1)
		stop_go_controller.timeout_check_timer()
	
#when go cue ends and stop needs to begin
func on_ssd_timeout():
	if !stop_go_controller.get_if_pressed():
		stop_go_controller.begin_stop_half()

#when stop cue ends and trial will come to an end
func on_stop_timeout():
	if !stop_go_controller.get_if_pressed():
		$Player.change_player_state(1)
		stop_go_controller.timeout_check_timer()
	#trigger to say trial ended - would need to report out if they did well or not
	#if this times out, it would be successful - so tell controller the trial ended and was successful
	
# MyUtility.start_timer(self, 2.0, callable(self, "_on_timer_timeout"))

#calls for hud to display feedback text
func display_feedback(feedback: String):
	$StopGoHud.display_feedback_text(feedback)
	
#if becomes triggered by things in world it would take in that obj to save its texture
#side 0-stopcenter left 1 right 2
func begin_trial_view(side: int):
	var go_cue = evidence_files.pick_random()
	$StopGoHud.setup_trial(go_cue, side)
	
func begin_stop_visuals():
	var stop_signal = stop_signals.pick_random()
	$StopGoHud.setup_trial(stop_signal,0)

#clears visual trial from hud
func clear_trial():
	$StopGoHud.clear_trial()

func end_session():
	$Player.change_player_state(0)
	var report_load = load("res://Report/Report.tscn")
	var report = report_load.instantiate()
	report.position = Vector2(325,325)
	report.setup_report(1,stop_go_controller.get_performances(),stop_go_controller.get_scores(),stop_go_controller,stop_go_controller.get_graph_trial_types())
	$StopGoHud.add_child(report)

func on_trial_key_press(direction: int):
	#if current_timer:
	#	current_timer = null
	timer.stop()
	print("a key was pressed, not set yet")
	stop_go_controller.trial_key_pressed(direction)
	$Player.change_player_state(1)

func on_exit_game():
	#emit_signal("mini_game_finished")
	get_tree().change_scene_to_file("res://mini_game_demonstration/mini_game_demonstration.tscn")
