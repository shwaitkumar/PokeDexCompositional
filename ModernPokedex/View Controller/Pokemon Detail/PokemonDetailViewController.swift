//
//  PokemonDetailViewController.swift
//  ModernPokedex
//
//  Created by Shwait Kumar on 19/01/23.
//

import UIKit
import TinyConstraints
import Kingfisher

class PokemonDetailViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }() // Content View
    
    private let pokemonImageView = StretchyHeaderView()
    
    private let contentView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        return container
    }()
    
    private let pokemonIdLabel: UILabel = {
        let id = UILabel()
        id.font = .systemFont(ofSize: 30, weight: .bold)
        id.isHidden = true
        return id
    }()
    
    private let pokemonNameLabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 30, weight: .bold)
        name.numberOfLines = 0
        name.isHidden = true
        return name
    }()
    
    private let pokemonTypeView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.isHidden = true
        return view
    }()
    
    private let pokemonType: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private let pokemonDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private var contentViewHeightConstraint: NSLayoutConstraint?
    
    private var pokemonData: Pokemon?
    
    private var imageBackgroundColor: UIColor = .white
    
    init(pokemonImage: UIImage, tag: Int, backgroundColor: UIColor, pokemonData: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        pokemonImageView.tag = tag
        pokemonImageView.imageView.image = pokemonImage
        pokemonImageView.imageView.backgroundColor = backgroundColor
        pokemonImageView.backgroundColor = .white
        self.pokemonData = pokemonData
        imageBackgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.contentViewHeightConstraint?.constant = self.view.frame.height * 0.75
            self.view.layoutIfNeeded()
        }) { _ in
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            self.pokemonIdLabel.layer.add(transition, forKey: nil)
            self.pokemonNameLabel.layer.add(transition, forKey: nil)
            self.pokemonType.layer.add(transition, forKey: nil)
            self.pokemonTypeView.layer.add(transition, forKey: nil)
            self.pokemonDescription.layer.add(transition, forKey: nil)
            self.pokemonIdLabel.isHidden = false
            self.pokemonNameLabel.isHidden = false
            self.pokemonTypeView.layer.cornerRadius = self.pokemonTypeView.bounds.height / 2
            self.pokemonType.isHidden = false
            self.pokemonTypeView.isHidden = false
            self.pokemonDescription.isHidden = false
            self.view.backgroundColor = .white
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.backgroundColor = .clear
        self.contentViewHeightConstraint?.constant = 0
        self.pokemonIdLabel.isHidden = true
        self.pokemonNameLabel.isHidden = true
        self.pokemonType.isHidden = true
        self.pokemonTypeView.isHidden = true
        self.pokemonDescription.isHidden = true
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(scrollView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.addSubview(wrapperView)
        wrapperView.addSubview(contentView)
        wrapperView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonIdLabel)
        contentView.addSubview(pokemonNameLabel)
        contentView.addSubview(pokemonTypeView)
        contentView.addSubview(pokemonType)
        contentView.addSubview(pokemonDescription)
        
        contentView.layer.cornerRadius = view.bounds.width * 0.05
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        if let pokemonId = pokemonData?.id {
            pokemonIdLabel.text = "#\(pokemonId)"
        }
        pokemonNameLabel.text = pokemonData?.name.capitalized
        pokemonType.text = pokemonData?.type.uppercased()
        pokemonType.textColor = .white
        pokemonDescription.text = pokemonData?.description
        
        pokemonImageView.contentMode = traitCollection.horizontalSizeClass == .compact ? .scaleAspectFit : .scaleAspectFill
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        pokemonIdLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonType.translatesAutoresizingMaskIntoConstraints = false
        pokemonTypeView.translatesAutoresizingMaskIntoConstraints = false
        pokemonDescription.translatesAutoresizingMaskIntoConstraints = false
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            wrapperView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            wrapperView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wrapperView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),

            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            pokemonImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: traitCollection.horizontalSizeClass == .compact ? 0.5 : 0.75),
            pokemonImageView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            pokemonImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),

            pokemonIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pokemonIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            pokemonNameLabel.leadingAnchor.constraint(equalTo: pokemonIdLabel.trailingAnchor, constant: 10),
            pokemonNameLabel.topAnchor.constraint(equalTo: pokemonIdLabel.topAnchor),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            pokemonType.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 10),
            
            pokemonTypeView.leadingAnchor.constraint(equalTo: pokemonIdLabel.leadingAnchor),
            pokemonTypeView.topAnchor.constraint(equalTo: pokemonType.topAnchor, constant: -5),
            pokemonTypeView.bottomAnchor.constraint(equalTo: pokemonType.bottomAnchor, constant: 5),
            
            pokemonType.leadingAnchor.constraint(equalTo: pokemonTypeView.leadingAnchor, constant: 20),
            pokemonType.trailingAnchor.constraint(equalTo: pokemonTypeView.trailingAnchor, constant: -20),
            
            pokemonDescription.leadingAnchor.constraint(equalTo: pokemonIdLabel.leadingAnchor),
            pokemonDescription.topAnchor.constraint(equalTo: pokemonTypeView.bottomAnchor, constant: 20),
            pokemonDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
    }

}

// MARK: - ScrollView Delegate
extension PokemonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pokemonImageView.scrollviewDidScroll(scrollView: scrollView)
    }
}

