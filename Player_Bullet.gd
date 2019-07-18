extends Area2D

var speed = 1000
var direction = Vector2()

func start(aim_position, gun_position):
    global_position = gun_position
    direction = (aim_position - gun_position).normalized()
    rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta


func _on_Player_Bullet_body_entered(body):
	if body.name != "Player":
		queue_free()
