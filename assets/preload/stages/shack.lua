function onCreate()
	-- background shit
	makeLuaSprite('wall', 'shop', -1350, -500);
	setScrollFactor('wall', 1, 1);
	scaleObject('wall', 1, 1);

	addLuaSprite('wall', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end