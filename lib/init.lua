local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Package = script.Parent
local Matter = require(Package.Matter)
local Plasma = require(Package.Plasma)

export type Middleware = (nextFn: () -> (), eventName: string) -> ()
export type Debugger = typeof(Matter.Debugger.new())

export type Options = {
	client: boolean?,
	debugger: Debugger?,
}

type NormalizedOptions = {
	client: boolean,
	debugger: Debugger?,
}

local function normalizeOptions(options: Options?): NormalizedOptions
	return {
		client = if options and options.client ~= nil
			then options.client
			else RunService:IsClient(),
		debugger = if options and options.debugger then options.debugger else nil,
	}
end

-- This is any because it relies on the Plasma Runtime which is a type error
-- because of a cyclic type dependency.
-- type ContinueHandle = typeof(Plasma.beginFrame(
-- 	Plasma.new(Instance.new("ScreenGui")),
-- 	function() end
-- ))

--- @class MatterPlasma

--[=[
	Creates a middleware function for Plasma that can be used with Matter.

	@function create
	@within MatterPlasma
]=]
local function createMiddleware(options: Options?): Middleware
	local options = normalizeOptions(options)

	local matterDebugger
	if options.debugger then
		matterDebugger = Instance.new("ScreenGui")
		matterDebugger.Name = "MatterDebugger"
		matterDebugger.ResetOnSpawn = false
		matterDebugger.IgnoreGuiInset = true
	end

	local plasmaContainer = Instance.new("Folder")
	plasmaContainer.Name = "PlasmaGui"
	local plasmaNode = Plasma.new(plasmaContainer)

	local parent
	if options.client then
		parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	else
		parent = ReplicatedStorage
	end
	plasmaContainer.Parent = parent

	if options.debugger then
		matterDebugger.Parent = parent
	end

	local seenEvents: { [string]: true } = {}
	local eventOrder: { string } = {}

	-- This should be a ContinueHandle, see type above.
	local continueHandle: unknown?

	return function(nextFn: () -> (), eventName: string)
		if not seenEvents[eventName] then
			seenEvents[eventName] = true
			table.insert(eventOrder, eventName)
		end

		if eventName == eventOrder[1] then
			continueHandle = Plasma.beginFrame(plasmaNode, function()
				if options.debugger and options.debugger.enabled then
					Plasma.setEventCallback(function(...)
						return options.debugger._eventBridge:connect(...)
					end)

					Plasma.portal(matterDebugger, function()
						options.debugger:update()
					end)
				end

				nextFn()
			end)
		elseif continueHandle then
			Plasma.continueFrame(continueHandle, function()
				if options.debugger and options.debugger.enabled then
					Plasma.setEventCallback(function(...)
						return options.debugger._eventBridge:connect(...)
					end)
				end

				nextFn()
			end)
		else
			-- warn("MatterPlasma: Received event out of order, skipping")
			nextFn()
		end

		if eventName == eventOrder[#eventOrder] then
			Plasma.finishFrame(plasmaNode)
		end
	end
end

return {
	create = createMiddleware,
}
