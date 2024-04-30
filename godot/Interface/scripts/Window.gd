@tool
extends PanelContainer
class_name Window

@export var window_title := ''
@export var icon: Texture2D
@export var window_content: PackedScene
var drag_position = null


signal moved(window)


func _ready() -> void:
	$Container/TitleBar/Margin/Container/Title.text = window_title
	$ReopenControl/Panel/ReopenTitle.text = window_title
	if window_content:
		$Container.add_child(window_content.instantiate())
	if icon:
		$ReopenControl/Icon/TextureRect.texture = icon


func _on_Window_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal('moved', self)


func _on_TitleBar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal('moved', self)
			drag_position = get_global_mouse_position() - position
		else:
			drag_position = null

	if event is InputEventMouseMotion and drag_position != null:
		set_position(get_global_mouse_position() - drag_position)
		move_inside_bounds()


func move_inside_bounds() -> void:
	var bounds := get_viewport_rect()

	if position.x + size.x > bounds.end.x:
		position.x = bounds.end.x - size.x

	if position.y + size.y > bounds.end.y:
		position.y = bounds.end.y - size.y

	if position.x < bounds.position.x:
		position.x = bounds.position.x

	if position.y < bounds.position.y:
		position.y = bounds.position.y


func hide() -> void:
	$ReopenControl.show()
	$Background.hide()
	$Container.hide()


func show() -> void:
	$ReopenControl.hide()
	$Background.show()
	$Container.show()


func _on_CloseButton_pressed() -> void:
	hide()


func _on_Reopen_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			show()

