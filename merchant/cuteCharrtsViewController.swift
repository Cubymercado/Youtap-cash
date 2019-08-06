//
//  cuteCharrtsViewController.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 15/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import UIKit
import SMDiagramViewSwift

class cuteCharrtsViewController: UIViewController, SMDiagramViewDataSource {

    // Variables
    var myProducts: [Products1] = []
    var product: Products1?
    let dataSource = [1, 2, 3, 4, 5]
    
 

    @IBOutlet weak var diagramView: SMDiagramView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diagramView.dataSource = self

        diagramView.minProportion = 0.1
        diagramView.diagramViewMode = .arc // or .segment
        diagramView.diagramOffset = .zero
        diagramView.radiusOfSegments = 80.0
        diagramView.radiusOfViews = 130.0
        diagramView.arcWidth = 6.0 //Ignoring for SMDiagramViewMode.segment
        diagramView.startAngle = -.pi/2
        diagramView.endAngle = 2.0 * .pi - .pi/2.0
        diagramView.colorOfSegments = .black
        diagramView.viewsOffset = .zero
        diagramView.separatorWidh = 1.0
        
    }
    
    
    // Graph function
    func numberOfSegmentsIn(diagramView: SMDiagramView) -> Int {
        
        return dataSource.count
    }


}
