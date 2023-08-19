require("bone_controller")
framerate = 120 -- In frames per second. Feel free to tweak this if you want
animationClock = 0
events.TICK:register(function() animationClock = animationClock + 1 end)

---------------Fooni code by a very amazing puppy <3 -----------------
animationCache = {}
metaAnimationCache = {__index = function (t,v)
    t[v] = {}
    setmetatable(t[v], metaAnimationCache)
    return t[v]
end}
setmetatable(animationCache, metaAnimationCache)
----------------------------------------------------------------------

function lerp_anim(bbmodel,boneName,type,layer,speed,offset,mod,startTick,endTick,lastTick,startValue,endValue,delta)
    local clock = (animationClock+offset+delta)*speed % lastTick
    if clock > startTick and clock < endTick then
        if table.empty(animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]) == true then
            local value = math.lerp(startValue,endValue,((clock-startTick))/((endTick-startTick)))
            bone[bbmodel][boneName][type][layer] = value*mod
            animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)] = value
        else
            bone[bbmodel][boneName][type][layer] = animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]*mod
        end
    end
end

function lerp_MCanim(bbmodel,boneName,type,layer,externalClock,offset,mod,startTick,endTick,startValue,endValue)
    local clock = externalClock + offset
    if clock > startTick and clock < endTick then
        if table.empty(animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]) == true then
            local value = math.lerp(startValue,endValue,((clock-startTick))/((endTick-startTick)))
            bone[bbmodel][boneName][type][layer] = value*mod
            animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)] = value
        else
            bone[bbmodel][boneName][type][layer] = animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]*mod
        end
    end
end
    
function cerp_anim(bbmodel,boneName,type,layer,speed,offset,mod,startTick,endTick,lastTick,startValue,endValue,startVel,endVel,delta)
    local clock = (animationClock+offset+delta)*speed % lastTick
    if clock > startTick and clock < endTick then
        if table.empty(animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]) == true then
            local value = startValue+(endValue-startValue)*(cerp(0,1,startVel,endVel,((clock-startTick))/((endTick-startTick))))
            bone[bbmodel][boneName][type][layer] = value*mod
            animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)] = value
        else
            bone[bbmodel][boneName][type][layer] = animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]*mod
        end
    end
end
  
function cerp_MCanim(bbmodel,boneName,type,layer,externalClock,offset,mod,startTick,endTick,startValue,endValue,startVel,endVel)
    local clock = externalClock + offset
    if clock > startTick and clock < endTick then
        if table.empty(animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]) == true then
            local value = startValue+(endValue-startValue)*(cerp(0,1,startVel,endVel,((clock-startTick))/((endTick-startTick))))
            bone[bbmodel][boneName][type][layer] = value*mod
            animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)] = value
        else
            bone[bbmodel][boneName][type][layer] = animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]*mod
        end
    end
end
    
function wave_anim(bbmodel,boneName,type,layer,speed,offset,mod,startTick,endTick,lastTick,period,phaseShift,minValue,maxValue,delta)
    local clock = (animationClock+offset+delta)*speed % lastTick
    if clock > startTick and clock < endTick then
        if table.empty(animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]) == true then
            local amplitude = vec(math.abs((maxValue[1]-minValue[1])/2),math.abs((maxValue[2]-minValue[2])/2),math.abs((maxValue[3]-minValue[3])/2))
            local verticalShift = vec((minValue[1]+maxValue[1])/2,(minValue[2]+maxValue[2])/2,(minValue[3]+maxValue[3])/2)
            local value = amplitude* vec(math.sin((2*math.pi*(clock+phaseShift[1]))/period[1]),math.sin((2*math.pi*(clock+phaseShift[2]))/period[2]),math.sin((2*math.pi*(clock+phaseShift[3]))/period[3]))+verticalShift
            bone[bbmodel][boneName][type][layer] = value*mod
            animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)] = value
        else
            bone[bbmodel][boneName][type][layer] = (animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)])*mod
        end
    end
end
  
function wave_MCanim(bbmodel,boneName,type,layer,externalClock,offset,mod,startTick,endTick,period,phaseShift,minValue,maxValue)
    local clock = externalClock + offset
    if clock > startTick and clock < endTick then
        if table.empty(animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)]) == true then
            local amplitude = vec(math.abs((maxValue[1]-minValue[1])/2),math.abs((maxValue[2]-minValue[2])/2),math.abs((maxValue[3]-minValue[3])/2))
            local verticalShift = vec((minValue[1]+maxValue[1])/2,(minValue[2]+maxValue[2])/2,(minValue[3]+maxValue[3])/2)
            local value = amplitude* vec(math.sin((2*math.pi*(clock+phaseShift[1]))/period[1]),math.sin((2*math.pi*(clock+phaseShift[2]))/period[2]),math.sin((2*math.pi*(clock+phaseShift[3]))/period[3]))+verticalShift
            bone[bbmodel][boneName][type][layer] = value*mod
            animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)] = value
        else
            bone[bbmodel][boneName][type][layer] = (animationCache[bbmodel][boneName][type][layer][math.floor(clock*framerate/20)])*mod
        end
    end
end
    
function const_anim(bbmodel,boneName,type,layer,speed,offset,mod,startTick,endTick,lastTick,value,delta)
    local clock = (world.getTime()+offset+delta)*speed % lastTick
    if clock > startTick and clock < endTick then
        bone[bbmodel][boneName][type][layer] = vec(value[1]*mod,value[2]*mod,value[3]*mod)
    end
end
  
function const_MCanim(bbmodel,boneName,type,layer,externalClock,offset,mod,startTick,endTick,value)
    local clock = externalClock + offset
    if clock > startTick and clock < endTick then
        bone[bbmodel][boneName][type][layer] = vec(value[1]*mod,value[2]*mod,value[3]*mod)
    end
end

function table.empty (self)
    if type(self) == 'table' then
        return true
    else
        return false
    end
end

function cerp(p0,p1,m0,m1,x)
    return (2*x^3-3*x^2+1)*p0+(x^3-2*x^2+x)*m0+(-2*x^3+3*x^2)*p1+(x^3-x^2)*m1
end