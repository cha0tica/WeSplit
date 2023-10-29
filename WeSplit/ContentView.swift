//
//  ContentView.swift
//  WeSplit
//
//  Created by Agata on 24.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmountString = ""
    @State private var numberOfPeople = 1
    @State private var tipPercentage = 10
    
    @FocusState private var amountIsFocused: Bool // для контроля клавиатуры
    
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = " "
        return numberFormatter
    }()
    
    let tipPercentages = [5, 7, 10, 15]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 1)
        let tipSelection = Double(tipPercentage)
        
        if let checkAmount = Double(checkAmountString) {
            let tipValue = checkAmount / 100 * tipSelection
            let grandTotal = checkAmount + tipValue
            let amountPerPerson = grandTotal / peopleCount
            return amountPerPerson
        } else {
            return 0
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Введите информацию для расчета") {
                    TextField("Введите суму чека", text: $checkAmountString)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Число людей", selection: $numberOfPeople) {
                        ForEach(1..<100) {
                            Text("\($0) чел.")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section ("Выберите процент чаевых") {
                    Picker("Выберите процент чаевых", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section ("Считаем") {
                    let checkAmount = Int(checkAmountString) ?? 0
                    let tipValue = (Double(checkAmount)) * Double(tipPercentage) / 100
                    let checkAndTip = checkAmount + Int(tipValue)
                    
                    Text("Cумма чека: \(numberFormatter.string(from: NSNumber(value: checkAmount)) ?? "")")
                        .foregroundColor(Color.gray)
                    Text("Чаевые \(tipPercentage)%: \(numberFormatter.string(from: NSNumber(value: Int(tipValue))) ?? "")")
                            .foregroundColor(Color.gray)
                        Text("Сумма + чай: \(numberFormatter.string(from: NSNumber(value: checkAndTip)) ?? "")")
                            .foregroundColor(Color.gray)
                }

                
                Section ("Итоговая сумма на человека") {
                    HStack {
                        Text(Int(totalPerPerson), format: .currency(code: ""))
                        Spacer()
                        Text("рублей")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Готово") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
