extends KinematicBody2D

export (int) var speed
export (int) var max_health = 100
var health = max_health
var velocity = Vector2()


func get_input():
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('shift'):
		velocity = velocity.normalized() * (speed * 2)
	else:
		velocity = velocity.normalized() * speed
	



func _physics_process(delta):
	get_input()
	if health == 0:
		self.queue_free()
		print("U DED MOTHAFAKA!!")
	velocity = move_and_slide(velocity) * delta
	


func _on_HitBox_area_entered(area):
	update()
	print(str(area.name))
	if area.name.similarity("Bullet"):
		health -= 1
		$Label.set_text(str(health))

