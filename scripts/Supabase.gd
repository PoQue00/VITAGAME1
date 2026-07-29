extends Node


signal leaderboard_received(data)


var supabase_url = "https://osstpzabskmtzryikwhi.supabase.co"

var anon_key = "sb_publishable_6qWyT84TmOTzmiD_z-X4zA_OF9D7kym"


var http := HTTPRequest.new()



func _ready():

	add_child(http)

	http.connect(
		"request_completed",
		self,
		"_on_request_completed"
	)



func get_leaderboard(level):

	print("Starting leaderboard request")

	var headers = [
		"apikey: " + anon_key,
		"Authorization: Bearer " + anon_key,
		"Content-Type: application/json"
	]

	var url = (
		supabase_url
		+ "/rest/v1/leaderboard"
		+ "?level_name=eq."
		+ level
		+ "&order=time.asc"
		+ "&limit=10"
	)

	print(url)

	var result = http.request(
		url,
		headers,
		false,
		HTTPClient.METHOD_GET
	)

	print("Request result:", result)


func submit_time(level, time):

	var headers = [
		"apikey: " + anon_key,
		"Authorization: Bearer " + anon_key,
		"Content-Type: application/json"
	]


	var data = {
		"player_name": PlayerData.username,
		"level_name": level,
		"time": time
	}


	http.request(
		supabase_url + "/rest/v1/leaderboard",
		headers,
		false,
		HTTPClient.METHOD_POST,
		to_json(data)
	)



func _on_request_completed(
	result,
	response_code,
	headers,
	body
):

	var text = body.get_string_from_utf8()


	if response_code == 200:

		var data = parse_json(text)

		emit_signal(
			"leaderboard_received",
			data
		)

	else:

		print("Supabase error:")
		print(response_code)
		print(text)
