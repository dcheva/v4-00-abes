extends CharacterBody2D

@export var scr_width  := 1100
@export var scr_height := 600

var speed      := scr_width/3
var direction  := Vector2.ZERO
var abes       := []
	

func _ready() -> void:
	## Initial direction
	direction = Vector2.ZERO
	if(global_position.x < scr_width/2):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	if(global_position.y < scr_height/2):
		direction += Vector2.DOWN
	else:
		direction += Vector2.UP
	## A little bit random
	speed *= randf_range(0.8,1.2)
	velocity  += direction * speed
	
	## Append attachable
	abes.append(attachable("Diffuse"))


func _physics_process(delta: float) -> void:
	## Bob movement 2d
	direction = Vector2.ZERO
	if global_position.x <= (scr_width/4):
		direction = Vector2.RIGHT
	if global_position.x >= (scr_width-scr_width/4):
		direction = Vector2.LEFT
	if global_position.y <= (scr_height/4):
		direction = Vector2.DOWN
	if global_position.y >= (scr_height-scr_height/4):
		direction = Vector2.UP
	velocity  += direction * speed * delta
	velocity.x = clamp(velocity.x, -speed/2, speed/2)
	velocity.y = clamp(velocity.y, -speed/2, speed/2)
	move_and_slide()
	
	## Call attachable.execute()
	if(randf() < delta):
		var args: Dictionary
		if name == "p1":
			args.from = get_parent().find_child("p1")
			args.to = get_parent().find_child("p2")
			args.color = Color.CYAN
		else:
			args.from = get_parent().find_child("p2")
			args.to = get_parent().find_child("p1")
			args.color = Color.MAGENTA
		args.amount = randi_range(5, 25)
		var res = abes[0].execute(args)
		## Print the answer result
		if res != {}:
			print(res)
	
	
func attachable(abe_name: StringName, args: Array = []) -> Node:
	## Instantiate ability
	var fname := "res://Addings/Abes/Abilities/" + abe_name + "/" + abe_name
	var scene = load(fname + ".tscn")
	var script = load(fname + ".gd")
	var instance: Node2D = scene.instantiate()
	add_child(instance)
	## Setting up an instance and script
	instance.set_script(script)
	## Force calling _process()
	instance.set_process(true)
	print("Node \"", name, "\" attached ", abe_name, args)
	return instance
