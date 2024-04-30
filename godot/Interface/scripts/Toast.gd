extends PanelContainer
class_name Toast

var message: String
var toasted_height := 0
var untoasted_height := 0
var delay := 0.0
var lifetime := -1.0
var margin := 30

@onready var tw: Tween = $Tween


func _ready() -> void:
#	modulate = Color.transparent
	$Message.text = message
	$TextSpaceCorrecter.text = $Message.text
	await get_tree().idle_frame # wait for rect to update

	set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	offset_top -= margin
	offset_bottom -= margin
	offset_left -= margin
	offset_right -= margin

	toasted_height = offset_top
	untoasted_height = offset_top + size.y + margin*2
	set_toast_height(untoasted_height)

	popup()


func popup():
	modulate = Color.WHITE
	tw.interpolate_method(
		self, "set_toast_height",
		untoasted_height, toasted_height, 1,
		Tween.TRANS_BACK, Tween.EASE_OUT, delay
	)
	tw.start()


func set_toast_height(pos: float):
	offset_top = pos
	offset_bottom = pos - size.y


func _on_Tween_tween_all_completed() -> void:
	if lifetime > 0:
		$Lifetime.start(lifetime)


func _on_Message_meta_clicked(meta) -> void:
	OS.shell_open(meta)


func _on_Dismiss_pressed() -> void:
	queue_free()


func _on_Lifetime_timeout() -> void:
	queue_free()


