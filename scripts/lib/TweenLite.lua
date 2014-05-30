local TweenLite = class("TweenLite")
local scheduler = require("framework.scheduler")
Easing = {
    Linear = function(t,b,c,d)  return c*t/d + b end,
    Quad = {
        easeIn = function(t,b,c,d)
            t=t/d
            return c*t*t + b
        end,
        easeOut = function(t,b,c,d)
            t = t/d
            return -c *t*(t-2) + b
        end,
        easeInOut = function(t,b,c,d)
            t=t/(d/2)
            if t < 1 then
                return c/2*t*t + b
            end
            t = t-1
            return -c/2 * (t*(t-2) - 1) + b
        end
    },
    Cubic = {
        easeIn = function(t,b,c,d)
            t = t/d
            return c*t*t*t + b;
        end,
        easeOut = function(t,b,c,d)
            t=t/d-1
            return c*(t*t*t + 1) + b
        end,
        easeInOut = function(t,b,c,d)
            t=t/(d/2)
            if t < 1 then return c/2*t*t*t + b end
            t = t-2
            return c/2*(t*t*t + 2) + b
        end
    },
    Quart = {
        easeIn = function(t,b,c,d)
            t = t/d
            return c*t*t*t*t + b
        end,
        easeOut = function(t,b,c,d)
            t = t/d-1
            return -c * (t*t*t*t - 1) + b
        end,
        easeInOut = function(t,b,c,d)
            t = t/(d/2)
            if t < 1 then return c/2*t*t*t*t + b end
            t = t-2
            return -c/2 * (t*t*t*t - 2) + b
        end
    },
    Quint = {
        easeIn = function(t,b,c,d)
            t = t/d
            return c*t*t*t*t*t + b
        end,
        easeOut = function(t,b,c,d)
            t = t/d-1
            return c*(t*t*t*t*t + 1) + b
        end,
        easeInOut = function(t,b,c,d)
            t = t/(d/2)
            if t < 1 then return c/2*t*t*t*t*t + b end
            t = t-2
            return c/2*(t*t*t*t*t + 2) + b
        end
    },
    Sine = {
        easeIn = function(t,b,c,d)
            return -c * math.cos(t/d * (math.pi/2)) + c + b
        end,
        easeOut = function(t,b,c,d)
            return c * math.sin(t/d * (math.pi/2)) + b
        end,
        easeInOut = function(t,b,c,d)
            return -c/2 * (math.cos(math.pi*t/d) - 1) + b
        end
    },
    Expo = {
        easeIn = function(t,b,c,d)
            if t == 0 then
                return b
            else
                return c * math.pow(2, 10 * (t/d - 1)) + b
            end
        end,
        easeOut = function(t,b,c,d)
            if t == d then
                return b+c
            else
                return c * (-math.pow(2, -10 * t/d) + 1) + b
            end
        end,
        easeInOut = function(t,b,c,d)
            if t==0 then return b end
            if t==d then return b+c end
            t = t/(d/2)
            if t < 1 then return c/2 * math.pow(2, 10 * (t - 1)) + b end
            return c/2 * (-math.pow(2, -10 * (t-1)) + 2) + b
        end
    },
    Circ = {
        easeIn = function(t,b,c,d)
            t = t/d
            return -c * (math.sqrt(1 - t*t) - 1) + b
        end,
        easeOut = function(t,b,c,d)
            t=t/d-1
            return c * math.sqrt(1 - t*t) + b
        end,
        easeInOut = function(t,b,c,d)
            t = t/(d/2)
            if t < 1 then return -c/2 * (math.sqrt(1 - t*t) - 1) + b end
            t=t-2
            return c/2 * (math.sqrt(1 - t*t) + 1) + b
        end
    },
    Elastic = {
        easeIn = function(t,b,c,d,a,p)
            if t==0 then return b end
            t = t/d
            if t==1 then return b+c end
            if not p then p=d*.3 end
            if (not a or a < math.abs(c))then
                a=c
                s=p/4
            else
                s = p/(2*math.pi) * math.asin (c/a)
            end
            t = t-1
            return -(a*math.pow(2,10*t) * math.sin( (t*d-s)*(2*math.pi)/p )) + b;
        end,
        easeOut = function(t,b,c,d,a,p)
            if t==0 then return b end
            t = t/d
            if t == 1 then return b+c end
            if not p then p=d*.3 end
            if not a or a < math.abs(c) then
                a=c
                s=p/4
            else
                s = p/(2*math.pi) * math.asin (c/a)
            end
            return (a*math.pow(2,-10*t) * math.sin( (t*d-s)*(2*math.pi)/p ) + c + b)
        end,
        easeInOut = function(t,b,c,d,a,p)
            if t==0 then return b end
            t=t/(d/2)
            if t == 2 then return b+c end
            if not p then p=d*(.3*1.5) end
            if not a or a < math.abs(c) then
                a=c
                s = p/4
            else
                s = p/(2*math.pi) * math.asin (c/a)
            end
            if t < 1 then t=t-1  return -.5*(a*math.pow(2,10*t) * math.sin( (t*d-s)*(2*math.pi)/p )) + b end
            t=t-1
            return a*math.pow(2,-10*t) * math.sin( (t*d-s)*(2*math.pi)/p )*.5 + c + b
        end
    },
    Back = {
        easeIn = function(t,b,c,d,s)
            if type(s) == "nil" then s = 1.70158 end
            t=t/d
            return c*t*t*((s+1)*t - s) + b
        end,
        easeOut = function(t,b,c,d,s)
            if type(s) == "nil" then s = 1.70158 end
            t=t/d-1
            return c*(t*t*((s+1)*t + s) + 1) + b;
        end,
        easeInOut = function(t,b,c,d,s)
            if type(s) == "nil" then s = 1.70158 end
            t=t/(d/2)
            if t < 1 then s=s*1.525 return c/2*(t*t*((s+1)*t - s)) + b end
            t=t-2
            s=s*1.525
            return c/2*(t*t*((s+1)*t + s) + 2) + b
        end
    },
    Bounce = {
        easeIn = function(t,b,c,d)
            return c - Easing.Bounce.easeOut(d-t, 0, c, d) + b
        end,
        easeOut = function(t,b,c,d)
            t=t/d
            if t < (1/2.75) then
                return c*(7.5625*t*t) + b
            elseif t < (2/2.75) then
                t=t-(1.5/2.75)
                return c*(7.5625*t*t + .75) + b
            elseif t < (2.5/2.75) then
                t=t-(2.25/2.75)
                return c*(7.5625*t*t + .9375) + b
            else
                t=t-(2.625/2.75)
                return c*(7.5625*t*t + .984375) + b
            end
        end,
        easeInOut = function(t,b,c,d)
            if t < d/2 then return Easing.Bounce.easeIn(t*2, 0, c, d) * .5 + b
            else return Easing.Bounce.easeOut(t*2-d, 0, c, d) * .5 + c*.5 + b end
        end
    }
}
setAttrValue = {
    x = function(target,value) target:setPositionX(value) end,
    y = function(target,value) target:setPositionY(value) end,
    w = function(target,value) target:setScaleX(value/target:getContentSize().width) end,
    h = function(target,value) target:setScaleY(value/target:getContentSize().height) end,
    wh = function(target,value) target:setScale(value/target:getContentSize().width) end,
    hw = function(target,value) target:setScale(value/target:getContentSize().height) end,
    opacity = function(target,value) target:setOpacity(value) end,
    rotate = function(target,value) target:setRotation(value) end
}
getAttrValue = {
    x = function(target) return target:getPositionX() end,
    y = function(target) return target:getPositionY() end,
    w = function(target) return target:getContentSize().width end,
    h = function(target) return target:getContentSize().height end,
    wh = function(target) return getAttrValue.w(target) end,
    hw = function(target) return getAttrValue.h(target) end,
    opacity = function(target) return target:getOpacity() end,
    opacity = function(target) return target:getOpacity() end,
    rotate = function(target) return target:getRotation() end
}
function test(a)
    function test2(a)
        function test3(a)
            print(a)
            scheduler.performWithDelayGlobal(function() test2(a) end,0)
        end
        test3(a)
    end
    test2(a)
end

--test(1111)
--test(2222)
function TweenLite:start(target,duration,vars,ease,delay,onComplete,onUpdate)
    if not target then return false end
    local speed = duration
    if type(ease) == "nil" then
        ease = Easing.Linear
    end
    local ifstop = false
    local attrArr = {}
    local curArr = {}
    local initArr = {}
    for i in pairs(vars) do
        if type(getAttrValue[i]) ~= "nil" then
            if i == "opacity" then if vars[i] > 255 then vars[i] = 255 elseif vars[i] < 0 then vars[i] = 0 end end
            local atObj = getAttrValue[i](target)
            table.insert(initArr,atObj)
            table.insert(attrArr,i)
            table.insert(curArr,vars[i])
        end
    end
    local function run()
        local s = os.clock() * 1.5
        local function callee()
            local t = os.clock() * 1.5 - s
            for i=1,#attrArr do
                local easeVars = ease(t,initArr[i],curArr[i]-initArr[i],speed)
                if(attrArr[i] == "opacity") then
                    if easeVars > 255 then easeVars = 255-(easeVars-255) elseif easeVars < 0 then easeVars = 0 end
                    setAttrValue[attrArr[i]](target,easeVars)
                else
                    setAttrValue[attrArr[i]](target,easeVars)
                end
            end
            --if type(target.timer) ~= "nil" then scheduler.unscheduleGlobal(target.timer) end
            if t < speed then
                scheduler.performWithDelayGlobal(callee,0)
                if type(onUpdate) ~= "nil" then  onUpdate() end
            else
                if not ifstop then
                    ifstop = true
                    --if type(target.timer) ~= "nil" then scheduler.unscheduleGlobal(target.timer) end
                    for i=1,#attrArr do
                        setAttrValue[attrArr[i]](target,curArr[i])
                    end
                    if type(onComplete) ~= "nil" then
                        onComplete()
                    end
                end
            end
        end
        callee()
    end
    if type(delay) ~= "nil" then
        --if type(target.delay) ~= "nil" then scheduler.unscheduleGlobal(target.delay) end
        target.delay = scheduler.performWithDelayGlobal(run,delay)
    else
        run()
    end
end
return TweenLite

