//
//  CarFormView.swift
//  Caranga
//
//  Created by Felipe Moreno Borges on 25/10/23.
//

import SwiftUI

struct CarFormView: View {
    @Binding var car: Car?
    @Binding var path: NavigationPath
    
    @State private var brand: String = ""
    @State private var name: String = ""
    @State private var price: Int = 0
    @State private var gastype: Int = 0
    @State private var isSaving: Bool = false
    
    private let service = CarService()
    
    var isEditing: Bool {
        car != nil
    }
    
    
    var body: some View {
        Form {
            Section("Dados do carro") {
                TextField("Marca", text: $brand)
                TextField("Nome", text: $name)
            }
            
            Section("Preço") {
                TextField("Preço", value: $price, format: .number)
                    .keyboardType(.numberPad)
            }
            
            Section("Combustível") {
                Picker("Tipo de combustível", selection: $gastype) {
                    Text("Flex").tag(0)
                    Text("Álcool").tag(1)
                    Text("Gasolina").tag(2)
                }
                .pickerStyle(.segmented)
            }
            
            Button {
                Task {
                    await save()
                }
            } label: {
                Text(isEditing ? "Alterar" : "Cadastrar")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }.disabled(isSaving)
        }
        .navigationTitle(isEditing ? "Edição" : "Cadastro")
        .onAppear {
            setupView()
        }
    
    }
    
    private func setupView() {
        name = car?.name ?? ""
        brand = car?.brand ?? ""
        gastype = car?.gasType ?? 0
        price = car?.price ?? 0
    }
    
    private func save() async {
        isSaving = true
        let finalCar = car ?? Car()
        finalCar.name = name
        finalCar.brand = brand
        finalCar.gasType = gastype
        finalCar.price = price
        
        if isEditing {
            await service.updateCar(finalCar)
        } else {
           await service.createCar(finalCar)
        }
        goBack()
    }
    
    private func goBack() {
        path.removeLast()
    }
}

#Preview {
    CarFormView(
        car: .constant(nil),
        path: .constant(NavigationPath())
    )
}
