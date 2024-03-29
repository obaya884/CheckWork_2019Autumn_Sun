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

    // ARオブジェクトを乗せるビュー
    @IBOutlet var sceneView: ARSCNView!

    // ポケモンのARオブジェクトファイル名を格納した配列
    let pokemonNameArray: [String] = ["pikachu", "Blastoise", "Bulbasaur", "Charmander", "Cubone", "pm0132_00", "Eevee", "Flareon", "Gardevoir", "Glaceon", "Groudon", "Growlithe", "Jigglypuff", "Jolteon", "Leafeon", "Lucario", "Lugia", "Magikarp", "Meowth", "Mew", "pmxxx1_00_fi", "Oddish", "Pichu", "Psyduck", "Reshiram", "Torchic", "Typhlosion", "Umbreon", "Vaporeon", "Vulpix", "pm0768_00_fi", "Zorua"]

    // 配列用のインデックス
    var index: Int = 0
    
    // BGM用の音楽プレイヤー
    var bgmPlayer: AVAudioPlayer!
    
    // 最初に画面が表示される前のセッティング
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        // BGMの再生（→教科書09.TechPod）
        let bgmPath = URL(fileURLWithPath: Bundle.main.path(forResource: "bgm", ofType: "mp3")!)
        bgmPlayer = try? AVAudioPlayer(contentsOf: bgmPath)
        bgmPlayer?.play()
        
        // sceneViewにARオブジェクトを追加する処理
        // 最初はピカチュウ（配列の0番目）を表示させてる！
        let scene = SCNScene(named: "art.scnassets/\(pokemonNameArray[0]).scn")!
        scene.rootNode.name = "pokemon"
        scene.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(scene.rootNode)
        let cameraPos = SCNVector3Make(0, 0, -0.2)
        let position = sceneView.pointOfView!.convertPosition(cameraPos, to: nil)
        sceneView.scene.rootNode.childNode(withName: "pokemon", recursively: true)?.position = position
    }
    
    // 右矢印のボタンを押した時の動作
    @IBAction func next() {
        // 現在sceneViewに追加している（＝表示している）ARオブジェクトを取り除く
        sceneView.scene.rootNode.enumerateChildNodes{ (node, step) in
            node.removeFromParentNode()
        }

        // インデックスを利用して表示するポケモンを変更していく（教科書06.クラス p33~）
        // 配列のインデックスを操作する
        if index != pokemonNameArray.count - 1 {
            index += 1
        }
        else {
            index = 0
        }
        
        // sceneViewにARオブジェクトを追加する処理（viewDidLoad()に同じ処理があるはず！）
        // インデックスを利用して配列の値にアクセスしよう
        let scene = SCNScene(named: "art.scnassets/\(pokemonNameArray[index]).scn")!
        scene.rootNode.name = "pokemon"
        scene.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(scene.rootNode)
        let cameraPos = SCNVector3Make(0, 0, -0.2)
        let position = sceneView.pointOfView!.convertPosition(cameraPos, to: nil)
        sceneView.scene.rootNode.childNode(withName: "pokemon", recursively: true)?.position = position

    }

    // 左矢印のボタンを押した時の動作
    @IBAction func back() {
        // 現在sceneViewに追加している（＝表示している）ARオブジェクトを取り除く
        sceneView.scene.rootNode.enumerateChildNodes{ (node, step) in
            node.removeFromParentNode()
        }
        
        // インデックスを利用して表示するポケモンを変更する（教科書06.クラス p33~）
        // 配列のインデックスを操作する
        if index == 0 {
            index = pokemonNameArray.count - 1
        }
        else {
            index -= 1
        }
        
        // sceneViewにARオブジェクトを追加する処理（viewDidLoad()に同じ処理があるはず！）
        // インデックスを利用して配列の値にアクセスしよう
        let scene = SCNScene(named: "art.scnassets/\(pokemonNameArray[index]).scn")!
        scene.rootNode.name = "pokemon"
        scene.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(scene.rootNode)
        let cameraPos = SCNVector3Make(0, 0, -0.2)
        let position = sceneView.pointOfView!.convertPosition(cameraPos, to: nil)
        sceneView.scene.rootNode.childNode(withName: "pokemon", recursively: true)?.position = position

    }
    
    // ポケモンボールボタンが押された時の処理（スナップショットを撮って保存する）
    @IBAction func saveSnapShot() {
        // システム音からカメラのシャッター音を鳴らす
        AudioServicesPlaySystemSound(1108)
        // sceneViewのスナップショットをimageに代入する
        let image: UIImage = sceneView.snapshot()
        
        // カメラロールにimageを保存する（→教科書08.TouchEvent p33~）
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        
        // アプリ画面が消える前にBGMを止めておく
        bgmPlayer.stop()
    }

    override func viewWillAppear(_ animated: Bool) {
        // ARKit周りの処理（今回は気にしなくてよし）
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

}
