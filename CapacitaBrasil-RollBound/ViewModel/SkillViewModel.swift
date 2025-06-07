//
//  SkillViewModel.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 05/06/25.
//
import SwiftUI
import SwiftData

class SkillViewModel: ObservableObject {
    static let shared = SkillViewModel()
    
    @Published var skills: [Skill] = []
    
    private init() { }
    
    // MARK: ADICIONAR NOVA SKILL
    func createSkill(context: ModelContext, skillName: String, dices: [Dice]) {
        let newSkill = Skill(dices: dices, skillName: skillName)
        
        skills.append(newSkill)
        context.insert(newSkill)
        
        do {
            try context.save()
        } catch {
            print("Falha ao adicionar nova habilidade: \(error)")
        }
    }
    
    // MARK: BUSCAR SKILLS
    func fetchAllSkills(context: ModelContext) {
        let descriptor = FetchDescriptor<Skill>()
        do {
            self.skills = try context.fetch(descriptor)
        } catch {
            print("Erro ao buscar habilidades: \(error)")
        }
    }
    
    // MARK: EDITAR SKILL
    func updateSkill(context: ModelContext, skill: Skill, skillName: String?, dices: [Dice]?) {
        skill.skillName = skillName ?? skill.skillName
        skill.dices = dices ?? skill.dices
        
        do {
            try context.save()
        } catch {
            print("Erro ao atualizar habilidade: \(error.localizedDescription)")
        }
    }
    
    // MARK: DELETAR SKILL
    func deleteSkill(context: ModelContext, skill: Skill) {
        skills.removeAll { $0.id == skill.id }
        context.delete(skill)
        
        do {
            try context.save()
        } catch {
            print("Erro ao deletar habilidade: \(error.localizedDescription)")
        }
    }

}

// MARK: VIEW DE TESTE (FUNÇÕES DA VM)
private struct TestSkillView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel = SkillViewModel.shared
    
    @State var mockDices: [Dice] = [Dice(numberOfSides: .D4, rollValue: Int.random(in: 1...6))]
    
    @State var newMockDices: [Dice] = [Dice(numberOfSides: .D8, rollValue: Int.random(in: 1...6))]

    var body: some View {
        VStack(spacing: 16) {
            Button("Criar Skill Mock") {
                viewModel.createSkill(context: context, skillName: "MockSkill", dices: mockDices)
            }

            Button("Atualizar Primeira Skill") {
                guard let firstSkill = viewModel.skills.first else { return }
                viewModel.updateSkill(context: context, skill: firstSkill, skillName: "SkillAtualizada", dices: newMockDices)
            }

            Button("Deletar Primeira Skill") {
                guard let firstSkill = viewModel.skills.first else { return }
                viewModel.deleteSkill(context: context, skill: firstSkill)
            }

            Text("Lista de Skills")
                .font(.headline)

            List(viewModel.skills, id: \.id) { skill in
                VStack(alignment: .leading) {
                    Text("Nome: \(skill.skillName)")
                    Text("Dados: \(skill.dices.map { $0.numberOfSides.rawValue }.joined(separator: ", "))")
                        .font(.caption)
                }
            }
        }
        .onAppear {
            viewModel.fetchAllSkills(context: context)
        }
        .padding()
    }
}

#Preview {
    TestSkillView()
}
