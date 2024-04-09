shader_type spatial;

instance uniform float hp_part = 1.0;
uniform vec3 filled_hp_color: source_color;
uniform vec3 lost_hp_color: source_color;

void vertex() {
	
}

void fragment() {
	if (UV.x < hp_part) {
		ALBEDO = filled_hp_color;
	} else {
		ALBEDO = lost_hp_color;
	}
}