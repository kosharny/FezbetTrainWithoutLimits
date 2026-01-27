import SwiftUI

struct TaskDetailsViewFB: View {
    let task: TaskFB
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingTaskFlow = false
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack {
                // Scaled Header Image
                ZStack(alignment: .topLeading) {
                    Image(task.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .clipped()
                    
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.5)))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            mainViewModel.toggleFavorite(taskId: task.id)
                        }) {
                            Image(systemName: mainViewModel.isFavorite(taskId: task.id) ? "heart.fill" : "heart")
                                .foregroundColor(mainViewModel.isFavorite(taskId: task.id) ? themeManager.currentTheme.secondaryColor : .white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.5)))
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(task.title.uppercased())
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(themeManager.currentTheme.primaryColor)
                        
                        HStack {
                            BadgeFB(text: task.difficulty, color: themeManager.currentTheme.accentColor)
                            BadgeFB(text: "\(task.steps.count) STEPS", color: .gray)
                        }
                        
                        Text(task.description)
                            .font(.body)
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .padding(.vertical)
                        
                        Text("STEPS OVERVIEW")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ForEach(task.steps) { step in
                            HStack(alignment: .top) {
                                Circle()
                                    .fill(themeManager.currentTheme.secondaryColor)
                                    .frame(width: 10, height: 10)
                                    .padding(.top, 6)
                                VStack(alignment: .leading) {
                                    Text(step.title)
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.white)
                                    Text(step.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                }
                
                if mainViewModel.isCompleted(taskId: task.id) {
                    ButtonFB(title: "COMPLETED") {
                        // Optional: Allow re-training?
                        showingTaskFlow = true
                    }
                    .opacity(0.8) 
                    .padding()
                } else {
                    ButtonFB(title: "START TRAINING") {
                        showingTaskFlow = true
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingTaskFlow) {
            TasksFlowViewFB(task: task)
        }
        .onAppear {
            withAnimation { mainViewModel.isTabBarVisible = false }
        }
        .onDisappear {
            withAnimation { mainViewModel.isTabBarVisible = true }
        }
    }
}

struct BadgeFB: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text.uppercased())
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(5)
    }
}

#Preview {
    TaskDetailsViewFB(task: TaskFB(id: UUID(), title: "Test Task", difficulty: "Hard", imageName: "task_sprint_sand", description: "Desc", steps: [], isPremium: false))
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}
