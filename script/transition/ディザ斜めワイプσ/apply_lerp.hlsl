Texture2D prev : register(t0);
Texture2D next : register(t1);
Texture2D pat : register(t2);
cbuffer constant0 : register(b0) {
	float2 dir;
	float len, blur;
	float step_size, intensity, interpol_mode_f;
};
static const uint interpol_mode = uint(interpol_mode_f);
float4 apply_lerp(float4 pos : SV_Position) : SV_Target {
	const float noise = pat[pos.xy].a;
	float alpha = dot(dir, pos.xy) - len;
	alpha = saturate(alpha / blur);
	if (interpol_mode == 1) alpha = alpha * alpha * (3 - 2 * alpha);

	float i = floor(alpha / step_size), f = frac(alpha / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	const float a = (i + f) * step_size;

	return lerp(next[pos.xy], prev[pos.xy], a);
}
