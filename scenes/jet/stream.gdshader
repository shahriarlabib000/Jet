// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx, unshaded;

//uniform vec4 albedo : source_color;
uniform vec3 colorA : source_color;
uniform vec3 colorB : source_color;
uniform float intensity;


//uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
//uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
//uniform vec3 uv2_scale;
//uniform vec3 uv2_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	if (UV.y >0.9)
	 VERTEX.z-=intensity+clamp(sin((TIME/2. * UV.x)*500.),0.,.1);
}

void fragment() {
	vec2 base_uv = UV;

	//vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = mix(colorA,colorB,UV.y);

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
}
