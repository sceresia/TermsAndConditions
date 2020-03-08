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
    
    var body: some View {
        
        NavigationView {
            TermsAndConditionsForm()
        }
    }
    
}

struct TermsAndConditionsForm : View {
    
    @ObservedObject private var model = TermsAndConditionsViewModel()
        
    var body: some View {
        
        VStack {
            Form {
                Section {
                    Section {
                        HStack {
                            TextField("Enter your age (18+ only)", text: $model.ageEntered)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if !model.ageEntered.isEmpty {
                                Checkmark(isValidAge: $model.isValidAge)
                            }
                        }
                    }
                    Section {
                        Toggle(isOn: $model.readAgreement) {
                            Text("Read Terms & Conditions")
                        }
                        Toggle(isOn: $model.agreeTerms) {
                            Text("Agree to Terms & Conditions")
                        }
                        Toggle(isOn: $model.acceptMarketingEmails) {
                            Text("Accept to receive email")
                        }
                    }
                    
                }.padding()
                
            }.navigationBarTitle("Terms and Conditions")
            
            ZStack {
                ContinueButton().disabled(!model.isEnabled)
            }
        }
        
    }
}

struct ContinueButton : View {
    @State private var showingSheet = false

    var body: some View {
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
    }
}

struct Checkmark : View {
    @Binding var isValidAge: Bool
    
    var body: some View {
        Image(systemName: isValidAge ? "checkmark.circle" : "xmark.circle").foregroundColor(isValidAge ? .green : .red)
            .font(.system(size: 32, weight: .medium))
    }
}

// PREVIEW
struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            .previewDisplayName("iPhone 11 Pro Max")
            .environment(\.colorScheme, .dark)
    }
}
// PREVIEW
