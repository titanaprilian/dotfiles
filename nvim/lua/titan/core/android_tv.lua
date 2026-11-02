local M = {}

-- Configuration defaults
M.config = {
	device = "emulator-5554",
	default_apk = "app/build/outputs/apk/debug/app-debug.apk",
	sdk_path = vim.env.ANDROID_HOME or vim.env.ANDROID_SDK_ROOT or (vim.env.HOME .. "/Development/android"),
}

-- Keyevent mappings for Android TV remote / D-pad
local KEY_MAP = {
	up = 19, -- KEYCODE_DPAD_UP
	down = 20, -- KEYCODE_DPAD_DOWN
	left = 21, -- KEYCODE_DPAD_LEFT
	right = 22, -- KEYCODE_DPAD_RIGHT
	enter = 23, -- KEYCODE_DPAD_CENTER
	select = 23, -- KEYCODE_DPAD_CENTER alias
	back = 4, -- KEYCODE_BACK
	home = 3, -- KEYCODE_HOME
	menu = 82, -- KEYCODE_MENU
	play_pause = 85, -- KEYCODE_MEDIA_PLAY_PAUSE
}

local DPAD_DIRECTIONS = { "up", "down", "left", "right", "enter", "back", "home" }

--- Resolve ADB binary path
---@return string
local function get_adb_bin()
	if vim.fn.executable("adb") == 1 then
		return "adb"
	end
	local adb_in_sdk = M.config.sdk_path .. "/platform-tools/adb"
	if vim.fn.executable(adb_in_sdk) == 1 then
		return adb_in_sdk
	end
	return "adb"
end

--- Find the root directory containing Gradle project markers
---@return string
local function find_gradle_root()
	local current_buf = vim.api.nvim_get_current_buf()
	local fname = vim.api.nvim_buf_get_name(current_buf)
	local start_dir = (fname ~= "" and vim.fs.dirname(fname)) or vim.fn.getcwd()
	local root = vim.fs.root(start_dir, {
		"gradlew",
		"settings.gradle",
		"settings.gradle.kts",
		"build.gradle",
		"build.gradle.kts",
	})
	return root or vim.fn.getcwd()
end

--- Track active Gradle build job
local active_build_job = nil

--- Run Gradle assemble asynchronously in background
---@param custom_tasks string?
function M.android_assemble(custom_tasks)
	if active_build_job then
		vim.notify("[Android TV] A build is already in progress.", vim.log.levels.WARN)
		return
	end

	local root = find_gradle_root()
	local gradlew = root .. "/gradlew"
	local cmd = {}

	if vim.fn.filereadable(gradlew) == 1 then
		cmd = { "./gradlew" }
	elseif vim.fn.executable("gradle") == 1 then
		cmd = { "gradle" }
	else
		vim.notify(
			"[Android TV] Neither ./gradlew nor system gradle found in: " .. root,
			vim.log.levels.ERROR
		)
		return
	end

	local tasks = (custom_tasks and custom_tasks ~= "") and vim.split(custom_tasks, "%s+") or { "assembleDebug" }
	for _, task in ipairs(tasks) do
		table.insert(cmd, task)
	end

	local task_str = table.concat(tasks, " ")
	vim.notify("[Android TV] Building: " .. table.concat(cmd, " "), vim.log.levels.INFO)

	local output_lines = {}

	active_build_job = vim.fn.jobstart(cmd, {
		cwd = root,
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(output_lines, line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(output_lines, line)
					end
				end
			end
		end,
		on_exit = function(_, exit_code)
			active_build_job = nil
			if exit_code == 0 then
				vim.notify(
					string.format("[Android TV] Build SUCCEEDED (%s)", task_str),
					vim.log.levels.INFO
				)
			else
				vim.notify(
					string.format("[Android TV] Build FAILED (%s) with exit code %d. Check :copen", task_str, exit_code),
					vim.log.levels.ERROR
				)
				-- Populate quickfix list for quick navigation of build errors
				local qf_entries = {}
				for _, line in ipairs(output_lines) do
					table.insert(qf_entries, { text = line })
				end
				vim.fn.setqflist(qf_entries, "r")
				vim.fn.setqflist({}, "a", { title = "Android Assemble: " .. task_str })
			end
		end,
	})

	if active_build_job <= 0 then
		active_build_job = nil
		vim.notify("[Android TV] Failed to spawn build job.", vim.log.levels.ERROR)
	end
end

--- Install APK to Android TV emulator
---@param custom_apk_path string?
function M.android_install(custom_apk_path)
	local adb = get_adb_bin()
	local device = vim.g.android_tv_device or M.config.device
	local root = find_gradle_root()

	local apk_rel = (custom_apk_path and custom_apk_path ~= "") and custom_apk_path or M.config.default_apk
	local full_apk_path = (apk_rel:sub(1, 1) == "/") and apk_rel or (root .. "/" .. apk_rel)

	if vim.fn.filereadable(full_apk_path) == 0 then
		vim.notify(
			string.format(
				"[Android TV] APK not found:\n%s\nRun :AndroidAssemble first.",
				full_apk_path
			),
			vim.log.levels.WARN
		)
		return
	end

	vim.notify(string.format("[Android TV] Installing %s to %s...", vim.fs.basename(full_apk_path), device), vim.log.levels.INFO)

	local cmd = { adb, "-s", device, "install", "-r", full_apk_path }

	vim.system(cmd, { text = true }, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				vim.notify(
					string.format("[Android TV] Successfully installed on %s", device),
					vim.log.levels.INFO
				)
			else
				local err = (obj.stderr and obj.stderr ~= "") and obj.stderr or (obj.stdout or "Unknown error")
				vim.notify(
					string.format("[Android TV] Install FAILED on %s:\n%s", device, vim.trim(err)),
					vim.log.levels.ERROR
				)
			end
		end)
	end)
end

--- Send D-pad / remote keyevent to Android TV emulator
---@param direction_or_key string
function M.tv_dpad(direction_or_key)
	local key = vim.trim(string.lower(direction_or_key or ""))
	local keycode = KEY_MAP[key]

	if not keycode then
		local valid = table.concat(DPAD_DIRECTIONS, ", ")
		vim.notify(
			string.format("[Android TV] Unknown key '%s'. Valid directions: %s", direction_or_key, valid),
			vim.log.levels.ERROR
		)
		return
	end

	local adb = get_adb_bin()
	local device = vim.g.android_tv_device or M.config.device
	local cmd = { adb, "-s", device, "shell", "input", "keyevent", tostring(keycode) }

	vim.system(cmd, { text = true }, function(obj)
		if obj.code ~= 0 then
			vim.schedule(function()
				local err = (obj.stderr and obj.stderr ~= "") and obj.stderr or (obj.stdout or "")
				vim.notify(
					string.format("[Android TV] Keyevent %s (%d) failed:\n%s", key, keycode, vim.trim(err)),
					vim.log.levels.ERROR
				)
			end)
		end
	end)
end

-- Register User Commands (Zero keymap pollution)
function M.setup()
	-- :AndroidAssemble [tasks] (e.g. :AndroidAssemble assembleDebug)
	vim.api.nvim_create_user_command("AndroidAssemble", function(opts)
		M.android_assemble(opts.args)
	end, {
		desc = "Run Gradle assemble asynchronously for Android TV",
		nargs = "*",
	})

	-- :AndroidBuild (alias for :AndroidAssemble)
	vim.api.nvim_create_user_command("AndroidBuild", function(opts)
		M.android_assemble(opts.args)
	end, {
		desc = "Alias for :AndroidAssemble",
		nargs = "*",
	})

	-- :AndroidInstall [apk_path]
	vim.api.nvim_create_user_command("AndroidInstall", function(opts)
		M.android_install(opts.args)
	end, {
		desc = "Install debug APK to Android TV emulator (emulator-5554)",
		nargs = "?",
		complete = "file",
	})

	-- :TvDpad <direction>
	vim.api.nvim_create_user_command("TvDpad", function(opts)
		M.tv_dpad(opts.args)
	end, {
		desc = "Send D-pad keyevent to Android TV emulator (up, down, left, right, enter, back, home)",
		nargs = 1,
		complete = function(arg_lead)
			return vim.tbl_filter(function(item)
				return vim.startswith(item, vim.trim(string.lower(arg_lead)))
			end, DPAD_DIRECTIONS)
		end,
	})

	-- :TvRemote <key> (alias with extended keys)
	vim.api.nvim_create_user_command("TvRemote", function(opts)
		M.tv_dpad(opts.args)
	end, {
		desc = "Send remote keyevent to Android TV emulator",
		nargs = 1,
		complete = function(arg_lead)
			local all_keys = vim.tbl_keys(KEY_MAP)
			table.sort(all_keys)
			return vim.tbl_filter(function(item)
				return vim.startswith(item, vim.trim(string.lower(arg_lead)))
			end, all_keys)
		end,
	})
end

-- Automatically initialize commands on module load
M.setup()

return M
