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
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    @IBAction func play(_ sender: Any) {
        self.playButton.isEnabled = false
        self.addNode()
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    func addNode(){
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        jellyFishNode?.position = SCNVector3(randomNumbers(firstNum: -1, secondNum: 1), randomNumbers(firstNum: -0.5, secondNum: 0.5), randomNumbers(firstNum: -1, secondNum: 1))
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
            
            if node.animationKeys.isEmpty{//faz a animação acontecer so se nao tiver animando antes
               
                SCNTransaction.begin()
                self.animateNode(node: node)
                SCNTransaction.completionBlock = { // executa quando terminar a animacao
                    node.removeFromParentNode()
                }
                SCNTransaction.commit()
            }
           
        }
    }
    
    func animateNode(node: SCNNode){
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position // presentation representa o estado atual do objeto dentro da cena
        
        spin.toValue = SCNVector3(node.presentation.position.z - 0.4, node.presentation.position.z - 0.2, node.presentation.position.z - 1) // Relativo à origem do mundo, por isso tem que colocar node.presentatio.z
        spin.duration = 3 // a animacao dura 3 seg pra ir e 3 pra voltar
        spin.autoreverses = true // usa a mesma animação pra voltar pra posicao original
        
        node.addAnimation(spin, forKey: "position")
        
        
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
            return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum - secondNum, 0)
            
        }
}

