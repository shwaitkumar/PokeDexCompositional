//
//  PokemonLargeCardCollectionViewCell.swift
//  ModernPokedex
//
//  Created by Shwait Kumar on 18/01/23.
//

import UIKit
import Kingfisher

class PokemonLargeCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer = "pokemon-large-card-item-cell-reuse-identifier"
    
    let container = UIView()
    let pokemonImageView = UIImageView()
    let stackView = UIStackView()
    let pokemonIdLabel = UILabel()
    let pokemonNameLabel = UILabel()
    
    var pokemonIndex: Int? {
        didSet {
            configure()
        }
    }
    
    var image: URL? {
        didSet {
            configure()
        }
    }
    
    var name: String? {
        didSet {
            configure()
        }
    }
    
    var type: String? {
        didSet {
            configure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pokemonIdLabel.text = nil
        pokemonImageView.image = nil
        pokemonNameLabel.text = nil
        pokemonImageView.backgroundColor = UIColor(hexString: "#D8D8AC").withAlphaComponent(0.5)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
}

extension PokemonLargeCardCollectionViewCell {
    func configure() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(hexString: "#FFFFFF")
        container.layer.cornerRadius = 4
        container.layer.shadowColor = UIColor(hexString: "#09203F").cgColor
        container.layer.shadowOpacity = 0.25
        container.layer.shadowRadius = 6
        container.layer.shadowOffset = .init(width: 0, height: 3)
        contentView.addSubview(container)
        
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        if type == "poison" {
            pokemonImageView.backgroundColor = UIColor(hexString: "##9B4DCA").withAlphaComponent(0.5)
        }
        else if type == "fire" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#FF0000").withAlphaComponent(0.5)
        }
        else if type == "water" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#7EE8FA").withAlphaComponent(0.8)
        }
        else if type == "bug" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#7F5A83").withAlphaComponent(0.8)
        }
        else if type == "flying" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#009FFD").withAlphaComponent(0.8)
        }
        else if type == "normal" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#F5F7FA")
        }
        else if type == "electric" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#FFCC2F").withAlphaComponent(0.8)
        }
        else if type == "ground" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#E8BC85")
        }
        else if type == "fairy" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#D65BCA").withAlphaComponent(0.8)
        }
        else if type == "grass" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#0BAB64").withAlphaComponent(0.8)
        }
        else if type == "fighting" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#FDDAC5")
        }
        else if type == "psychic" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#923CB5").withAlphaComponent(0.8)
        }
        else if type == "steel" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#96A7CF")
        }
        else if type == "ice" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#FFFCFF")
        }
        else if type == "rock" {
            pokemonImageView.backgroundColor = UIColor(hexString: "#756213").withAlphaComponent(0.8)
        }
        else {
            pokemonImageView.backgroundColor = UIColor(hexString: "#D8D8AC").withAlphaComponent(0.5)
        }
        pokemonImageView.clipsToBounds = true
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.layer.cornerRadius = 4
        pokemonImageView.kf.setImage(with: image, options: [.cacheOriginalImage])
        container.addSubview(pokemonImageView)
        
        pokemonIdLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonIdLabel.textColor = UIColor(hexString: "#6E45E1")
        pokemonIdLabel.font = .systemFont(ofSize: 14, weight: .bold)
        if let index = pokemonIndex {
            pokemonIdLabel.text = "#\(index)"
        }
        
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNameLabel.textColor = UIColor(hexString: "#461220")
        pokemonNameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        if let pokemonName = name {
            pokemonNameLabel.text = pokemonName.capitalized
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(pokemonIdLabel)
        stackView.addArrangedSubview(pokemonNameLabel)
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            stackView.heightAnchor.constraint(equalToConstant: 38.5),

            pokemonImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            pokemonImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            pokemonImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            pokemonImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5)
        ])
    }
}
