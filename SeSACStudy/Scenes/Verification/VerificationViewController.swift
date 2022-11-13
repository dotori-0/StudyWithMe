//
//  VerificationViewController.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

class VerificationViewController: BaseViewController {
    // MARK: - Properties
    private let verificationView = VerificationView()
    private let verificationViewModel = VerificationViewModel()
    private let disposeBag = DisposeBag()
//    var numCount = 0

    // MARK: - Life Cycle
    override func loadView() {
        view = verificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        bind()
//        bindTextFieldWithCALayer()  // CALayer
        
        verificationView.phoneNumberInputView.textField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
//        verificationView.phoneNumberTextField.setBottomLine()  // CALayer
    }
    
    // MARK: - Setting Methods
    private func setNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Binding
    private func bind() {
        let input = VerificationViewModel.Input(editingDidBegin: verificationView.phoneNumberInputView.textField.rx.controlEvent([.editingDidBegin]),
                                                editingDidEnd: verificationView.phoneNumberInputView.textField.rx.controlEvent([.editingDidEnd]),
                                                phoneNumber: verificationView.phoneNumberInputView.textField.rx.text,
                                                verifyButtonTap: verificationView.verifyButton.rx.tap)
        
        let output = verificationViewModel.transform(input)
        var isValid = false
        
        // 입력 상태에 따라 TextField의 bottomLine 컬러 바꾸기
        output.editingDidBegin
            .drive(with: self) { vc, _ in
                vc.verificationView.phoneNumberInputView.isTextFieldFocused = true  // UIView
            }
            .disposed(by: disposeBag)
        
        output.editingDidEnd
            .drive(with: self) { vc, _ in
                vc.verificationView.phoneNumberInputView.isTextFieldFocused = false  // UIView
            }
            .disposed(by: disposeBag)
        
        // 입력한 번호의 유효성에 따라 버튼 컬러 바꾸기
        output.isValidNumber
        //            .bind(to: verificationView.verifyButton.rx.isActivated)  // rx 객체라면 self가 필요하지 않지만 일반 객체라면 withUnretained(self) 나 [weak self]를 통해 self의 객체로 접근? ❔
            .withUnretained(self)
            .bind(onNext: { (vc, isValidNumber) in
                vc.verificationView.verifyButton.isActivated = isValidNumber
                isValid = isValidNumber
            })
            .disposed(by: disposeBag)
        
        output.number
            .drive(verificationView.phoneNumberInputView.textField.rx.text)
            .disposed(by: disposeBag)        
        

        output.verifyButtonTap
            .withUnretained(self)
            .bind { (vc, _) in
//                let isValid = BehaviorRelay(value: false)
//                output.isValidNumber.bind(to: isValid).disposed(by: vc.disposeBag)
                if isValid {
                    vc.verificationView.makeToast(String.Verification.startVerification, duration: 0.5, position: .center)
                } else {
                    vc.verificationView.makeToast(String.Verification.wrongNumberFormat, duration: 0.5, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        
        

        
        
//        verificationView.phoneNumberInputView.textField.rx.controlEvent([.editingDidBegin])
//            .asDriver()
//            .drive(with: self) { vc, _ in
//                vc.verificationView.phoneNumberInputView.isTextFieldFocused = true  // UIView
//            }
//            .disposed(by: disposeBag)
//
//        verificationView.phoneNumberInputView.textField.rx.controlEvent([.editingDidEnd])
//            .asDriver()
//            .drive(with: self) { vc, _ in
//                vc.verificationView.phoneNumberInputView.isTextFieldFocused = false  // UIView
//            }
//            .disposed(by: disposeBag)
    }
    
    private func bindTextFieldWithCALayer() {
        verificationView.phoneNumberTextField.rx.controlEvent([.editingDidBegin])
            .asDriver()
            .drive(with: self) { vc, _ in
                vc.verificationView.phoneNumberTextField.changeBottomLineColorToFocus()  // CALayer
            }
            .disposed(by: disposeBag)
        
        verificationView.phoneNumberTextField.rx.controlEvent([.editingDidEnd])
            .asDriver()
            .drive(with: self) { vc, _ in
                vc.verificationView.phoneNumberTextField.changeBottomLineColorToFocus()  // CALayer
            }
            .disposed(by: disposeBag)
    }
}

extension VerificationViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
