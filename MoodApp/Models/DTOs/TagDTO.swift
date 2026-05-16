import Foundation

struct TagDTO: Identifiable, Codable {
    let id: UUID
    let name: String
    let colorHex: String
    
    init(id: UUID = UUID(), name: String, colorHex: String) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }
}

enum PresetTag: String, CaseIterable {
    case work = "工作"
    case family = "家庭"
    case health = "健康"
    case social = "社交"
    case study = "学习"
    case hobby = "爱好"
    case finance = "财务"
    case travel = "旅行"
    
    var defaultColor: String {
        switch self {
        case .work: return "#FF6B6B"
        case .family: return "#4ECDC4"
        case .health: return "#95E1D3"
        case .social: return "#F38181"
        case .study: return "#AA96DA"
        case .hobby: return "#FCBAD3"
        case .finance: return "#FFFFD2"
        case .travel: return "#A8E6CF"
        }
    }
    
    func toDTO() -> TagDTO {
        TagDTO(name: self.rawValue, colorHex: self.defaultColor)
    }
}
