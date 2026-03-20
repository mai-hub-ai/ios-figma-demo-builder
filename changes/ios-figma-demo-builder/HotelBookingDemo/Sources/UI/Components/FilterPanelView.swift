//
//  FilterPanelView.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public protocol FilterPanelViewDelegate: AnyObject {
    func filterPanel(_ panel: FilterPanelView, didSelectFilter filter: FilterOption)
    func filterPanelDidResetFilters(_ panel: FilterPanelView)
    func filterPanelDidApplyFilters(_ panel: FilterPanelView)
}

public class FilterPanelView: UIView {
    
    // MARK: - Data Models
    public struct FilterCategory {
        public let title: String
        public let options: [FilterOption]
        public let type: FilterType
        
        public init(title: String, options: [FilterOption], type: FilterType = .singleSelection) {
            self.title = title
            self.options = options
            self.type = type
        }
    }
    
    public enum FilterType {
        case singleSelection
        case multipleSelection
        case range
    }
    
    public struct FilterOption {
        public let id: String
        public let title: String
        public let isSelected: Bool
        
        public init(id: String, title: String, isSelected: Bool = false) {
            self.id = id
            self.title = title
            self.isSelected = isSelected
        }
    }
    
    // MARK: - UI Components
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(text: "筛选条件", style: .headlineLarge)
        return label
    }()
    
    private let resetButton: CustomButton = {
        let button = CustomButton(style: .text, size: .small)
        button.setTitle("重置", for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let applyButton: CustomButton = {
        let button = CustomButton(style: .primary, size: .large)
        button.setTitle("应用筛选", for: .normal)
        return button
    }()
    
    // MARK: - Properties
    public weak var delegate: FilterPanelViewDelegate?
    
    private var filterCategories: [FilterCategory] = []
    private var selectedFilters: Set<String> = []
    
    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupFilterPanel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFilterPanel()
    }
    
    // MARK: - Setup
    private func setupFilterPanel() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.surface
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(resetButton)
        addSubview(tableView)
        addSubview(applyButton)
        
        // Setup constraints
        setupConstraints()
        
        // Setup table view
        setupTableView()
        
        // Setup interactions
        setupInteractions()
        
        // Load sample data
        loadSampleFilters()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title and reset button
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.l),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.m),
            
            resetButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            resetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.m),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.l),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -Spacing.l),
            
            // Apply button
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.m),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.m),
            applyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.l),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilterCategoryCell.self, forCellReuseIdentifier: "FilterCategoryCell")
    }
    
    private func setupInteractions() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Loading
    private func loadSampleFilters() {
        filterCategories = [
            FilterCategory(
                title: "价格范围",
                options: [
                    FilterOption(id: "price_0_300", title: "¥0 - ¥300"),
                    FilterOption(id: "price_300_600", title: "¥300 - ¥600"),
                    FilterOption(id: "price_600_1000", title: "¥600 - ¥1000"),
                    FilterOption(id: "price_1000_plus", title: "¥1000以上")
                ],
                type: .singleSelection
            ),
            FilterCategory(
                title: "酒店星级",
                options: [
                    FilterOption(id: "star_5", title: "五星酒店"),
                    FilterOption(id: "star_4", title: "四星酒店"),
                    FilterOption(id: "star_3", title: "三星酒店"),
                    FilterOption(id: "star_2", title: "二星及以下")
                ],
                type: .singleSelection
            ),
            FilterCategory(
                title: "设施服务",
                options: [
                    FilterOption(id: "facility_wifi", title: "免费WiFi"),
                    FilterOption(id: "facility_parking", title: "免费停车"),
                    FilterOption(id: "facility_pool", title: "游泳池"),
                    FilterOption(id: "facility_gym", title: "健身房"),
                    FilterOption(id: "facility_restaurant", title: "餐厅"),
                    FilterOption(id: "facility_breakfast", title: "早餐")
                ],
                type: .multipleSelection
            ),
            FilterCategory(
                title: "用户评分",
                options: [
                    FilterOption(id: "rating_4_5", title: "4.5分以上"),
                    FilterOption(id: "rating_4_0", title: "4.0分以上"),
                    FilterOption(id: "rating_3_5", title: "3.5分以上"),
                    FilterOption(id: "rating_3_0", title: "3.0分以上")
                ],
                type: .singleSelection
            )
        ]
        
        tableView.reloadData()
    }
    
    // MARK: - Event Handlers
    @objc private func resetButtonTapped() {
        selectedFilters.removeAll()
        filterCategories = filterCategories.map { category in
            let resetOptions = category.options.map { option in
                FilterOption(id: option.id, title: option.title, isSelected: false)
            }
            return FilterCategory(title: category.title, options: resetOptions, type: category.type)
        }
        tableView.reloadData()
        delegate?.filterPanelDidResetFilters(self)
    }
    
    @objc private func applyButtonTapped() {
        delegate?.filterPanelDidApplyFilters(self)
    }
    
    // MARK: - Public Methods
    public func updateFilterCategories(_ categories: [FilterCategory]) {
        self.filterCategories = categories
        tableView.reloadData()
    }
    
    public func selectFilter(withId filterId: String) {
        selectedFilters.insert(filterId)
        updateFilterSelection(filterId, isSelected: true)
    }
    
    public func deselectFilter(withId filterId: String) {
        selectedFilters.remove(filterId)
        updateFilterSelection(filterId, isSelected: false)
    }
    
    private func updateFilterSelection(_ filterId: String, isSelected: Bool) {
        for (categoryIndex, category) in filterCategories.enumerated() {
            for (optionIndex, option) in category.options.enumerated() {
                if option.id == filterId {
                    var updatedOptions = category.options
                    updatedOptions[optionIndex] = FilterOption(id: option.id, title: option.title, isSelected: isSelected)
                    filterCategories[categoryIndex] = FilterCategory(title: category.title, options: updatedOptions, type: category.type)
                    break
                }
            }
        }
        tableView.reloadData()
    }
    
    public func getSelectedFilters() -> [String] {
        return Array(selectedFilters)
    }
}

// MARK: - UITableViewDataSource
extension FilterPanelView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategories[section].options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCategoryCell", for: indexPath) as! FilterCategoryCell
        let option = filterCategories[indexPath.section].options[indexPath.row]
        let category = filterCategories[indexPath.section]
        
        cell.configure(
            with: option,
            type: category.type,
            delegate: self
        )
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterPanelView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Colors.surfaceSecondary
        
        let label = CustomLabel(text: filterCategories[section].title, style: .titleMedium)
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Spacing.m),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -Spacing.m)
        ])
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - FilterCategoryCell
private class FilterCategoryCell: UITableViewCell {
    
    weak var delegate: FilterPanelView?
    private var filterOption: FilterPanelView.FilterOption?
    private var filterType: FilterPanelView.FilterType = .singleSelection
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(style: .bodyMedium)
        return label
    }()
    
    private let checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkboxImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.m),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkboxImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.m),
            checkboxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with option: FilterPanelView.FilterOption, type: FilterPanelView.FilterType, delegate: FilterPanelView) {
        self.filterOption = option
        self.filterType = type
        self.delegate = delegate
        
        titleLabel.text = option.title
        updateCheckboxState(option.isSelected)
    }
    
    private func updateCheckboxState(_ isSelected: Bool) {
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        checkboxImageView.image = UIImage(systemName: imageName)
        checkboxImageView.isHidden = !isSelected && filterType == .singleSelection
    }
    
    @objc private func cellTapped() {
        guard let option = filterOption else { return }
        
        if filterType == .multipleSelection {
            if option.isSelected {
                delegate?.deselectFilter(withId: option.id)
            } else {
                delegate?.selectFilter(withId: option.id)
            }
        } else {
            // Single selection - deselect others in same category
            delegate?.selectFilter(withId: option.id)
        }
    }
}