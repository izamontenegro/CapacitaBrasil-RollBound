//
//  RollViewModel.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 04/06/25.
//
import SwiftUI
import SwiftData

enum DiceRollState {
    case idle, rolling, finished
}


@MainActor
class RollViewModel: ObservableObject {
    static let shared = RollViewModel()
    
    @Published var state: DiceRollState = .idle
    
    @Published var rolls: [Roll] = []
    @Published var selectedDices: [DiceSides] = []
    @Published var rolledDices: [Dice] = []
    
    @Published var currentValue: Int = 0
    @Published var currentDiceIndex: Int = -1
    
    @Published var displayedValue: Int = 0

    private init() {}

    // MARK: CRIAR NOVA ROLAGEM
    func createNewRoll(context: ModelContext, dices: [Dice], total: Int) {
        let newRoll = Roll(dices: dices, total: total)
        
        rolls.append(newRoll)
        context.insert(newRoll)
        
        do {
            try context.save()
        } catch {
            print("Falha ao adicionar nova rolagem: \(error)")
        }
    }

    // MARK: BUSCAR ROLAGENS
    func fetchAllRolls(context: ModelContext) {
        let descriptor = FetchDescriptor<Roll>()
        do {
            self.rolls = try context.fetch(descriptor)
        } catch {
            print("Erro ao buscar rolagens: \(error)")
        }
    }

    // MARK: REALIZAR ROLAGEM
    func rollDices(context: ModelContext, dices: [DiceSides]) async {
        state = .rolling
        
        rolledDices = []
        currentDiceIndex = -1
        currentValue = 0
        displayedValue = 0
        
        var total = 0

        let reversedDices = dices.reversed()

        for (index, diceSide) in reversedDices.enumerated() {
            currentDiceIndex = index
            displayedValue = 0 
            let max = diceSide.sides
            let result = Int.random(in: 1...max)
            let newDice = Dice(numberOfSides: diceSide, rollValue: result)
            rolledDices.insert(newDice, at: 0)

            try? await Task.sleep(nanoseconds: 300_000_000)
            
            displayedValue = result
            total += result
            currentValue = total

            try? await Task.sleep(nanoseconds: 001_000_000_000)
        }

        createNewRoll(context: context, dices: rolledDices, total: total)
        
        state = .finished
    }
}
