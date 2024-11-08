//
//  LogInView.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/14.
//

import UIKit

final class LogInView: VerificationAndSignUpView {
    // MARK: - Properties
    let resendButton = GlobalButton(title: String.LogIn.resend)
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setTextFieldTextContentType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting Methods
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubview(resendButton)
    }
    
    override func setUI() {
        super.setUI()
        print(#function, "LogInView")
        super.setText(labelText: String.LogIn.verificationCodeSent,
                      textFieldPlaceholder: String.LogIn.verificationCodePlaceholder,
                      buttonTitle: String.LogIn.verifyAndStart)
        
        print("재전송버튼 활성화")
        resendButton.isActivated = true
//        print("다음버튼 비활성화")
//        button.isActivated = true
//        button.isActivated = false
    }
    
    override func setConstraints() {
        super.setConstraints()
        resendButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-16)
        }
        
//        updateConstraints()  //
//        setNeedsUpdateConstraints()
//        updateConstraintsIfNeeded()
//        updateInitialConstraints()
    }
  
    
    override func updateInitialConstraints() {
        userInputView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(label.snp.bottom).offset(96)
            make.trailing.equalTo(resendButton.snp.leading).offset(-8)
            make.height.equalTo(48)
        }
        
        resendButton.snp.makeConstraints { make in
            make.centerY.equalTo(userInputView)
        }
    }
    
    
//    override func updateConstraints() {
//        label.snp.updateConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide).offset(80)
//        }
//
//        userInputView.snp.updateConstraints { make in
//            make.top.equalTo(label.snp.bottom).offset(96)
//            make.trailing.equalTo(resendButton.snp.leading).offset(-8)
//        }
//
////        super.updateConstraints()
//    }
    
    private func setTextFieldTextContentType() {
        userInputView.textField.textContentType = .oneTimeCode
    }
}
