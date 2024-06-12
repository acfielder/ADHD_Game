extends GutTest


func test_init():
	var first_trial = SequenceTrialInfo.new([0,-1], 5, [1,2,3,4,5])
	assert_eq(first_trial.get_sequence_type(),[0,-1], "forward")
	assert_eq(first_trial.get_length(),5,"should be length 5")
	assert_eq(first_trial.get_mem_order(), [1,2,3,4,5], "should be same mem_order")
	assert_eq(first_trial.get_response(), [], "should still be empty")
	var second_trial = SequenceTrialInfo.new([1,-1],4,[1,2,3,4])
	assert_eq(second_trial.get_sequence_type(),[1,-1],"should be reversed")
	assert_eq(second_trial.get_length(),4, "should be length 4")
	assert_eq(second_trial.get_mem_order(), [1,2,3,4], "should be same")
	assert_eq(second_trial.get_score(),0,"should be 0 to start")
	second_trial.score = 2
	assert_eq(second_trial.get_score(),2,"should be 2 with changes")
	
func test_calculate_score():
	var trial = SequenceTrialInfo.new([0,-1],4,[2,3,5,1])
	trial.response = [1,1,1,1]
	assert_eq(trial.calculate_score(),4,"should be all correct for score=length")
	trial.score = 0
	trial.response = [1,1,0,0]
	assert_eq(trial.calculate_score(),2,"should be lower than length as 2 were incorrect")
	
	var rev_trial = SequenceTrialInfo.new([1,-1],6,[1,2,4,5,2,4])
	rev_trial.response = [1,1,1,1,1,1]
	rev_trial.score = 0
	assert_eq(rev_trial.calculate_score(),6,"should be all correct score=length")
	rev_trial.response = [0,1,1,1,1,0]
	rev_trial.score = 0
	assert_eq(rev_trial.calculate_score(),4,"should be only 4 correct")
	
	
func test_determine_next_trial_length():
	var trial = SequenceTrialInfo.new([2,-1],5,[5,4,5,3,2])
	trial.score = 5
	assert_eq(trial.determine_next_trial_length(),6,"should be length+1 when all correct")
	trial.score = 3
	assert_eq(trial.determine_next_trial_length(),4,"should be length-1 when few incorrect")
	trial = SequenceTrialInfo.new([3,0],8,[1,2,3,4,5,4,3,1])
	trial.score = 8
	assert_eq(trial.determine_next_trial_length(),8,"should still be 8 at edge with all correct")
	trial.length = 3
	trial.score = 2
	assert_eq(trial.determine_next_trial_length(),3,"should still be 3 at edge with incorrect")
	var rev_trial = SequenceTrialInfo.new([3,1],3,[1,3,2])
	rev_trial.score = 3
	assert_eq(rev_trial.determine_next_trial_length(),4,"should be length+1 when all correct and reversed")

	
func test_check_update_response():
	var trial = SequenceTrialInfo.new([0,-1],4,[3,2,4,1])
	trial.answer_order = [3,2,4,1]
	assert_true(trial.check_update_response(3),"should be true, first pin is 3")
	assert_eq(trial.get_response(),[1],"single correct should be [1]")
	assert_false(trial.check_update_response(4),"should be false, 2nd pin isnt 4 its 2")
	assert_eq(trial.get_response(),[1,0],"second incorrect should be [1,0]")
	
	var rev_trial = SequenceTrialInfo.new([2,-1],5,[3,2,4,1,2])
	rev_trial.answer_order = [2,3,4,2,1]
	assert_true(rev_trial.check_update_response(2), "should be true, first/last pin is 2")
	assert_eq(rev_trial.get_response(),[1],"single correct should be [1]")
	assert_false(rev_trial.check_update_response(2), "should be false, second to last isnt 3")
	assert_eq(rev_trial.get_response(),[1,0],"should be [1,0]")
	assert_true(rev_trial.check_update_response(4),"should be true, 3rd to last is 4")
	assert_eq(rev_trial.get_response(),[1,0,1],"should be [1,0,1] with three rev")
	
	
func test_update_trial_info():
	var trial = SequenceTrialInfo.new([0,-1],4,[3,2,4,1])
	trial.update_trial_info()
	#assert_eq()
	#prompt = correct prompt
	#answer_order is correct
	pass
	


