const obj, type, math = obj, type, math;

if obj.getinfo("version") < tonumber("${LEAST_AVIUTL_VERSION}") then
	error([[AviUtl ExEdit2 version ${LEAST_AVIUTL_VERSION_STRING} 以降が必要です！]], 2);
end

---PI で `boolean|number|nil` での指定を適用する．number の場合，0 を false 扱い，0 以外を true 扱いとする．
---@param pi_value any # PI に渡ってきた値．
---@param gui_value boolean # 実際にスクリプトのパラメタとして渡ってきた値．
---@return boolean
const PI_as_bool = |pi_value, gui_value| ->
	type(pi_value) == "boolean" ? pi_value :
	type(pi_value) == "number" ? pi_value ~= 0 : gui_value;

local PI_choose_interpol_mode do
	const name2num = {
		["線形補間"] = 0,
		["エルミート補間"] = 1,
	};

	---@alias interpol_mode # ぼかしの「補間方法」．
	---| 0 # 線形補間
	---| 1 # エルミート補間

	---PI で「補間方法」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	--`--select@interpol_mode:補間方法=0,線形補間=0,エルミート補間=1`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value interpol_mode # 実際にスクリプトのパラメタとして渡ってきた値．
	---@return interpol_mode
	function PI_choose_interpol_mode(pi_value, gui_value)
		return math.min(math.max(math.floor(0.5 + (name2num[pi_value] ?? gui_value)), 0), 1);
	end
end

local PI_choose_pattern do
	const name2num = {
		["Flat"] = 0,
		["Checker"] = 1, ["Bayer 2x2"] = 2, ["Bayer 4x4"] = 3, ["Bayer 256x256"] = 4,
		["IGN"] = 5, ["White Noise"] = 6,
		["Halftone"] = 7, ["Halftone Honeycomb"] = 8, ["Halftone Square"] = 9, ["Stripe"] = 10,
	};
	---@alias dither_pattern # ディザリングの「パターン」．
	---| 0 # Flat
	---| 1 # Checker
	---| 2 # Bayer 2x2
	---| 3 # Bayer 4x4
	---| 4 # Bayer 256x256
	---| 5 # IGN
	---| 6 # White Noise
	---| 7 # Perlin Noise
	---| 8 # Halftone
	---| 9 # Halftone Honeycomb
	---| 10 # Halftone Square
	---| 11 # Stripe

	---PI で「パターン」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@pattern:パターン=3,Flat=0,Checker=1,Bayer 2x2=2,Bayer 4x4=3,Bayer 256x256=4,IGN=5,White Noise=6,Perlin Noise=7,Halftone=8,Halftone Honeycomb=9,Halftone Square=10,Stripe=11`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value dither_pattern # 実際にスクリプトのパラメタとして渡ってきた値．
	---@return dither_pattern
	function PI_choose_pattern(pi_value, gui_value)
		return math.min(math.max(math.floor(0.5 + (name2num[pi_value] ?? gui_value)), 0), 11);
	end
end

---乱数シードに関する，「0 以上だと同じシードでも別オブジェクトだと別の乱数．負だと同じシードなら別オブジェクトでも同じ乱数．」のための調整．
---@param seed number # GUI で与えられたシード値．
---@return integer # 実際に使用するシード値．0 以上の整数．
const function modify_seed(seed)
	seed = math.floor(0.5 + seed);
	if seed >= 0 then
		seed += 2525 * (obj.id & 0xf_ffff)
			+ 13579 * (obj.effect_id & 0xf_ffff)
			+ 54321 * (obj.index & 0xf_ffff);
	end
	seed &= 0xf_ffff;
	return seed;
end

---`obj.setanchor()` のラッパー．回転中心を基準にアンカーを配置する．
---@param var_name string # アンカーに対応する変数の名前の組．
const function setanchor(var_name)
	if obj.getoption("gui") then
		const cx, cy = obj.getvalue("center");
		obj.setanchor(var_name, 0, "line", "offset", cx + obj.cx, cy + obj.cy);
	end
end

return {
	PI = {
		as_bool = PI_as_bool,
		pattern = PI_choose_pattern,
		interpol_mode = PI_choose_interpol_mode,
	};
	setanchor = setanchor,
	modify_seed = modify_seed,
};
