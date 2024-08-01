//
//  GameSettings.swift
//  FlappyBird
//
//  Created by Max BG on 7/30/24.
//

import Foundation

// Структура содержащая настройки игры

struct GameSettings {
    // ширина трубы
    let pipeWight: Double
    // Минимальная высота трубы
    let minPipeHeight: Double
    // максимальная высота трубы
    let maxPipeHeight: Double
    // Расстояние между трубами
    let pipeSpacing: Double
    // Скорость движения труб
    let pipeSpeed: Double
    // Сила прыжка птицы
    let jumpVelocity: Double
    // Сила гравитации
    let gravity: Double
    // Высота грунта
    let groundHeight: Double
    // Размер представления птицы
    let birdSize: Double
    // реальный радиус птицы
    let birdRadius: Double
    
    // Возвращает экземляр 'GameSettings" с настройками по умолчанию
    static var defaultSettings: GameSettings {
        GameSettings(
            pipeWight: 100,
            minPipeHeight: 100,
            maxPipeHeight: 500,
            pipeSpacing: 100,
            pipeSpeed: 200,
            jumpVelocity: -300,
            gravity: 1000,
            groundHeight: 100,
            birdSize: 80,
            birdRadius: 13) // настройки пор умолчанию
    }
}
