//
//  VerificationAndSignUpView.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/14.
//

import UIKit

class VerificationAndSignUpView: BaseView {
    // MARK: - Properties
    var labelText: String?
    var inputTextFieldPlaceholder: String?
    var buttonTitle: String?
    
    let label = VerificationAndSignUpLabel()
//    let inputTextField = InputTextField()
    let button = GlobalButton()
    var userInputView = InputView()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting Methods
    override func setHierarchy() {
        [label, userInputView, button].forEach {
            addSubview($0)
        }
    }
    
    override func setUI() {
        print(#function, "VerificationAndSignUpView")
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.horizontalEdges.equalToSuperview()
        }
        
        userInputView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(userInputView.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        updateInitialConstraints()
    }
    
    // MARK: - Intenal Methods
    func setText(labelText: String, textFieldPlaceholder: String? = nil, buttonTitle: String) {
        label.setText(with: labelText)
        if let textFieldPlaceholder {
            userInputView.setPlaceholder(as: textFieldPlaceholder)
        }
        button.setButtonTitle(as: buttonTitle)
    }
    
    func updateInitialConstraints() {
        
    }
}
