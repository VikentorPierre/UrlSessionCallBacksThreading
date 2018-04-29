import UIKit


class MainVC: UITableViewController {
    var userName = [String]()
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VicksetupNavigationBar()
        setupTableView()
        
        getUsers { (success, response, error) in
            if success{
                guard let names = response as? [String] else{return}
                self.userName = names
                //UITableView.reloadData() must be used from main thread only
                self.tableView.reloadData()}
            else if let er = error{print(er)}
        }
    }//end ViewDidLoad
    
    func VicksetupNavigationBar(){
        tableView.backgroundColor = .white
        navigationItem.title = "CallBacks&Threading"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Get", style: .plain, target: self, action: #selector(get))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(post))
    }
    func setupTableView(){
        tableView.register(Mycell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        //tableView.reloadData()
    }
    // MARK:- URL Session get
   @objc func get (){
        print("get")
        // first get your api end point
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        let mySession = URLSession.shared
        
        mySession.dataTask(with: url) { (data, response, error) in
            if error != nil {print(error ?? "error in dataTask")}
            if let res = response {print(res)}
            if let jsonData = data {
                do{
                    let decoder = JSONDecoder()
                    self.users = try decoder.decode([Users].self, from: jsonData)
                    DispatchQueue.main.async {
                        print(self.users)
                    }
                }catch let err{print(err)}
                
            }
            }.resume()
        
    }// end get
    
    @objc func post (){
        print("post")
        // first get your api end point
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let newPost = Post(userId: 50, id: 110, title: "heloo", body: "helloe world")
        do{
            let jsonBody = try JSONEncoder().encode(newPost)
            request.httpBody = jsonBody

        }catch let er{print(er)}

        let newSession = URLSession.shared
        newSession.dataTask(with: request) { (data, response, error) in
            if let res = response { print(res)}
            if let jsonData = data {
                do{
                    let pureJson = try JSONDecoder().decode(Post.self, from: jsonData)
                    print(pureJson)

                }catch let err{print(err)}

            }

            }.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- GetUsers
    /**
     this func snip reads from a file than put in a string array and
     ### Important Note  ###
     note below are very important
     
     
     */
//  below goes to the viewDidLoad
//    getUsers { (success, response, error) in
//    if success{
//    guard let names = response as? [String] else{return}
//    self.userName = names
//    //UITableView.reloadData() must be used from main thread only
//    self.tableView.reloadData()
//
//    }
//    else if let er = error{print(er)}
//    }
    
    func getUsers(completion:@escaping (Bool, Any?, Error? ) -> Void ){
        // gets file path
        guard let path = Bundle.main.path(forResource: "JsonData", ofType: "txt") else {return}
        // set the url with the path
        let url = URL(fileURLWithPath: path)
        // do catch to turn the data into json
        do{
            // getting the data from the url path
            let data = try Data(contentsOf: url)
            // turn to json
            let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
            // turn json into an Array of dictionary of string:Any
            guard let array = json as? [[String:Any]] else {return}
            // array to hold the data we read
            var names = [String]()
            for i in array{
                guard let name = i["username"] as? String else {continue}
                names.append(name)
            }
            DispatchQueue.main.async {
                completion(true, names, nil )}
        }catch{
            print(error)
            DispatchQueue.main.async {
                completion( false, nil, error)
            }
        }
    }//End getUsers
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userName.count
    }
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Mycell else {return UITableViewCell()}
        cell.textLabel?.text = userName[indexPath.row]
        cell.detailTextLabel?.text = userName[indexPath.row]
        
        return cell
    }
    
}//endClass
class Mycell:UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

