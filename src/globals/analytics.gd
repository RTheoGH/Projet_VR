extends Node

var save_directory: String = "./"
var current_session_id: int

var dt := 1.0 # time between monitoring in seconds.

var timer: Timer
var db : GDDuckDB

func _ready():
	timer = Timer.new()
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(update_monitored)
	add_child(timer)
	
	
	var empty := not FileAccess.file_exists(save_directory + "db.duckdb")
	db = GDDuckDB.new()
	db.set_path(save_directory + "db.duckdb")
	db.open_db()
	db.connect()
	
	if empty:
		# sequence thing https://duckdb.org/docs/stable/sql/statements/create_sequence
		db.query("
		CREATE SEQUENCE id_sequence START 1;
		CREATE SEQUENCE id_sequence_balls START 1;
		
		CREATE TABLE player (
			id INT PRIMARY KEY DEFAULT nextval('id_sequence'),
			age INT DEFAULT -1,
			gender VARCHAR(32) DEFAULT 'unknown',
			videogame_proficiency INT DEFAULT -1, 
			vr_proficiency INT DEFAULT -1,
		);
		
		CREATE TABLE system_balls (
		    id INT PRIMARY KEY DEFAULT nextval('id_sequence_balls'),
			positions REAL[3][] DEFAULT [],
			completion_time REAL DEFAULT -1,
			first_spell_time REAL DEFAULT -1,
		);
		")
	db.get_query_result()
	new_session()
	export_as_csv()

func _notification(what: int) -> void:
	if what == NOTIFICATION_CRASH or what == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_tree()
func exit_tree() -> void:
	db.disconnect()
	db.close_db()
	print("db has been closed")

func export_as_csv():
	db.query("COPY (SELECT * FROM player FULL JOIN system_balls ON player.id = system_balls.id) TO 'db_output.csv' (HEADER, DELIMITER ',');")

func get_user_data(id: int) -> Dictionary:
	db.query("SELECT * FROM player WHERE i = %d " % [id])
	return db.get_query_result()[0]

func get_all_user_data() -> Array:
	db.query("SELECT * FROM player")
	return db.get_query_result()

func show_error(text: String):
	OS.alert(text, "Analytics error !!")

func _exit_tree() -> void:
	db.close_db()

func get_current_id_from_db() -> int:
	if db.query("SELECT MAX(id) FROM player AS id"):
		if not db.get_query_result()[0]["max(id)"]:
			return 1
		
		return db.get_query_result()[0]["max(id)"] + 1
	else:
		return -1

func new_session() -> bool:
	current_session_id = get_current_id_from_db() 
	if current_session_id == -1:
		show_error("Could not create a new analytics session!\nAnalytics will be deactivated for now")
		return false
	else:
		db.query("INSERT INTO player DEFAULT VALUES ")
		db.get_query_result()
		db.query("INSERT INTO system_balls DEFAULT VALUES ")
		db.get_query_result()
		print("Created new analytics session (id %d)" % current_session_id)
		return true

func set_value(table_name: String, attrib_name: String, value: Variant) -> void:
	if value is String: # to support spaces.
		value = "\'%s\'" % value
	if not db.query("
		UPDATE %s
		SET %s = %s
		WHERE id = %s
	" % [table_name, attrib_name, str(value), str(current_session_id)]
	):
		show_error("Couldn't set %s into attribute %s of table %s" % [value, attrib_name, table_name])

func push_value(table_name: String, attrib_name: String, value) -> bool:
	if value is Vector3:
		value = "[%f, %f, %f]" % [value.x, value.y, value.z]
	elif value is Vector2:
		value = "[%f, %f]" % [value.x, value.y]
	else:
		value = str(value)
	if db.query("
		UPDATE \"%s\"
		SET %s = list_append(
			(SELECT %s FROM %s WHERE id = %s),
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
		return true
	else:
		show_error("Couldn't push %s into attribute %s of table %s" % [value, attrib_name, table_name])
		return false

# for the monitoring. Index to index.
var monitored_tables: Array[String] = []
var monitored_attributes: Array[String] = []
var monitored_objects: Array[Object] = []
var monitored_vars: Array[StringName] = []
var should_be_ignored: Array[bool] = []
func update_monitored():
	for i in monitored_objects.size():
		var val: Variant = monitored_objects[i].get(monitored_vars[i])
		should_be_ignored[i] = !push_value(monitored_tables[i], monitored_attributes[i], val)

func add_monitored(object: Object, var_name: StringName, table_name: String, attrib_name: String):
	monitored_tables.push_back(table_name)
	monitored_attributes.push_back(attrib_name)
	monitored_objects.push_back(object)
	monitored_vars.push_back(var_name)
	should_be_ignored.push_back(false)
