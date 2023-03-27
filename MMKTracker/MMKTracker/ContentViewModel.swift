//
//  ContentViewModel.swift
//  MMKTracker
//
//  Created by Dhan Moti on 27/3/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var lastUpdate: String = ""
        @Published var currencies: [Currency] = []
        @Published var searchText: String = ""
        
        private var repo: [Currency] = [] {
            didSet {
                currencies = repo
            }
        }
        private let db = Firestore.firestore()
        
        private var cancellables: [AnyCancellable] = []
        init() {
            $searchText
                .filter { $0.isEmpty == false }
                .sink { [weak self] text in
                self?.currencies = self?.repo
                        .filter { $0.title.contains(text) || $0.shortTitle.contains(text.uppercased()) } ?? []
            }.store(in: &cancellables)
            
            $searchText
                .filter { $0.isEmpty   }
                .sink { [weak self] _ in
                self?.currencies = self?.repo ?? []
            }.store(in: &cancellables)
        }
        
        
        //--currencies/centralbank
        func fetch() {
            let docRef = db.collection("currencies").document("centralbank")

            docRef.getDocument { [weak self] (document, error) in
                    guard error == nil else {
                        print("error", error ?? "")
                        return
                    }

                    if let document = document, document.exists {
                        let data = document.data()
                        if let data = data,
                           let lUpdate = data["lastUpdate"] as? String,
                           let rates = data["rates"] as? [[String: String]] {
                            
                            self?.lastUpdate = lUpdate
                            self?.repo.removeAll()
                            
                            for r in rates {
                                let c = Currency(title: r["title"] ?? "",
                                                 shortTitle: r["code"] ?? "",
                                                 rate: r["rate"] ?? "",
                                                 timestamp: r["timestamp"] ?? "",
                                                 base: r["base"] ?? "")
                                self?.repo.append(c)
                            }
                        
                        }
                    }

                }
        }
    }
}
