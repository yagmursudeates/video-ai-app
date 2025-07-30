import SwiftUI

@main
struct video_ai_appApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    
    init() {
            if CommandLine.arguments.contains("-resetOnboardingView") {
    hasCompletedOnboarding = false
            }
        }
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainView()
            } else {
                SplashView() 
            }
        }
    }
}


