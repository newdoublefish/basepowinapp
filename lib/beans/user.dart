class User {
  int id;
  String name;
  String password;
  String mobile;
  String username;
  String department;
  String role;
  bool is_active;
  bool is_superuser;
  bool is_admin;

  User();

  User.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.department = json['dept_name'],
        this.mobile = json['mobile'],
        this.name = json['name'],
        this.username = json['username'],
        this.password = json['password'],
        this.role = json['role_name'],
        this.is_active = json['is_active'],
        this.is_superuser = json['is_superuser'],
        this.is_admin = json['is_admin'];

  @override
  String toString() {
    // TODO: implement toString
    return '$id,$name,$mobile,$department,$department,$role, $is_superuser, $is_active, $is_admin';
  }
}

