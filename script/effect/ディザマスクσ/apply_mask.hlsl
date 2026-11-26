Texture2D pat : register(t0);
cbuffer constant0 : register(b0) {
	float alpha, intensity;
};
float4 apply_mask(float4 pos : SV_Position) : SV_Target {
	const float noise = pat[pos.xy].a;
	const float a = saturate((alpha - intensity * noise) / (1 - intensity));
	return float4(0, 0, 0, a);
}
