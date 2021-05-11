# LocationUtils

This is a mini CoreLcation library. It provides an efficient way to get the currentLocatin of user every 100m for fitness purposes.

## Example

```swift
let regionLocationManager = RegionMonitoringLocationManager(radius: 100)

// 1st ask for authorization
regionLocationManager.requestAlwaysAuthorization()

// 2nd call the start function
regionLcationManager.start()

// 3rd call the stop function to stop location updates
regionLocationManager.stop()
```
Calling `regionLocationManager.start()` will retrieve once the currentLocation of the user using the `regionLocationManager.requestLocation()` and create a `CLCircularRegion` around that location with 100m radius with the property `notifyOnExit = true`. We also store that region in memory and when user exits that region we repeat the above.


