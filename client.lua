local DrawSprite = DrawSprite
local DrawRect = DrawRect

local isHackActive = false
local isCallbackSent = false
local callbackFn

local activeNumberNode = 1
local activeCircleNode = 0

local generatedNumbers = {}

local targetVoltage = 0
local targetVoltageTable = {}

local resultVoltage = 0
local resultVoltageString = {0,0,0}

local occupiedCircleNodes = {}
local confirmedNodes = {} 

local countDownTime = 6
local isSuccess = nil

local circlNodeColor = {
	{250, 172, 54},
	{247, 49, 49},
	{58, 53, 212}
}

local resultTextColor = {
	{191, 191, 191},
	{88, 204, 102}
}
local resultAlpha = 255

local connectedNodeAlpha = {
	255,
	255,
	255
}

local iconName = {
	'Icons__x1',
	'Icons__x2',
	'Icons__x3',
	'Icons__x5',
	'Icons__x10',
	'Icons__x15'
}

local timerUI = {
	{0.383, 0.815, 0.0145, 0.05},
	{0.373, 0.815, 0.0145, 0.05},
	{0.363, 0.815, 0.0145, 0.05},
	{0.353, 0.815, 0.0145, 0.05},
	{0.343, 0.815, 0.0145, 0.05},
	{0.333, 0.815, 0.0145, 0.05},

}

local nodePaths = {

	['1'] = {
		['1'] = {
				['square1'] = {0.324, 0.307,0.006, 0.01},
				['square2'] = {0.658, 0.307,0.006, 0.01},
				
				['line'] = {0.49, 0.307, 0.33, 0.004} -- 1:1 line
		},
		
		['2'] = {
				['square1'] = {0.324, 0.307, 0.006, 0.01},
				['sqaure2'] = {0.49, 0.307,0.007, 0.0135},
				['square3'] = {0.49, 0.501, 0.007, 0.0128},
				['square4'] = {0.657, 0.501, 0.007, 0.0128},
				
				['line1'] = {0.407, 0.307, 0.16, 0.004}, -- line1
				['line2'] = {0.4905, 0.404, 0.002, 0.18}, -- line2
				['line3'] = {0.574, 0.501, 0.16, 0.004} -- line3
		},
		
		['3'] = {
			['square1'] = {0.324, 0.307,0.007, 0.0128, 250, 172, 54, 255},
			['square2'] = {0.397, 0.307,0.007, 0.0128, 250, 172, 54, 255},
			['square3'] = {0.397, 0.502,0.007, 0.0128, 250, 172, 54, 255},
			['square4'] = {0.49, 0.502,0.007, 0.0128, 250, 172, 54, 255},
			['square5'] = {0.49, 0.694,0.007, 0.0128, 250, 172, 54, 255},
			['square6'] = {0.657, 0.694,0.007, 0.0128, 250, 172, 54, 255},
			
			['line1'] = {0.36, 0.307, 0.07, 0.004, 250, 172, 54, 255}, --line1
			['line2'] = {0.3965, 0.404, 0.002, 0.182, 250, 172, 54, 255}, -- vertical line1
			
			['line3'] = {0.445, 0.502, 0.09, 0.004, 250, 172, 54, 255}, -- line2
			['line4'] = {0.4905, 0.598, 0.002, 0.182, 250, 172, 54, 255}, -- vertical line2
			
			['line5'] = {0.574, 0.694, 0.16, 0.004, 250, 172, 54, 255} -- line3
		}
	},
	
	['2'] = {
		['1'] = {
			['square1'] = {0.324, 0.5,0.006, 0.01},
			['square2'] = {0.46, 0.5,0.007, 0.01281},
			['square3'] = {0.46, 0.39,0.007, 0.01281},
			['square4'] = {0.551, 0.39,0.007, 0.01281},
			['square5'] = {0.551, 0.307,0.007, 0.01281},
			['square6'] = {0.658, 0.307,0.006, 0.01},
			
			['line1'] = {0.392, 0.5, 0.129, 0.0035},
			['line2'] = {0.46, 0.444, 0.003, 0.1}, -- vertical 1
			['line3'] = {0.508, 0.39, 0.09, 0.004},
			['line4'] = {0.508, 0.39, 0.09, 0.0025}, -- vertical 2
			['line5'] = {0.605, 0.307, 0.108, 0.004},
			['line6'] = {0.551, 0.35, 0.0025, 0.08} -- vertical 3
		},
		
		['2'] = {
			['square1'] = {0.324, 0.5,0.006, 0.01},
			['square2'] = {0.657, 0.5,0.006, 0.01},
			
			['line1'] = {0.49, 0.5, 0.33, 0.004} -- 2:2 line
		},
		
		['3'] = {
			['square1'] = {0.324, 0.5,0.006, 0.01},
			['square2'] = {0.429, 0.5,0.007, 0.01281},
			['square3'] = {0.429, 0.694,0.007, 0.01281},
			['square4'] = {0.657, 0.694,0.007, 0.01281},
			
			['line1'] = {0.376, 0.5, 0.1, 0.0035},
			['line2'] = {0.429, 0.6, 0.003, 0.2}, -- vertical 1
			['line3'] = {0.543, 0.694, 0.22, 0.0035}
		}
	},
	
	['3'] = {
		['1'] = {
			['square1'] = {0.324, 0.694,0.006, 0.01},
			['square2'] = {0.521, 0.694,0.007, 0.01281},
			['square3'] = {0.521, 0.61,0.007, 0.01281},
			['square4'] = {0.582, 0.61,0.007, 0.01281},
			['square5'] = {0.582, 0.3085,0.007, 0.01281},
			['square6'] = {0.6565, 0.307,0.007, 0.01281},
			
			['line1'] = {0.421, 0.694, 0.19, 0.0035},
			['line2'] = {0.521, 0.652, 0.00222, 0.074}, --vertical 2
			
			['line3'] = {0.55, 0.61, 0.06, 0.0035},
			['line4'] = {0.582, 0.46, 0.00222, 0.29}, --vertical 2
			
			['line5'] = {0.62, 0.307, 0.07, 0.0035}
		},
		
		['2'] = {
			['sqaure1'] = {0.324, 0.694,0.006, 0.01},
			['sqaure2'] = {0.521, 0.694,0.007, 0.01281},
			['sqaure3'] = {0.521, 0.61,0.007, 0.01281},
			['sqaure4'] = {0.582, 0.61,0.007, 0.01281},
			['sqaure5'] = {0.582, 0.5,0.007, 0.01281},
			['sqaure6'] = {0.6565, 0.5,0.007, 0.01281},
			
			['line1'] = {0.421, 0.694, 0.19, 0.0035},
			['line2'] = {0.521, 0.652, 0.00222, 0.074}, --vertical 2
			
			['line3'] = {0.55, 0.61, 0.06, 0.0035},
			['line4'] = {0.582, 0.55, 0.00222, 0.11}, --vertical 2
			
			['line5'] = {0.62, 0.5, 0.07, 0.0035}
		},
		
		['3'] = {
			['square1'] = {0.324, 0.694,0.006, 0.01},
			['square2'] = {0.6565, 0.694,0.007, 0.01281},
			
			['line1'] = {0.49, 0.694, 0.33, 0.0035} -- 3:3 line
		}
	}


}


-- Main game logic

local function shuffle(t) --Utility function
	local tbl = {}
	for i = 1, #t do
	  tbl[i] = t[i]
	end
	for i = #tbl, 2, -1 do
	  local j = math.random(i)
	  tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end


local function getTableSize(t) --Utility function
	local count = 0
	for _, __ in pairs(t) do
		count = count + 1
	end
	return count
end


local function playSound(audioName,audioRef)
	PlaySoundFrontend(-1 , audioName,audioRef, true)
end


local function generateTargetVoltage()
	targetVoltage = 0
	for i=1,3 do
		generatedNumbers[i] = math.random(1,8)
	end

	for i=1,3 do
		targetVoltage = targetVoltage + (generatedNumbers[i] * iconValues[i])
	end
end


local function updateResultVoltage(volt)
	volt = volt or resultVoltage
	local resultVoltage = tostring(volt)
	
	if string.len(resultVoltage) < 3 then
		for i=1,(3 - string.len(resultVoltage)) do
			resultVoltage = '0' .. resultVoltage
		end
	end
	
	for i = 1,3 do
		resultVoltageString[i] = resultVoltage:sub(i, i)
	end
end

local function formatTargetVoltage()
	local voltageString = tostring(targetVoltage)
	
	if string.len(voltageString) < 3 then
		for i=1,(3 - string.len(voltageString)) do
			voltageString = '0' .. voltageString
		end
	end
	
	for i = 1,3 do
		targetVoltageTable[i] = voltageString:sub(i, i)
	end
end

-- Load audio and texture stuff

local requiredTxd = {'MPIsland_Voltage', 'MPIsland_Voltage_BG'}
local requiredAudioBank = 'DLC_HEI4\\DLC_HEI4_V_MG'
local requiredAudioBank2 = 'DLC_HEI4\\DLC_HEI4_FH_MG'

for i=1,#requiredTxd do
	RequestStreamedTextureDict(requiredTxd[i], false)
end

RequestScriptAudioBank(requiredAudioBank, false, -1)
RequestScriptAudioBank(requiredAudioBank2, false, -1)

CreateThread(function()


	for i=1,#requiredTxd do
		while not HasStreamedTextureDictLoaded(requiredTxd[i]) do
			Wait(10)
		end
	end
end)
local function drawRect(x, y, w, h, r, g, b, a )
	DrawRect(x,y,w,h,r,g,b,a)
end

local function drawSprite(txd, txName, screenX, screenY, width, height, head, red, green, blue, alpha)
	DrawSprite(txd, txName, screenX, screenY, width, height, head, red, green, blue, alpha)
end


function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 194, true))
    ButtonMessage("Abort Hack")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 191, true))
    ButtonMessage("Confirm selection (Irrevertible)")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 307, true))
	Button(GetControlInstructionalButton(2, 308, true))
	Button(GetControlInstructionalButton(2, 299, true))
	Button(GetControlInstructionalButton(2, 300, true))
	ButtonMessage("Select")
	PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end


AddEventHandler("ultra-voltlab", function(time, returnFn)

	--Reset previous data
	isCallbackSent = false
	occupiedCircleNodes = {}
	confirmedNodes = {} 
	activeNumberNode = 1
	activeCircleNode = 0
	countDownTime = 6

	callbackFn = returnFn
	local time = tonumber(time)
	timer = time
	
	if time < 10 or time > 60 then
		callbackFn(-1,'Entered time is out of range')
		isCallbackSent = true
		return
	end



	generateTargetVoltage() -- Generate random voltage target level
	formatTargetVoltage() -- Format target voltage to 3 digit string

	-- Ensure that generated target is within limits 
	while targetVoltage > 999 or targetVoltage <= 0 do
		Wait(10)
		generateTargetVoltage()
	end
	
	-- Randomize index to prevent repetative pattern generations
	generatedNumbers = shuffle(generatedNumbers)
	iconValues = shuffle(iconValues)
	iconName = shuffle(iconName)
	
	local iconValueLimit = 0
	for	i=1,3 do
		iconValueLimit = iconValueLimit + iconValues[i]
	end
	if iconValueLimit > 111 or iconValueLimit <= 0 then
		callbackFn(-1,'Icon values are out of range in config')
		isCallbackSent = true
		return
	end

	formatTargetVoltage()

	
	
	CreateThread(function()
		Wait(100)
		SendNUIMessage({
			type = 'intro'
		})
		playSound('Loading_Bink','DLC_H4_Voltage_Minigame_Sounds')
		isHackActive = true
		
		while isHackActive do 
			Wait(1)

			drawSprite(
				'MPIsland_Voltage_BG', 
				'PHONE_BACKGROUND', 
				0.50, 0.50, 1.0, 1.0, 0, 255, 255, 255, 255
			)				
			
			drawSprite(
				'MPIsland_Voltage_BG', 
				'target_text', 
				0.498, 0.12, 0.04, 0.014, 0,  231, 99, 99, 255
			)

			drawSprite(
				'MPIsland_Voltage_BG', 
				'result_text', 
				0.498, 0.88, 0.04, 0.014, 0,  88, 204, 102, 255
			)
							
			drawSprite(
				'MPIsland_Voltage', 
				'Phone_Icons', 
				0.95, 0.03, 0.08, 0.04, 0, 160, 160, 160, 255
			)
			
			
			-- Main interface
			drawSprite(
				'MPIsland_Voltage', 
				'MainInterface_BG', 
				0.5, 0.5, 0.5, 0.73, 0, 255, 255, 255, 255
			)


			-- Target voltage 
			drawSprite(
				'MPIsland_Voltage', 
				targetVoltageTable[1], 
				0.457, 0.185, 0.03, 0.09, 0, 231, 99, 99, 255
			)
			
			drawSprite(
				'MPIsland_Voltage', 
				targetVoltageTable[2], 
				0.497, 0.185	, 0.03, 0.09, 0, 231, 99, 99, 255
			)
			
			drawSprite(
				'MPIsland_Voltage', 
				targetVoltageTable[3], 
				0.539, 0.185	, 0.03, 0.09, 0, 231, 99, 99, 255
			)

			
			-- Left numbers
			
			drawSprite(
				'MPIsland_Voltage', 
				generatedNumbers[1], 
				0.29, 0.307, 0.03, 0.09, 0, 255, 255, 255, 255
			)
			
			drawSprite(
				'MPIsland_Voltage', 
				generatedNumbers[2], 
				0.29, 0.50, 0.03, 0.09, 0, 255, 255, 255, 255
			)


			drawSprite(
				'MPIsland_Voltage', 
				generatedNumbers[3], 
				0.29, 0.694, 0.03, 0.09, 0, 255, 255, 255, 255
			)
			
			
			-- Right target icons

			drawSprite(
				'MPIsland_Voltage', 
				iconName[1], 
				0.699, 0.307, 0.06, 0.08, 0, 255, 255, 255, 255
			)
			

			drawSprite(
				'MPIsland_Voltage', 
				iconName[2], 
				0.7, 0.503, 0.05, 0.08, 0, 255, 255, 255, 255
			)
			
			
			drawSprite(
				'MPIsland_Voltage', 
				iconName[3], 
				0.7, 0.698, 0.04, 0.06, 0, 255, 255, 255, 255
			)				

				
			-- Result voltage

			local resultColor = 0
			if resultVoltage == targetVoltage then
				resultColor = 2
			else
				resultColor = 1
			end
			drawSprite(
				'MPIsland_Voltage', 
				tostring(resultVoltageString[1]), 
				0.457, 0.815, 0.03, 0.09, 0, resultTextColor[resultColor][1], resultTextColor[resultColor][2], resultTextColor[resultColor][3], resultAlpha
			)
			
			drawSprite(
				'MPIsland_Voltage', 
				tostring(resultVoltageString[2]), 
				0.497, 0.815, 0.03, 0.09, 0, resultTextColor[resultColor][1], resultTextColor[resultColor][2], resultTextColor[resultColor][3], resultAlpha
			)
			
			drawSprite(
				'MPIsland_Voltage', 
				tostring(resultVoltageString[3]), 
				0.539, 0.815, 0.03, 0.09, 0, resultTextColor[resultColor][1], resultTextColor[resultColor][2], resultTextColor[resultColor][3], resultAlpha
			)

			for i=1,countDownTime do
				drawSprite(
					'MPIsland_Voltage', 
					'maininterface_progress_highlight', 
					timerUI[i][1], timerUI[i][2], timerUI[i][3], timerUI[i][4], 0, 88, 204, 102, 255
				)
			end

			-- Track drawing nodes

			if activeNumberNode == 1 then 
				drawSprite(
					'MPIsland_Voltage', 
					'NUMBER_NODE', 
					0.298, 0.307, 0.06, 0.098, 0, 250, 172, 54, 255
				)
			elseif activeNumberNode == 2 then
			
				drawSprite(
					'MPIsland_Voltage', 
					'NUMBER_NODE', 
					0.298, 0.5, 0.06, 0.098, 0, 247, 49, 49, 255
				)
			elseif activeNumberNode == 3 then
			
				drawSprite(
					'MPIsland_Voltage', 
					'NUMBER_NODE', 
					0.298, 0.693, 0.06, 0.098, 0, 58, 53, 212, 255
				)
			end
			
			-- Active circle nodes
			
			if activeCircleNode == 1 then 
				drawSprite(
					'MPIsland_Voltage', 
					'CIRCLE_NODE', 
					0.691, 0.307, 0.078, 0.13, 0, circlNodeColor[activeNumberNode][1], circlNodeColor[activeNumberNode][2], circlNodeColor[activeNumberNode][3], 255
				)
			elseif activeCircleNode == 2 then
			
				drawSprite(
					'MPIsland_Voltage', 
					'CIRCLE_NODE', 
					0.691, 0.5, 0.078, 0.125, 0, circlNodeColor[activeNumberNode][1], circlNodeColor[activeNumberNode][2], circlNodeColor[activeNumberNode][3], 255
				)
			elseif activeCircleNode == 3 then
			
				drawSprite(
					'MPIsland_Voltage', 
					'CIRCLE_NODE', 
					0.691, 0.694, 0.078, 0.125, 0, circlNodeColor[activeNumberNode][1], circlNodeColor[activeNumberNode][2], circlNodeColor[activeNumberNode][3], 255
				)
			end
			
			if activeNumberNode ~= 0 and activeCircleNode ~= 0 then
				for i,k in pairs(nodePaths[tostring(activeNumberNode)][tostring(activeCircleNode)]) do
					if activeNumberNode and activeCircleNode then
						drawRect(k[1],k[2],k[3],k[4],circlNodeColor[activeNumberNode][1], circlNodeColor[activeNumberNode][2], circlNodeColor[activeNumberNode][3], connectedNodeAlpha[activeNumberNode])
					end
				end	
			end	
	
			if getTableSize(confirmedNodes) ~= 0 then
				for index,freezeData in pairs(confirmedNodes) do
					for i,k in pairs(nodePaths[tostring(freezeData[1])][tostring(freezeData[2])]) do
						if freezeData[1] and freezeData[2] then
							drawRect(k[1],k[2],k[3],k[4],circlNodeColor[freezeData[1]][1], circlNodeColor[freezeData[1]][2], circlNodeColor[freezeData[1]][3], connectedNodeAlpha[freezeData[1]])
						end
					end	
				end
			end
	


		end
	end)

	Wait(100) -- Necessary to actiavte the previous thread

	CreateThread(function()
		local tempVoltage = 0
		local totalVoltage = 0
		local form = setupScaleform("instructional_buttons")

		while isHackActive do
			Wait(5)
			DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
			if IsControlJustPressed(0, 172) then -- Arrow UP
				if activeNumberNode > 1 and activeNumberNode < 4 then
					activeNumberNode = activeNumberNode - 1
					playSound('Disconnect_Wire','DLC_H4_Voltage_Minigame_Sounds')
					if activeCircleNode ~= 0 then
						tempVoltage = totalVoltage + generatedNumbers[activeNumberNode] * iconValues[activeCircleNode]
						updateResultVoltage(tempVoltage)
					end
				end
				
			elseif IsControlJustPressed(0, 173) then -- Arrow DOWN
				if activeNumberNode < 3 and activeNumberNode >= 0 then
					activeNumberNode = activeNumberNode + 1
					playSound('Disconnect_Wire','DLC_H4_Voltage_Minigame_Sounds')
					if activeCircleNode ~= 0 then
						tempVoltage = totalVoltage + generatedNumbers[activeNumberNode] * iconValues[activeCircleNode]
						updateResultVoltage(tempVoltage)
					end
				end
				
			elseif IsControlJustPressed(0, 174) then -- Arrow LEFT
				if activeCircleNode > 1 and activeCircleNode < 4 then
					activeCircleNode = activeCircleNode - 1
					playSound('Disconnect_Wire','DLC_H4_Voltage_Minigame_Sounds')
					tempVoltage = totalVoltage + generatedNumbers[activeNumberNode] * iconValues[activeCircleNode]
					updateResultVoltage(tempVoltage)
				end
				
			elseif IsControlJustPressed(0, 175) then -- Arrow RIGHT
				if activeCircleNode < 3 and activeCircleNode >= 0 then
					activeCircleNode = activeCircleNode + 1
					playSound('Disconnect_Wire','DLC_H4_Voltage_Minigame_Sounds')
					tempVoltage = totalVoltage + generatedNumbers[activeNumberNode] * iconValues[activeCircleNode]
					updateResultVoltage(tempVoltage)
				end
			
			elseif IsControlJustPressed(0, 194) then -- backspace

				isSuccess = false
				isHackActive = false
				playSound('Minigame_Failure','DLC_H4_Voltage_Minigame_Sounds')
				SendNUIMessage({
					type = 'fail'
				})
				isCallbackSent = true
				callbackFn(0,'Hack cancelled')

			elseif IsControlJustPressed(0, 191) then -- Enter
				if activeCircleNode ~= 0 then
					if occupiedCircleNodes[tostring(activeCircleNode)] == nil or occupiedCircleNodes[tostring(activeCircleNode)] == false then 	
						if confirmedNodes[tostring(activeNumberNode)] == nil or confirmedNodes[tostring(activeNumberNode)] == false then
							
							local flashcount = 1
							local alpha = 255
							playSound('OS_Draw','DLC_H4_Voltage_Minigame_Sounds')
							CreateThread(function()
								while flashcount > 0 do
									for i=1,#connectedNodeAlpha do
										connectedNodeAlpha[i] = alpha
										if alpha < 255 then
											alpha = alpha + 85
										else
											alpha = alpha - 85
										end
									end
									Wait(100)
								end
								for i=1,#connectedNodeAlpha do
									connectedNodeAlpha[i] = 255
								end
							end)
							Wait(1000)
							flashcount = 0
	
							totalVoltage = totalVoltage + generatedNumbers[activeNumberNode] * iconValues[activeCircleNode]
							resultVoltage = totalVoltage
	
							occupiedCircleNodes[tostring(activeCircleNode)] = true
							confirmedNodes[tostring(activeNumberNode)] = {activeNumberNode, activeCircleNode}
	
							if getTableSize(confirmedNodes) >= 3 then
								if totalVoltage == targetVoltage then
	
									isSuccess = true
									playSound('All_Connected_Correct','DLC_H4_Voltage_Minigame_Sounds')
									local resultFlashCount = 1
									CreateThread(function()
										while resultFlashCount > 0 do
											if resultAlpha < 255 then
												resultAlpha = resultAlpha + 85
											else
												resultAlpha = resultAlpha - 85
											end
											Wait(100)
										end
										resultAlpha = 255
									end)
									Wait(1000)
									resultFlashCount = 0
									playSound('Minigame_Success','DLC_H4_Voltage_Minigame_Sounds')
									SendNUIMessage({
										type = 'success'
									})
									isHackActive = false
									isCallbackSent = true
									callbackFn(1)
								else
									Wait(1000)
									isSuccess = false
									isHackActive = false
									playSound('Minigame_Failure','DLC_H4_Voltage_Minigame_Sounds')
									SendNUIMessage({
										type = 'fail'
									})
									isCallbackSent = true
									callbackFn(0,'Hack failed')
									
								end
							end
						end
					end
				end
			end
		end
	end)


	CreateThread(function()
		Wait(5000)
		local timerWait = timer / 6
		while timer > 0 do
			Wait(timerWait*1000)
			timer = timer - timerWait
			countDownTime = countDownTime - 1
		end 
		Wait(2000)
		if isSuccess == nil then
			isHackActive = false
			playSound('Minigame_Failure','DLC_H4_Voltage_Minigame_Sounds')
			SendNUIMessage({
				type = 'fail'
			})
			if not isCallbackSent then 
				callbackFn(2,'Hack timeout out')
			end
		end
	end)
end)
