//
//  GlobalButton.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/10.
//

import UIKit

final class GlobalButton: UIButton {
    // MARK: - Properties
    var title: String?
    var buttonConfiguration = UIButton.Configuration.filled()
    var isActivated: Bool {
        didSet {
//            print("GlobalButton didSet")
            setButtonColor()
        }
    }

    // MARK: - Initializers
    init(title: String = "") {
        self.title = title
        self.isActivated = false
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Design Methods
    private func setUI() {
        guard let title = title else {
            print("No title for GlobalButton")
            return
        }

//        var container = AttributeContainer()
//        container.font = .Body3_R14
//
//        buttonConfiguration.attributedTitle = AttributedString(title, attributes: container)
        setButtonTitle(as: title)
//        print("🔘 버튼 컬러를 지정하겠다!")
        setButtonColor()
//        print("🔘 버튼 컬러를 지정했다!")
    }
    
    func setButtonTitle(as title: String) {
        var container = AttributeContainer()
        container.font = .Body3_R14
        
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: container)
    }
    
    private func setButtonColor() {
//        print(#function)
//        print("🧐 버튼이 활성화 되어 있나요? \(isActivated)")
        let buttonColor = isActivated ? Asset.Colors.BrandColor.green.color : Asset.Colors.Grayscale.gray6.color
        let textColor = isActivated ? Asset.Colors.BlackWhite.white.color : Asset.Colors.Grayscale.gray3.color
        buttonConfiguration.baseBackgroundColor = buttonColor
        buttonConfiguration.baseForegroundColor = textColor
        configuration = buttonConfiguration
//        print("💀 버튼의 텍스트 컬러는: \(configuration!.baseForegroundColor)")
    }
}
