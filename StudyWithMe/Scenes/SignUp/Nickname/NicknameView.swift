//
//  NicknameView.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/16.
//

import UIKit

final class NicknameView: VerificationAndSignUpView {
    // MARK: - Setting Methods
    override func setUI() {
        super.setText(labelText: String.Nickname.inputNickname,
                      textFieldPlaceholder: String.Nickname.nicknamePlaceholder,
                      buttonTitle: String.Action.next)
        
        userInputView.changeKeyboardType(to: .default)
    }
    
    override func updateInitialConstraints() {
        label.snp.updateConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(96)
        }
    }
}
