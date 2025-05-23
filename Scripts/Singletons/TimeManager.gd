extends Node

var time_in_minutes : int = 0  # total minutes from midnight
var time_speed : float = 60.0  # 1 second real time = 1 minute game time

signal time_changed(hour, minute)
signal point_increase()
signal event_11am()
signal event_7pm()


var _last_trigger_11am = false
var _last_trigger_7pm = false

func _process(delta):
	time_in_minutes += int(time_speed * delta)
	time_in_minutes = time_in_minutes % (24 * 60)  # wrap after 24 hours

	var hour = time_in_minutes / 60
	var minute = time_in_minutes % 60
	
	emit_signal("time_changed", hour, minute)
	

	# Trigger events only once per occurrence
	if hour == 11 and minute == 0 and not _last_trigger_11am:
		emit_signal("event_11am")
		_last_trigger_11am = true
	elif hour != 11:
		_last_trigger_11am = false

	if hour == 19 and minute == 0 and not _last_trigger_7pm:
		emit_signal("event_7pm")
		_last_trigger_7pm = true
	elif hour != 19:
		_last_trigger_7pm = false
