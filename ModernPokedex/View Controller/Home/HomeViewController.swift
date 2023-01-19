//
//  HomeViewController.swift
//  ModernPokedex
//
//  Created by Shwait Kumar on 18/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let topView = UIView()
    private let titleLabel = UILabel()
    
    private var collectionView: UICollectionView! = nil
    
    private var datasource: Datasource!
    
    enum Section: CaseIterable {
        case pokemonList
    }
    
    enum Item: Hashable {
        case pokemon(Pokemon)
    }
    
    public var pokemonData: [Pokemon]?
    
    private var pokemonTransitionManager: PokemonTransitionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a diagonal gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#F6F0EA").cgColor, UIColor(hexString: "#F6F0EA").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        configureCollectionView()
        configureUi()
        configureDatasource()
//        addData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.shadowColor = UIColor(hexString: "#09203F").cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 6)
        shapeLayer.shadowOpacity = 0.25
        shapeLayer.shadowRadius = 10
            
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#A71D31").cgColor, UIColor(hexString: "#3F0D12").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = topView.superview?.bounds ?? topView.bounds // to apply gradient to part of shape which is outside the bounds of topView
        gradientLayer.mask = shapeLayer

        topView.layer.addSublayer(gradientLayer)
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = view.bounds.width * 0.10 // Height of the wave-like curve
        let path = UIBezierPath()
        let width = topView.frame.width
        // Creating a wave-like bottom edge for top view starting from left side
        path.move(to: CGPoint(x: 0, y: topView.frame.height)) // Start at bottom left corner with extra height
        path.addQuadCurve(to: CGPoint(x: width/2, y: topView.frame.height), controlPoint: CGPoint(x: width/4, y: topView.frame.height + height))
        path.addQuadCurve(to: CGPoint(x: width, y: topView.frame.height), controlPoint: CGPoint(x: width*3/4, y: topView.frame.height - height))
        path.addLine(to: CGPoint(x: topView.frame.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        return path.cgPath
    }

}

// MARK: - Add Data
extension HomeViewController {
    func addData() {
        SimpleNetworkHelper.shared.fetchPokemon(completion: { (pokemon) in
            if let pokemon = pokemon {
                self.pokemonData = pokemon
                let maxAttack = pokemon.max { $0.attack < $1.attack }?.attack
                debugPrint("Max attack - ", maxAttack)
                let maxDefence = pokemon.max { $0.defense < $1.defense }?.defense
                debugPrint("Max DEfence - ", maxDefence)
                DispatchQueue.main.async {
                    self.generatePokemonSnapshot(animated: true)
                }
            }
        })
    }
}

// MARK: - Setup CollectionView & Layout
extension HomeViewController {
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        
        collectionView.contentInset = UIEdgeInsets(top: view.bounds.width * (traitCollection.horizontalSizeClass == .compact ? 0.33 : 0.36), left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: view.bounds.width * (traitCollection.horizontalSizeClass == .compact ? 0.33 : 0.36), left: 0, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        
        // Cells
        collectionView.register(PokemonLargeCardCollectionViewCell.self, forCellWithReuseIdentifier: PokemonLargeCardCollectionViewCell.reuseIdentifer)
        
        self.collectionView = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.traitCollection.horizontalSizeClass == .regular
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .pokemonList:
                return self.generatePokemonList(isWide: isWideView)
            }
            
        }
        
        return layout
    }
    
    private func generatePokemonList(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)

        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.33 : 0.66)
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(5)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5)

        return section
    }

}

// MARK: - Collection View Datasource
extension HomeViewController {
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        })
    }
    
    // MARK: Cell
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        switch item {
        case .pokemon(let data):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonLargeCardCollectionViewCell.reuseIdentifer, for: indexPath) as? PokemonLargeCardCollectionViewCell else { fatalError("Could not create new cell") }

            cell.pokemonIndex = data.id
            cell.image = data.imageUrl
            cell.name = data.name
            cell.type = data.type
            
            // TODO: - Delete
            cell.pokemonImageView.tag =  (indexPath.item + 1) * 100

            return cell
        }
    }
    
    private func generatePokemonSnapshot(animated: Bool) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.pokemonList])
        
        if let pokemon = self.pokemonData {
            snapshot.appendItems(pokemon.map(Item.pokemon), toSection: .pokemonList)
        }
        
        datasource.apply(snapshot, animatingDifferences: animated)
    }

}

// MARK: - Collection View Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PokemonLargeCardCollectionViewCell else {
            return
        }
        
        if let pokemonImage = cell.pokemonImageView.image {
            UIView.animate(withDuration: 0.065, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                collectionView.cellForItem(at: indexPath)?.transform = .init(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.065, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    collectionView.cellForItem(at: indexPath)?.transform = .identity
                }) { _ in
                    let pokemonTransitionManager = PokemonTransitionManager(anchorViewTag: (indexPath.item + 1) * 100)
                    let pokemonViewController = PokemonDetailViewController(pokemonImage: pokemonImage, tag: (indexPath.item + 1) * 100, backgroundColor: cell.pokemonImageView.backgroundColor ?? .clear, pokemonData: self.pokemonData![indexPath.item])
                    pokemonViewController.modalPresentationStyle = .custom
                    pokemonViewController.transitioningDelegate = pokemonTransitionManager
                    self.present(pokemonViewController, animated: true)
                    self.pokemonTransitionManager = pokemonTransitionManager
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            collectionView.cellForItem(at: indexPath)?.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            collectionView.cellForItem(at: indexPath)?.transform = .identity
        }
    }
}

// MARK: - Configure UI
extension HomeViewController {
    func configureUi() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        topView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Pokemon!"
        titleLabel.font = .systemFont(ofSize: traitCollection.horizontalSizeClass == .compact ? 32 : 64, weight: .heavy)
        titleLabel.textColor = UIColor(hexString: "#F5F7FA")
        view.addSubview(titleLabel)
            
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: view.bounds.width * (traitCollection.horizontalSizeClass == .compact ? 0.4 : 0.33)),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: view.bounds.width *  0.10)
        ])
    }

}

