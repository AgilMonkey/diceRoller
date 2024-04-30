extends HBoxContainer

var type: String: set = set_type

signal add_dice(type, amount)
signal remove_dice(type)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action('clear') and get_viewport().gui_get_focus_owner() == $NumberInput:
		get_viewport().set_input_as_handled()
		emit_signal('remove_dice', type)


func set_type(new_type: String) -> void:
	type = new_type
	var icon: CompressedTexture2D = load('res://Interface/Icons/%s.png' % type)
	if not icon:
		push_warning('No icon texture could be found at res://Interface/Icons/%s.png' % type)
		return
	$IconAspect/DiceIcon/Icon.texture = icon
	$IconAspect/DiceIcon.tooltip_text = 'Dice type (%s)' % new_type


func _on_DiceAdd_pressed() -> void:
	emit_signal('add_dice', type, $NumberInput.get_number())


func _on_NumberInput_text_entered(_new_text: String) -> void:
	emit_signal('add_dice', type, $NumberInput.get_number())


func _on_DiceClear_pressed() -> void:
	emit_signal('remove_dice', type)



