//
//  CarDetailView.swift
//  Caranga
//
//  Created by Felipe Moreno Borges on 25/10/23.
//

import SwiftUI

struct CarDetailView: View {
    @Binding var car: Car
    @Binding var path: NavigationPath
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        
        return formatter
    }()
    
    var body: some View {
        VStack {
            CarDataView(image: "car.fill", type: "Marca", value: car.brand)
            CarDataView(image: "fuelpump.fill", type: "Combustível", value: car.fuel)
            CarDataView(
                image: "dollarsign.circle.fill",
                type: "Preço",
                value: (numberFormatter.string(from: NSNumber(value: car.price))) ?? "R$ \(car.price)"
            )
            
            Spacer()
        }
        .padding()
        .navigationTitle(car.name)
        .toolbar {
            Button("Editar") {
                path.append(NavigationType.form(car))
            }
        }
    }
}
    
struct CarDataView: View {
    let image: String
    let type: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: image)
                Text(type)
            }
            Text(value)
                .fontWeight(.medium)
                .font(.title)
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(.accent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
    

#Preview {
    CarDetailView(
        car: .constant(Car(brand:"VW", name: "Golf GTI")),
        path: .constant(NavigationPath())
    )
}
