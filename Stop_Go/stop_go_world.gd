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


func on_session_begin():
	$Player.change_player_state(1)
	#tell controller to begin
	
	
func run_timer(timer_type: int, duration: float):
	var to_call: Callable
	match timer_type:
		0: #interval timer
			to_call = on_interval_timeout
		1: #go triral response timer
			to_call = on_go_rt_timeout
		2: #go to stop timer
			on_go_stop_timeout
		3: #ssd timer
			on_ssd_timeout
		_:
			print("unable to create timer")
	Utilities.start_timer(self,duration,to_call)
	
func on_interval_timeout():
	pass
	
func on_go_rt_timeout():
	pass
	
func on_go_stop_timeout():
	pass
	
func on_ssd_timeout():
	pass
	
	
	
	
	
	
# MyUtility.start_timer(self, 2.0, callable(self, "_on_timer_timeout"))
func _on_timer_timeout():
	print("Timer from MyUtility has timed out!")
