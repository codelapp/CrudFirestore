import UIKit
import Firebase
class EditarViewController: UIViewController {

    var editarUsuario : Usuarios!
    var ref : DocumentReference!
    var id = ""
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nombre.text = editarUsuario.nombre!
        apellido.text = editarUsuario.apellido!
        id = editarUsuario.id!
        ref = Firestore.firestore().collection("usuarios").document(id)
    }

    @IBAction func editar(_ sender: UIButton) {
        
        let campos : [String:Any] = ["nombre":nombre.text!,"apellido":apellido.text!]
        ref.setData(campos) { (error) in
            if let error = error?.localizedDescription {
                print("fallo al actualizar", error)
            }else{
                print("actualizo")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
