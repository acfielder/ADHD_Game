extends Resource
class_name UserModel

@export var name : String

#Corsi Block Tapping Task - Sequence Game
@export var current_level : int = 1 #players current level over sessions
@export var completed_of_level : int = 0 #how many sequences have been completed of the current level
@export var sequence_session_count : int = 0 #number of sessions completed of the sequence game

#2D arrays holding trial data for each level, hased into their particular sequence type
@export var level_one_data : Array = [[],[],[],[],[],[]]
@export var level_two_data : Array = [[],[],[],[],[],[]]
@export var level_three_data : Array = [[],[],[],[],[],[]]
@export var level_four_data : Array = [[],[],[],[],[],[]]
@export var level_five_data : Array = [[],[],[],[],[],[]]
#complete dictionary of all trial info
@export var levels_data : Dictionary = {1:level_one_data, 2:level_two_data, 3:level_three_data, 4:level_four_data, 5:level_five_data}

@export var sequence_session_performance_level : Array = [10,10] #number of trials successful with total in last session

#takes trial information to condense into a dictionary
func create_sequence_trial_save(sequence_type: Array, length: int, score: int):
	var trial_dict = {"sequence_type": sequence_type, "sequence_length": length, "score":score}
	return trial_dict

#adds previously played trial's info to user's save - info saved may change
func add_to_sequence_level_data(sequence_type: Array, length: int, score: int):
	var trial_dict = create_sequence_trial_save(sequence_type, length, score)
	var index = sequence_type[0] + sequence_type[1] + 1
	levels_data.get(current_level)[index].append(trial_dict)

#increases saved sequece level once user completes level within completed session
func increase_sequence_level():
	print(str("current level before change: ") + str(current_level))
	current_level += 1
	print(str("current level after change: ") + str(current_level))
	completed_of_level = 0
	print("users internal level has been increased")
	
#funcs to return specific pieces like the actual level dicts for level report purposes
#session reports will happen fully in the game model
	
#resets all user data as though starting a new save
func reset_user_data():
	name = "" #this will need asked for at start of game
	current_level = 1
	completed_of_level = 0
	sequence_session_count = 0
	sequence_session_performance_level = [10,10]
	level_one_data = [[],[],[],[],[],[]]
	level_two_data = [[],[],[],[],[],[]]
	level_three_data = [[],[],[],[],[],[]]
	level_four_data = [[],[],[],[],[],[]]
	level_five_data = [[],[],[],[],[],[]]
	levels_data = {1:level_one_data, 2:level_two_data, 3:level_three_data, 4:level_four_data, 5:level_five_data}
