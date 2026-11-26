--information:ディザ斜めクリッピングσ@Dither_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:斜めクリッピングのぼかし部分を選んだディザリングのパターンにします．
--label:Dither_S
--filter
--require:${LEAST_AVIUTL_VERSION}
---$tips:0% から 100% までの段階の個数．
---$track:諧調数, min = 2, max = 512, step = 1, scale = 0.015625
local steps = 2

---$track:中心X, min = -5000, max = 5000, step = 0.01, scale = 0.2
local grad_x = 0

---$track:中心Y, min = -5000, max = 5000, step = 0.01, scale = 0.2
local grad_y = 0

--trackgroup@grad_x,grad_y:Center
---$track:角度, min = -3600, max = 3600, step = 0.01, scale = 0.1
local grad_angle = 0

---$track:ぼかし, min = 0, max = 2000, step = 0.01, scale = 0.25
local grad_blur = 100

---$track:幅, min = -2000, max = 2000, step = 0.01, scale = 0.25
local grad_width = 0

---$select:補間方法
---線形補間 = 0
---エルミート補間 = 1
local grad_interpol = 0

---$select:アンカー基準
---回転中心 = 0
---左上 = 1
---上 = 2
---右上 = 3
---左 = 4
---中央 = 5
---右 = 6
---左下 = 7
---下 = 8
---右下 = 9
local mode_anchor_base = 0

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
---     :  grad_x, grad_y: number?,
---     :  grad_angle: number?,
---     :  grad_blur: number?,
---     :  grad_width: number?,
---     :  grad_interpol: string?,
---     :  mode_anchor_base: string?,
---     :  pattern: string?,
---     :  intensity: number?,
---     :  scale: number?,
---     :  X, Y: number?,
---     :  angle: number?,
---     :  dither_seed: number?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@apply_mask:
---$include "apply_mask.hlsl"
]]
const dither_s = require("Dither_S");
const obj, tonumber, math = obj, tonumber, math;

-- set anchor.
if obj.getoption("gui") then
	local cx, cy;
	if mode_anchor_base == 0 then
		cx, cy = obj.getvalue("center");
		cx += obj.cx; cy += obj.cy;
	else
		cx = obj.w * (((mode_anchor_base - 1) % 3) - 1) / 2;
		cy = obj.h * (math.floor((mode_anchor_base - 1) / 3) - 1) / 2;
	end
	obj.setanchor("grad_x,grad_y", 0, "line", "offset", cx, cy);
end
if pattern ~= 0 then dither_s.setanchor("X,Y") end

--#region PI / normalize parameters.

-- take parameters.
steps = tonumber(PI.steps) ?? steps;
grad_x = tonumber(PI.grad_x) ?? grad_x;
grad_y = tonumber(PI.grad_y) ?? grad_y;
grad_angle = tonumber(PI.grad_angle) ?? grad_angle;
grad_blur = tonumber(PI.grad_blur) ?? grad_blur;
grad_width = tonumber(PI.grad_width) ?? grad_width;
grad_interpol = dither_s.PI.interpol_mode(PI.grad_interpol, grad_interpol);
if type(PI.mode_anchor_base) == "string" then
	const name2num = {
		["回転中心"] = 0,
		["左上"] = 1, ["上"] = 2, ["右上"] = 3,
		["左"] = 4, ["中央"] = 5, ["右"] = 6,
		["左下"] = 7, ["下"] = 8, ["右下"] = 9,
	};
	mode_anchor_base = name2num[PI.mode_anchor_base] ?? mode_anchor_base;
end
pattern = dither_s.PI.pattern(PI.pattern, pattern);
intensity = tonumber(PI.intensity) ?? intensity;
scale = tonumber(PI.scale) ?? scale;
X = tonumber(PI.X) ?? X;
Y = tonumber(PI.Y) ?? Y;
angle = tonumber(PI.angle) ?? angle;
dither_seed = tonumber(PI.dither_seed) ?? dither_seed;

-- normalize parameters.
steps = math.min(math.max(math.floor(0.5 + steps), 2), 2 ^ 12);

mode_anchor_base = math.min(math.max(math.floor(0.5 + mode_anchor_base), 0), 9);
if mode_anchor_base == 0 then
	const cx, cy = obj.getvalue("center");
	grad_x += cx + obj.cx; grad_y += cy + obj.cy;
else
	grad_x += obj.w * (((mode_anchor_base - 1) % 3) - 1) / 2;
	grad_y += obj.h * (math.floor((mode_anchor_base - 1) / 3) - 1) / 2;
end
grad_x += obj.w / 2; grad_y += obj.h / 2;
grad_angle = 2 * math.pi * ((grad_angle / 360) % 1);
const grad_c, grad_s = math.sin(grad_angle), -math.cos(grad_angle); -- 0 is up, clockwise.
grad_blur = math.max(grad_blur, 2 ^ -10);

dither_seed = dither_s.modify_seed(dither_seed);
intensity = math.min(math.max(intensity / 100, 0), 1 - 2 ^ -10);
scale = math.max(scale / 100, 1);
const cx, cy = obj.getvalue("center");
X += cx + obj.cx + obj.w / 2; Y += cy + obj.cy + obj.h / 2;
angle = 2 * math.pi * ((angle / 360) % 1);
const c, s = math.cos(angle) / scale, math.sin(angle) / scale;

--#endregion PI / normalize parameters.

-- further calculations.
local grad_len, grad_mode = grad_c * grad_x + grad_s * grad_y, 0;
if grad_width == 0 then
	grad_len -= grad_blur / 2;
else
	grad_len = grad_c * grad_x + grad_s * grad_y;
	if grad_width > 0 then
		grad_mode = 1;
		grad_width = grad_width / 2 - grad_blur;
	else
		grad_mode = 2;
		grad_width = -grad_width / 2;
	end
end

-- generate the dither pattern.
const cache_pat = "cache:dither_s/pat";
obj.clearbuffer(cache_pat, obj.w, obj.h);
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
obj.pixelshader("apply_mask@ディザ斜めクリッピングσ@Dither_S", "object", cache_pat, {
	grad_c, grad_s;
	grad_len; grad_width; grad_mode; grad_blur;
	1 / (steps - 1); intensity; grad_interpol;
}, "mask");
