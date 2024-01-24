# Description

- This script is server-side script!
- This script required OneSync to work correctly.
- This script allows storing in server data, Plate text allocated to Vehicle!
- If Pattern is not valid, vehicle is deleted.
- If plate text is not allowed by the server for the player who creates the vehicle, the vehicle is deleted.
- Script create check loop (3 minutes) to test if all Server vehicles have set the correct Plate, if not, the vehicle is deleted.


# Basic information
When the client starts to create a vehicle, the server just triggers the native event `entityCreated`

After that, if Plate is different from the default GTA pattern, the Server Trigger event:
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
You handle this event with a database script to test if the player owns this Plate String.

Timeout: `TestPlateTimeOut` (3 min) script test: all vehicles on the server have the correct plate if not, the vehicle is deleted.

# Exports

- `getPlate(handle)` return server plate of Vehicle
- `setPlate(handle, plate)` to set plate of Vehicle


# Example of open Trunk inventory

1. When the client wants to open "Trunk," we can accept data from the client only if they provide `Plate` and `NetworkVehicleId`
Now convert NetId to entity by `NetworkGetEntityFromNetworkId` and 
We can test if this Vehicle plate provided by the client is correct and open Trunk inventory.
2. When the client wants to open "Trunk," we can accept data from the client only if they provide `NetworkVehicleId`
Now convert NetId to entity by `NetworkGetEntityFromNetworkId` and we can get plate `getPlate` and open the correct Trunk inventory

## Know issue
- Off Course client with Executor can create a local vehicle after few second set new Plate, but after 3 min server automatic delete this not valid vehicle, and if try open inventory server return started plate if contain native GTA pattern or nil if vehicle not registered

# Example of Create Vehicle
- After the client creates their own vehicle, it is nice to be set `setPlate` by new `NetworkVehicleId`, Plate should be set for this new vehicle.