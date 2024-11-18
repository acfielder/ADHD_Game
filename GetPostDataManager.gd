extends Node

func _ready():
	#http_get("http://127.0.0.1:5000/get-data")
	pass

func http_get(url: String, callback: Callable, headers: Array = []):
	var http_request = HTTPRequest.new()
	#add_child(http_request)
	call_deferred("add_child", http_request)
	set_meta("callback", callback) #used to have http_request. first
	http_request.request_completed.connect(_on_request_completed_get)
	http_request.request(url, headers)
	http_request.call_deferred("request", url, headers)
	return http_request  # Return the request object for further tracking if needed
	
	
	
#update to save callback meta
func http_post(url: String, data: Dictionary, callback: Callable, headers: Array = []):
	var http_request = HTTPRequest.new()
	call_deferred("add_child", http_request)
	set_meta("callback", callback)
	http_request.request_completed.connect(_on_request_completed_post)
	var json_data = JSON.stringify(data)
	headers.append("Content-Type: application/json")
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)
	if err != OK: #its not ok
		print("Error sending request:", err)
	return http_request  # Return the request object for further tracking if needed


#update to callback to original function via meta
func _on_request_completed_post(result, response_code, headers, body):
	print("Request completed with response code: ", response_code)
	print("Response body: ", body.get_string_from_utf8())
	var callback = null
	if has_meta("callback"):
		callback = get_meta("callback")
	if response_code == 201:
		#return data to original - parse and send back
		#confirm data was saved
		print("database updated")
	else:
		print("Failed to update database")
		
	if callback and callback.is_valid():
		callback.call(response_code)
	# Free the HTTPRequest node
	queue_free()
	#var http_request = get_parent()
	#if http_request:
	#	http_request.queue_free()
		
func _on_request_completed_get(result, response_code, headers, body):
	var callback = null
	if has_meta("callback"):
		callback = get_meta("callback")
	var data = null
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		
		if parse_result == OK:
			data = json.data
		else:
			print("Failed to parse JSON")
	else:
		print("Failed to retrieve data")
		
	if callback and callback.is_valid():
		callback.call(data)
	
	queue_free()
	
	
	
