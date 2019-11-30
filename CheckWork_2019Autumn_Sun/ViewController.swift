//
//  ViewController.swift
//  CheckWork_2019Autumn_Sun
//
//  Created by 大林拓実 on 2019/11/30.
//  Copyright © 2019 Obayashi Takumi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var index: Int = 0
    let pokemonNameArray: [String] = ["Blastoise", "Bulbasaur", "Charmander", "Cubone", "pm0132_00", "Eevee", "Flareon", "Gardevoir", "Glaceon", "Groudon", "Growlithe", "Jigglypuff", "Jolteon", "Leafeon", "Lucario", "Lugia", "Magikarp", "Meowth", "Mew", "pmxxx1_00_fi", "Oddish", "Pichu", "pikachu", "Psyduck", "Reshiram", "Torchic", "Typhlosion", "Umbreon", "Vaporeon", "Vulpix", "pm0768_00_fi", "Zorua"]
    
    var bgmPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        let bgmPath = URL(fileURLWithPath: Bundle.main.path(forResource: "bgm", ofType: "mp3")!)
        bgmPlayer = try? AVAudioPlayer(contentsOf: bgmPath)
        bgmPlayer?.play()
        
        let string = "pikachu"
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/\(string).scn")!
        scene.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(scene.rootNode)
        
    }
    
    @IBAction func next() {
        sceneView.scene.rootNode.enumerateChildNodes{ (node, step) in
            node.removeFromParentNode()
        }
        
        if index != pokemonNameArray.count - 1 {
            index += 1
        }
        else {
            index = 0
        }
        
        let scene = SCNScene(named: "art.scnassets/\(pokemonNameArray[index]).scn")!
        scene.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(scene.rootNode)

    }
    
    @IBAction func back() {
        sceneView.scene.rootNode.enumerateChildNodes{ (node, step) in
            node.removeFromParentNode()
        }
        
        if index == 0 {
            index = pokemonNameArray.count - 1
        }
        else {
            index -= 1
        }
        
        let scene = SCNScene(named: "art.scnassets/\(pokemonNameArray[index]).scn")!
        scene.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(scene.rootNode)

    }
    
    @IBAction func saveSnapShot() {
        AudioServicesPlaySystemSound(1108)
        let image: UIImage = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        bgmPlayer.stop()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
