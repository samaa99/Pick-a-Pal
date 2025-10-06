//
//  ContentView.swift
//  Pick-a-Pal
//
//  Created by Samaa Soltan on 29/08/2025.
//


// Tips
// A binding is a way for you to give one view access to state that another view owns. To create a binding to a state property, prefix the property name with $.

//["Ibrahiem", "Ismaiel", "Mohamed", "Nouh", "Mousa"]
import SwiftUI

struct ContentView: View {
    @State private var names: Array<String> = []
    @State private var savedNames: Array<String> = []
    @State private var nameToAdd: String = ""
    @State private var pickedName: String = ""
    @State private var shouldRemovePickedName: Bool = false
    @State private var addNameValidationMessage: String = ""
    
    var body: some View {
        VStack {
            
            VStack {
                Image(systemName: "person.3.sequence.fill")
                    .foregroundStyle(.tint)
                    .symbolRenderingMode(.hierarchical)
                
                
                Text("Pick-a-Pal")
            }.font(.title)
                .bold()
            
            Text(pickedName.isEmpty || names.isEmpty ? " " : pickedName)
                .bold()
                .font(.title3)
                .padding(.bottom, 16)
            
            HStack {
                Button {
                    if names.isEmpty && !savedNames.isEmpty {
                        names.append(contentsOf: savedNames)
                    }
                } label: {
                    Text("Load List")
                }
                .disabled(savedNames.isEmpty)
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button {
                    savedNames = names
                } label: {
                    Text("Save List")
                }
                .disabled(names.isEmpty || savedNames == names)
                .buttonStyle(.borderedProminent)

            }
            
            if names.isEmpty {
                ContentUnavailableView {
                    Label("No Names Yet", systemImage: "person.crop.circle.badge.plus")
                        .foregroundStyle(.tint)
                } description: {
                    Text("Add names to get started")
                }
                
                
            } else {
                List {
                    
                    ForEach(names, id: \.self) { name in
                        Text(name)
                    }
                    .onDelete { indexSet in
                            names.remove(atOffsets: indexSet)
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.bottom, 8)
                
            }
            
            
            TextField("Add Name", text: $nameToAdd)
                .autocorrectionDisabled(true)
                .onChange(of: nameToAdd) {
                        addNameValidationMessage = ""
                    }
                .onSubmit {
                    
                    let trimmedName = nameToAdd.trimmingCharacters(in: .whitespaces)
                        
                        if trimmedName.isEmpty {
                            addNameValidationMessage = "Name cannot be empty"
                        } else if names.contains(trimmedName) {
                            addNameValidationMessage = "Name already exists"
                            nameToAdd = ""
                        } else {
                            names.append(trimmedName)
                            nameToAdd = ""
                            addNameValidationMessage = ""
                        }
                    
                }
            
            if !addNameValidationMessage.isEmpty {
                Text(addNameValidationMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
                
            
            Toggle("Remove Picked Name", isOn: $shouldRemovePickedName)
            
            Button {
                if let randomName = names.randomElement() {
                    pickedName = randomName
                    
                    if shouldRemovePickedName {
                        names.removeAll { $0 == randomName }
                    }
                    
                } else {
                    pickedName = ""
                }
            } label: {
                Text("Pick Random Name")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
            }
            .buttonStyle(.borderedProminent)
            .disabled(names.isEmpty)
        
        }.padding()
    }
}

#Preview {
    ContentView()
}
