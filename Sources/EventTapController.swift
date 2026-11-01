import CoreGraphics
import Foundation

/// Owns the global event tap that intercepts the Globe key.
///
/// macOS reports the Globe key as key code 179. The tap consumes that key
/// before the system can show the input source indicator (the ABC/Russian HUD),
/// then asks `InputSourceSwitcher` to change the layout.
final class EventTapController {
    /// Virtual key code for the Globe/Fn key on modern Apple keyboards.
    static let globeKeyCode: Int64 = 179

    private let switcher: InputSourceSwitcher
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    // One physical press can emit repeated key-down events. These flags make
    // sure a press produces exactly one layout switch.
    private var globeIsDown = false
    private var lastGlobeDownTime = Date.distantPast

    init(switcher: InputSourceSwitcher) {
        self.switcher = switcher
    }

    var isRunning: Bool {
        eventTap != nil
    }

    /// Installs the event tap on the current run loop. Safe to call twice.
    @discardableResult
    func start() -> Bool {
        if eventTap != nil { return true }

        let mask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
        let userInfo = Unmanaged.passUnretained(self).toOpaque()

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: eventTapCallback,
            userInfo: userInfo
        ) else {
            return false
        }

        eventTap = tap
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        runLoopSource = source
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        log("event tap started")
        return true
    }

    /// Removes and invalidates the event tap.
    func stop() {
        if let runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
        }
        eventTap = nil
        runLoopSource = nil
        log("event tap stopped")
    }

    fileprivate func handle(type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // macOS disables taps that take too long or when the user interrupts
        // them. Re-enable the tap and pass the event through.
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let eventTap {
                CGEvent.tapEnable(tap: eventTap, enable: true)
                log("event tap re-enabled")
            }
            return Unmanaged.passUnretained(event)
        }

        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        guard keyCode == Self.globeKeyCode else {
            return Unmanaged.passUnretained(event)
        }

        let now = Date()
        if type == .keyDown {
            let isRepeat = event.getIntegerValueField(.keyboardEventAutorepeat) != 0
            // If a key-up got lost, recover after a second instead of staying stuck.
            let stuck = globeIsDown && now.timeIntervalSince(lastGlobeDownTime) > 1.0

            if !isRepeat && (!globeIsDown || stuck) {
                globeIsDown = true
                lastGlobeDownTime = now
                switcher.switchToAlternativeLayout()
            }
        } else if type == .keyUp {
            globeIsDown = false
        }

        // Consume the Globe key so TextInputSwitcher never shows the HUD.
        return nil
    }
}

/// C callback for the event tap. The controller is passed through `userInfo`.
private func eventTapCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let userInfo else { return Unmanaged.passUnretained(event) }
    let controller = Unmanaged<EventTapController>.fromOpaque(userInfo).takeUnretainedValue()
    return controller.handle(type: type, event: event)
}
