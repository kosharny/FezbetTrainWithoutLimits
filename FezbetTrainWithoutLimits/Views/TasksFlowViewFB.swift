import SwiftUI
import Combine

struct TasksFlowViewFB: View {
    let task: TaskFB
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentStepIndex = 0
    @State private var timerActive = false
    @State private var timeRemaining = 0
    @State private var isFinished = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentStep: TaskStepFB {
        task.steps[currentStepIndex]
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            if isFinished {
                VStack(spacing: 30) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 80))
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                        .glow(color: themeManager.currentTheme.primaryColor, radius: 20)
                    
                    Text("TRAINING COMPLETE")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Text("You have mastered this session.")
                        .foregroundColor(.gray)
                    
                    ButtonFB(title: "FINISH") {
                        mainViewModel.completeTask(taskId: task.id)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.horizontal, 50)
                }
            } else {
                VStack {
                    // Header Progress
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("STEP \(currentStepIndex + 1) / \(task.steps.count)")
                            .font(.headline)
                            .foregroundColor(themeManager.currentTheme.primaryColor)
                        Spacer()
                        
                        // Favorite Toggle
                        Button(action: {
                            mainViewModel.toggleFavorite(taskId: task.id)
                        }) {
                            Image(systemName: mainViewModel.favoriteTaskIDs.contains(task.id) ? "heart.fill" : "heart")
                                .foregroundColor(mainViewModel.favoriteTaskIDs.contains(task.id) ? .red : .gray)
                                .font(.title2)
                        }
                    }
                    .padding()
                    
                    ProgressView(value: Double(currentStepIndex), total: Double(task.steps.count))
                        .accentColor(themeManager.currentTheme.primaryColor)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Step Content
                    VStack(spacing: 30) {
                        Text(currentStep.title)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text(currentStep.description)
                            .font(.title3)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Timer
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                                .frame(width: 200, height: 200)
                            
                            Circle()
                                .trim(from: 0, to: Double(timeRemaining) / Double(currentStep.durationSeconds))
                                .stroke(themeManager.currentTheme.primaryColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: timeRemaining)
                            
                            Text(formatTime(timeRemaining))
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Controls
                    HStack(spacing: 20) {
                        Button(action: toggleTimer) {
                            Circle()
                                .fill(themeManager.currentTheme.primaryColor)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: timerActive ? "pause.fill" : "play.fill")
                                        .font(.title)
                                        .foregroundColor(themeManager.currentTheme.backgroundColor)
                                )
                        }
                        
                        ButtonFB(title: timeRemaining == 0 ? "NEXT" : "SKIP") {
                            nextStep()
                        }
                    }
                    .padding(.bottom, 50)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            resetTimer()
        }
        .onReceive(timer) { _ in
            if timerActive && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timerActive && timeRemaining == 0 {
                timerActive = false
            }
        }
        .onAppear {
            withAnimation { mainViewModel.isTabBarVisible = false }
        }
        .onDisappear {
            withAnimation { mainViewModel.isTabBarVisible = true }
        }
    }
    
    func resetTimer() {
        timeRemaining = currentStep.durationSeconds
        timerActive = false
    }
    
    func toggleTimer() {
        timerActive.toggle()
    }
    
    func nextStep() {
        timerActive = false
        if currentStepIndex < task.steps.count - 1 {
            currentStepIndex += 1
            resetTimer()
        } else {
            withAnimation {
                isFinished = true
            }
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TasksFlowViewFB(task: TaskFB(id: UUID(), title: "Test Task", difficulty: "Hard", imageName: "task_sprint_sand", description: "Desc", steps: [
        TaskStepFB(id: "S1", title: "Step 1", description: "Do this", durationSeconds: 60)
    ], isPremium: false))
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}
