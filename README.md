Been a while since my last public release huh. Well I didn't want to release same random thing so it took a little bit of time. 

Voltlab hacking is one of the missions on the latest Cayo Perico DLC. Player has to match the randomly generated numbers on left with the icons on right to achieve the target voltage to successfuly hack. Each pattern is randomly generated to prevent any repetition.

**This isn't a drag-n-drop resource and developers need to intergrate the resource in thier own scripts.**

**Usage:**

```
	TriggerEvent('ultra-voltlab', time, function(result,reason)
	-- time: Time in seconds which player has. Min is 10, Max is 60
	-- result: Reason is the reason of result. Result is an integer code which represents result.
	-- 	   0: Hack failed by player
	-- 	   1: Hack successful
	-- 	   2: Time ran out and hack failed
	-- 	  -1: Error occured i.e. passed input or contents in config is wrong
		if result == 0 then
			print('Hack failed', reason)
		elseif result == 1 then
			print('Hack successful')
		elseif result == 2 then
			print('Timed out')
		elseif result == -1 then
			print('Error occured',reason)
		end
	end)
```

**Controls:** Up or down key to move left selection. Left or right key to move right selection. Enter to confirm the selection/connection which is non-revertible. Green bars at bottom left represent the time left.
