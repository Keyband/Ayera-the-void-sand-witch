extends Position2D
### Spawner
var margin = OS.window_size.x * 0.15
var enemy = preload("res://Scenes/enemy/enemy.tscn")

func _ready(): $tmr_spawn.wait_time = rand_range(0.5, 1.5)

func _on_tmr_spawn_timeout():
	$tmr_spawn.wait_time = rand_range(1.5, 3)
	self.global_position.x = rand_range( margin, OS.window_size.x - margin)
	var i = enemy.instance()
	i.global_position = self.global_position
	get_parent().add_child(i)