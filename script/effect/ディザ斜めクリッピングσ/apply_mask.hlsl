Texture2D pat : register(t0);
cbuffer constant0 : register(b0) {
	float2 dir;
	float len, width, mode_f, blur;
	float step_size, intensity, interpol_mode_f;
};
static const uint mode = uint(mode_f), interpol_mode = uint(interpol_mode_f);
float4 apply_mask(float4 pos : SV_Position) : SV_Target {
	const float noise = pat[pos.xy].a;
	float alpha = dot(dir, pos.xy) - len;
	if (mode != 0) alpha = abs(alpha) - width;
	alpha = saturate(alpha / blur);
	if (mode == 1) alpha = 1 - alpha;
	if (interpol_mode == 1) alpha = alpha * alpha * (3 - 2 * alpha);

	float i = floor(alpha / step_size), f = frac(alpha / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	const float a = (i + f) * step_size;

	return float4(0, 0, 0, a);
}
