extends Node2D

var _target_ip: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SingleplayerButton.pressed.connect(_start_singleplayer_game)
	$HostButton.pressed.connect(_host_game)
	$JoinButton.pressed.connect(_join_game)
	$IpEdit.text_changed.connect(_on_ip_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _start_singleplayer_game() -> void:
	_load_main_scene()
	pass

func _host_game() -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(12345, 10)
	multiplayer.multiplayer_peer = peer
	print(result)
	print("Hosting server on port 12345")
	get_tree().change_scene_to_packed(load("res://menus/host_lobby.tscn"))
	
func _join_game() -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(_target_ip, 12345)
	print(result)
	multiplayer.multiplayer_peer = peer
	print("Connecting to server at %s...")
	print(_target_ip)
	
func _load_main_scene() -> void:
	var main_scene = load("res://main_scene.tscn")
	get_tree().change_scene_to_packed(main_scene)
	
func _on_ip_updated(new_text: String) -> void:
	_target_ip = new_text
	
