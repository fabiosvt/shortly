//
//  ViewModel.swift
//  URL shortening
//
//  Created by Fabio Silvestri on 20/08/21.
//

import Foundation

struct Model: Codable, Hashable {
    let long: String
    let short: String
}

struct APIResult: Codable {
    let code: String
    let short_link: String
    let full_short_link: String
    let short_link2: String
    let full_short_link2: String
    let short_link3: String
    let full_short_link3: String
    let share_link: String
    let full_share_link: String
    let original_link: String
}

struct APIResponse: Codable {
    let ok: Bool
    let result: APIResult
}

class ViewModel: ObservableObject {
    @Published var models = [Model]()
    @Published var isLoading = false

    init() {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedLinks") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([Model].self, from: savedPerson) {
                self.models = loadedPerson
            }
        }
    }
    
    func submit(urlString: String) {
        guard URL(string: urlString) != nil else {
            return
        }
        guard let apiUrl = URL(string: "https://api.shrtco.de/v2/shorten?url="+urlString) else {
            return
        }
        self.isLoading = true
        
        let task = URLSession.shared.dataTask(with: apiUrl) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                let long = result.result.original_link
                let short = result.result.full_short_link
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.models.append(.init(long: long, short: short))
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(self?.models) {
                        let defaults = UserDefaults.standard
                        defaults.set(encoded, forKey: "SavedLinks")
                    }
                }
            }
            catch {
                print(error)
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
        task.resume()
    }
}
