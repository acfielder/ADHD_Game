extends GutTest

func test_update_rule_block_phase_length():
	var model = wcstModel.new()
	var user = User_Data_Manager.load_resource()
	model.set_user(user)
	user.reset_wcst_data()
	model.update_rule_block_phase_length()
	assert_eq(model.rule_length,11)
	
	user.prev_overall_adaption_rate = 0.82
	user.prev_rule_block_length = 11
	model.update_rule_block_phase_length()
	assert_eq(model.rule_length,14)


func test_rule_change():
	var model = wcstModel.new()
	model.rule_change()
	assert_eq(model.current_rule,1)
	assert_eq(model.session_rule_blocks.size(),1)
	

