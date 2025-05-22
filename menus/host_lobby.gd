extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	$StartButton.pressed.connect(_on_start_button_pressed)

func _on_peer_connected() -> void:
	$PlayersCounter.value = $PlayersCounter.value + 1

@rpc("any_peer", "call_local", "reliable")
func _load_main_scene() -> void:
	var main_scene = load("res://main_scene.tscn")
	get_tree().change_scene_to_packed(main_scene)
	# spawn_players.rpc()

func _on_start_button_pressed():
	_load_main_scene.rpc()
	
@rpc("authority") # Runs only on the server
func spawn_players() -> void:
	for peer_id in multiplayer.get_peers():
		spawn_player_for_peer.rpc_id(peer_id)
		
@rpc("authority", "call_local")
func spawn_player_for_peer(peer_id: int) -> void:
	pass
	# Load player. Something like:
	#var player_scene = preload("res://Player.tscn")
	#var player = player_scene.instantiate()
	#player.name = "Player_%d" % peer_id
	#player.set_multiplayer_authority(peer_id)
#
	#get_tree().get_root().get_node("Main").add_child(player)
