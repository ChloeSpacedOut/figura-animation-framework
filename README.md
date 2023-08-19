# figura-animation-framework

A framework that allows easy, keyframeable, and layerable script-based animations. Both a fully-featured and lightweight version is available. The bone controller can also be used independantly as its own framework for making functions from the model api layerable. E.g. setPos(), setRot(), setScale(), etc. Most of this was originally created for the prewrite before the animation API, but was ported for rewrite. Since we have the animation API now, this is mostly redundant. It's best to use the build in animation framework in almost every scenario :p. I'm only posting this for archive, and in an edge case where someone might need this.

**USAGE:**
__Initialisation__
If you're using the fully-featured version, simply put `bone_controller.lua` and `animation_framework.lua` inside your avatar's folder and then at the top of your script type `require("animation_framework")`. If you're using the lightweight version, just put `animation_framework_lightweight.lua`  inside your avatar's folder and type `require("animation_framework_lightweight")`.
__Framerate__
You might want to customise the framerate. Because this framework caches animation values to save render instructions, there is a limit on how smooth the animation can be. Don't be tempted to set this value to 99999999999 though. The higher FPS value you have set, the more the longer it will take to render and store. The smaller, the faster and less storage (but less smooth). You can customise the framework in the animation_framework.lua file.

Ok, with that done, you can now just use the functions provided by the framework inside a registered render function (with delta). I'll now I'll go into the things commonly used inside the framework and explain them.

__bbmodel__
'bbmodel' is the name of the blockbench model you're referring to. For example, "my_model".
__boneName__
'boneName' is the NAME of your bone part, NOT THE PATH. For example, "eyebrow", NOT "model.head.eyebrow". Note, if you're referring to a cube/mesh and not a group, and so they have the same name, it'll apply to all parts with that name. This is handy, but can also be annoying, so name your cubes differently or animate with groups.
__layer__
So, this framework supports layers. This allows you to play multiple animations at once using the same model part. 'layer' is simply used as an identifier for combining the animations. You can name this what ever you want, as long as it's a string, and if your animations have different layer names, then it'll work. For example, "Running_Anim"
__type__
This is the type of animation you're using. This frameworks supports a lot more then just position, scale, and rotation. You can use setUV(), setColor(), setOpacity(), and much more. Go wild! Just not too wild. setEnabled() is a boolean. I'm looking at you Dragekk. For this, it's just a string with the type from the model API used inside it. For example, "setPos" or "setRot".
__Speed__
The speed of the animation. This is just an integer. 1 is default. If you set this to negative, the animation will play backwards. Note, that playing at half speed also plays at half FPS, since it's cached, and do doesn't re-render it. 
__Offset__
Just an offset. Shifts the animation forward in time if positive, and backwards if negative. This value is in ticks, so 20 is one second. This is an integer if it wasn't obvious.
__Mod__
A modifier that is applied to the entire animation. Default is 1. I literally only added this so I could make animations that smoothly blend together on a model I'm working on. Once again, an integer.
__Keyframes__
There's three values associated with this: 'startTick', 'endTick', and 'finalTick'. 'startTick' is the tick that your animation will begin playing, and end is when it will end. 'finalTick' is at what tick you want the animation to loop. In most cases, you want this to always be the same across a single animation, so that everything loops together. So, for example, if I had an animation that was 80 ticks long, and I wanted a specific movement to start 20 ticks in and end at 50, 'startTick' would be 20, 'endTick' would be 50, and 'lastTick' would be 80. These are integers. Obviously.
__Delta__
Type delta here. No quotation marks, it's a variable. So just delta. As long as your animation is inside of render(delta), or world_render(delta), this'll work fine.

**DEFAULT ANIMATION FUNCTIONS**
__Linear Interpolation (lerp_anim)__
Allows you to animate a part linearly from one value to another. startValue and endValue are both tables.
Here's a Desmos graph if you'd like a visual representation of how the maths works: https://www.desmos.com/calculator/duycpn9zuo
Its syntax is: `lerp_anim(bbmodel,boneName,type,layer,speed,offset,mod,startTick,endTick,lastTick,startValue,endValue,delta)`. For example:
```lua
lerp_anim("my_model","part","setRot","exampleLayer",1,0,1,0,10,20,{0,180,0},{90,0,0},delta)
```
__Cubic Interpolation (cerp_anim)__
Allows you to animate a part with smooth, tasty animations through the power of maths! startValue, endValue, startVel, and endVel are all tables! I won't get into the maths on what the vel actually does, so just think of it as how quickly you want that part to be moving when the animation starts or ends. At 0, it comes to a complete stop. At 1, it's moving at a constant speed. At 2, double. Etc.
Here's a Desmos graph if you'd like a visual representation of how the maths works: https://www.desmos.com/calculator/230xbfexbp
Its syntax is: `cerp_anim(bbmodel,bonePath,type,layer,speed,offset,mod,startTick,endTick,lastTick,startValue,endValue,startVel,endVel,delta)` For example:
```lua
cerp_anim("my_model","part","setRot","exampleLayer",1,0,1,0,10,20,{0,180,0},{90,0,0},{0,1,0},{1,0,0},delta)
```
__Wave Animations (wave_anim)__
Allows you to animate using sin waves. The syntax has changed for this since 2.0 to make it easier to use. Now, instead of worrying about amplitude and vertical shift, you can just put in the minimum and maximum value, and it does it all for you :3
NOTE: do **NOT** set the period to 0, IT WILL BREAK. This isn't an issue with the framework, this is just maths.
Also, if you swap around the max and the min, it'll just treat the smaller one as the minimum. Sorry. Use the phase shift if you want the inverse of the wave.
Period, Phase Shift, Min Value, and Max Value are all tables. Don't forget! Also this now has keyframes to fix an issue with the animation caching. Make sure the period and the lastTick all match up!
Here's a Desmos graph if you'd like a visual representation of how the maths works: https://www.desmos.com/calculator/ngqpqxzykv
Its syntax is: `wave_anim(bbmodel,boneName,layer,type,speed,offset,mod,startTick,endTick,lastTick,period,phaseShift,minValue,maxValue,delta)` For example:
```lua
wave_anim("my_model","part","setRot","exampleLayer",1,0,1,0,10,20,{0,180,90},{20,20,20},{0,10,2.3},{0,90,0},delta)
```
__Constant Animations (const_anim)__
Simply allows you to use the keyframe functionality with a still fame. This is actually very useful for texture animations! It doesn't have to be for texture animations though.
Its syntax is: `const_anim(bbmodel,boneName,layer,type,speed,offset,mod,startTick,endTick,lastTick,period,phaseShift,minValue,maxValue,delta)` For example:
```lua
const_anim("my_model","part","setRot","exampleLayer",1,0,1,0,10,20,{90,0,0},delta)
```
**MANUAL CLOCK VARIENTS**
These are variants which don't have their own built in clocks, and so you have more control over how the animation plays. 'Speed', 'lastTick' and 'delta' are all removed, and 'externalClock' is added. This is a variable you would make. It's important to note, if your don't want looping animations, ensure you actually STOP the clock, or you will cache a bunch of useless frames and your avatar will probably eventually crash. Same with the wave animation. Make the clock loop. Also, since delta isn't required, you can use this in a registered tick function if you want. It just might be best to modify the bone controller to also only run on tick if you do that :p
The modified functions are as follows:
`lerp_MCanim(bbmodel,boneName,layer,type,externalClock,offset,mod,startTick,endTick,startValue,endValue)`
`cerp_MCanim(bbmodel,boneName,layer,type,externalClock,offset,mod,startTick,endTick,startValue,endValue,startVel,endVel)`
`wave_MCanim(bbmodel,boneName,layer,type,externalClock,offset,mod,startTick,endTick,period,phaseShift,minValue,maxValue)`
`const_MCanim(bbmodel,boneName,layer,type,externalClock,offset,mod,startTick,endTick,value)`
