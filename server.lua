local TestPlateTimeOut = 1000 * 60 * 3

function IsPlateCanBySet(plate, owner, firstOwner)
  local p = promise.new()

  TriggerEvent('IsPlateCanBySet', { plate = plate, owner = owner, firstOwner = firstOwner }, function(isCanBySet)
    if p then
      p:resolve(isCanBySet)
      p = nil
    end
  end)

  Citizen.SetTimeout(10000, function()
    if p then
      p:resolve(false)
      p = nil
    end
  end)
  return Citizen.Await(p)
end

AddEventHandler('entityCreated', function(handle)
  if not DoesEntityExist(handle) then
    return
  end
  if GetEntityType(handle) ~= 2 then
    return
  end
  local owner = NetworkGetEntityOwner(handle)
  local firstOwner = NetworkGetFirstEntityOwner(handle)
  local plate = GetVehicleNumberPlateText(handle)

  if string.find(plate, "%d%d%u%u%u%d%d%d") or IsPlateCanBySet(plate, owner, firstOwner) then
    local entityBag = Entity(handle)
    entityBag.state:set('_plate', plate, false)
  else
    DeleteEntity(handle)
  end
end)

-- Test is Plate is coreleate with Server StateBag if not DeleteEntity
function TestPlate()
  for _, handle in pairs(GetAllVehicles()) do
    local entityBag = Entity(handle)
    local svPlate = entityBag.state['_plate']
    if svPlate then
      local plate = GetVehicleNumberPlateText(handle)
      if plate ~= svPlate then
        DeleteEntity(handle)
      end
    end
  end
end

-- MainLoop of execute in pcall TestPlate function
function MainLoop()
  pcall(TestPlate)
  Citizen.SetTimeout(TestPlateTimeOut, MainLoop)
end

Citizen.SetTimeout(TestPlateTimeOut, MainLoop)

exports('getPlate', function(handle)
  local entityBag = Entity(handle)
  local svPlate = entityBag.state['_plate']
  return svPlate
end)

exports('setPlate', function(handle, plate)
  local entityBag = Entity(handle)
  entityBag.state:set('_plate', plate, false)
end)
