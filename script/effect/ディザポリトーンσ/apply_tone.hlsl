Texture2D src : register(t0);
Texture2D pat : register(t1);
cbuffer constant0 : register(b0) {
	float filter_intensity, intensity;
	float4 tones[16];
};
static const float3 luma_coeff = { 0.299, 0.587, 0.114 };
float4 apply_tone(float4 pos : SV_Position) : SV_Target {
	float4 c = src[pos.xy]; const float noise = pat[pos.xy].a;
	c.rgb = c.a != 0 ? c.rgb / c.a : 0;
	const float luma = saturate(dot(luma_coeff, c.rgb));

	float4 t0, t1;
	for (uint i = 0; i < 7; i++) {
		t0 = tones[i]; t1 = tones[i + 1];
		if (t0.a >= t1.a) continue;
		if (t0.a <= luma && luma <= t1.a) break;
	}

	float f = (luma - t0.a) / (t1.a - t0.a);
	f = saturate((f - intensity * noise) / (1 - intensity));
	c.rgb = lerp(c.rgb, lerp(t0.rgb, t1.rgb, f), filter_intensity);

	c.rgb *= c.a;
	return c;
}
