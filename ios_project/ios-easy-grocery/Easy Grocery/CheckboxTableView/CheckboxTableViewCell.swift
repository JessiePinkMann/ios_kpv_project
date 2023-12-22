import UIKit

class CheckboxTableViewCell: UITableViewCell {
    let checkboxButton = CheckboxButton()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    var cellInit = CheckboxCell(title: "")
    
    var checkboxTableViewControllerDelegate: CheckboxTableViewControllerDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        checkboxButton.checkboxTableViewCellDelegate = self
        
        contentView.addSubview(checkboxButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(titleLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
        contentView.layoutMargins = UIEdgeInsets.zero
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .systemGray2
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
//        print(checkboxTableViewControllerDelegate?.checkboxActiveType ?? "NO VAL")
        checkboxButton.configureButton(UIImage(systemName: checkboxTableViewControllerDelegate?.checkboxActiveType ?? "minus.square.fill")!)
        checkboxButton.isUserInteractionEnabled = true
        checkboxButton.pinTop(to: contentView.topAnchor, 6)
//        checkboxButton.pinCenterY(to: contentView)
        checkboxButton.pinLeft(to: contentView, 16)
        checkboxButton.setHeight(30)
        checkboxButton.setWidth(30)
        
        titleLabel.pinCenterY(to: checkboxButton)
//        titleLabel.pinTop(to: contentView.topAnchor, 6)
        titleLabel.pinLeft(to: checkboxButton.trailingAnchor, 16)
        titleLabel.pinRight(to: contentView.trailingAnchor, 16)
        
        descriptionLabel.pinLeft(to: checkboxButton.trailingAnchor, 8)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
        descriptionLabel.pinRight(to: contentView.trailingAnchor, 16)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, 4)
        
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        checkboxButton.scaleImage(1.3)
    }
    
    @objc private func cellTapped() {
        print("Cell tapped")
        checkboxButton.buttonTapped()
    }
}

protocol CheckboxTableViewCellDelegate {
    func checkboxTableViewCellDidTapButton(_ isBeingSelected: Bool)
}

extension CheckboxTableViewCell: CheckboxTableViewCellDelegate {
    func checkboxTableViewCellDidTapButton(_ isBeingSelected: Bool) {
        print("TabVCDelegate called")
        if (isBeingSelected) {
            checkboxTableViewControllerDelegate?.selectCell(self.cellInit)
        } else {
            checkboxTableViewControllerDelegate?.deselectCell(self.cellInit)
        }
    }
}
