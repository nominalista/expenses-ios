import SwiftUI

struct DeviceOrientationViewModifier: ViewModifier {
    
    let didRotate: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear() // Workaround to make onReceive() working.
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIDevice.orientationDidChangeNotification
                )
            ) { _ in
                didRotate(UIDevice.current.orientation)
            }
    }
}

extension View {
    
    func onRotate(action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceOrientationViewModifier(didRotate: action))
    }
}
