import SwiftUI
import AVKit
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isPaywallUnlocked") var isPaywallUnlocked: Bool = false
    
    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0) // #FF6D00

    private let player = AVPlayer(url: Bundle.main.url(forResource: "paywall-video", withExtension: "mp4")!)

    var body: some View {
        ZStack {
            // Black background for the entire screen
            Color.black.ignoresSafeArea()
            
            // Video player covering only the top half
            VStack(spacing: 0) {
                VideoPlayerView(player: player)
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .clipped()
                
                // Black space for bottom half
                Color.black
                    .frame(height: UIScreen.main.bounds.height / 2)
            }
            .ignoresSafeArea()

            // Gradient overlay for better text readability
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.4), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .frame(width: 32, height: 32)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Button(action: {
                        Task {
                            await restorePurchases()
                        }
                    }) {
                        Text("Restore")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)

                Spacer()
            }

            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 266) // 266px from top

                Text("SORA PRO")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Try AI Video, Unleash your creativity")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    FeatureRow(text: "Text to Video & Image to Video")
                    FeatureRow(text: "Ultra HD Resolution")
                    FeatureRow(text: "Unlock All Styles & Presets")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)

                VStack(spacing: 12) {
                    PaywallOptionView(
                        title: "Annually Access",
                        subtitle: "TRY 2,379.99",
                        price: "TRY 45.64 / Week",
                        tag: "BEST PRICE",
                        credits: "90 credits per week"
                    )

                    PaywallOptionView(
                        title: "Weekly Access",
                        subtitle: "TRY 394.99",
                        price: "TRY 394.99 / Week",
                        tag: "MOST POPULAR",
                        credits: "60 credits per week"
                    )
                }


                .padding(.horizontal)

                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    Text("Auto - Renewal, Cancel Anytime")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)

                Button(action: {
                    print("Upgrade tapped")
                    
                }) {
                    Text("Upgrade to Sora Pro")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(soraOrange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 0)

                

                HStack {
                    Button("Privacy Policy", action: {})
                        .foregroundColor(soraOrange)
                    Text("|")
                        .foregroundColor(.white.opacity(0.6))
                    Button("Terms of Service", action: {})
                        .foregroundColor(soraOrange)
                }
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

                Spacer().frame(height: 20)
            }
        }
    }

    func restorePurchases() async {
        do {
            for await result in Transaction.currentEntitlements {
                switch result {
                case .verified(let transaction):
                    if transaction.productID == "paywall_video" {
                        await MainActor.run {
                            isPaywallUnlocked = true
                            // Do not call dismiss() here
                        }
                        print("Restored succesffully")
                    }
                case .unverified(_, let error):
                    print("Verification failed: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Verification error: \(error.localizedDescription)")
        }
    }
}

struct FeatureRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
            Text(text)
                .foregroundColor(.white)
                .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}


    struct PaywallOptionView: View {
        let title: String
        let subtitle: String
        let price: String
        let tag: String?
        let credits: String
        
        private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0) // #FF6D00
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(credits)
                        .font(.footnote)
                        .italic()
                        .foregroundColor(.gray)

                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(soraOrange, lineWidth: title.contains("Annually") ? 2:1)                )
                .cornerRadius(14)

                VStack(alignment: .trailing, spacing: 4) {
                    if let tag = tag {
                        Text(tag)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .background(title.contains("Annually") ? soraOrange : Color.gray.opacity(0.8))
                            .clipShape(
                                RoundedCorner(radius: 12, corners: [.bottomLeft])
                            )
                    }
                    
                    Text(price)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .offset(x: -8, y: 0)
            }
            .padding(.horizontal)
        }
    }

#Preview {
    PaywallView()
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
