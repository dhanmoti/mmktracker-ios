//
//  ContentView.swift
//  MMKTracker
//
//  Created by Dhan Moti on 15/3/23.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(vm.currencies) { c in
                        VStack(alignment: .leading) {
                            Spacer(minLength: 4)
                            
                            Text(c.title)
                                .font(.system(.caption))
                            
                            Spacer(minLength: 4)
                            
                            HStack {
                                Text("\(c.base) \(c.shortTitle)")
                                    .font(.system(.title))
                                    .foregroundColor(.blue)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.blue)
                                Text("\(c.rate) MMK")
                                    .font(.system(.title))
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer(minLength: 8)
                        }
                    }
                }
                .refreshable {
                    vm.fetch()
                }
                .onAppear {
                    vm.fetch()
                }
                
                VStack {
                    Text("Last Update: \(vm.lastUpdate)")
                        .font(.system(.footnote))
                    Text("Source: forex.cbm.gov.mm")
                        .font(.system(.footnote))
                }
            }
        }
        .searchable(text: $vm.searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: .init())
    }
}




