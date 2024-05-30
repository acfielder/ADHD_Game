extends GutTest



func before_all():
	pass

func test_check_update_response():
	var model = Sequence_Game.new()
	model.mem_order = [1,2,4,3]
	model.sequence_type_state = model.Sequence_Type.FORWARD
	assert_eq(model.check_update_response(1), true, "answer was correct should be true")
	assert_eq(model.response, [1], "correct response should be 1")
	
	assert_eq(model.check_update_response(3), false, "answer was incorrect should be false")
	assert_eq(model.response, [1,0], "incorrect response should be 0 added onto list")
	
	model = Sequence_Game.new()
	model.reversed_order = [4,3,2,1]
	model.sequence_type_state = model.Sequence_Type.REVERSE
	assert_eq(model.check_update_response(1), false, "answer was incorrect should be false")
	assert_eq(model.response, [0], "incorrect response should be added as 0 onto list")
	
	assert_eq(model.check_update_response(3), true, "answer was correct should be true")
	assert_eq(model.response, [0,1], "correct response should be 1 added onto list")




func test_create_sequence_order():
	var model = Sequence_Game.new()
	model.create_sequence_order()
	assert_eq(model.mem_order.size(), 4, "first trial length should be 4")
	for i in range(model.mem_order.size()-1):
		assert(model.mem_order[i] >= 1 and model.mem_order[i] <= 8)
		
	if model.sequence_type_state == model.Sequence_Type.FORWARD:
		model.current_trial = 2
		model.response = [1,1,1,1]
		model.create_sequence_order()
		assert_eq(model.mem_order.size(), 5, "second trial all correct length should be 5")
		for i in range(model.mem_order.size()-1):
			assert(model.mem_order[i] >= 1 and model.mem_order[i] <= 8)

func test_create_sequence_order_2():
	pass
		
	

func test_determine_new_length_2():
	#unsure how to fully test when random
	var for_count = 0
	var rev_count = 0
	var model = Sequence_Game.new()
	model.determine_new_length()
	assert_eq(model.length, 3, "trial 1 length should be 3")
	for_count += 1
	
	model.response = [1,1,1,1]
	model.mem_order = [1,2,3,4]
	model.reversed_order = [4,3,2,1]
	model.current_trial = 2
	model.determine_new_length()
	if model.sequence_type_state == model.Sequence_Type.FORWARD:
		assert_eq(model.length, 4, "Trial 2 length after all correct and length < 8, should be 4")
		for_count += 1
	elif model.sequence_type_state == model.Sequence_Type.REVERSE:
		assert_eq(model.length, 3, "First trial with reverse should be 3")
		rev_count += 1
	


#unc test_determine_new_length():
	#var model = Sequence_Game.new()
	#model.determine_new_length()
	#assert_eq(model.length, 4, "Trial 1 length should be 4")
	
	#model.response = [1,1,1,1]
	#model.mem_order = [1,2,3,4]
	#model.current_trial = 2
	#model.determine_new_length()
	#assert_eq(model.length, 5, "Trial 2 length after all correct and length < 8, should be 5")
	
	#model.response = [1,0,1,1]
	#model.determine_new_length()
	#assert_eq(model.length, 3, "Trial 2 length after incorrect and length > 3, should be 3")
	
	#model.response = [1,0,0]
	#model.mem_order = [2,3,3]
	#model.determine_new_length()
	#assert_eq(model.length, 3, "Trial 2 length after incorrect and length =3, should be 3")
	
	#model.response = [1,1,1,1,1,1,1,1]
	#model.mem_order = [1,2,3,4,5,6,7,8]
	#model.determine_new_length()
	#assert_eq(model.length, 8, "Trial 2 length after all correct and length = 8, should be 8")
	
	
func test_update_overall_performance():
	var model = Sequence_Game.new()
	model.response = [1,0,1,1,1]
	model.update_overall_performance()
	assert_eq(model.overall_performance, [1,0,1,1,1,0,0,0], "initial trial performance")
	
	model.response = [1,1,0,1,0,0,1,1]
	model.update_overall_performance()
	assert_eq(model.overall_performance, [2,1,1,2,1,0,1,1], "after trial after the intial, adding more")
	
func test_reset_trial_info():
	var model = Sequence_Game.new()
	model.pins_pressed = 6
	model.current_trial = 9
	model.reset_trial_info()
	assert_eq(model.pins_pressed, 0, "reset pins pressed to 0")
	assert_eq(model.current_trial, 10, "current trial should increase by 1")

func test_choose_sequence_type():
	var model = Sequence_Game.new()
	model.choose_sequence_type()
	assert_eq(model.sequence_type_state, model.Sequence_Type.FORWARD, "first trial should always be forward")
	model.sequence_type_state = model.Sequence_Type.TEST
	model.choose_sequence_type()
	assert(model.sequence_type_state == model.Sequence_Type.FORWARD || model.sequence_type_state == model.Sequence_Type.REVERSE)
	






#func before_each():
#	gut.p("ran setup", 2)

#func after_each():
#	gut.p("ran teardown", 2)

#func before_all():
#	gut.p("ran run setup", 2)

#func after_all():
#	gut.p("ran run teardown", 2)

#func test_assert_eq_number_not_equal():
#	assert_eq(1, 2, "Should fail.  1 != 2")

#func test_assert_eq_number_equal():
#	assert_eq('asdf', 'asdf', "Should pass")

#func test_assert_true_with_true():
#	assert_true(true, "Should pass, true is true")

#func test_assert_true_with_false():
#	assert_true(false, "Should fail")

#func test_something_else():
#	assert_true(false, "didn't work")
	

