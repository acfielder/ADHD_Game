extends Node2D


var Sequence = load("res://SequenceGame/Sequence.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	var user = User_Data_Manager.load_resource()#"user://user_save/User_Model.tres"
	var new_sequence = Sequence.instantiate()
	new_sequence.user = user
	print(user.levels_data) 
	print(user.completed_of_level)
	#user.reset_user_data()
	print(user.levels_data)
	print(user.completed_of_level)
	print(user.sequence_session_performance_level)
	get_tree().get_root().get_node("InvestigationBoardGame/Board").add_child(new_sequence)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
