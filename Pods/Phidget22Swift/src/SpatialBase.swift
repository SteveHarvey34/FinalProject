import Foundation
import Phidget22_C

/**
The Spatial class simultaneously gathers data from the acceleromter, gyroscope and magnetometer on a Phidget board.

You can also use the individual classes for these sensors if you want to handle the data in separate events.
*/
public class SpatialBase : Phidget {

	public init() {
		var h: PhidgetHandle?
		PhidgetSpatial_create(&h)
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
			PhidgetSpatial_delete(&chandle)
		}
	}

	/**
	Selects the IMU/AHRS algorithm.

	- returns:
	The sensor algorithm

	- throws:
	An error or type `PhidgetError`
	*/
	public func getAlgorithm() throws -> SpatialAlgorithm {
		let result: PhidgetReturnCode
		var algorithm: Phidget_SpatialAlgorithm = SPATIAL_ALGORITHM_NONE
		result = PhidgetSpatial_getAlgorithm(chandle, &algorithm)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return SpatialAlgorithm(rawValue: algorithm.rawValue)!
	}

	/**
	Selects the IMU/AHRS algorithm.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- algorithm: The sensor algorithm
	*/
	public func setAlgorithm(_ algorithm: SpatialAlgorithm) throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_setAlgorithm(chandle, Phidget_SpatialAlgorithm(algorithm.rawValue))
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	Sets the gain for the magnetometer in the AHRS algorithm. Lower gains reduce sensor noise while slowing response time.

	- returns:
	The AHRS algorithm magnetometer gain

	- throws:
	An error or type `PhidgetError`
	*/
	public func getAlgorithmMagnetometerGain() throws -> Double {
		let result: PhidgetReturnCode
		var algorithmMagnetometerGain: Double = 0
		result = PhidgetSpatial_getAlgorithmMagnetometerGain(chandle, &algorithmMagnetometerGain)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return algorithmMagnetometerGain
	}

	/**
	Sets the gain for the magnetometer in the AHRS algorithm. Lower gains reduce sensor noise while slowing response time.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- algorithmMagnetometerGain: The AHRS algorithm magnetometer gain
	*/
	public func setAlgorithmMagnetometerGain(_ algorithmMagnetometerGain: Double) throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_setAlgorithmMagnetometerGain(chandle, algorithmMagnetometerGain)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	The `DataInterval` is the time that must elapse before the channel will fire another `SpatialData` event.

	*   The data interval is bounded by `MinDataInterval` and `MaxDataInterval`.

	- returns:
	The data interval value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getDataInterval() throws -> UInt32 {
		let result: PhidgetReturnCode
		var dataInterval: UInt32 = 0
		result = PhidgetSpatial_getDataInterval(chandle, &dataInterval)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return dataInterval
	}

	/**
	The `DataInterval` is the time that must elapse before the channel will fire another `SpatialData` event.

	*   The data interval is bounded by `MinDataInterval` and `MaxDataInterval`.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- dataInterval: The data interval value
	*/
	public func setDataInterval(_ dataInterval: UInt32) throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_setDataInterval(chandle, dataInterval)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	The minimum value that `DataInterval` can be set to.

	- returns:
	The data interval value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getMinDataInterval() throws -> UInt32 {
		let result: PhidgetReturnCode
		var minDataInterval: UInt32 = 0
		result = PhidgetSpatial_getMinDataInterval(chandle, &minDataInterval)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return minDataInterval
	}

	/**
	The maximum value that `DataInterval` can be set to.

	- returns:
	The data interval value

	- throws:
	An error or type `PhidgetError`
	*/
	public func getMaxDataInterval() throws -> UInt32 {
		let result: PhidgetReturnCode
		var maxDataInterval: UInt32 = 0
		result = PhidgetSpatial_getMaxDataInterval(chandle, &maxDataInterval)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
		return maxDataInterval
	}

	/**
	Calibrate your device for the environment it will be used in.

	*   Due to physical location, hard and soft iron offsets, and even bias errors, your device should be calibrated. We have created a calibration program that will provide you with the `MagnetometerCorrectionParameters` for your specific situation. See your device's User Guide for more information.

	- throws:
	An error or type `PhidgetError`

	- parameters:
		- magneticField: Ambient magnetic field value.
		- offset0: Provided by calibration program.
		- offset1: Provided by calibration program.
		- offset2: Provided by calibration program.
		- gain0: Provided by calibration program.
		- gain1: Provided by calibration program.
		- gain2: Provided by calibration program.
		- T0: Provided by calibration program.
		- T1: Provided by calibration program.
		- T2: Provided by calibration program.
		- T3: Provided by calibration program.
		- T4: Provided by calibration program.
		- T5: Provided by calibration program.
	*/
	public func setMagnetometerCorrectionParameters(magneticField: Double, offset0: Double, offset1: Double, offset2: Double, gain0: Double, gain1: Double, gain2: Double, T0: Double, T1: Double, T2: Double, T3: Double, T4: Double, T5: Double) throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_setMagnetometerCorrectionParameters(chandle, magneticField, offset0, offset1, offset2, gain0, gain1, gain2, T0, T1, T2, T3, T4, T5)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	Resets the `MagnetometerCorrectionParameters` to their default values.

	*   Due to physical location, hard and soft iron offsets, and even bias errors, your device should be calibrated. We have created a calibration program that will provide you with the `MagnetometerCorrectionParameters` for your specific situation. See your device's User Guide for more information.

	- throws:
	An error or type `PhidgetError`
	*/
	public func resetMagnetometerCorrectionParameters() throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_resetMagnetometerCorrectionParameters(chandle)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	Saves the `MagnetometerCorrectionParameters`.

	*   Due to physical location, hard and soft iron offsets, and even bias errors, your device should be calibrated. We have created a calibration program that will provide you with the `MagnetometerCorrectionParameters` for your specific situation. See your device's User Guide for more information.

	- throws:
	An error or type `PhidgetError`
	*/
	public func saveMagnetometerCorrectionParameters() throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_saveMagnetometerCorrectionParameters(chandle)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	Zeros the AHRS algorithm.

	- throws:
	An error or type `PhidgetError`
	*/
	public func zeroAlgorithm() throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_zeroAlgorithm(chandle)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	/**
	Re-zeros the gyroscope in 1-2 seconds.

	*   The device must be stationary when zeroing.
	*   The angular rate will be reported as 0.0°/s while zeroing.
	*   Zeroing the gyroscope is a method of compensating for the drift that is inherent to all gyroscopes. See your device's User Guide for more information on dealing with drift.

	- throws:
	An error or type `PhidgetError`
	*/
	public func zeroGyro() throws {
		let result: PhidgetReturnCode
		result = PhidgetSpatial_zeroGyro(chandle)
		if result != EPHIDGET_OK {
			throw (PhidgetError(code: result))
		}
	}

	internal override func initializeEvents() {
		initializeBaseEvents()
		PhidgetSpatial_setOnAlgorithmDataHandler(chandle, nativeAlgorithmDataHandler, UnsafeMutableRawPointer(selfCtx!.toOpaque()))
		PhidgetSpatial_setOnSpatialDataHandler(chandle, nativeSpatialDataHandler, UnsafeMutableRawPointer(selfCtx!.toOpaque()))
	}

	internal override func uninitializeEvents() {
		uninitializeBaseEvents()
		PhidgetSpatial_setOnAlgorithmDataHandler(chandle, nil, nil)
		PhidgetSpatial_setOnSpatialDataHandler(chandle, nil, nil)
	}

	/**
	The most recent IMU/AHRS Quaternion will be reported in this event, which occurs when the `DataInterval` has elapsed.

	---
	## Parameters:
	*   `quaternion`: The quaternion vaulues
	*   `timestamp`: The timestamp value
	*/
	public let algorithmData = Event<Spatial, (quaternion: [Double], timestamp: Double)> ()
	let nativeAlgorithmDataHandler : PhidgetSpatial_OnAlgorithmDataCallback = { ch, ctx, quaternion, timestamp in
		let me = Unmanaged<Spatial>.fromOpaque(ctx!).takeUnretainedValue()
		me.algorithmData.raise(me, ([Double](UnsafeBufferPointer(start: quaternion!, count: 4)), timestamp));
	}

	/**
	The most recent values that your channel has measured will be reported in this event, which occurs when the `DataInterval` has elapsed.

	---
	## Parameters:
	*   `acceleration`: The acceleration vaulues
	*   `angularRate`: The angular rate values
	*   `magneticField`: The field strength values
	*   `timestamp`: The timestamp value
	*/
	public let spatialData = Event<Spatial, (acceleration: [Double], angularRate: [Double], magneticField: [Double], timestamp: Double)> ()
	let nativeSpatialDataHandler : PhidgetSpatial_OnSpatialDataCallback = { ch, ctx, acceleration, angularRate, magneticField, timestamp in
		let me = Unmanaged<Spatial>.fromOpaque(ctx!).takeUnretainedValue()
		me.spatialData.raise(me, ([Double](UnsafeBufferPointer(start: acceleration!, count: 3)), [Double](UnsafeBufferPointer(start: angularRate!, count: 3)), [Double](UnsafeBufferPointer(start: magneticField!, count: 3)), timestamp));
	}

}
