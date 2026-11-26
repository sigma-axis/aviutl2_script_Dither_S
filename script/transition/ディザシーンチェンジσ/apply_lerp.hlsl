Texture2D prev : register(t0);
Texture2D next : register(t1);
Texture2D pat : register(t2);
Texture2D map : register(t3);
SamplerState smp : register(s0);
cbuffer constant0 : register(b0) {
	float2 pos_cff, pos_ofs, lum_lin;
	float step_size, intensity, interpol_mode_f;
};
static const uint interpol_mode = uint(interpol_mode_f);
static const float3 luma_coeff = { 0.299, 0.587, 0.114 };
float4 apply_lerp(float4 pos : SV_Position) : SV_Target {
	const float noise = pat[pos.xy].a,
		lum = dot(map.SampleLevel(smp, pos_cff * pos.xy + pos_ofs, 0).rgb, luma_coeff);
	float alpha = saturate(dot(float2(lum, 1), lum_lin));
	if (interpol_mode == 1) alpha = alpha * alpha * (3 - 2 * alpha);

	float i = floor(alpha / step_size), f = frac(alpha / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	const float a = (i + f) * step_size;

	return lerp(prev[pos.xy], next[pos.xy], a);
}
