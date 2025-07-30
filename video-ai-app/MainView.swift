import SwiftUI
import AVKit

struct MainView: View {
    @State private var promptText = ""
    @State private var selectedStyle = "35 mm"
    @State private var showAdvancedSettings = false
    @State private var selectedAspect: String = "3:4"
    @State private var motionScore: Double = 5
    @State private var showGenerateAlert = false
    @State private var showVideoResult = false
    
    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0) // #FF6D00
    
    private let styles = [
        ("35 mm", "main-video-1"),
        ("3D Render", "main-video-2"), 
        ("Abandoned", "main-video-3"),
        ("Style 4", "main-video-4"),
        ("Style 5", "main-video-5"),
        ("Style 6", "main-video-6")
    ]
    
    private let exploreCards = [
        ("Subtle reflections of a woman on the win...", "main-down-video-1"),
        ("Ultra-fast disorienting hyperla...", "main-down-video-2"),
        ("Thrilling safari adventure through t...", "main-down-video-3"),
        ("Handheld tracking shot at night in aba...", "main-down-video-4")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Video AI")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            // PRO action
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "bolt.fill")
                                    .font(.caption)
                                Text("PRO")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(soraOrange)
                            .cornerRadius(16)
                        }
                        
                        Button(action: {
                            // Settings action
                        }) {
                            Image(systemName: "gearshape")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Enter Prompt Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Enter Prompt")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                // Inspire me action
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "bolt.fill")
                                        .font(.caption)
                                    Text("inspire me")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(soraOrange)
                            }
                        }
                        
                        ZStack(alignment: .bottomTrailing) {
                            TextField("", text: $promptText, axis: .vertical)
                                .textFieldStyle(.plain)
                                .padding(16)
                                .frame(minHeight: 120)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .lineLimit(4...6)
                                .placeholder(when: promptText.isEmpty) {
                                    Text("Provide a detailed description of the video you have for your artwork.")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                }
                            
                            Text("\(promptText.count)/320")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.trailing, 16)
                                .padding(.bottom, 16)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Select Style Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Style")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Styles are adjustments directly related to how the video will appear.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(styles, id: \.0) { style in
                                    StyleCard(
                                        title: style.0,
                                        videoName: style.1,
                                        isSelected: selectedStyle == style.0
                                    ) {
                                        selectedStyle = style.0
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, -20)
                    }
                    .padding(.horizontal, 20)
                    
                    // Advanced Settings Button
                    Button(action: {
                        showAdvancedSettings.toggle()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 16))
                            Text("Advanced Settings (Optional)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: $showAdvancedSettings) {
                        AdvancedSettingsSheet(
                            selectedAspect: $selectedAspect,
                            motionScore: $motionScore,
                            onSave: { showAdvancedSettings = false }
                        )
                        .presentationDetents([.height(340)])
                        .background(Color.black.ignoresSafeArea())
                    }
                    
                    // Generate Button
                    Button(action: {
                        // Generate video action
                        // showGenerateAlert = true
                        showVideoResult = true
                    }) {
                        Text("Generate")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(soraOrange)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .fullScreenCover(isPresented: $showVideoResult) {
                        VideoResultView(
                            prompt: promptText,
                            videoName: "karda_kayan_adam",
                            onClose: { showVideoResult = false }
                        )
                    }
                    
                    // Explore Beyond Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Explore Beyond")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(exploreCards, id: \.0) { card in
                                ExploreCard(
                                    title: card.0,
                                    videoName: card.1
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 50)
            }
            .background(Color.black.ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

struct StyleCard: View {
    let title: String
    let videoName: String
    let isSelected: Bool
    let action: () -> Void
    
    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0)
    @State private var player: AVPlayer? = nil
     
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(width: 120, height: 80)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isSelected ? soraOrange : Color.clear, lineWidth: 2)
                        )
                        .onAppear {
                            player.seek(to: .zero)
                            player.play()
                            player.isMuted = true
                            player.actionAtItemEnd = .none
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 80)
                        .cornerRadius(8)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            if player == nil, let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                player = AVPlayer(url: url)
            }
        }
    }
}

struct ExploreCard: View {
    let title: String
    let videoName: String
    
    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0)
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(height: 120)
                        .cornerRadius(8)
                        .onAppear {
                            player.seek(to: .zero)
                            player.play()
                            player.isMuted = true
                            player.actionAtItemEnd = .none
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 120)
                        .cornerRadius(8)
                }
                Button(action: {
                    // Try prompt action
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.caption2)
                        Text("Try Prompt")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(6)
                }
                .padding(8)
            }
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(2)
        }
        .onAppear {
            if player == nil, let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                player = AVPlayer(url: url)
            }
        }
    }
} 

// Extension for placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
} 

struct AdvancedSettingsSheet: View {
    @Binding var selectedAspect: String
    @Binding var motionScore: Double
    var onSave: () -> Void
    
    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0)
    private let aspectRatios = ["1:1", "4:3", "3:4", "2:3"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Aspect Ratio ")
                .font(.headline)
                .foregroundColor(.white) +
            Text("(Optional)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("You can specify the orientation of the video output.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 4)
            HStack(spacing: 16) {
                ForEach(aspectRatios, id: \.self) { ratio in
                    Button(action: { selectedAspect = ratio }) {
                        Text(ratio)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 48, height: 36)
                            .background(Color.black.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedAspect == ratio ? soraOrange : Color.clear, lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.bottom, 8)
            Text("Motion Score ")
                .font(.headline)
                .foregroundColor(.white) +
            Text("(Optional)")
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("\(Int(motionScore))")
                    .font(.headline)
                    .foregroundColor(.white)
                Slider(value: $motionScore, in: 0...10, step: 1)
                    .accentColor(soraOrange)
            }
            Text("Increase or decrease the intensity of motion in your video. Higher values result in more motion.")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Button(action: onSave) {
                Text("Save")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(soraOrange)
                    .cornerRadius(12)
            }
        }
        .padding(24)
        .background(Color.black)
    }
} 

struct VideoResultView: View {
    let prompt: String
    let videoName: String
    let onClose: () -> Void
    @State private var showWatermark = true
    private let soraOrange = Color(red: 1.0, green: 0.427, blue: 0.0)
    @State private var player: AVPlayer? = nil
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Video AI")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if let player = player {
                VideoPlayer(player: player)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.35, contentMode: .fit)
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1.35, contentMode: .fit)
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
            }
            Text(prompt)
                .font(.body)
                .foregroundColor(.white)
                .padding(16)
                .background(Color(red: 0.09, green: 0.13, blue: 0.18))
                .cornerRadius(16)
                .padding(.horizontal, 16)
            HStack {
                Text("Watermark")
                    .font(.body)
                    .foregroundColor(.white)
                Spacer()
                Toggle("", isOn: $showWatermark)
                    .toggleStyle(SwitchToggleStyle(tint: soraOrange))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(red: 0.09, green: 0.13, blue: 0.18))
            .cornerRadius(16)
            Spacer()
            HStack(spacing: 32) {
                VStack(spacing: 8) {
                    Button(action: { /* Regenerate */ }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.09, green: 0.13, blue: 0.18))
                                .frame(width: 56, height: 56)
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    Text("Regenerate")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                VStack(spacing: 8) {
                    Button(action: { /* Save */ }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.09, green: 0.13, blue: 0.18))
                                .frame(width: 56, height: 56)
                            Image(systemName: "arrow.down.to.line")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    Text("Save")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                VStack(spacing: 8) {
                    Button(action: { /* Delete */ }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.09, green: 0.13, blue: 0.18))
                                .frame(width: 56, height: 56)
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    Text("Delete")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                VStack(spacing: 8) {
                    Button(action: { /* Share */ }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.09, green: 0.13, blue: 0.18))
                                .frame(width: 56, height: 56)
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    Text("Share")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            if player == nil, let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                player = AVPlayer(url: url)
            }
        }
    }
} 
