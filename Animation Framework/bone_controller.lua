---------------Fooni code by a very amazing puppy <3 -----------------
-- Sets all indexes of 'bone' and 'boneStore' to be {}, making it so you don't need to define each index of the tabe before calling the next
bone = {}
metaBone = {__index = function (t,v)
    t[v] = {}
    setmetatable(t[v], metaBone)
    return t[v]
end}
setmetatable(bone, metaBone)

boneStore = {}
metaBoneStore = {__index = function (t,v)
    t[v] = {}
    setmetatable(t[v], metaBoneStore)
    return t[v]
end}
setmetatable(boneStore, metaBoneStore)
----------------------------------------------------------------------

-- generates a table inside 'boneIndex' for every model file
function generateBoneIndex()
    boneIndex = {}
    for i,v in pairs(models:getChildren()) do
        boneIndex[v:getName()] = {}
        generateBoneIndexLoop(v,v:getName())
    end
end
-- generates a variable with the name of every group, cube and mesh inside each blockbench files, and sets the value to that part's ID
function generateBoneIndexLoop(path,bbfile)
    for i,v in pairs(path:getChildren()) do
        boneIndex[bbfile][v:getName()] = v
        generateBoneIndexLoop(v,bbfile)
    end
end

-- returns an empty form of the desired type. Kinda jank, but works :p
function getType(bonePath,type)
    for l,layer in pairs(type) do
        return bonePath[l]-bonePath[l]
    end
end

-- runs though the bones table, calculates the combined value for each of the layers, and saves it
function updateBones()
    if player:isLoaded() then
        for b,bbfile in pairs(bone) do
            for n,name in pairs(bbfile) do
                for t, type in pairs(name) do
                    boneStore[b][n][t] = getType(bone[b][n][t],type)
                    countBones = 0
                    for l, layer in pairs(type) do
                        boneStore[b][n][t] = boneStore[b][n][t] + bone[b][n][t][l]
                        countBones = countBones + 1
                    end
                    boneIndex[b][n][t](boneIndex[b][n],boneStore[b][n][t]/countBones)
                end
            end
        end
    end
end

-- actually runs the functions
generateBoneIndex()
events.RENDER:register(function() updateBones() end)
