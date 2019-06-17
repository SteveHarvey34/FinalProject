import Foundation
import Phidget22_C

/**
The Power Guard class controls the safety features and thresholds of a programmable power guard Phidget board.
*/
public class PowerGuardBase : Phidget {

	public init() {
		var h: PhidgetHandle?
		PhidgetPowerGuard_create(&h)
		super.init(h!)
		initializeEvents()
	}

	internal override init(_ handle: PhidgetHandle) {
		super.init(handle)
	}

	deinit {
		if (retained) {
			Phidget_release(&chandle)
		} else {
			uninitializeEvents()
			PhidgetPowerGuard_delete(&chandle)
		}
	}

	/**
	Enables the **failsafe** feature for the channel, with a given **failsafe time**.

	The **failsafe** feature is intended for use in applications where it is important for the channel to enter a known _safe state_ if the program controlling it locks up or crashes. If you do not enable the failsafe feature, the channel will carry out whatever instructions it was last given until it is explicitly told to stop.

	Enabling the failsafe feature starts a recurring **failsafe timer** for the channel. Once the failsafe timer is enabled, it must be reset within the specified time or the channel will enter a **failsafe state**. The failsafe timer may be reset either by calling this function again, or using the `ResetFailsafe` function. Resetting the failsafe timer will reload the timer with the specified _failsafe time_, starting when the message to reset the timer is received by the Phidget.

	For example: if the failsafe is enabled with a **failsafe time** of 1000ms, you will have 1000ms to reset the failsafe timer. Every time the failsafe timer is reset, you will have 1000ms from that time to reset the failsafe again.

	If the failsafe timer is not reset before it runs out, the channel will enter a **failsafe state**. For PowerGuard channels, this will disable the output. Once the channel enters the **failsafe state**, it will reject any further input until the channel is reopened.

	To prevent the channel from falsely entering the failsafe state, we recommend resetting the failsafe timer as frequently as is practical for your applicaiton. A good rule of thumb is to not let more than a third of the failsafe time pass before resetting the timer.

	Once the failsafe timer has been set, it cannot be disabled by any means other than closing and reopening the channel.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- failsafeTime: Failsafe timeout in milliseconds
	*/
	public func enableFailsafe(failsafeTime: UInt32) throws {
		let result: PhidgetReturnCode
		result = PhidgetPowerGuard_enableFailsafe(chandle, failsafeTime)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	The minimum value that `failsafeTime` can be set to when calling `EnableFailsafe`.

	- returns:
	The failsafe time

	- throws:
	An error or type `PhidgetError`
	*/
	public func getMinFailsafeTime() throws -> UInt32 {
		let result: PhidgetReturnCode
		var minFailsafeTime: UInt32 = 0
		result = PhidgetPowerGuard_getMinFailsafeTime(chandle, &minFailsafeTime)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return minFailsafeTime
	}

	/**
	The maximum value that `failsafeTime` can be set to when calling `EnableFailsafe`.

	- returns:
	The failsafe time

	- throws:
	An error or type `PhidgetError`
	*/
	public func getMaxFailsafeTime() throws -> UInt32 {
		let result: PhidgetReturnCode
		var maxFailsafeTime: UInt32 = 0
		result = PhidgetPowerGuard_getMaxFailsafeTime(chandle, &maxFailsafeTime)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return maxFailsafeTime
	}

	/**
	The `FanMode` dictates the operating condition of the fan.

	*   Choose between on, off, or automatic (based on temperature).
	*   If the `FanMode` is set to automatic, the fan will turn on when the temperature reaches 70°C and it will remain on until the temperature falls below 55°C.
	*   If the `FanMode` is off, the device will still turn on the fan if the temperature reaches 85°C and it will remain on until it falls below 70°C.

	- returns:
	The fan mode value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getFanMode() throws -> FanMode {
		let result: PhidgetReturnCode
		var fanMode: Phidget_FanMode = FAN_MODE_OFF
		result = PhidgetPowerGuard_getFanMode(chandle, &fanMode)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return FanMode(rawValue: fanMode.rawValue)!
	}

	/**
	The `FanMode` dictates the operating condition of the fan.

	*   Choose between on, off, or automatic (based on temperature).
	*   If the `FanMode` is set to automatic, the fan will turn on when the temperature reaches 70°C and it will remain on until the temperature falls below 55°C.
	*   If the `FanMode` is off, the device will still turn on the fan if the temperature reaches 85°C and it will remain on until it falls below 70°C.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- fanMode: The fan mode value
	*/
	public func setFanMode(_ fanMode: FanMode) throws {
		let result: PhidgetReturnCode
		result = PhidgetPowerGuard_setFanMode(chandle, Phidget_FanMode(fanMode.rawValue))
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	The device constantly monitors the output voltage, and if it exceeds the `OverVoltage` value, it will disconnect the input from the output.

	*   This functionality is critical for protecting power supplies from regenerated voltage coming from motors. Many power supplies assume that a higher than output expected voltage is related to an internal failure to the power supply, and will permanently disable themselves to protect the system. A typical safe value is to set OverVoltage to 1-2 volts higher than the output voltage of the supply. For instance, a 12V supply would be protected by setting OverVoltage to 13V.
	*   The device will connect the input to the output again when the voltage drops to (`OverVoltage` \- 1V)

	- returns:
	The voltage value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getOverVoltage() throws -> Double {
		let result: PhidgetReturnCode
		var overVoltage: Double = 0
		result = PhidgetPowerGuard_getOverVoltage(chandle, &overVoltage)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return overVoltage
	}

	/**
	The device constantly monitors the output voltage, and if it exceeds the `OverVoltage` value, it will disconnect the input from the output.

	*   This functionality is critical for protecting power supplies from regenerated voltage coming from motors. Many power supplies assume that a higher than output expected voltage is related to an internal failure to the power supply, and will permanently disable themselves to protect the system. A typical safe value is to set OverVoltage to 1-2 volts higher than the output voltage of the supply. For instance, a 12V supply would be protected by setting OverVoltage to 13V.
	*   The device will connect the input to the output again when the voltage drops to (`OverVoltage` \- 1V)

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- overVoltage: The voltage value
	*/
	public func setOverVoltage(_ overVoltage: Double) throws {
		let result: PhidgetReturnCode
		result = PhidgetPowerGuard_setOverVoltage(chandle, overVoltage)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	The minimum value that `OverVoltage` can be set to.

	- returns:
	The voltage value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getMinOverVoltage() throws -> Double {
		let result: PhidgetReturnCode
		var minOverVoltage: Double = 0
		result = PhidgetPowerGuard_getMinOverVoltage(chandle, &minOverVoltage)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return minOverVoltage
	}

	/**
	The maximum value that `OverVoltage` can be set to.

	- returns:
	The voltage value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getMaxOverVoltage() throws -> Double {
		let result: PhidgetReturnCode
		var maxOverVoltage: Double = 0
		result = PhidgetPowerGuard_getMaxOverVoltage(chandle, &maxOverVoltage)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return maxOverVoltage
	}

	/**
	When `PowerEnabled` is true, the device will connect the input to the output and begin monitoring.

	*   The output voltage is constantly monitored and will be automatically disconnected from the input when the output exceeds the `OverVoltage` value.
	*   `PowerEnabled` allows the device to operate as a Solid State Relay, powering on or off all devices connected to the output.

	- returns:
	The power enabled value.

	- throws:
	An error or type `PhidgetError`
	*/
	public func getPowerEnabled() throws -> Bool {
		let result: PhidgetReturnCode
		var powerEnabled: Int32 = 0
		result = PhidgetPowerGuard_getPowerEnabled(chandle, &powerEnabled)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return (powerEnabled == 0 ? false : true)
	}

	/**
	When `PowerEnabled` is true, the device will connect the input to the output and begin monitoring.

	*   The output voltage is constantly monitored and will be automatically disconnected from the input when the output exceeds the `OverVoltage` value.
	*   `PowerEnabled` allows the device to operate as a Solid State Relay, powering on or off all devices connected to the output.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- powerEnabled: The power enabled value.
	*/
	public func setPowerEnabled(_ powerEnabled: Bool) throws {
		let result: PhidgetReturnCode
		result = PhidgetPowerGuard_setPowerEnabled(chandle, (powerEnabled ? 1 : 0))
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	Resets the failsafe timer, if one has been set. See `EnableFailsafe` for details.

	This function will fail if no failsafe timer has been set for the channel.

	- throws:
	An error or type `PhidgetError`
	*/
	public func resetFailsafe() throws {
		let result: PhidgetReturnCode
		result = PhidgetPowerGuard_resetFailsafe(chandle)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

}
