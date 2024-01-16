extends Node3D

@export var radius = 10
@export var rotation_speed = 0.01

@export var zoom_speed = 1

@export var min_zoom = 5
@export var max_zoom = 20

@export_enum("Drag","Mouse","Keyboard","All") var input_type = "Mouse"

@onready var camera = $Camera3D

var zoom = radius

func _ready():
	if input_type == "Mouse" or input_type == "All":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	camera.position.z = radius

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and (input_type == "Mouse" or input_type == "All"):
		rotate_y(-event.relative.x * rotation_speed)
		rotation.x += -event.relative.y * rotation_speed
	elif event is InputEventScreenDrag and (input_type == "Drag" or input_type == "All"):
		rotate_y(-event.relative.x * rotation_speed)
		rotation.x += -event.relative.y * rotation_speed
	if event is InputEventMouseButton and (input_type == "Mouse" or input_type == "All"):
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				change_zoom(-zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				change_zoom(zoom_speed)
			
	if event is InputEventKey and (input_type == "Keyboard" or input_type == "All"):
		if event.as_text() == "Up":
			rotation.x += -7 * rotation_speed
		elif event.as_text() == "Down":
			rotation.x += 7 * rotation_speed
		if event.as_text() == "Right":
			rotate_y(7 * rotation_speed)
		elif event.as_text() == "Left":
			rotate_y(-7 * rotation_speed)
		
		if event.as_text() == "Down":
			pass
		if event.as_text() == "W":
			change_zoom(-zoom_speed)
		elif event.as_text() == "S":
			change_zoom(zoom_speed)
	
	rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func change_zoom(value):
	zoom += value
	zoom = clamp(zoom, min_zoom, max_zoom)
	camera.position.z = zoom
