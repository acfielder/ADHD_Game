extends Node2D


var Sequence = load("res://SequenceGame/Sequence.tscn")

signal mini_game_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	var user = User_Data_Manager.load_resource()#"user://user_save/User_Model.tres"
	var new_sequence = Sequence.instantiate()
	new_sequence.user = user
	#make controller here and also pass to Sequence like user
	
	
	#user.reset_user_data()
	
	
	print(str(user.completed_of_level) + str("c_o_l"))
	print(str("start user level ") + str(user.current_level))
	#print(user.sequence_session_performance_level)
	#print(user.sequence_session_count)
	#getting name - this would also be moved to the larger area
	#using text input - or buttons

	#get_tree().get_root().get_node("InvestigationBoardGame/Board")
	add_child(new_sequence)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	


func _on_exit_game_pressed():
	emit_signal("mini_game_finished")
