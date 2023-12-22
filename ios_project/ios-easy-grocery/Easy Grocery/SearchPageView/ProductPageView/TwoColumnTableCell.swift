import UIKit

class TwoColumnTableCell: UITableViewCell {
    let column1Label = UILabel()
    let column2Label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Set up the first column label
        column1Label.translatesAutoresizingMaskIntoConstraints = false
        column1Label.font = .systemFont(ofSize: 14, weight: .bold)
        column1Label.textColor = .black
        addSubview(column1Label)

        // Set up the second column label
        column2Label.translatesAutoresizingMaskIntoConstraints = false
        column2Label.font = .systemFont(ofSize: 14)
        column2Label.textColor = .black
        addSubview(column2Label)

        // Add constraints for the labels
        column1Label.pinLeft(to: leadingAnchor, 10)
        column1Label.pinCenterY(to: centerYAnchor)
        column2Label.pinLeft(to: centerXAnchor)
        column2Label.pinRight(to: trailingAnchor, 10)
        column2Label.pinCenterY(to: centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
