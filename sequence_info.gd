class_name SequenceInfo

var overall_performance = [0,0,0,0,0,0,0,0]
var new_length
var memory_order = []
var rng = RandomNumberGenerator.new()
var trial = 1

#this should:
#determine length of sequence based on performance
	#if do poorly with 3, bring down to 2, if do well move to 4
#create the order of the sequence
#?determine the pushpin layouts for different boards
#track performance throughout
	#keep list of each sequence lengths number correct/incorrect(like the example graph)
	#note this class will have to be instantiated in the actual sequence scene
	
#i think eventually I might make it so board elements and pins are initiated together for more board possibilities
	
func start_game():
	new_length = 4
	create_sequence_order()
	return memory_order
	
func next_trial(lastResponseScores):
	update_performance_log(lastResponseScores)
	determine_new_length(lastResponseScores)
	memory_order = []
	create_sequence_order()
	return memory_order
	
func determine_new_length(lastResponseScores): #takes in array of scores for each press for last done sequence
	var score_sum = 0
	for response in range(lastResponseScores.size()):
		if lastResponseScores[response] != -1:
			score_sum += lastResponseScores[response]
	if score_sum == memory_order.size() && memory_order.size()<8: #change to fit correct num pins
		new_length = memory_order.size()+1
	elif score_sum < memory_order.size() && memory_order.size()>3:
		new_length = memory_order.size()-1
	else:
		new_length = memory_order.size()

	
func create_sequence_order():
	var pin_num
	for i in range(new_length):
		pin_num = int(rng.randf_range(1, 5)) #needs changed to fit however many pins there are
		memory_order.append(pin_num)
	
func update_performance_log(lastResponseScores):
	for i in lastResponseScores.size():
		overall_performance[i] += lastResponseScores[i]
	

