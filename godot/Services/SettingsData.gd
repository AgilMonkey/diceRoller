extends Node


var setting_path := "user://settings.json"
var settings := {}

signal setting_changed(setting, value)
signal settings_saved

func _ready() -> void:
	load_settings()


func save_settings(silent: bool = false) -> void:
	var file := File.new()
	file.open(setting_path, File.WRITE)
	file.store_string(JSON.stringify(settings))
	file.close()
	if not silent:
		emit_signal("settings_saved")


func load_settings() -> void:
	var file := File.new()
	if file.file_exists(setting_path):
		file.open(setting_path, File.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		settings = test_json_conv.get_data()
		file.close()
	for setting in settings:
		if "color" in setting:
			settings[setting] = str_to_var("Color(" + settings[setting] + ")")


func set_setting(setting: String, value) -> void:
	settings[setting] = value
	emit_signal("setting_changed", setting, value)


func get_setting(setting: String, default = null):
	if setting_exists(setting):
		return settings[setting]
	return default


func setting_exists(setting: String) -> bool:
	return settings.has(setting)


func listen(node: Node, method: String) -> void:
	if node.has_method(method):
		connect("setting_changed", Callable(node, method))

