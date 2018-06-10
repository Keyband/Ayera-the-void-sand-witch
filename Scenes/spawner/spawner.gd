extends Position2D
### Spawner
var margin = OS.window_size.y * 0.15
var enemy = preload("res://Scenes/enemy/enemy.tscn")

func _ready(): pass

func _on_tmr_spawn_timeout():
	self.global_position.y = rand_range( margin, OS.window_size.y - margin)
	var i = enemy.instance()
	i.global_position = self.global_position
	get_parent().add_child(i)