//
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//



import UIKit

class NgoViewController: UIViewController,
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    // ✅ Your data
    private var shownNgos: [NGO] = []
    private var selectedCategory: String? = nil

    // ✅ Header UI (same style as Donor List)
    private var searchBar: UISearchBar!
    private var filterButton: UIButton!

    // ✅ Empty state label
    private let noNgosLabel: UILabel = {
        let label = UILabel()
        label.text = "No NGOs available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browse NGOs"

        tableView.delegate = self
        tableView.dataSource = self

        // ✅ Start list
        shownNgos = arrNgo

        // ✅ Add header (Search + Filter) UNDER the navigation bar (like Donor List)
        setupHeaderSearchAndFilter()

        // ✅ Empty label
        view.addSubview(noNgosLabel)
        noNgosLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNgosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNgosLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        updateNoNgosLabel()

        // Remove default nav bar shadow
        navigationController?.navigationBar.shadowImage = UIImage()

        // Add a bottom line under nav bar
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.systemGray4
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
        ])

        // ✅ Hide back button text for next screen
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }

    // ✅ Helps iPad / rotation keep header width correct
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderWidth()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySearchAndFilter()
    }

    // MARK: - Header (Search + Filter) like Donor List

    private func setupHeaderSearchAndFilter() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
        container.backgroundColor = .systemBackground

        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        // Search bar
        searchBar = UISearchBar()
        searchBar.placeholder = "Search NGOs"
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        // Filter button
        filterButton = UIButton(type: .system)
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        filterButton.tintColor = .label
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)

        header.addSubview(searchBar)
        header.addSubview(filterButton)
        container.addSubview(header)

        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            searchBar.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
            searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),

            filterButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            filterButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
            filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        tableView.tableHeaderView = container
    }

    private func updateHeaderWidth() {
        guard let header = tableView.tableHeaderView else { return }
        let newWidth = tableView.bounds.width
        if header.frame.width != newWidth {
            header.frame.size.width = newWidth
            tableView.tableHeaderView = header
        }
    }

    // MARK: - SearchBar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySearchAndFilter()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownNgos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell") as! NgoTableTableViewCell
        let data = shownNgos[indexPath.row]
       // cell.setupCell(photo: data.photo, name: data.name, category: data.category)
        cell.setupCell(photoUrl: data.photo, name: data.name, category: data.category)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell index = \(indexPath.row)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNgoDetails" {
            let vc = segue.destination as! NgoDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedNgo = shownNgos[indexPath.row]
            }
        }
    }

    // MARK: - Empty State

    private func updateNoNgosLabel() {
        let text = (searchBar?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isSearching = !text.isEmpty || selectedCategory != nil

        if shownNgos.isEmpty {
            noNgosLabel.text = isSearching ? "No results found" : "No NGOs available"
            noNgosLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNgosLabel.isHidden = true
            tableView.isHidden = false
        }
    }

    // MARK: - Filter Button

    @objc private func filterTapped() {
        // TODO: your teammate will implement filter UI later
    }

    // MARK: - Apply Search + Filter

    private func applySearchAndFilter() {
        var result = arrNgo

        // category filter
        if let cat = selectedCategory {
            result = result.filter { $0.category == cat }
        }

        // search by name/category
        let text = (searchBar?.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if !text.isEmpty {
            result = result.filter { ngo in
                ngo.name.lowercased().contains(text) ||
                ngo.category.lowercased().contains(text)
            }
        }

        shownNgos = result
        tableView.reloadData()
        updateNoNgosLabel()
    }
}
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//
