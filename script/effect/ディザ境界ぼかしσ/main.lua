--information:ディザ境界ぼかしσ@Dither_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:選んだディザリングのパターンで境界ぼかしをします．
--label:Dither_S
--require:${LEAST_AVIUTL_VERSION}
---$tips:0% から 100% までの段階の個数．
---$track:諧調数, min = 2, max = 512, step = 1, scale = 0.015625
local steps = 2

---$track:範囲, min = 0, max = 2000, step = 0.01, scale = 0.1
local blur_range = 40

---$tips:正で横長，負で縦長のぼかし幅．
---$track:縦横比, min = -100, max = 100, step = 0.001
local blur_aspect = 0

---$checksection:透明度の境界をぼかす
local blur_alpha_edge = true

---$track:αしきい値, min = 0, max = 100, step = 0.01
local blur_threshold = 0

--hide@blur_threshold:blur_alpha_edge==0
---$select:補間方法
---線形補間 = 0
---エルミート補間 = 1
local grad_interpol = 0

--group:パターン設定,true
---$nolang: options
---$select:パターン
---Flat = 0
---Checker = 1
---Bayer 2x2 = 2
---Bayer 4x4 = 3
---Bayer 256x256 = 4
---IGN = 5
---White Noise = 6
---Perlin Noise = 7
---Halftone = 8
---Halftone Honeycomb = 9
---Halftone Square = 10
---Stripe = 11
local pattern = 3

---$track:ディザ強さ, min = 0, max = 100, step = 0.01
local intensity = 100

---$tips:パターンの拡大率
---$track:ドットサイズ, min = 100, max = 6400, step = 0.01, scale = 0.0625
local scale = 100

--hide@scale:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

--hide@X:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

--hide@Y:pattern==0
--trackgroup@X,Y:Origin
---$tips:パターンの回転角度
---$track:回転, min = -3600, max = 3600, step = 0.01, scale = 0.1
local angle = 0

--hide@angle:pattern==0
---$tips:0 以上だと同じシードでも別オブジェクトだと別の乱数．
---     :負だと同じシードなら別オブジェクトでも同じ乱数．
---$track:ノイズシード, min = -65536, max = 65535, step = 1
local dither_seed = 10000

--hide@dither_seed:pattern==0
--hide@dither_seed:pattern==1
--hide@dither_seed:pattern==2
--hide@dither_seed:pattern==3
--hide@dither_seed:pattern==4
--hide@dither_seed:pattern==8
--hide@dither_seed:pattern==9
--hide@dither_seed:pattern==10
--hide@dither_seed:pattern==11
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  steps: number?,
---     :  blur_range: number?,
---     :  blur_aspect: number?,
---     :  blur_alpha_edge: boolean|number|nil,
---     :  blur_threshold: number?,
---     :  grad_interpol: string?,
---     :  pattern: string?,
---     :  intensity: number?,
---     :  scale: number?,
---     :  X, Y: number?,
---     :  angle: number?,
---     :  dither_seed: number?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@rect_mask:
---$include "rect_mask.hlsl"
]]
--[[pixelshader@dist_init:
---$include "dist_header.hlsl"
---$include "dist_init.hlsl"
]]
--[[pixelshader@dist_step:
---$include "dist_header.hlsl"
---$include "dist_step.hlsl"
]]
--[[pixelshader@dist_mask:
---$include "dist_header.hlsl"
---$include "dist_mask.hlsl"
]]
const dither_s = require("Dither_S");
const obj, tonumber, math = obj, tonumber, math;

-- set anchor.
if pattern ~= 0 then dither_s.setanchor("X,Y") end

--#region PI / normalize parameters.

-- take parameters.
steps = tonumber(PI.steps) ?? steps;
blur_range = tonumber(PI.blur_range) ?? blur_range;
blur_aspect = tonumber(PI.blur_aspect) ?? blur_aspect;
blur_alpha_edge = dither_s.PI.as_bool(PI.blur_alpha_edge, blur_alpha_edge);
blur_threshold = tonumber(PI.blur_threshold) ?? blur_threshold;
grad_interpol = dither_s.PI.interpol_mode(PI.grad_interpol, grad_interpol);
pattern = dither_s.PI.pattern(PI.pattern, pattern);
intensity = tonumber(PI.intensity) ?? intensity;
scale = tonumber(PI.scale) ?? scale;
X = tonumber(PI.X) ?? X;
Y = tonumber(PI.Y) ?? Y;
angle = tonumber(PI.angle) ?? angle;
dither_seed = tonumber(PI.dither_seed) ?? dither_seed;

-- normalize parameters.
steps = math.min(math.max(math.floor(0.5 + steps), 2), 2 ^ 12);

blur_range = math.max(blur_range, 0);
if blur_range == 0 then return end
blur_aspect = math.min(math.max(blur_aspect / 100, -1), 1);
blur_threshold = math.min(math.max(blur_threshold / 100, 0), 1 - 2 ^ -12);
const blur_range_x, blur_range_y =
	blur_range * math.min(1 + blur_aspect, 1),
	blur_range * math.min(1 - blur_aspect, 1);
dither_seed = dither_s.modify_seed(dither_seed);
intensity = math.min(math.max(intensity / 100, 0), 1 - 2 ^ -10);
scale = math.max(scale / 100, 1);
const cx, cy = obj.getvalue("center");
X += cx + obj.cx + obj.w / 2; Y += cy + obj.cy + obj.h / 2;
angle = 2 * math.pi * ((angle / 360) % 1);
const c, s = math.cos(angle) / scale, math.sin(angle) / scale;

--#endregion PI / normalize parameters.

-- create distance map.
const cache_pat, cache_dist = "cache:dither_s/pat", "cache:dither_s/dist";
obj.clearbuffer(cache_pat, obj.w, obj.h);
if blur_alpha_edge then
	obj.pixelshader("dist_init@ディザ境界ぼかしσ@Dither_S", cache_pat, "object", { blur_threshold });
	assert(obj.copybuffer(cache_dist, cache_pat));
	for i = math.ceil(math.max(math.log(math.max(obj.w, obj.h) / 2, 2), -1)), 0, -1 do
		obj.pixelshader("dist_step@ディザ境界ぼかしσ@Dither_S",
			(i % 2 ~= 0) ? cache_dist : cache_pat,
			(i % 2 == 0) ? cache_dist : cache_pat, {
			obj.w, obj.h;
			blur_range_x, blur_range_y;
			2 ^ i;
		});
	end
end

-- generate the dither pattern.
obj.pixelshader("gen_pat@ディザマスクσ@Dither_S", cache_pat, nil, {
	1, 0, 0, 0,
	0, 1; 0, 0;
	1, 0, 0, 0,
	0, 1; 0, 0;
	1, 0, 0, 0,
	0, 1; 0, 0;
	c, -s, 0, 0,
	s, c; X, Y;
	pattern; dither_seed;
});

-- apply dithering.
if blur_alpha_edge then
	obj.pixelshader("dist_mask@ディザ境界ぼかしσ@Dither_S", "object", { cache_dist, cache_pat }, {
		obj.w, obj.h;
		blur_range_x, blur_range_y;
		1 / (steps - 1); intensity; grad_interpol;
	}, "mask");
else
	obj.pixelshader("rect_mask@ディザ境界ぼかしσ@Dither_S", "object", cache_pat, {
		obj.w, obj.h;
		blur_range_x, blur_range_y;
		1 / (steps - 1); intensity; grad_interpol;
	}, "mask");
end
