extends Resource
class_name UserModel

@export var name : String

#Corsi Block Tapping Task - Sequence Game
@export var current_level : int = 1
@export var completed_of_level : int = 0
@export var session_count : int = 0


@export var level_one_data : Array = [[],[],[],[],[],[]]
@export var level_two_data : Array = [[],[],[],[],[],[]]
@export var level_three_data : Array = [[],[],[],[],[],[]]
@export var level_four_data : Array = [[],[],[],[],[],[]]
@export var level_five_data : Array = [[],[],[],[],[],[]]
@export var levels_data : Dictionary = {1:level_one_data, 2:level_two_data, 3:level_three_data, 4:level_four_data, 5:level_five_data}

@export var sequence_session_performance_level : Array

func create_sequence_trial_save(sequence_type: Array, length: int, score: int):
	var trial_dict = {"sequence_type": sequence_type, "sequence_length": length, "score":score}
	return trial_dict
	
func add_to_sequence_level_data(sequence_type: Array, length: int, score: int):
	var trial_dict = create_sequence_trial_save(sequence_type, length, score)
	var index = sequence_type[0] + sequence_type[1]
	levels_data.get(current_level)[index].append(trial_dict) #current error, levels_data is empty??
	
func increase_sequence_level():
	current_level += 1
	
#funcs to return specific pieces like the actual level dicts for level report purposes
	#session reports will happen fully in the game model
	
