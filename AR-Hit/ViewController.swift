//
//  ViewController.swift
//  AR-Hit
//
//  Created by Thiago Martins on 03/11/20.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    @IBAction func play(_ sender: Any) {
        self.addNode()
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    func addNode(){
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        jellyFishNode?.position = SCNVector3(0, 0, -0.5)
        self.sceneView.scene.rootNode.addChildNode(jellyFishNode!)
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let results = hitTest.first!
            let node = results.node
            self.animateNode(node: node)
        }
    }
    
    func animateNode(node: SCNNode){
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position // presentation representa o estado atual do objeto dentro da cena
        
        spin.toValue = SCNVector3(0,0,-2)
        
        
    }
}

