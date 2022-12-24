extends Node2D

var rotate = true
var rotateSpeed = 3
var ropeSpeed = 3
var minRopeLength = 32
var maxRopeLength = 470
var direction = false #false = left, true = right
var shoot = false
var allowUserInput = true
var score = 0
var catch = ""
const toLeftFish = preload("res://ToLeftFish.tscn")
const toRightFish = preload("res://ToRightFish.tscn")

func _ready():
	if not direction: 
		$DirectionController.rotation_degrees = 90
	elif direction:
		$DirectionController.rotation_degrees = -90

func _process(delta):
	$Rotate.text = "Rotate: " + str(rotate)
	if not direction:
		$Direction.text = "Direction: Left"
	elif direction:
		$Direction.text = "Direction: Right"
	$Shoot.text = "Shoot: " + str(shoot)
	$AllowUserInput.text = "Allow User Input: " + str(allowUserInput)
	$Score.text = "Score: " + str(score)
	
	if $DirectionController.rotation_degrees >= 90 and $DirectionController.rotation_degrees > 89.9:
		direction = true
	elif $DirectionController.rotation_degrees <= -90 and $DirectionController.rotation_degrees < -90.1:
		direction = false
	if rotate:
		if not direction:
			$DirectionController.rotate(rotateSpeed * delta)
		elif direction:
			$DirectionController.rotate(-rotateSpeed * delta)
	
	if allowUserInput:
		if Input.is_action_just_pressed("Space"):
			#cheat shoot = not shoot
			if allowUserInput:
				shoot = true
				allowUserInput = false
	
	if shoot:
		rotate = false
		if $DirectionController/Rope.rect_size.y + 1 <= maxRopeLength:
			$DirectionController/Rope.rect_size.y += ropeSpeed
			$DirectionController/Rope/Hook.position.y += ropeSpeed
		else:
			shoot = false
			allowUserInput = false
	elif not shoot:
		if $DirectionController/Rope.rect_size.y > minRopeLength:
			$DirectionController/Rope.rect_size.y -= ropeSpeed
			$DirectionController/Rope/Hook.position.y -= ropeSpeed
			if catch != "":
				$DirectionController/Rope/Hook/Area2D.hide()
				get_node(catch).global_position = Vector2($DirectionController/Rope/Hook.global_position.x, $DirectionController/Rope/Hook.global_position.y)
		else:
			rotate = true
			allowUserInput = true
			if catch != "":
				score += 1
				get_node(catch).queue_free()
				catch = ""
				$DirectionController/Rope/Hook/Area2D.show()

	if ($Timer.time_left == 0):
		$Timer.start()

func _on_body_entered(body):
	shoot = false
	allowUserInput = false
	catch = body.get_parent().get_parent().name + "/" + body.get_parent().name

func _on_Timer_timeout():
	randomize()
	var randomDirection
	var choiceDirection = [false, true, false, true, false, true, false, true, false, true]
	randomDirection = choiceDirection[randi() % choiceDirection.size()]
	var spawnedFish
	var spawnPoint = RandomSpawnPoint()
	if not randomDirection:
		spawnedFish = toRightFish.instance()
		get_node("ToRight" + str(spawnPoint)).add_child(spawnedFish)
	elif randomDirection:
		spawnedFish = toLeftFish.instance()
		get_node("ToLeft" + str(spawnPoint)).add_child(spawnedFish)

func RandomSpawnPoint():
	randomize()
	var choiceSpawnPoint = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
	return choiceSpawnPoint[randi() % choiceSpawnPoint.size()]
