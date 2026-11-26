--information:ディザ減色σ@Dither_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:選んだディザリングのパターンで，画像の色成分を階段状にして減色します．
--label:Dither_S
--filter
--require:${LEAST_AVIUTL_VERSION}
---$nolang: options
---$select:色空間
---RGB = 0
---RGB Linear = 1
---CMY = 2
---CMY Linear = 3
local space = 1

---$tips:0% から 100% までの段階の個数．
---$track:諧調数1, min = 2, max = 512, step = 0.001, scale = 0.015625
local comp1_steps = 3

---$tips:0% から 100% までの段階の個数．
---$track:諧調数2, min = 2, max = 512, step = 0.001, scale = 0.015625
local comp2_steps = 3

---$tips:0% から 100% までの段階の個数．
---$track:諧調数3, min = 2, max = 512, step = 0.001, scale = 0.015625
local comp3_steps = 3

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
--group:成分1個別設定,false
---$track:comp1::ディザ強さ, min = 0, max = 100, step = 0.01
local comp1_intensity = 100

---$tips:パターンの拡大率
---$track:comp1::ドットサイズ, min = 100, max = 6400, step = 0.01, scale = 0.0625
local comp1_scale = 100

--hide@comp1_scale:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:comp1::X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local comp1_X = 0

--hide@comp1_X:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:comp1::Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local comp1_Y = 0

--hide@comp1_Y:pattern==0
--trackgroup@comp1_X,comp1_Y:Origin_1
---$tips:パターンの回転角度
---$track:comp1::回転, min = -3600, max = 3600, step = 0.01, scale = 0.1
local comp1_angle = 0

--hide@comp1_angle:pattern==0
--group:成分2個別設定,false
---$track:comp2::ディザ強さ, min = 0, max = 100, step = 0.01
local comp2_intensity = 100

---$tips:パターンの拡大率
---$track:comp2::ドットサイズ, min = 100, max = 6400, step = 0.01, scale = 0.0625
local comp2_scale = 100

--hide@comp2_scale:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:comp2::X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local comp2_X = 0

--hide@comp2_X:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:comp2::Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local comp2_Y = 0

--hide@comp2_Y:pattern==0
--trackgroup@comp2_X,comp2_Y:Origin_2
---$tips:パターンの回転角度
---$track:comp2::回転, min = -3600, max = 3600, step = 0.01, scale = 0.1
local comp2_angle = 0

--hide@comp2_angle:pattern==0
--group:成分3個別設定,false
---$track:comp3::ディザ強さ, min = 0, max = 100, step = 0.01
local comp3_intensity = 100

---$tips:パターンの拡大率
---$track:comp3::ドットサイズ, min = 100, max = 6400, step = 0.01, scale = 0.0625
local comp3_scale = 100

--hide@comp3_scale:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:comp3::X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local comp3_X = 0

--hide@comp3_X:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:comp3::Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local comp3_Y = 0

--hide@comp3_Y:pattern==0
--trackgroup@comp3_X,comp3_Y:Origin_3
---$tips:パターンの回転角度
---$track:comp3::回転, min = -3600, max = 3600, step = 0.01, scale = 0.1
local comp3_angle = 0

--hide@comp3_angle:pattern==0
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  space: string?,
---     :  comp1_steps: number?,
---     :  comp2_steps: number?,
---     :  comp3_steps: number?,
---     :  pattern: string?,
---     :  intensity: number?,
---     :  scale: number?,
---     :  X, Y: number?,
---     :  angle: number?,
---     :  dither_seed: number?,
---     :  comp1_intensity: number?,
---     :  comp1_scale: number?,
---     :  comp1_X: number?,
---     :  comp1_Y: number?,
---     :  comp1_angle: number?,
---     :  comp2_intensity: number?,
---     :  comp2_scale: number?,
---     :  comp2_X: number?,
---     :  comp2_Y: number?,
---     :  comp2_angle: number?,
---     :  comp3_intensity: number?,
---     :  comp3_scale: number?,
---     :  comp3_X: number?,
---     :  comp3_Y: number?,
---     :  comp3_angle: number?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@apply_rgb:
---$include "apply_rgb.hlsl"
]]
const dither_s = require("Dither_S");
const obj, tonumber, type, math = obj, tonumber, type, math;

-- set anchor.
if pattern ~= 0 then dither_s.setanchor("X,Y") end

--#region PI / normalize parameters.

-- take parameters.
if type(PI.space) == "string" then
	const name2num = {
		["RGB"] = 0, ["RGB Linear"] = 1,
		["CMY"] = 2, ["CMY Linear"] = 3,
	};
	space = name2num[PI.space] ?? space;
end
comp1_steps = tonumber(PI.comp1_steps) ?? comp1_steps;
comp2_steps = tonumber(PI.comp2_steps) ?? comp2_steps;
comp3_steps = tonumber(PI.comp3_steps) ?? comp3_steps;
pattern = dither_s.PI.pattern(PI.pattern, pattern);
intensity = tonumber(PI.intensity) ?? intensity;
scale = tonumber(PI.scale) ?? scale;
X = tonumber(PI.X) ?? X;
Y = tonumber(PI.Y) ?? Y;
angle = tonumber(PI.angle) ?? angle;
dither_seed = tonumber(PI.dither_seed) ?? dither_seed;
comp1_intensity = tonumber(PI.comp1_intensity) ?? comp1_intensity;
comp1_scale = tonumber(PI.comp1_scale) ?? comp1_scale;
comp1_X = tonumber(PI.comp1_X) ?? comp1_X;
comp1_Y = tonumber(PI.comp1_Y) ?? comp1_Y;
comp1_angle = tonumber(PI.comp1_angle) ?? comp1_angle;
comp2_intensity = tonumber(PI.comp2_intensity) ?? comp2_intensity;
comp2_scale = tonumber(PI.comp2_scale) ?? comp2_scale;
comp2_X = tonumber(PI.comp2_X) ?? comp2_X;
comp2_Y = tonumber(PI.comp2_Y) ?? comp2_Y;
comp2_angle = tonumber(PI.comp2_angle) ?? comp2_angle;
comp3_intensity = tonumber(PI.comp3_intensity) ?? comp3_intensity;
comp3_scale = tonumber(PI.comp3_scale) ?? comp3_scale;
comp3_X = tonumber(PI.comp3_X) ?? comp3_X;
comp3_Y = tonumber(PI.comp3_Y) ?? comp3_Y;
comp3_angle = tonumber(PI.comp3_angle) ?? comp3_angle;

-- normalize parameters.
space = math.min(math.max(math.floor(0.5 + space), 0), 3);
const space_mod = (space & 1) ~= 0; space >>= 1;

comp1_steps = math.min(math.max(comp1_steps, 2), 2 ^ 12);
comp2_steps = math.min(math.max(comp2_steps, 2), 2 ^ 12);
comp3_steps = math.min(math.max(comp3_steps, 2), 2 ^ 12);

dither_seed = dither_s.modify_seed(dither_seed);
const cx, cy = obj.getvalue("center");
X += cx + obj.cx + obj.w / 2; Y += cy + obj.cy + obj.h / 2;

comp1_intensity = math.min(math.max(comp1_intensity * intensity / 10000, 0), 1 - 2 ^ -10);
comp1_scale = math.max(comp1_scale * scale / 10000, 1);
comp1_X += X; comp1_Y += Y;
comp1_angle = 2 * math.pi * (((comp1_angle + angle) / 360) % 1);
const c1, s1 = math.cos(comp1_angle) / comp1_scale, math.sin(comp1_angle) / comp1_scale;

comp2_intensity = math.min(math.max(comp2_intensity * intensity / 10000, 0), 1 - 2 ^ -10);
comp2_scale = math.max(comp2_scale * scale / 10000, 1);
comp2_X += X; comp2_Y += Y;
comp2_angle = 2 * math.pi * (((comp2_angle + angle) / 360) % 1);
const c2, s2 = math.cos(comp2_angle) / comp2_scale, math.sin(comp2_angle) / comp2_scale;

comp3_intensity = math.min(math.max(comp3_intensity * intensity / 10000, 0), 1 - 2 ^ -10);
comp3_scale = math.max(comp3_scale * scale / 10000, 1);
comp3_X += X; comp3_Y += Y;
comp3_angle = 2 * math.pi * (((comp3_angle + angle) / 360) % 1);
const c3, s3 = math.cos(comp3_angle) / comp3_scale, math.sin(comp3_angle) / comp3_scale;

--#endregion PI / normalize parameters.

-- generate the dither pattern.
const cache_pat = "cache:dither_s/pat";
obj.clearbuffer(cache_pat, obj.w, obj.h);
obj.pixelshader("gen_pat@ディザマスクσ@Dither_S", cache_pat, nil, {
	c1, -s1, 0, 0,
	s1, c1; comp1_X, comp1_Y;
	c2, -s2, 0, 0,
	s2, c2; comp2_X, comp2_Y;
	c3, -s3, 0, 0,
	s3, c3; comp3_X, comp3_Y;
	1, 0, 0, 0,
	0, 1; 0, 0;
	pattern; dither_seed;
});

-- apply dithering.
obj.pixelshader("apply_rgb@ディザ減色σ@Dither_S", "object", { "object", cache_pat }, {
	1 / (comp1_steps - 1), 1 / (comp2_steps - 1), 1 / (comp3_steps - 1); space;
	comp1_intensity, comp2_intensity, comp3_intensity; space_mod ? 1 : 0;
});
