extends CharacterBody2D

const SPEED = 300.0
const JUMP_FORCE = -400.0
@onready var label = %Label
@onready var texture := %AnimatedSprite2D
var is_jump = false

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if is_jump == true and velocity.y < 0:
			texture.play("caindo")

	if is_on_floor() and is_jump == true:
		is_jump = false
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		texture.play("pulando")
		is_jump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_jump == false:
			texture.play("correndo")
		
		if velocity.x < 0:
			texture.flip_h = true
		else:
			texture.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_jump == false:
			texture.play("parado")

	move_and_slide()


func _on_area_2d_body_entered(body):
	if(body.name == "Personagem"):
		queue_free()
		get_tree().paused = true
		label.visible = true
