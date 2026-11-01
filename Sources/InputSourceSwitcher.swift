import Carbon
import Foundation

/// Switches between enabled keyboard layouts using the public Text Input Sources API.
///
/// The switcher prefers the previously used layout (stored in `UserDefaults`)
/// and falls back to the next enabled layout. This mirrors the "switch to the
/// previous input source" behavior most macOS users expect.
final class InputSourceSwitcher {
    private let defaults: UserDefaults
    private var lastSwitchTime = Date.distantPast
    private let debounceInterval: TimeInterval = 0.15

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Switches to the remembered layout, or to the first alternative layout.
    ///
    /// The debounce prevents duplicate events when the Globe key sends several
    /// key-down events for one physical press.
    func switchToAlternativeLayout() {
        let now = Date()
        guard now.timeIntervalSince(lastSwitchTime) >= debounceInterval else { return }
        lastSwitchTime = now

        let layouts = enabledKeyboardLayouts()
        guard !layouts.isEmpty else {
            log("no enabled keyboard layouts")
            return
        }

        let currentID = currentInputSourceID()
        let rememberedID = defaults.string(forKey: "lastInputSourceID")

        let target: TISInputSource?
        if let rememberedID, rememberedID != currentID,
           let remembered = layouts.first(where: { inputSourceID($0) == rememberedID }) {
            target = remembered
        } else {
            target = layouts.first(where: { inputSourceID($0) != currentID })
        }

        guard let target else {
            log("no alternative layout")
            return
        }

        let status = TISSelectInputSource(target)
        if status == noErr {
            defaults.set(currentID, forKey: "lastInputSourceID")
            log("switched \(currentID ?? "?") -> \(inputSourceID(target) ?? "?")")
        } else {
            log("switch failed with status \(status)")
        }
    }

    /// Returns enabled keyboard layouts only (no input methods, emoji, etc.).
    private func enabledKeyboardLayouts() -> [TISInputSource] {
        let filter: [String: Any] = [
            kTISPropertyInputSourceCategory as String: kTISCategoryKeyboardInputSource as String,
            kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout as String,
            kTISPropertyInputSourceIsEnabled as String: true
        ]
        guard let result = TISCreateInputSourceList(filter as CFDictionary, false)?.takeRetainedValue() else {
            return []
        }
        return result as? [TISInputSource] ?? []
    }

    private func currentInputSourceID() -> String? {
        guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else { return nil }
        return inputSourceID(source)
    }

    private func inputSourceID(_ source: TISInputSource) -> String? {
        guard let property = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) else { return nil }
        return Unmanaged<CFString>.fromOpaque(property).takeUnretainedValue() as String
    }
}
