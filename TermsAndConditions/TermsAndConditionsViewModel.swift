//
//  TermsAndConditionsViewModel.swift
//  TermsAndConditions
//
//  Created by Stephen Ceresia on 2020-03-07.
//  Copyright © 2020 Stephen Ceresia. All rights reserved.
//

import Foundation
import Combine

class TermsAndConditionsViewModel: ObservableObject {

    @Published var ageEntered = ""
    @Published var validAgeEntered = false
    @Published var readAgreement = false
    @Published var agreeTerms = false
    @Published var acceptMarketingEmails = false
    
    @Published var isEnabled = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var minAge = 18
    private var maxAge = 124

    private var areTermsAcceptedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($readAgreement, $agreeTerms, $acceptMarketingEmails)
            .map { readAgreement, agreeTerms, acceptMarketingEmails in
                return readAgreement && agreeTerms && acceptMarketingEmails
            }
            .eraseToAnyPublisher()
    }
    
    private var isOldEnough: AnyPublisher<Bool, Never> {
        $ageEntered
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { age in
                return Int(age) ?? 0 >= self.minAge && Int(age) ?? 0 < self.maxAge
            }
            .eraseToAnyPublisher()
    }
    
    private var canContinue: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(areTermsAcceptedPublisher, isOldEnough)
            .map { areTermsAcceptedPublisher, isOldEnough in
                return areTermsAcceptedPublisher && isOldEnough
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        
        isOldEnough
            .receive(on: RunLoop.main)
            .assign(to: \.validAgeEntered, on: self)
            .store(in: &cancellableSet)
        canContinue
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: self)
            .store(in: &cancellableSet)
    }
    
}
