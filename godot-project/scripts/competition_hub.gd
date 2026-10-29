extends Control
# Pizza Panic local competitions & milestone arcade. Real online rankings require a configured, trusted server.
signal closed
signal best_score_changed(category: String, score: int)
const SAVE_PATH := "user://pizza_panic_competitions.cfg"
const GAME_NAMES := {5: "PIZZA TOSS", 10: "PERFECT PIZZA", 15: "KITCHEN RUSH", 20: "PIZZA CHAMPIONSHIP", 25: "PIZZA TOSS", 30: "PERFECT PIZZA", 35: "KITCHEN RUSH", 40: "PIZZA CHAMPIONSHIP", 45: "PIZZA TOSS", 50: "PERFECT PIZZA", 55: "KITCHEN RUSH", 60: "PIZZA CHAMPIONSHIP", 65: "PIZZA TOSS", 70: "PERFECT PIZZA", 75: "KITCHEN RUSH", 80: "PIZZA CHAMPIONSHIP", 85: "PIZZA TOSS", 90: "PERFECT PIZZA", 95: "KITCHEN RUSH", 100: "PIZZA CHAMPIONSHIP"}
const RECIPES := ["CHEESE", "PEPPERONI", "MUSHROOM", "OLIVE"]
var best: Dictionary = {}
var claimed: Dictionary = {}
var entered: Dictionary = {}
var selected_day := 5
var playing := false
var seconds := 30.0
var score := 0
var attempts := 0
var phase := 0.0
var target_index := 0
var streak := 0
var target := 0
var sequence: Array[int] = []
var current_sequence: Array[int] = []
var online_endpoint := ""
var http: HTTPRequest
var title_label: Label
var status_label: Label
var instructions: Label
var controls: HBoxContainer
var action_buttons: Array[Button] = []
var list_label: Label
var online_label: Label
var start_btn: Button
var tabs: HBoxContainer
var online_pending := false
var showing_board := false
var endless_record := 0
var weekly_week := ""
var weekly_best := 0

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_STOP
    z_index = 450
    _read_save()
    var shade := ColorRect.new()
    shade.color = Color(0.08,0.04,0.02,0.89)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)
    var panel := PanelContainer.new()
    panel.position = Vector2(245,72)
    panel.size = Vector2(790,574)
    add_child(panel)
    var vb := VBoxContainer.new()
    vb.add_theme_constant_override("separation", 12)
    panel.add_child(vb)
    title_label = Label.new()
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 30)
    vb.add_child(title_label)
    instructions = Label.new()
    instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    instructions.custom_minimum_size.y = 65
    vb.add_child(instructions)
    status_label = Label.new()
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 22)
    vb.add_child(status_label)
    controls = HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    vb.add_child(controls)
    for i in range(4):
        var b := Button.new()
        b.custom_minimum_size = Vector2(158,64)
        b.pressed.connect(_action.bind(i))
        controls.add_child(b)
        action_buttons.append(b)
    start_btn = Button.new()
    start_btn.text = "START CHALLENGE"
    start_btn.custom_minimum_size.y = 48
    start_btn.pressed.connect(_start_game)
    vb.add_child(start_btn)
    tabs = HBoxContainer.new()
    for day in [5,10,15,20]:
        var b := Button.new()
        b.text = "DAY %d" % day
        b.pressed.connect(open_game.bind(day))
        tabs.add_child(b)
    vb.add_child(tabs)
    list_label = Label.new()
    list_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vb.add_child(list_label)
    online_label = Label.new()
    online_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    online_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    vb.add_child(online_label)
    var buttons := HBoxContainer.new()
    vb.add_child(buttons)
    var leaderboard := Button.new()
    leaderboard.text = "LEADERBOARDS"
    leaderboard.pressed.connect(open_leaderboards)
    buttons.add_child(leaderboard)
    var refresh := Button.new()
    refresh.text = "CHECK ONLINE RANKINGS"
    refresh.pressed.connect(refresh_online)
    buttons.add_child(refresh)
    var weekly := Button.new()
    weekly.text = "WEEKLY CHALLENGE"
    weekly.pressed.connect(open_weekly)
    buttons.add_child(weekly)
    var back := Button.new()
    back.text = "BACK TO GAME"
    back.pressed.connect(_close)
    buttons.add_child(back)
    http = HTTPRequest.new()
    http.request_completed.connect(_online_result)
    add_child(http)
    hide()

func _read_save() -> void:
    var cfg := ConfigFile.new()
    cfg.load(SAVE_PATH)
    best = cfg.get_value("scores","best",{})
    claimed = cfg.get_value("scores","claimed",{})
    entered = cfg.get_value("scores","seen",{})
    online_endpoint = str(cfg.get_value("connection","leaderboard_url",""))
    endless_record = int(cfg.get_value("scores","endless_round",0))
    weekly_week = str(cfg.get_value("scores","weekly_week",""))
    weekly_best = int(cfg.get_value("scores","weekly_best",0))

func _write_save() -> void:
    var cfg := ConfigFile.new()
    cfg.set_value("scores","best",best)
    cfg.set_value("scores","claimed",claimed)
    cfg.set_value("scores","seen",entered)
    cfg.set_value("connection","leaderboard_url",online_endpoint)
    cfg.set_value("scores","endless_round",endless_record)
    cfg.set_value("scores","weekly_week",weekly_week)
    cfg.set_value("scores","weekly_best",weekly_best)
    cfg.save(SAVE_PATH)

func available_after(day: int) -> bool:
    return GAME_NAMES.has(day)

func already_seen(day: int) -> bool:
    return bool(entered.get(str(day),false))

func open_game(day: int) -> void:
    if not GAME_NAMES.has(day): return
    selected_day = day
    entered[str(day)] = true
    _write_save()
    playing = false
    showing_board = false
    title_label.text = "DAY %d BONUS • %s" % [day,GAME_NAMES[day]]
    var descriptions := {5:"Tap TOSS when the moving target is centered. 30 seconds.",10:"Assemble the requested pizza by selecting the correct ingredient. 30 seconds.",15:"Serve the highlighted kitchen station before it changes. 30 seconds.",20:"Championship: a changing sequence of ingredients. Accuracy builds your combo. 40 seconds."}
    instructions.text = descriptions[milestone_game_type(day)]
    controls.show()
    tabs.show()
    start_btn.show()
    for b in action_buttons: b.disabled = true
    status_label.text = "PERSONAL BEST: %d POINTS" % int(best.get(str(day),0))
    list_label.text = "Practice and improve your personal best. Milestone coin prizes are planned for a later economy update."
    online_label.text = "Scores on this device are local and not verified online."
    _set_buttons()
    show()

func _start_game() -> void:
    playing = true
    seconds = 40.0 if milestone_game_type(selected_day) == 20 else 30.0
    score = 0
    attempts = 0
    streak = 0
    phase = 0
    target_index = 0 if selected_day == -1 else randi_range(0,3)
    sequence.clear()
    current_sequence.clear()
    start_btn.hide()
    for b in action_buttons: b.disabled = false
    _set_buttons()
    _refresh_status()

func milestone_game_type(day: int) -> int:
    if day == -1: return -1
    return 5 + (((day / 5) - 1) % 4) * 5

func _set_buttons() -> void:
    for i in range(4):
        if milestone_game_type(selected_day) == 5:
            action_buttons[i].text = "TOSS" if i == 0 else "—"
            action_buttons[i].visible = i == 0
        elif milestone_game_type(selected_day) == 15:
            action_buttons[i].text = ["OVEN","PLATE","SERVE","CLEAN"][i]
            action_buttons[i].visible = true
        else:
            action_buttons[i].text = RECIPES[i]
            action_buttons[i].visible = true

func _process(delta: float) -> void:
    if not playing or not visible: return
    seconds = maxf(0.0,seconds-delta)
    phase += delta * 5.2
    if seconds <= 0.0:
        _finish()
    else:
        _refresh_status()

func _refresh_status() -> void:
    var prompt := ""
    match milestone_game_type(selected_day):
        5: prompt = "TOSS NOW!" if absf(sin(phase)) < 0.32 else "WAIT FOR THE CENTER"
        10: prompt = "ORDER: %s" % RECIPES[target_index]
        15: prompt = "NEXT TASK: %s" % ["OVEN","PLATE","SERVE","CLEAN"][target_index]
        20: prompt = "CHAMPIONSHIP ORDER: %s  •  COMBO %d" % [RECIPES[target_index],streak]
        -1: prompt = "WEEKLY ORDER: %s  •  COMBO %d" % [RECIPES[target_index],streak]
    status_label.text = "TIME %02d   SCORE %d   ATTEMPTS %d\n%s" % [ceili(seconds),score,attempts,prompt]

func _action(index: int) -> void:
    if not playing: return
    attempts += 1
    var correct := false
    if milestone_game_type(selected_day) == 5:
        correct = absf(sin(phase)) < 0.32
    else:
        correct = index == target_index
    if correct:
        streak += 1
        score += 10 + mini(streak,5) * 2
    else:
        streak = 0
    if selected_day == -1:
        # Consistent deterministic ingredient order across devices within one calendar week.
        target_index = (attempts * 7 + _weekly_seed()) % 4
    else:
        target_index = randi_range(0,3)
    _refresh_status()

func _finish() -> void:
    playing = false
    for b in action_buttons: b.disabled = true
    var key := str(selected_day)
    var old := int(best.get(key,0))
    if selected_day == -1:
        if score > weekly_best:
            weekly_best = score
            best_score_changed.emit("weekly",score)
    elif score > old:
        best[key] = score
        best_score_changed.emit("minigame_%d" % selected_day,score)
    _write_save()
    var display_best := weekly_best if selected_day == -1 else int(best.get(key,0))
    status_label.text = "FINISHED! SCORE %d   BEST %d\nATTEMPTS %d" % [score,display_best,attempts]
    list_label.text = "Your best is saved locally. No online score was submitted."
    start_btn.text = "PLAY AGAIN"
    start_btn.show()

func open_leaderboards() -> void:
    playing = false
    showing_board = true
    title_label.text = "PIZZA PANIC • COMPETITIONS"
    controls.hide()
    start_btn.hide()
    tabs.show()
    instructions.text = "Local personal records. Online worldwide standings require a trusted competition server."
    var rows := PackedStringArray()
    for day in range(5,101,5):
        if int(best.get(str(day),0)) > 0:
            rows.append("Day %d %-19s %d pts" % [day,str(GAME_NAMES[day]),int(best.get(str(day),0))])
    rows.append("Endless Restaurant best round: %d" % endless_record)
    rows.append("Weekly challenge (%s): %d pts" % [_week_key(),weekly_best if weekly_week == _week_key() else 0])
    list_label.text = "\n".join(rows)
    status_label.text = "PERSONAL HALL OF FAME"
    online_label.text = "Online: not connected (no verified submissions)."
    show()

func set_online_endpoint(url: String) -> void:
    # Supply only your own trusted HTTPS, server-backed read-only leaderboard endpoint.
    online_endpoint = url if url.begins_with("https://") else ""
    _write_save()

func refresh_online() -> void:
    if online_endpoint.is_empty():
        online_label.text = "Online leaderboard not configured. Local records still work offline."
        return
    if online_pending: return
    online_pending = true
    online_label.text = "Fetching public online rankings..."
    var err := http.request(online_endpoint)
    if err != OK:
        online_pending = false
        online_label.text = "Connection unavailable. Your local records are safe."

func _online_result(_result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
    online_pending = false
    if code != 200:
        online_label.text = "Online rankings unavailable (HTTP %d)." % code
        return
    var data = JSON.parse_string(body.get_string_from_utf8())
    if typeof(data) != TYPE_DICTIONARY or not data.has("rankings") or typeof(data["rankings"]) != TYPE_ARRAY:
        online_label.text = "Online response is not a valid leaderboard."
        return
    var lines := PackedStringArray()
    for row in (data["rankings"] as Array).slice(0,5):
        if typeof(row) == TYPE_DICTIONARY:
            lines.append("%s — %d" % [str(row.get("name","Player")).substr(0,18),int(row.get("score",0))])
    online_label.text = "ONLINE RANKINGS (READ ONLY)\n" + "\n".join(lines)

func _close() -> void:
    playing = false
    hide()
    closed.emit()

func _week_key() -> String:
    # Local Monday start. Intended only for offline challenges; server time must
    # determine official weekly boundaries if public competitions are deployed.
    var d := Time.get_date_dict_from_system()
    var unix_day: int = int(Time.get_unix_time_from_datetime_dict({"year":d["year"],"month":d["month"],"day":d["day"],"hour":12,"minute":0,"second":0}))
    var weekday: int = int(d["weekday"])
    var days_since_monday: int = (weekday + 6) % 7
    var monday := Time.get_date_dict_from_unix_time(unix_day - days_since_monday * 86400)
    return "%04d-%02d-%02d" % [int(monday["year"]),int(monday["month"]),int(monday["day"])]

func _weekly_seed() -> int:
    var value := 0
    for c in _week_key().to_utf8_buffer():
        value += int(c)
    return value

func open_weekly() -> void:
    var this_week := _week_key()
    if weekly_week != this_week:
        weekly_week = this_week
        weekly_best = 0
        _write_save()
    selected_day = -1
    playing = false
    title_label.text = "WEEKLY PIZZA CHAMPIONSHIP"
    instructions.text = "40 seconds • the same deterministic order pattern each week. This is an offline practice competition, not an official online ranking."
    controls.show()
    tabs.show()
    start_btn.text = "START WEEKLY CHALLENGE"
    start_btn.show()
    for b in action_buttons: b.disabled = true
    _set_buttons()
    status_label.text = "WEEK %s • PERSONAL BEST %d" % [this_week,weekly_best]
    list_label.text = "Complete as many correct orders as possible. Errors break your combo."
    online_label.text = "Online score submission disabled until server verification is implemented."
    show()

func record_endless_round(round_number: int) -> void:
    if round_number > endless_record:
        endless_record = round_number
        _write_save()
        best_score_changed.emit("endless",round_number)
