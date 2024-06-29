extends Node3D
class_name StopGoWorld


var stop_go_controller : StopGoController
var user : UserModel 

var evidence_files: Array = []
var stop_signals: Array = []


var timer : Timer
var last_connection = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$StopGoHud.connect("begin_session",on_session_begin)
	$StopGoHud.connect("key_press",on_trial_key_press)
	user = User_Data_Manager.load_resource()
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


func on_trial_key_press(direction: int):
	#if current_timer:
	#	current_timer = null
	timer.stop()
	print("a key was pressed, not set yet")
	stop_go_controller.trial_key_pressed(direction)
	$Player.change_player_state(1)
