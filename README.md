# Rolo - Rogue-like Only Lives Once
CSCI-150 Project

Test Cases : https://docs.google.com/spreadsheets/d/1WKCYqAgPM8pfnXUOHKvrMGB3EZUJ9CE4jSbywNmFEs4/edit?usp=sharing

## Settings Menu
The Settings Menu currently contains the options for *Sounds*, *Displays*, and *Keybinds*.
<p align="center">
  <img width="303" height="257" alt="image" src="https://github.com/user-attachments/assets/18537514-3c27-4b48-8eda-f76f4fc7a6da" />
  <img width="305" height="257" alt="image" src="https://github.com/user-attachments/assets/e584610b-b2ac-4dcc-b836-d6fd7675c9b4" />
</p>

### Sound Settings
The sound options include three horizontal sliders corresponding to their respective audio buses: *Master*, *Sound Effect*, and *Music*.
All the sliders uses the custom `VolumeHSlider` class, which inherits from the Godot `HSlider` node. The `VolumeHSlider` class 
has the property `Bus` that is of type `enum BusIndex`. Other things the class does is initializes the `HSlider` properties:
`min_value`, `max_value`, `step`, and `value`; and also updates the audio bus with the current value.
```gdscript
enum BusIndex = {Master, SoundEffect, Music}
@export var bus: BusIndex = BusIndex.Master
...
func _on_value_changed(value: float) -> void:
	## Update whenever slider updates
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
```

<p align="center">
  <img width="258" height="231" alt="image" src="https://github.com/user-attachments/assets/6ea60ac2-1df2-43b2-812d-899b052c6b60" />
  <img width="431" height="347" alt="image" src="https://github.com/user-attachments/assets/11065b0d-3ee3-403b-9023-7f5e138e4015" />
</p>

### Keybinds
The keybind/control options includes buttons and labels for each action that could be customized. Each button uses the custom `KeybindButton` class,
which inherits from the Godot `Button` node. `KeybindButton` contains the class properties `action` and `default_key` to 
define the action assigned to the button. It also has the methods: `enable_buttons()`, `disable_nonactive_buttons()`, `release()`, and `set_text_mouse_events()`.
The `KeybindButton` class also handles the logic associated with assigning, accepting/rejecting reassignment, etc.

```gdscript
@export var action: String
@export var default_key: InputEvent
...
InputMap.action_erase_events(action)
InputMap.action_add_event(action, mouse_event)
```
<p align="center">
  <img width="636" height="260" alt="image" src="https://github.com/user-attachments/assets/8c6cfc41-86e7-4452-8d0b-0a0e83ecfd83" />
</p>
