import UIKit

class CheckboxButton: UIButton {
//    private var checkedImage = UIImage(systemName: "checkmark.square.fill")
//    private var uncheckedImage = UIImage(systemName: "square")
    
    var checkboxTableViewCellDelegate: CheckboxTableViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureButton()
    }
    
//    required init?(checkedImageType: String, uncheckedImageType: String) {
//        self.checkedImage = UIImage(systemName: checkedImageType)
//        self.uncheckedImage = UIImage(systemName: uncheckedImageType)
//
//        super.init(frame: .zero)
//        configureButton()
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        configureButton()

    }

    func configureButton(_ checkedImage: UIImage = UIImage(systemName: "checkmark.square.fill")!, uncheckedImage: UIImage = UIImage(systemName: "square")!) {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setImage(uncheckedImage, for: .normal)
        setImage(checkedImage, for: .selected)
        tintColor = .systemBlue
    }
    
    func deselectButton() {
        isSelected = false
    }
    
    func selectButton() {
        isSelected = true
    }

    @objc func buttonTapped() {
        print("Button tapped")
        isSelected.toggle()
        checkboxTableViewCellDelegate?.checkboxTableViewCellDidTapButton(isSelected)
    }
}
