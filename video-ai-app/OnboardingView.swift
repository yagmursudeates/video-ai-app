import SwiftUI
import AVKit

struct OnboardingPageData {
    let videoName: String
    let title: AttributedString
    let buttonText: String
}

struct OnboardingView: View {
    var onFinish: () -> Void = {}
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasSeenPaywall") private var hasSeenPaywall = false
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss

    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0) // #FF6D00

    private var titleLines: [[Text]] {
        // Each page: custom line breaks as requested
        let orange = soraOrange
        return [
            // Page 1
            [
                Text("Turn Your Words"),
                Text("into Stunning"),
                Text("Videos!")
            ],
            // Page 2
            [
                Text("Turn Your Words"),
                Text("into Stunning"),
                Text("Videos! v2 text")
            ],
            // Page 3
            [
                Text("Turn Your ") + Text("Words").foregroundColor(.red),
                Text("Videos! v3 text")
            ]
        ]
    }

    private let pages: [(videoName: String, buttonText: String)] = [
        ("onboarding-video-1", "Get Started"),
        ("onboarding-video-2", "Next"),
        ("onboarding-video-3", "Finished")
    ]

    @State private var player = AVPlayer()

    var body: some View {
        ZStack {
            VideoPlayerView(player: player)
                .ignoresSafeArea()
                .onAppear { 
                    updatePlayer()
                    // Temporary: Reset hasSeenPaywall for testing
                    hasSeenPaywall = false
                    print("DEBUG: OnboardingView appeared, hasSeenPaywall reset to: \(hasSeenPaywall)")
                }
                .onChange(of: currentPage) { _ in updatePlayer() }

            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .black.opacity(0.7)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: 0)
                    // Titles (3 lines, left-aligned)
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<titleLines[currentPage].count, id: \.self) { i in
                            titleLines[currentPage][i]
                                .font(.custom("Poppins-SemiBold", size: 37))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 0)
                                .padding(.bottom, i == titleLines[currentPage].count - 1 ? 0 : 2)
                                .lineSpacing(14)
                                .frame(height: 37, alignment: .center)
                        }
                    }
                    .frame(width: 361, height: 144, alignment: .leading)
                    .padding(.top, 536)
                    .padding(.leading, 16)
                    // Page indicator (TabView dots)
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { idx in
                            Color.clear.tag(idx) // Sadece noktacıklar için
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 24)
                    Spacer().frame(height: 14)
                    Spacer()
                    // Buton ve info alanı
                    VStack(spacing: 0) {
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                print("DEBUG: Finished button tapped, currentPage: \(currentPage)")
                                print("DEBUG: hasSeenPaywall: \(hasSeenPaywall)")
                                hasCompletedOnboarding = true
                                if !hasSeenPaywall {
                                    onFinish()
                                } else {
                                    print("DEBUG: User has already seen paywall, dismissing")
                                    dismissOrRouteToMain()
                                }
                            }
                        }) {
                            HStack(spacing: 0) {
                                ZStack {
                                    Text(pages[currentPage].buttonText)
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 14)
                            .padding(.bottom, 14)
                            .background(soraOrange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 0)

                        Group {
                            if currentPage == 0 {
                                VStack(spacing: 0) {
                                    Spacer().frame(height: 16)
                                    Text("By tapping Get Started indicate that you’ve read")
                                        .font(.system(size: 13.5))
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                    HStack(spacing: 0) {
                                        Text("and agree to our ")
                                            .font(.system(size: 13.5))
                                            .foregroundColor(.white.opacity(0.8))
                                        Text("Privacy")
                                            .font(.system(size: 13.5))
                                            .foregroundColor(soraOrange)
                                            .underline()
                                        Text(" and ")
                                            .font(.system(size: 13.5))
                                            .foregroundColor(.white.opacity(0.8))
                                        Text("Terms of Service")
                                            .font(.system(size: 13.5))
                                            .foregroundColor(soraOrange)
                                            .underline()
                                    }
                                    .multilineTextAlignment(.center)
                                    Spacer().frame(height: 48)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 32)
                            } else {
                                // Invisible placeholder to reserve space
                                VStack(spacing: 0) {
                                    Spacer().frame(height: 16)
                                    Text("By tapping Get Started indicate that you’ve read")
                                        .font(.system(size: 13.5))
                                        .opacity(0)
                                    HStack(spacing: 0) {
                                        Text("and agree to our ")
                                            .font(.system(size: 13.5))
                                            .opacity(0)
                                        Text("Privacy")
                                            .font(.system(size: 13.5))
                                            .opacity(0)
                                        Text(" and ")
                                            .font(.system(size: 13.5))
                                            .opacity(0)
                                        Text("Terms of Service")
                                            .font(.system(size: 13.5))
                                            .opacity(0)
                                    }
                                    Spacer().frame(height: 48).opacity(0)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 32)
                            }
                        }
                        .padding(.bottom, 0)
                        // Butonun altı ile ekranın altı arasında 100pt boşluk
                    }
                    .padding(.bottom, 100)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    private func updatePlayer() {
        let page = pages[currentPage]
        if let url = Bundle.main.url(forResource: page.videoName, withExtension: "mp4") {
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
            player.play()
            player.isMuted = true
            player.actionAtItemEnd = .none
        }
    }

    private func dismissOrRouteToMain() {
        dismiss()
    }
}
