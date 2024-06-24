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
