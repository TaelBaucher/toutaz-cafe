import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _settingsController;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _newNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _typeController;
  
  bool _isAddProduct = false;
  bool _isRetireProduct = false;
  bool _isChangeStock = false;
  bool _isChangePrice = false;
  bool _isChangeName = false;
  bool _isChangePassword = false;

  @override
  void initState() {
    super.initState();
    _settingsController = SettingsController();
  }

  final List<String> types = [
    "Soda",
    "Diabolo",
    "Jus de fruits",
    "Smoothie",
    "Sirop",
    "Thé",
    "Café",
    "Chocolat",
    "Snack salé",
    "Snack sucré"
  ];

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: "Nom du produit",
        hintText: _typeController ?? "Rentrer le nom du produit",
        hintStyle: TextStyle(
          color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.coffee_outlined),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nom du produit requit";
        } else {
          return null;
        }
      },
    );
  }

  Widget _newNameField() {
    return TextFormField(
      controller: _newNameController,
      decoration: InputDecoration(
        labelText: "Nouveau nom du produit",
        hintText: _typeController ?? "Rentrer le nouveau nom",
        hintStyle: TextStyle(
          color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.coffee_outlined),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nouveau nom du produit requit";
        } else {
          return null;
        }
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Mot de passe actuel",
        hintText: _typeController ?? "Rentrer le mot de passe actuel",
        hintStyle: TextStyle(
          color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.lock_open_outlined),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Mot de passe requis";
        } else {
          return null;
        }
      },
    );
  }

  Widget _newPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Nouveau mot de passe",
        hintText: _typeController ?? "Rentrer le nouveau mot de passe",
        hintStyle: TextStyle(
          color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.lock_open_outlined),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nouveau mot de passe requis";
        } else if (value.length < 6) {
          return "Le mot de passe doit faire minimum 6 chiffres";
        } else {
          return null;
        }
      },
    );
  }

  Widget _quantityField() {
    return TextFormField(
      controller: _quantityController,
      decoration: InputDecoration(
        labelText: "Quantité du produit",
        hintText: _typeController ?? "Rentrer la quantité du produit",
        hintStyle: TextStyle(
          color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.numbers_outlined),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Quantité du produit  requit";
        } else if (int.tryParse(value) == null) {
          return "La valeur doit être entière";
        } else {
          return null;
        }
      },
    );
  }

  Widget _priceField() {
    return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Prix du produit",
          hintText: _typeController ?? "Rentrer le prix du produit",
          hintStyle: TextStyle(
            color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(Icons.euro_outlined),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
        controller: _priceController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Prix du produit  requit";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _typeField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Type de produit",
          hintText: _typeController ?? "Sélectionner le type du produit",
          hintStyle: TextStyle(
            color: _typeController != null ? Colors.grey[800] : Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(Icons.category_outlined),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
        onTap: () => _showTypeSelectionBottomSheet(context),
        validator: (value) {
          if (_typeController == null || _typeController!.isEmpty) {
            return "Type du produit requis";
          }
          return null;
        },
      ),
    );
  }

  void _showTypeSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.category_outlined),
                    const SizedBox(width: 12),
                    Text("Sélectionner le type du produit"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Options list
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final type = types[index];
                    final isSelected = type == _typeController;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _typeController = type;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[50] : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.deepPurple : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? Colors.deepPurple : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected ? Colors.deepPurple : Colors.grey[800],
                                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _validateSettings() async {
    if (_isAddProduct) {
      _settingsController.addProduct(
          _nameController.text,
          _typeController!,
          double.parse(_priceController.text)
      );
    } else if (_isRetireProduct) {
      _settingsController.retireProduct(
          _nameController.text
      );
    } else if (_isChangeStock) {
      _settingsController.changeStock(
          _nameController.text,
          int.parse(_quantityController.text)
      );
    } else if (_isChangePrice) {
      _settingsController.changePrice(
          _nameController.text,
          double.parse(_priceController.text)
      );
    } else if (_isChangeName) {
      _settingsController.changeName(
          _nameController.text,
          _newNameController.text
      );
    } else {
      _settingsController.changeName(
        _passwordController.text,
        _newPasswordController.text
      );
    }

    setState(() {
      _isAddProduct = false;
      _isRetireProduct = false;
      _isChangeStock = false;
      _isChangePrice = false;
      _isChangeName = false;
      _isChangePassword = false;
      _typeController = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRetireProduct = false;
                      _isChangeStock = false;
                      _isChangePrice = false;
                      _isChangeName = false;
                      _isAddProduct = !_isAddProduct;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isAddProduct
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_right),
                      ),
                      Center(
                        child: Text(
                          "Ajouter un produit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isAddProduct) const SizedBox(height: 5,),
              if (_isAddProduct) _nameField(),
              if (_isAddProduct) const SizedBox(height: 5,),
              if (_isAddProduct) _priceField(),
              if (_isAddProduct) const SizedBox(height: 5,),
              if (_isAddProduct) _typeField(),
              if (_isAddProduct) const SizedBox(height: 5,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRetireProduct = !_isRetireProduct;
                      _isChangeStock = false;
                      _isChangePrice = false;
                      _isChangeName = false;
                      _isAddProduct = false;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isRetireProduct
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_right),
                      ),
                      Center(
                        child: Text(
                          "Retirer un produit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isRetireProduct) const SizedBox(height: 5,),
              if (_isRetireProduct) _nameField(),
              if (_isRetireProduct) const SizedBox(height: 5,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isRetireProduct = false;
                        _isChangeStock = !_isChangeStock;
                        _isChangePrice = false;
                        _isChangeName = false;
                        _isAddProduct = false;
                      });
                    },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isChangeStock
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_right),
                      ),
                      Center(
                        child: Text(
                          "Changer le stock d'un produit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isChangeStock) const SizedBox(height: 5,),
              if (_isChangeStock) _nameField(),
              if (_isChangeStock) const SizedBox(height: 5,),
              if (_isChangeStock) _quantityField(),
              if (_isChangeStock) const SizedBox(height: 5,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isRetireProduct = false;
                        _isChangeStock = false;
                        _isChangePrice = !_isChangePrice;
                        _isChangeName = false;
                        _isAddProduct = false;
                      });
                    },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isChangePrice
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_right),
                      ),
                      Center(
                        child: Text(
                          "Changer le prix d'un produit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isChangePrice) const SizedBox(height: 5,),
              if (_isChangePrice) _nameField(),
              if (_isChangePrice) const SizedBox(height: 5,),
              if (_isChangePrice) _priceField(),
              if (_isChangePrice) const SizedBox(height: 5,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isRetireProduct = false;
                        _isChangeStock = false;
                        _isChangePrice = false;
                        _isChangeName = !_isChangeName;
                        _isAddProduct = false;
                      });
                    },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isChangeName
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_right),
                      ),
                      Center(
                        child: Text(
                          "Changer le nom d'un produit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isChangeName) const SizedBox(height: 5,),
              if (_isChangeName) _nameField(),
              if (_isChangeName) const SizedBox(height: 5,),
              if (_isChangeName) _newNameField(),
              if (_isChangeName) const SizedBox(height: 5,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRetireProduct = false;
                      _isChangeStock = false;
                      _isChangePrice = false;
                      _isChangeName = false;
                      _isAddProduct = false;
                      _isChangePassword = !_isChangePassword;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isChangePassword
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_right),
                      ),
                      Center(
                        child: Text(
                          "Changer le mot de passe",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isChangePassword) const SizedBox(height: 5,),
              if (_isChangePassword) _passwordField(),
              if (_isChangePassword) const SizedBox(height: 5,),
              if (_isChangePassword) _newPasswordField(),
              if (_isChangePassword) const SizedBox(height: 5,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _validateSettings();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              shadowColor: Colors.deepPurple.withOpacity(0.4),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Valider les paramètres"),
          ),
        ),
      )
    );
  }
}