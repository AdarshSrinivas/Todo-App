import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../model/todo.dart';


// ignore: must_be_immutable
class AddCategory extends StatefulWidget {

  AddCategory({Key? key,}) : super(key: key);
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String colorString='';
  Color pickerColor = Color(0xff6633ff);
  Color currentColor = Color(0xff6633ff);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(13),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Add Category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (title) => setState(
                      () => this._title = title,
                    ),
                    maxLines: 1,
                    validator: (_title) {
                      if (_title!.isEmpty) {
                        return 'The Title cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 80,
                    onChanged: (description) => setState(
                      () => this._description = description,
                    ),
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      elevation: 3.0,
                      onPressed: () {
                        pickerColor = currentColor;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  enableAlpha: false,
                                  onColorChanged: changeColor,
                                  showLabel: false,
                                ),
                              ),
                              actions: <Widget>[
                                // ignore: deprecated_member_use
                                FlatButton(
                                  child: Text('Got it'),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Card color'),
                      color: currentColor,
                      textColor: const Color(0xffffffff),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.amber),
                      ),
                      onPressed: () {
                        final isValid = formKey.currentState!.validate();
                        FocusScope.of(context).unfocus();
    
                        if (isValid) {
                          formKey.currentState!.save();
                        }
                        if (_title.isNotEmpty) {
                          colorString =
                              pickerColor.toString().split('(')[1].split(')')[0];
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Category Added')));
                          Navigator.pop(context,Todo(this.colorString,this._title,this._description));
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }
}
