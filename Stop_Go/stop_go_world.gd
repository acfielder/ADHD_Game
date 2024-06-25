extends Node3D
class_name StopGoWorld


var stop_go_controller : StopGoController
var user : UserModel 

# Called when the node enters the scene tree for the first time.
func _ready():
	$StopGoHud.connect("begin_session",on_session_begin)
	user = User_Data_Manager.load_resource()
	stop_go_controller = StopGoController.new(self,user)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#upon player beginning the session, allow movement and trigger controller
func on_session_begin():
	$Player.change_player_state(1)
	#tell controller to begin
	
#create and run a timer to create walking intervals, reaction time timers, and view timers
func run_timer(timer_type: int, duration: float):
	var to_call: Callable
	match timer_type:
		0: #interval timer
			to_call = on_interval_timeout
		1: #go triral response timer
			to_call = on_go_rt_timeout
		2: #go to stop timer
			on_ssd_timeout
		3: #ssd timer
			on_stop_timeout
		_:
			print("unable to create timer")
	Utilities.start_timer(self,duration,to_call)
	
#when the trial's walking interval ends - begins actual trial
func on_interval_timeout():
	$Player.change_player_state(0)
	#trigger controller to say that the actual trial should begin now
	pass

#when allotted time to respond runs out and trial will come to an end
func on_go_rt_timeout():
	$Player.change_player_state(1)
	#trigger to say that trial ended - would need to report out if they did well or not
	pass
	
#when go cue ends and stop needs to begin
func on_ssd_timeout():
	#trigger controller to allow moving onto the stop being shown
	pass

#when stop cue ends and trial will come to an end
func on_stop_timeout():
	$Player.change_player_state(1)
	#trigger to say trial ended - would need to report out if they did well or not
	pass
	
# MyUtility.start_timer(self, 2.0, callable(self, "_on_timer_timeout"))

#if becomes triggered by things in world it would take in that obj to save its texture
#side 0-stopcenter left 1 right 2
func begin_trial_view(side: int):
	#get a random go cue texture
	#tell hud to show the texture on a side
	pass

#clears visual trial from hud
func clear_trial():
	#call hud clear trial
	pass
