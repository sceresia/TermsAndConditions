//
//  ContentView.swift
//  TermsAndConditions
//
//  Created by Stephen Ceresia on 2020-03-07.
//  Copyright © 2020 Stephen Ceresia. All rights reserved.
//

import SwiftUI
import Combine

struct TermsAndConditionsView: View {
    
    @ObservedObject private var model = TermsAndConditionsViewModel()
    
    @State private var showingSheet = false
    
    struct Checkmark : View {
         @Binding var validAgeEntered: Bool
        
        var body: some View {
            Image(systemName: validAgeEntered ? "checkmark.circle" : "xmark.circle").foregroundColor(validAgeEntered ? .green : .red)
            .font(.system(size: 32, weight: .medium))
        }
    }
    
    var body: some View {
        
        VStack {
            List {
                Spacer()
                
                Section(header:Text("Terms and Conditions").font(Font.system(.title).bold())) {

                    VStack {
                        HStack {
                            TextField("Enter your age (18+ only)", text: $model.ageEntered)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if !model.ageEntered.isEmpty {
                                Checkmark(validAgeEntered: $model.validAgeEntered)
                            }
                        }
                    }
                    
                    HStack {
                        Toggle(isOn: $model.readAgreement) {
                            Text("Read Terms & Conditions")
                        }
                    }
                    HStack {
                        Toggle(isOn: $model.agreeTerms) {
                            Text("Agree to Terms & Conditions")
                        }
                    }
                    HStack {
                        Toggle(isOn: $model.acceptMarketingEmails) {
                            Text("Accept to receive email")
                        }
                    }
                }
                .padding()
            }
            
            ZStack {
                Button(action: {
                    self.showingSheet = true
                }) {
                    Text("Continue")
                }
                .actionSheet(isPresented: $showingSheet) {
                    ActionSheet(title: Text("Good to go 👌"), message: nil, buttons: [.cancel(Text("Dismiss"))])
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(8)
                .disabled(!model.isEnabled)
            }
        }
        
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            .previewDisplayName("iPhone 11 Pro Max")
            .environment(\.colorScheme, .dark)
    }
}
