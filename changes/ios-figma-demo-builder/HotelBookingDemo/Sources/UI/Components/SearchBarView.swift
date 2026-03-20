//
//  SearchBarView.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public protocol SearchBarViewDelegate: AnyObject {
    func searchBarDidBeginEditing(_ searchBar: SearchBarView)
    func searchBarDidEndEditing(_ searchBar: SearchBarView)
    func searchBar(_ searchBar: SearchBarView, textDidChange searchText: String)
    func searchBarSearchButtonClicked(_ searchBar: SearchBarView)
    func searchBarCancelButtonClicked(_ searchBar: SearchBarView)
}

public class SearchBarView: UIView {
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.surface
        view.layer.cornerRadius = BorderRadius.large
        view.layer.borderWidth = BorderWidth.thin
        view.layer.borderColor = Colors.border.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = Colors.textSecondary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "搜索酒店、地点..."
        textField.font = Typography.bodyMedium
        textField.textColor = Colors.textPrimary
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton(style: .text, size: .small)
        button.setTitle("取消", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let filterButton: CustomButton = {
        let button = CustomButton(style: .outlined, size: .small)
        button.setTitle("筛选", for: .normal)
        button.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Properties
    public weak var delegate: SearchBarViewDelegate?
    
    public var placeholder: String? {
        didSet { textField.placeholder = placeholder }
    }
    
    public var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    public var isCancelButtonHidden: Bool = true {
        didSet { cancelButton.isHidden = isCancelButtonHidden }
    }
    
    public var showsFilterButton: Bool = true {
        didSet { filterButton.isHidden = !showsFilterButton }
    }
    
    public var isActive: Bool = false {
        didSet { updateActiveState() }
    }
    
    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchBar()
    }
    
    // MARK: - Setup
    private func setupSearchBar() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(backgroundView)
        backgroundView.addSubview(searchIconImageView)
        backgroundView.addSubview(textField)
        addSubview(cancelButton)
        addSubview(filterButton)
        
        // Setup constraints
        setupMainConstraints()
        setupTextFieldConstraints()
        setupButtonConstraints()
        
        // Setup interactions
        setupInteractions()
        
        // Initial state
        updateActiveState()
    }
    
    private func setupMainConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTextFieldConstraints() {
        NSLayoutConstraint.activate([
            searchIconImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Spacing.m),
            searchIconImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 20),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: searchIconImageView.trailingAnchor, constant: Spacing.s),
            textField.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Spacing.s),
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            filterButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: Spacing.s),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // Adjust background view trailing constraint based on button visibility
        backgroundView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: Spacing.m).isActive = true
    }
    
    private func setupInteractions() {
        textField.delegate = self
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to background for activation
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activateSearch))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - State Management
    private func updateActiveState() {
        backgroundView.layer.borderColor = isActive ? Colors.primary.cgColor : Colors.border.cgColor
        backgroundView.layer.borderWidth = isActive ? BorderWidth.thick : BorderWidth.thin
        
        if isActive {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @objc private func activateSearch() {
        isActive = true
        delegate?.searchBarDidBeginEditing(self)
    }
    
    @objc private func cancelButtonTapped() {
        textField.text = ""
        isActive = false
        delegate?.searchBarCancelButtonClicked(self)
    }
    
    @objc private func filterButtonTapped() {
        // Handle filter action
        print("Filter button tapped")
    }
    
    // MARK: - Public Methods
    public func resignFirstResponder() {
        textField.resignFirstResponder()
        isActive = false
    }
    
    public func becomeFirstResponder() {
        textField.becomeFirstResponder()
        isActive = true
    }
    
    public func setSearchIcon(_ image: UIImage?) {
        searchIconImageView.image = image
    }
    
    public func setFilterButtonTitle(_ title: String) {
        filterButton.setTitle(title, for: .normal)
    }
    
    public func showCancelButton(_ show: Bool, animated: Bool = true) {
        guard isCancelButtonHidden != !show else { return }
        
        isCancelButtonHidden = !show
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchBarView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        isActive = true
        delegate?.searchBarDidBeginEditing(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        isActive = false
        delegate?.searchBarDidEndEditing(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        delegate?.searchBar(self, textDidChange: updatedText)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarSearchButtonClicked(self)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Convenience Extensions
public extension SearchBarView {
    static func prominentSearchBar() -> SearchBarView {
        let searchBar = SearchBarView()
        searchBar.backgroundView.backgroundColor = Colors.primary
        searchBar.backgroundView.layer.borderColor = Colors.primary.cgColor
        searchBar.textField.textColor = .white
        searchBar.textField.attributedPlaceholder = NSAttributedString(
            string: "搜索酒店、地点...",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )
        searchBar.searchIconImageView.tintColor = .white
        return searchBar
    }
    
    static func minimalSearchBar() -> SearchBarView {
        let searchBar = SearchBarView()
        searchBar.showsFilterButton = false
        searchBar.isCancelButtonHidden = false
        return searchBar
    }
}