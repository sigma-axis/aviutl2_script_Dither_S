Texture2D prev : register(t0);
Texture2D pat : register(t1);
cbuffer constant0 : register(b0) {
	float2 size_f, range;
	float step_size, intensity;
	float interpol_mode_f;
};
static const uint2 size = uint2(size_f);
static const uint interpol_mode = uint(interpol_mode_f);

float4 dist_mask(float4 pos : SV_Position) : SV_Target
{
	const uint2 p0 = int2(pos.xy);

	float len_sq_min = 2;
	[unroll] for (int j = -1; j <= 1; j++) {
		[unroll] for (int i = -1; i <= 1; i++) {
			uint2 p = int2(p0) + int2(i, j);
			if (all(p < size)) p = dec(prev[p].xy);

			const int2 dp = int2(p) - int2(p0);
			const float2 dp1 = range > 0 ? dp / range : dp == 0 ? 0 : 1;
			const float len_sq = dot(dp1, dp1);
			if (valid(p) && len_sq < len_sq_min) {
				len_sq_min = len_sq;
			}
		}
	}
	float alpha = saturate(sqrt(len_sq_min));
	if (interpol_mode == 1) alpha = alpha * alpha * (3 - 2 * alpha);

	const float noise = pat[pos.xy].a;
	float i = floor(alpha / step_size), f = frac(alpha / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	const float a = (i + f) * step_size;

	return float4(0, 0, 0, a);
}
