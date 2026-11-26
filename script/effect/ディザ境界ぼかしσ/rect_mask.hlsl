Texture2D pat : register(t0);
cbuffer constant0 : register(b0) {
	float2 size_f, range;
	float step_size, intensity;
	float interpol_mode_f;
};
static const uint interpol_mode = uint(interpol_mode_f);
float4 rect_mask(float4 pos : SV_Position) : SV_Target {
	float2 R = max(range - min(pos.xy, size_f - pos.xy), 0);
	R = range > 0 ? R / range : R <= 0 ? 0 : 1;
	float alpha = saturate(1 - length(R));
	if (interpol_mode == 1) alpha = alpha * alpha * (3 - 2 * alpha);

	const float noise = pat[pos.xy].a;
	float i = floor(alpha / step_size), f = frac(alpha / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	const float a = (i + f) * step_size;

	return float4(0, 0, 0, a);
}
