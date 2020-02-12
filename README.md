# E05b-Scripting-and-Scenes

To continue to prepare you to turn in the space shooter project, we will experiment a little with more scripting, some procedural generation, and switching scenes in GDScript.

As usual, Fork and Clone this repository. Pay attention to where (on the file system) it is being saved.

 * Open Godot. In the project viewer, select Import.
 * Click Browse, and find the folder that contains your Cloned Project. Select the project.godot file and Open it. Import & Edit.
 * You should see a basic brick-breaking game. We will now add a few features to make it feel more like a game.
 * In the Scene panel, right-click on the World node and Add Child Node. Select a Label. Rename that Label "Score". Drag the label in to the top left corner of the Viewport
 * In the Scene panel, right-click on the World node and Add Child Node. Select a Label. Rename that Label "Lives". Drag the label in to the top right corner of the Viewport
 * Select the new Score label. In the inspector panel, change the Text to "Score:". Then, under Control, select Custom Fonts
 * In the Font drop down, click [empty], and select New DynamicFont
 * Click on DynamicFont and select Edit
 * In the new menu that appears, select Font, Font Data, and click Load. A file-picker menu will appear.
 * In res://Assets, select OstrichSans-Heavy.otf
 * Under Settings, Size, change the value to 18
 * Now select the Lives label, change the Text to "Lives:" and add the same font (and the same font size) to this label
 * _When editing the following scripts, make sure you indent using tabs. If you copy the code from this page, it will be indented with spaces; you will need to change that._
 * Right-click on the World node and Attach Script. Name the script res://Scripts/world.gd
 * Delete lines 2–17 and replace them with the following:
 ```
 export var score = 0
 export var lives = 3
 
 func increase_score(s):
  score += int(s)
  find_node("Score").update_score()
  
 func decrease_lives():
  lives -= 1
  find_node("Lives").update_lives()
 ```
 * Right-click on Score and Attach Script. Name the script res://Scripts/score.gd
 * Delete lines 2–17 and replace them with the following:
 ```
 func _ready():
  update_score()
 
 func update_score():
  text = "Score: " + str(get_parent().score)
 ```
 * Right-click on Lives and Attach Script. Name the script res://Scripts/lives.gd
 * Delete lines 2–17 and replace them with the following:
 ```
 func _ready():
  update_lives()
 
 func update_lives():
  text = "Lives: " + str(get_parent().lives)
 ```
 * Edit the script attached to the Ball node (res://Scripts/ball.gd):
 ```
 extends RigidBody2D
 
 export var maxspeed = 300
 
 signal lives
 signal score
 
 func _ready():
  contact_monitor = true
  set_max_contacts_reported(4)
  var WorldNode = get_node("/root/World")
  connect("score", WorldNode, "increase_score")
  connect("lives", WorldNode, "decrease_lives")
 
 func _physics_process(delta):
  var bodies = get_colliding_bodies()
  for body in bodies:
   if body.is_in_group("Tiles"):
    emit_signal("score",body.score)
    body.queue_free()
   if body.get_name() == "Paddle":
    pass
   
  if position.y > get_viewport_rect().end.y:
   emit_signal("lives")
   queue_free()
 ```
 * Right click on the Ball, Save Branch as Scene. Save it to res://Scenes/Ball.tscn
 * Edit the script attached to the Paddle node (res://Scripts/paddle.gd):
 ```
 extends KinematicBody2D
 
 var new_ball = preload("res://Scenes/Ball.tscn")
 
 func _ready():
  set_process_input(true)
 
 func _physics_process(delta):
  var mouse_x = get_viewport().get_mouse_position().x
  position = Vector2(mouse_x, position.y)
 
 func _input(event):
  if event is InputEventMouseButton and event.pressed:
   if not get_parent().has_node("Ball"):
    var ball = new_ball.instance()
    ball.position = position - Vector2(0, 32)
    ball.name = "Ball"
    ball.linear_velocity = Vector2(200, -200)
    get_parent().add_child(ball)
 
 ```
 * Under the Scene menu, select New Scene
 * Create Root Node: 2D Scene, and name it "Game Over"
 * Add a Child Node: Node2D and rename it "Message"
 * Under Message, Add Child Node: Label
 * Select the Label, and in the Inspector Panel, change Text to "Game Over!"
 * Set Align to Center
 * Select Custom Fonts and set the font to res://Assets/OstrichSansInline-Regular.otf
 * In Settings: set the Size to 40
 * Drag the Label to the middle of the Viewport and expand it so the message is centered on the screen
 * Under Message, Add Child Node: ColorRect
 * In the Inspector Panel, change the Color to black
 * Resize the ColorRect to cover the text of the Label
 * In the Scene hierarchy, move ColorRect above Label (under Message)
 * You should now see the message against a black rectangle
 * Save the scene as res://Scenes/End.tscn
 * Go back to the World Scene
 * Edit the script attached to the World node (res://Scripts/world.gd):
 ```
 extends Node
 
 export var score = 0
 export var lives = 3
 
 func increase_score(s):
  score += int(s)
  find_node("Score").update_score()
  
 func decrease_lives():
  lives -= 1
  find_node("Lives").update_lives()
  if lives <= 0:
   get_tree().change_scene("res://Scenes/End.tscn")
 ```

If you have score and lives labels that update, and if you get a end-game screen if your lives get to zero, you have completed the exercise. Save the Scenes, edit your LICENSE and README, commit everything to Github, and turn in the URL of your repository on Canvas.
 
