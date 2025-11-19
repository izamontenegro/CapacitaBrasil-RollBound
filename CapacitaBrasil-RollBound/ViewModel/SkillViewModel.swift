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
