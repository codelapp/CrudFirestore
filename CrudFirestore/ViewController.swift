import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    
    var ref: DocumentReference!
    var getRef : Firestore!
    
    var listaUsuarios = [Usuarios]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        getRef = Firestore.firestore()
        //todo()
        realTime()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaUsuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user : Usuarios
        user = listaUsuarios[indexPath.row]
        cell.textLabel?.text = user.nombre
        cell.detailTextLabel?.text = user.apellido
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar" {
            if let id = tabla.indexPathForSelectedRow {
                let fila = listaUsuarios[id.row]
                let destino = segue.destination as! EditarViewController
                destino.editarUsuario = fila
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let borrar = UITableViewRowAction(style: .destructive, title: "borrar") { (action, indexPath) in
            let user : Usuarios
            user = self.listaUsuarios[indexPath.row]
            let id = user.id
            self.getRef.collection("usuarios").document(id!).delete()
        }
        return [borrar]
    }
    
    
    
    
    func todo(){
        
        getRef.collection("usuarios").whereField("nombre", isEqualTo: "pedro").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("hubo un error al traer los datos", error)
            }else{
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let valores = document.data()
                    let nombre = valores["nombre"] as? String ?? ""
                    let apellido = valores["apellido"] as? String ?? "sin apellido"
                    let users = Usuarios(nombre: nombre, apellido: apellido, id: id)
                    self.listaUsuarios.append(users)
                    self.tabla.reloadData()
                }
            }
        }
        
/*
        getRef.collection("usuarios").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("hubo un error al traer los datos", error)
            }else{
                for document in querySnapshot!.documents {
                    let valores = document.data()
                    let nombre = valores["nombre"] as? String ?? ""
                    let apellido = valores["apellido"] as? String ?? "sin apellido"
                    let users = Usuarios(nombre: nombre, apellido: apellido)
                    self.listaUsuarios.append(users)
                    self.tabla.reloadData()
                }
            }
        }
 
*/
    }
    
    func realTime(){
        getRef.collection("usuarios").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("hubo un error al traer los datos", error)
            }else{
                self.listaUsuarios.removeAll()
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let valores = document.data()
                    let nombre = valores["nombre"] as? String ?? ""
                    let apellido = valores["apellido"] as? String ?? "sin apellido"
                    let users = Usuarios(nombre: nombre, apellido: apellido, id: id)
                    self.listaUsuarios.append(users)
                    self.tabla.reloadData()
                }
            }
        }
    }
    

    @IBAction func guardar(_ sender: UIButton) {
        
        let campos : [String:Any] = ["nombre": nombre.text!, "apellido":apellido.text!]
        ref = getRef.collection("usuarios").addDocument(data: campos, completion: { (error) in
            if let error = error?.localizedDescription {
                print("error de firebase al guardar", error)
            }else{
                print("guardo correctamente")
            }
        })
        
    }
    
}

