//
//  GameView.swift
//  FlappyBird
//
//  Created by Max BG on 7/29/24.
//

import SwiftUI

// Состояние игры
enum GameState {
    case ready, active, stopped
}

struct GameView: View {
    
    @State private var gameState: GameState = .ready
    @State private var birdPosition = CGPoint(x: 100, y: 300)
    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    @State private var topPipeHeight = Double.random(in: 100...500)
    @State private var pipeOffset = 0.0
    @State private var passedPipe = false
    @State private var scores = 0
    @AppStorage(wrappedValue: 0, "highScore") private var highScore: Int
    @State private var lastUpdateTime = Date()
    
    private let defaultSettings = GameSettings.defaultSettings
    
    private let timer = Timer.publish(
        every: 0.01,
        on: .main,
        in: .common
    ).autoconnect()
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image(.flappyBirdBackground)
                        .resizable()
                        .scaleEffect(
                            CGSize(
                                width: geometry.size.width * 0.003,
                                height: geometry.size.height * 0.0017
                            )
                        )
                    
                    BIRDView(birdSize: defaultSettings.birdSize)
                        .position(birdPosition)
                    
                    pipesView(
                        topPipeHeight: topPipeHeight,
                        pipeWidth: defaultSettings.pipeWight,
                        pipeSpacing: defaultSettings.pipeSpacing
                    )
                    .offset(x: geometry.size.width + pipeOffset)
                    
                    if gameState == .ready {
                        Button(action: playButtonAction) {
                            Image(systemName: "play.fill")
                                .scaleEffect(x: 3.5, y: 3.5)
                        }
                        .foregroundColor(.white)
                    }
                    if gameState == .stopped {
                        ResultView(score: scores, highScore: highScore) {
                            resetGame()
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text(scores.formatted())
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                
                .onTapGesture {
                    switch gameState {
                    case .ready:
                        playButtonAction()
                    case .active:
                        birdVelocity = CGVector(dx: 0, dy: defaultSettings.jumpVelocity)
                    case .stopped:
                        break
                    }
                }
                .onReceive(timer) { currentTime in
                    guard gameState == .active else { return }
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
                    
                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBoudaries(geometry: geometry)
                    updatePipePosition(deltaTime: deltaTime)
                    resetPipePositionIfNeeded(geometry: geometry)
                    
                                    
                    if checkCollision(with: geometry) {
                        gameState = .stopped
                    }
                    
                    updateScoresAndHighScores(geometry: geometry)
                    
                    lastUpdateTime = currentTime
                }
            }
        }
    }
    
    // Действие по нажатию кнопки Play
    private func playButtonAction() {
        gameState = .active
        lastUpdateTime = Date()
    }
    
    // Действие по нажатию кнопки Reset
    private func resetGame() {
        birdPosition = CGPoint(x: 100, y: 300)
        birdVelocity = CGVector(dx: 0, dy: 0)
        pipeOffset = 0
        topPipeHeight = Double.random(in: defaultSettings.minPipeHeight...defaultSettings.maxPipeHeight)
        scores = 0
        gameState = .ready
    }
    
    // Эффект гравитации
    private func applyGravity(deltaTime: TimeInterval) {
        birdVelocity.dy += Double(defaultSettings.gravity * deltaTime)
    }
    
    // Обновление позиции птицы, учитывая её текущую скорость
    private func updateBirdPosition(deltaTime: TimeInterval) {
        birdPosition.y += birdVelocity.dy * Double(deltaTime)
    }
    // Остановка падения птицы на уровне грунта
    // Ограничение высоты полета
    private func checkBoudaries(geometry: GeometryProxy) {
        // Проверка не достигла ли птица верхней границы экрана
        if birdPosition.y <= 0 {
            birdPosition.y = 0
        }
        // Проверка, не достигла ли птица грунта
        if birdPosition.y > geometry.size.height - defaultSettings.groundHeight - defaultSettings.birdSize / 2 {
            birdPosition.y = geometry.size.height - defaultSettings.groundHeight - defaultSettings.birdSize / 2
            birdVelocity.dy = 0
        }
        if birdPosition.y >= geometry.size.height - defaultSettings.groundHeight - defaultSettings.birdSize / 2  || birdPosition.y <= 0 {
               gameState = .stopped
           }
    }
    
    // Обновление положения столбов
    private func updatePipePosition(deltaTime: TimeInterval) {
        pipeOffset -= Double(defaultSettings.pipeSpeed * deltaTime)
        }
    // Установка столбов на начальную позицию по завершению цикла
    private func resetPipePositionIfNeeded(geometry: GeometryProxy) {
        if pipeOffset <= -geometry.size.width - defaultSettings.pipeWight {
            pipeOffset = 0
            topPipeHeight = Double.random(in:
                defaultSettings.minPipeHeight...defaultSettings.maxPipeHeight)
        }
    }
    
    private func checkCollision(with geometry: GeometryProxy) -> Bool {
        // Создаем прямоугольник вокруг птицы
        let birdFrame = CGRect(
            x: birdPosition.x - defaultSettings.birdRadius / 2,
            y: birdPosition.y - defaultSettings.birdRadius / 2,
            width: defaultSettings.birdRadius,
            height: defaultSettings.birdRadius
        )
        
        // Обновленный код для создания прямоугольников столбов с учетом их реального расположения
        let pipeXPosition = geometry.size.width + pipeOffset
        
        // Создаем прямоугольник вокруг верхнего столба
        let topPipeFrame = CGRect(
            x: pipeXPosition,
            y: 0,
            width: defaultSettings.pipeWight,
            height: topPipeHeight
        )
        
        // Создаем прямоугольник вокруг нижнего столба
        let bottomPipeFrame = CGRect(
            x: pipeXPosition,
            y: topPipeHeight + defaultSettings.pipeSpacing,
            width: defaultSettings.pipeWight,
            height: geometry.size.height - topPipeHeight - defaultSettings.pipeSpacing
        )
        
        // Функция возвращает 'true', если прямоугольник птицы пересекается с прямоугольником любого из столбов
        return birdFrame.intersects(topPipeFrame) || birdFrame.intersects(bottomPipeFrame)
    }
    
    // Функция обновления количества набранных очков и рекорда
    private func updateScoresAndHighScores(geometry: GeometryProxy){
        if pipeOffset + defaultSettings.pipeWight + geometry.size.width < birdPosition.x && !passedPipe {
            scores += 1
            // Обновление рекорда
            if scores > highScore {
                highScore = scores
            }
            // Избегаем повторного увеличения счета
            passedPipe = true
        } else if pipeOffset + geometry.size.width > birdPosition.x {
            // Сброс положения труб, после их выхода за пределы экрана
            passedPipe = false
        }
    }
}

#Preview {
    GameView()
}
