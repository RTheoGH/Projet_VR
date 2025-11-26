extends Node

var save_directory: String = "./"
var current_session_id: int
var current_session_data: Dictionary

var db : GDDuckDB
func _ready():
	var empty := not FileAccess.file_exists(save_directory + "db.parquet")
	db = GDDuckDB.new()
	db.set_path(save_directory + "db.parquet")
	db.open_db()
	db.connect()
	
	if empty:
		db.query("
		CREATE TABLE player (
		    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			age INT,
			gender VARCHAR(32),
			videogame_proficiency INT, 
			vr_proficiency INT,
		);
		
		CREATE TABLE system_balls (
		    id INT NOT NULL,
			positions REAL[3][],
			completion_time REAL,
			first_spell_time REAL,
		);
		")
	db.get_query_result()
	new_session()
	set_value("player", "gender", "yolo")

func show_error(text: String):
	OS.alert(text, "Analytics error !!")

func _exit_tree() -> void:
	db.close_db()

func get_current_id_from_db() -> int:
	if db.query("SELECT MAX(id) FROM player AS id"):
		if not db.get_query_result()[0]["max(id)"]:
			return 0
		
		return db.get_query_result()[0]["max(id)"] + 1
	else:
		return -1

func new_session() -> bool:
	current_session_id = get_current_id_from_db() + 1
	if current_session_id == -1:
		show_error("Could not create a new analytics session!\nAnalytics will be deactivated for now")
		return false
	else:
		db.query("INSERT INTO player DEFAULT VALUES ")
		db.get_query_result()
		db.query("INSERT INTO system_balls DEFAULT VALUES ")
		db.get_query_result()
		return true
func set_value(table_name: String, attrib_name: String, value: Variant) -> void:
	if not db.query("
		UPDATE %s
		SET %s = %s
		WHERE id = %s
	" % [table_name, attrib_name, str(value), str(current_session_id)]
	):
		show_error("Couldn't set %s into attribute %s of table %s" % [value, attrib_name, table_name])

func push_value(table_name: String, attrib_name: String, value) -> void:
	if value is Vector3:
		value = "[%f, %f, %f]" % [value.x, value.y, value.z]
	elif value is Vector2:
		value = "[%f, %f]" % [value.x, value.y]
	else:
		value = str(value)
	if db.query("
		UPDATE %s
		SET %s = list_append(
			SELECT %s FROM %s WHERE id = %s,
			%s
		)
		WHERE id = %s
	" % [
		table_name, attrib_name,
		# internal select
		attrib_name, table_name, str(current_session_id),
		# end
		value,
		str(current_session_id)]
	):
		pass
	else:
		show_error("Couldn't push %s into attribute %s of table %s" % [value, attrib_name, table_name])
	

func add_monitored(object: Object, var_name: String, targt_analytics_path: String):
	pass
