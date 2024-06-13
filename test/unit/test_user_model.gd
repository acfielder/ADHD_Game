extends GutTest

func test_create_sequence_trial_save():
	var user = UserModel.new()
	assert_eq(user.create_sequence_trial_save([1,-1],5,4),{"sequence_type": [1,-1], "sequence_length": 5, "score": 4})
	assert_eq(user.create_sequence_trial_save([3,2],7,0),{"sequence_type": [3,2], "sequence_length": 7, "score": 0})

func test_add_to_sequence_level_data():
	var user = UserModel.new()
	assert_eq(user.levels_data, {1:[[],[],[],[],[],[]], 2:[[],[],[],[],[],[]], 3:[[],[],[],[],[],[]], 4:[[],[],[],[],[],[]], 5:[[],[],[],[],[],[]]})
	user.add_to_sequence_level_data([2,-1],4,3)
	assert_eq(user.level_one_data, [[],[],[{"sequence_type": [2,-1], "sequence_length": 4, "score": 3}],[],[],[]])
	
	user.add_to_sequence_level_data([2,-1],6,6)
	assert_eq(user.level_one_data, [[],[],[{"sequence_type": [2,-1], "sequence_length": 4, "score": 3}, {"sequence_type": [2,-1], "sequence_length": 6, "score": 6}],[],[],[]])
	
	user.current_level = 3
	user.add_to_sequence_level_data([1,-1],4,3)
	user.add_to_sequence_level_data([3,0],3,2)
	assert_eq(user.level_three_data, [[],[{"sequence_type": [1,-1], "sequence_length": 4, "score": 3}],[],[],[{"sequence_type": [3,0], "sequence_length": 3, "score": 2}],[]])
	
	assert_eq(user.levels_data, {1:[[],[],[{"sequence_type": [2,-1], "sequence_length": 4, "score": 3}, {"sequence_type": [2,-1], "sequence_length": 6, "score": 6}],[],[],[]], 2:[[],[],[],[],[],[]], 3:[[],[{"sequence_type": [1,-1], "sequence_length": 4, "score": 3}],[],[],[{"sequence_type": [3,0], "sequence_length": 3, "score": 2}],[]], 4:[[],[],[],[],[],[]], 5:[[],[],[],[],[],[]]})

func test_increase_sequence_level():
	var user = UserModel.new()
	assert_eq(user.current_level,1)
	user.increase_sequence_level()
	assert_eq(user.current_level,2)

func test_reset_user_info():
