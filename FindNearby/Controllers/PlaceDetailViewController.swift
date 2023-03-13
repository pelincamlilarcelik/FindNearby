//
//  PlaceDetailViewController.swift
//  FindNearby
//
//  Created by Onur Celik on 13.03.2023.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.alpha = 0.4
        return label
    }()
    lazy var directionButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.bordered()
        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var callButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.bordered()
        button.setTitle("Call", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()

        
    }
    @objc private func directionsButtonTapped(){
        let coordinate = place.location.coordinate
        guard let url = URL(string: "https://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else
        {return}
        UIApplication.shared.open(url)
        
    }
    @objc private func callButtonTapped(){
        guard let url  = URL(string: "tel://\(place.phone.formattedPhoneNumber)") else {return}
        UIApplication.shared.open(url)
        
    }
    private func setUpUI(){
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIStackView.spacingUseDefault
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        nameLabel.text = place.name
        addressLabel.text = place.address
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        //nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width-20).isActive = true
        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem
        directionButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        contactStackView.addArrangedSubview(directionButton)
        contactStackView.addArrangedSubview(callButton)
        stackView.addArrangedSubview(contactStackView)
        view.addSubviews(stackView)
        
        
    }

    

}
