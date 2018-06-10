extends Node
### Global stuff
var player 
var camera
var score = 0
signal game_over

var bg = preload("res://Scenes/snd_bg.tscn")

func _ready():
	randomize()
	add_child(bg.instance())

func game_over():
	emit_signal('game_over')