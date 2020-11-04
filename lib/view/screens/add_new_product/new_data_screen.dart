import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/products.dart';
import '../../../provider/products_model.dart';
import '../../../utilis/constants.dart';
import 'package:toast/toast.dart';
import 'validator.dart';

class NewProduct extends StatefulWidget {
  static const String routeName = '/new_product_screen';

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> with FormValidation {
  final _titleTextFiled = TextEditingController();
  final _priceTextFiled = TextEditingController();
  final _descriptionTextFiled = TextEditingController();
  final _imaggeUrlTextFiled = TextEditingController();

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imaggeUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _isInit = true;
  bool isLoading = false;
  String selectedValue = 'Men';

  var _editedProduct = ProductModel(
      id: null,
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
      category: '');
  @override
  void initState() {
    _imaggeUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imaggeUrlFocusNode.removeListener(_updateImageUrl);
    _titleTextFiled.dispose();
    _priceTextFiled.dispose();
    _descriptionTextFiled.dispose();
    _imaggeUrlTextFiled.dispose();

    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imaggeUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(id: productId);

        _titleTextFiled.text = _editedProduct.title;
        _priceTextFiled.text = _editedProduct.price.toString();
        _descriptionTextFiled.text = _editedProduct.description;
        _imaggeUrlTextFiled.text = _editedProduct.imageUrl;
        selectedValue = _editedProduct.category;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imaggeUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  DropdownButton getDropDownItem() {
    List<DropdownMenuItem<String>> _listItem = [];
    for (String item in categoryList) {
      var newItem = DropdownMenuItem(
        value: item,
        child: Center(
          child: Text(item),
        ),
      );
      _listItem.add(newItem);
    }
    return DropdownButton<String>(
        hint: Text(
          'Category',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        style: kTextStyleTitle.copyWith(color: Colors.black),
        underline: SizedBox(),
        value: selectedValue,
        items: _listItem,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            _editedProduct = ProductModel(
                id: _editedProduct.id,
                title: _editedProduct.title,
                price: _editedProduct.price,
                description: _editedProduct.description,
                imageUrl: _editedProduct.imageUrl,
                category: value);
          });
        });
  }

  Future<void> onSave() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      if (_editedProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        Navigator.of(context).pop();
        Toast.show('updated!', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addNewProduct(_editedProduct);
          Toast.show('new item added!', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('An error occured'),
                  content: Text(error.toString()),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK')),
                  ],
                );
              });
        } finally {
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Product')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 10, bottom: 10),
                        child: getDropDownItem(),
                      ),
                      titleFormField(),
                      SizedBox(height: 20),
                      priceFormField(),
                      SizedBox(height: 20),
                      descriptionFormField(),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.indigo,
                            )),
                            child: _imaggeUrlTextFiled.text.isEmpty
                                ? Text('Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imaggeUrlTextFiled.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: imageUrlFormField()),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          onPressed: () {
                            onSave();
                          },
                          child: Text(
                            _editedProduct.id != null ? 'Update' : 'Save',
                            style:
                                kTextStyleButton.copyWith(color: Colors.white),
                          ),
                          color: Colors.indigo,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  TextFormField titleFormField() {
    return TextFormField(
      onFieldSubmitted: (value) {
        onSave();
      },
      onSaved: (value) {
        _editedProduct = ProductModel(
            id: _editedProduct.id,
            title: value,
            price: _editedProduct.price,
            description: _editedProduct.description,
            imageUrl: _editedProduct.imageUrl,
            category: _editedProduct.category);
      },
      validator: titleValidator,
      controller: _titleTextFiled,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'title',
        hintText: 'title',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField priceFormField() {
    return TextFormField(
      onFieldSubmitted: (value) {
        onSave();
      },
      onSaved: (value) {
        _editedProduct = ProductModel(
            id: _editedProduct.id,
            title: _editedProduct.title,
            price: double.parse(value),
            description: _editedProduct.description,
            imageUrl: _editedProduct.imageUrl,
            category: _editedProduct.category);
      },
      validator: priceValidator,
      focusNode: _priceFocusNode,
      controller: _priceTextFiled,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'price',
        hintText: 'price',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField descriptionFormField() {
    return TextFormField(
      onFieldSubmitted: (value) {
        onSave();
      },
      onSaved: (value) {
        _editedProduct = ProductModel(
            id: _editedProduct.id,
            title: _editedProduct.title,
            price: _editedProduct.price,
            description: value,
            imageUrl: _editedProduct.imageUrl,
            category: _editedProduct.category);
      },
      validator: descriptionValidator,
      focusNode: _descriptionFocusNode,
      controller: _descriptionTextFiled,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'description',
        hintText: 'description',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField imageUrlFormField() {
    return TextFormField(
      onFieldSubmitted: (value) {
        onSave();
      },
      onSaved: (value) {
        _editedProduct = ProductModel(
            id: _editedProduct.id,
            title: _editedProduct.title,
            price: _editedProduct.price,
            description: _editedProduct.description,
            imageUrl: value,
            category: _editedProduct.category);
      },
      validator: imageUrlValidator,
      focusNode: _imaggeUrlFocusNode,
      controller: _imaggeUrlTextFiled,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'description',
        hintText: 'description',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
