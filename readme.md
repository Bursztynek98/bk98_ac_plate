# Decryption

- This script is Server Side script!
- This script required OneSync to work correctly.
- This script allow to sorte in serwer data of Plate text allocated to Vehicle!
- If Pattern is not valid, vehicle is deleted.
- If plate text is not allowed by serwer for the player who creates the vehicle, vehicle is deleted.
- Script create check loop (3 min) to test is all Server vehicle have set correct Plate if not, vehicle is deleted.


# Basic information
When client start create vehicle. Server Just Trigger native event `entityCreated`

After that if Plate is different from default gta pattern Server Trigger event:
```lua
TriggerEvent('IsPlateCanBySet',
-- DATA
{
plate = plate, -- Plate of created Vehicle
owner = owner, -- Should by Player of Created Vehicle but can by current owner
firstOwner = firstOwner -- Is Should by Player of Created Vehicle
},
-- CallBack
function(isCanBySet)
  -- If this function return false new entity is Delete from map
end
)
```
You handle this event with database script to test is player own this Plate String.

TimeOut: `TestPlateTimeOut` (3 min) script test all vehicle on server is have correct plate if not vehicle is Delete

# Exports

- `getPlate(handle)` return server plate of Vehicle
- `setPlate(handle, plate)` to set plate of Vehicle


# Example of open Trunk inventory

1. When Client want Open "Trunk" we can accept data from the client only if provide `Plate` and `NetworkVehicleId`
now convert NetId to entity by `NetworkGetEntityFromNetworkId` and 
we can test is this Vehicle plate provided by client is correct and open Trunk inventory 
2. When Client want Open "Trunk" we can accept data from the client only if provide `NetworkVehicleId`
now convert NetId to entity by `NetworkGetEntityFromNetworkId` and we can get plate `getPlate` and open correct Trunk inventory

## Know issue
- Off Course client with Executor can create local vehicle after few second set new Plate, but after 3 min serwer automatic delete this not valid vehicle, and if try open inventory server return started plate if contain native GTA pattern or nil if vehicle not registered

# Example of Create Vehicle
- After Client Create own Vehicle is nice to by set `setPlate` by new `NetworkVehicleId`, Plate should by set for this new vehicle 