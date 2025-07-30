import SwiftUI
import UIKit

struct SplashView: View {
    @State private var animate = false
    @State private var isActive = false
    @State private var showPaywall = false
    @State private var onboardingCompleted = false
    var body: some View {
        ZStack {
            if !onboardingCompleted {
                OnboardingView {
                    showPaywall = true
                    onboardingCompleted = true
                }
            }
            else{
                ZStack{
                    Color.black
                        .ignoresSafeArea()
                    Image("orange-play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .scaleEffect(animate ? 1.0 : 0.8)
                        .opacity(animate ? 1 : 0.5)
                        .onAppear{
                            withAnimation(.easeInOut(duration: 2.0)){
                                animate = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                withAnimation{
                                    isActive = true
                                }
                                
                            }
                            
                            
                        }
                }
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
                .interactiveDismissDisabled(true)
        }
    }
}
