extends Area2D
### Void
func _ready():
	self.scale = Vector2(0,0)
	$particles_darker.emitting = false
	$particles_lighter.emitting = false
	$twn_begin.interpolate_property(self, 'scale', self.scale, Vector2(1,1), 0.25, Tween.TRANS_BACK, Tween.EASE_OUT, 0.0)
	$twn_begin.start()

func _on_twn_begin_tween_completed(object, key):
	$collision_shape_2d.disabled = false
	$particles_darker.emitting = true
	$particles_lighter.emitting = true

func _on_tmr_duration_timeout():
	$collision_shape_2d.disabled = true
	$particles_darker.emitting = false
	$particles_lighter.emitting = false
	$twn_end.interpolate_property(self, 'scale', self.scale, Vector2(0,0), 1.5, Tween.TRANS_BACK, Tween.EASE_IN, 0.0)
	$twn_end.start()

func _on_twn_end_tween_completed(object, key): self.queue_free()

func grow():
	if $void.scale.x > 32*5: _on_tmr_duration_timeout()
	
	$tmr_duration.start()
	$void.scale *= 1.1
	$void.scale.x = clamp($void.scale.x, 0, 32*5.2); $void.scale.y = clamp($void.scale.y, 0, 32*5.2)
	$collision_shape_2d.shape.radius = $void.scale.x/2
	$particles_darker.process_material.emission_sphere_radius = $void.scale.x/2
	$particles_lighter.process_material.emission_sphere_radius = $void.scale.x
	$twn_begin.interpolate_property($void, 'scale', $void.scale, $void.scale * 1.1, 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT, 0.0)
	$twn_begin.start()
	

func _on_void_body_entered(body):
	if body.is_in_group('Player') or body.is_in_group('Enemy'):
#	if body.is_in_group('Player'): print('Void: Player was here!')
#	elif body.is_in_group('Enemy'):
		grow()
		body.hit()
		body.collapse_position = self.global_position
		print('Void: Enemy was here!')