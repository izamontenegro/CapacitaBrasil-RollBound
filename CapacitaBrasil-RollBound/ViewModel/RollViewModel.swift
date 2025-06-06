//
//  RollViewModel.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 04/06/25.
//
import SwiftUI
import SwiftData

@MainActor
class RollViewModel: ObservableObject {
    static let shared = RollViewModel()
    
    @Published var rolls: [Roll] = []
    @Published var selectedDices: [DiceSides] = []
    @Published var rolledDices: [Dice] = []
    @Published var currentValue: Int = 0
    @Published var currentDiceIndex: Int = -1
    @Published var isRolling: Bool = false

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
    func rollDices(context: ModelContext) async {
        rolledDices = []
        currentDiceIndex = -1
        currentValue = 0
        isRolling = true
        var total = 0

        for (index, diceSide) in selectedDices.enumerated() {
            currentDiceIndex = index
            currentValue = 0

            try? await Task.sleep(nanoseconds: 500_000_000)

            let max = Int(diceSide.rawValue) ?? 6
            let result = Int.random(in: 1...max)
            currentValue = result

            let newDice = Dice(numberOfSides: diceSide, rollValue: result)
            rolledDices.append(newDice)
            total += result

            try? await Task.sleep(nanoseconds: 600_000_000)
        }

        createNewRoll(context: context, dices: rolledDices, total: total)

        selectedDices.removeAll()
        isRolling = false
    }
}

// MARK: VIEW DE TESTE (FUNÇÕES DA VM E EXIBICAO)

struct RollView: View {
    @StateObject private var viewModel = RollViewModel.shared
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack {
            Text("Rolls:")
            ForEach(viewModel.rolls) { roll in
                HStack {
                    ForEach(roll.dices) { dice in
                        Text("+ \(dice.numberOfSides.rawValue) (\(dice.rollValue))")
                    }
                    Text("= \(roll.total)")
                }
            }

            if viewModel.isRolling {
                Text("\(viewModel.currentValue)")
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
            }

            if !viewModel.isRolling {
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(maximum: 30)), count: 2)) {
                    ForEach(DiceSides.allCases, id: \.self) { dice in
                        Button(dice.rawValue) {
                            viewModel.selectedDices.append(dice)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }

            HStack {
                ForEach(Array(viewModel.selectedDices.enumerated()), id: \.offset) { index, dice in
                    let isCurrent = index == viewModel.currentDiceIndex
                    Text(dice.rawValue)
                        .foregroundColor(isCurrent ? .pink : .primary)
                }
            }

            if !viewModel.isRolling {
                Button("Rolar") {
                    Task {
                        await viewModel.rollDices(context: context)
                    }
                }
                .disabled(viewModel.selectedDices.isEmpty)
            }
        }
        .onAppear {
            viewModel.fetchAllRolls(context: context)
        }
        .padding()
    }
}

#Preview {
    RollView()
}
