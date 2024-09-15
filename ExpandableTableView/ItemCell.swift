//
//  ItemCell.swift
//  ExpandableTableView
//
//  Created by Abouzar Moradian on 9/13/24.
//

import UIKit

protocol ExpandableTableViewCellDelegate: AnyObject {
    func expandableTableViewCell(_ tableViewCell: UITableViewCell, expanded: Bool)
}

class ItemCell: UITableViewCell {
    
    static let identfier = "ItemCell"
    
    let expandButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.init(systemName: "chevron.down"), for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = .systemFont(ofSize: 20, weight: .regular)
        return labelView
    }()
    
    let detailsLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = .systemFont(ofSize: 18, weight: .regular)
        labelView.numberOfLines = 0
        return labelView
    }()
    
    private let expandableContent: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    var cellModel: CellModel? {
        didSet{
            titleLabel.text = cellModel?.title
            detailsLabel.text = cellModel?.detail
            expanded = cellModel?.expanded ?? false
            
            expandButton.transform = expanded ?  .init(rotationAngle: .pi - 0.001) : .identity
            expandableContentHeightConstraint.isActive = !expanded
        }
    }
    
    private lazy var expandableContentHeightConstraint = expandableContent.heightAnchor.constraint(
        equalToConstant: 0
    )
    
    private var expanded: Bool = false
    
    weak var delegate: ExpandableTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        placeContent(in: contentView)
        configureContent()
        
        
    }
    
    required init?(coder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
    
    private func placeContent(in view: UIView){
        
        view.addSubview(titleLabel)
        view.addSubview(expandButton)
        view.addSubview(expandableContent)
        
        expandableContent.addSubview(detailsLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        expandableContent.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        expandButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailsLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        detailsLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let detailsBottomConstraint = detailsLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: expandableContent.bottomAnchor, constant: -4)
        detailsBottomConstraint.priority = .fittingSizeLevel
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            expandButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            expandButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            expandButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            expandableContent.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            expandableContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            expandableContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            expandableContent.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -4),
            expandableContentHeightConstraint,
            
            detailsLabel.topAnchor.constraint(equalTo: expandableContent.topAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: expandableContent.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: expandableContent.trailingAnchor),
            detailsBottomConstraint
        ])
    }
    
    private func configureContent() {
        selectionStyle = .none
        
        

        expandButton.addAction(.init(handler: { [weak self] _ in
            
            
            guard let self = self,
                  let  tableView = self.superview as? UITableView else { return }
            
            self.expanded = !self.expanded
            tableView.beginUpdates()
            UIView.animate(withDuration: 0.3, delay: 0) {
                
                self.expandButton.transform = self.expanded  ? .init(rotationAngle: .pi - 0.001) : .identity
                self.expandableContentHeightConstraint.isActive = !self.expanded
                self.contentView.layoutIfNeeded()
                
            } completion: { completed in
                
                self.expanded = completed ? self.expanded : !self.expanded
                self.expandButton.transform = self.expanded ? .init(rotationAngle: .pi - 0.001) : .identity
                self.expandableContentHeightConstraint.isActive = !self.expanded
                if completed {
                    self.delegate?.expandableTableViewCell(self, expanded: self.expanded)
                }
            }
            
            tableView.endUpdates()
            
            
        }), for: .primaryActionTriggered)
        
    }
    
    
    
}
