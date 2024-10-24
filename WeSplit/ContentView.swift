//
//  ContentView.swift
//  WeSplit
//
//  Created by jalal on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var totalBill: Double? = nil
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @State private var showMessage: Bool = false
    @State private var isTipZero: Bool = false
    
    @FocusState private var activeKeyboard: Bool
    
    let percetages = [0, 5, 10, 15, 20, 25, 30]
    
    private var finalAmount: Double {
        
        guard let b = totalBill else { return 0.0}
        let c = (b / 100 * Double(tipPercentage))
        let a = (b + c) / (Double(numberOfPeople) + 2)
        return a
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    TextField("Total Bill", value: $totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($activeKeyboard)
                        .onAppear {
                            totalBill = 0.0
                        }
                        .onChange(of: activeKeyboard) {
                            if activeKeyboard && totalBill == 0.00 {
                                totalBill = nil
                            } else if !activeKeyboard && totalBill == nil {
                                totalBill = 0.0
                            }
                        }
                    
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) Peoples")
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section("Choose the tip") {
                    Picker("", selection: $tipPercentage) {
                        ForEach(percetages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    
                    .pickerStyle(.segmented)
                }
                
                Section {
                    VStack(alignment: .center) {
                        Text(finalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(isTipZero ? .red : .black)
                            .onChange(of: tipPercentage) { oldValue, newValue in
                                if newValue == 0 {
                                    isTipZero = true
                                } else {
                                    isTipZero = false
                                }
                            }
                        
                        if showMessage {
                            Text("Please Pay Your Share")
                                .foregroundStyle(
                                    Color.gray
                                )
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .lineLimit(2)
                            
                        }
                    }
                    .onChange(of: finalAmount) {
                        if finalAmount > 0.0 {
                            showMessage = true
                        } else {
                            showMessage = false
                        }
                    }
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if activeKeyboard {
                    Button("Done") {
                        activeKeyboard = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
