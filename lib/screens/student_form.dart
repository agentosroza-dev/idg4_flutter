import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/my_message.dart';
import '../logics/major_logic.dart';
import '../logics/student_logic.dart';
import '../models/major_model.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StudentForm extends StatefulWidget {
  Datum? student;

  StudentForm({super.key, this.student});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();
  final _service = StudentService();

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      _nameCtrl.text = widget.student!.name;
    }
  }

  void _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  String _output = "";
  bool _edited = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text;
    final majorId = _selectedMajor!.id;

    if (widget.student == null) {
      _service
          .insertStudents(context, name, majorId, _imageFile)
          .then((value) {
            _edited = true;
            // setState(() => _output = value.toString());
            if(_edited){
              MyMessage(context, "Student inserted");
              context.read<StudentLogic>().readStudents(context);
            }
          })
          .onError((e, s) {
            setState(() => _output = e.toString());
          });
    } else {
      _service
          .updateStudent(context, widget.student!.id, name, majorId, _imageFile)
          .then((value) {
            _edited = true;
            // setState(() => _output = value.toString());
            if (_edited) {
              MyMessage(context, "Student updated");
              context.read<StudentLogic>().readStudents(context);
            }
          })
          .onError((e, s) {
            setState(() => _output = e.toString());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (mounted) Navigator.of(context).pop(_edited);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (mounted) Navigator.of(context).pop(_edited);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(isEditing ? 'Edit Student' : 'New Student'),
        ),

        body: _buildBody(isEditing),
      ),
    );
  }

  Widget _buildBody(bool isEditing) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildNameTextField(),
            const SizedBox(height: 10),
            _buildMajorDropdown(),
            const SizedBox(height: 10),
            _buildImagePickerButton(),
            _buildImageFrame(isEditing),
            const SizedBox(height: 20),
            _buildButton(isEditing),
            Text(_output),
          ],
        ),
      ),
    );
  }

  MajorModel? _selectedMajor;
  
  Widget _buildMajorDropdown() {
    List<MajorModel> majors = context.watch<MajorLogic>().majors;

    // When editing, auto-select by matching id
    if (widget.student != null && _selectedMajor == null && majors.isNotEmpty) {
      _selectedMajor = majors.firstWhere(
        (m) => m.id == widget.student!.majorId,
        orElse: () => majors.first,
      );
    }

    return DropdownButtonFormField<MajorModel>(
      initialValue: _selectedMajor,
      items: majors.map((x) {
        return DropdownMenuItem<MajorModel>(value: x, child: Text(x.title));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedMajor = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Major',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      controller: _nameCtrl,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildImagePickerButton() {
    return FilledButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.image),
      label: const Text('Pick Image'),
    );
  }

  Widget _buildImageFrame(bool isEditing) {
    if (_imageFile != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Image.file(_imageFile!, height: 150),
      );
    } else if (isEditing) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CachedNetworkImage(
          imageUrl: widget.student!.image,
          height: 150,
          placeholder: (context, url) => Container(color: Colors.grey.shade900),
          errorWidget: (context, url, error) =>
              Container(color: Colors.grey.shade900, child: Icon(Icons.error)),
        ),
      );
    }
    return SizedBox();
  }

  Widget _buildButton(bool isEditing) {
    return FilledButton(
      onPressed: _submit,
      child: Text(isEditing ? 'UPDATE' : 'SAVE'),
    );
  }
}
