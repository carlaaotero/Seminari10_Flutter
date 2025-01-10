import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/models/userModel.dart';

class RegisterController extends GetxController {
  final UserService userService = Get.put(UserService());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  //Afegim l'id del usuari
  String? userId; 

  
  void signUp() async {
    if (!_validateFields()) return;

    /*
    // Validación de campos vacíos
    if (nameController.text.isEmpty || passwordController.text.isEmpty || mailController.text.isEmpty || commentController.text.isEmpty) {
      errorMessage.value = 'Campos vacíos';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validación de formato de correo electrónico
    if (!GetUtils.isEmail(mailController.text)) {
      errorMessage.value = 'Correo electrónico no válido';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }*/

    isLoading.value = true;

    try {
      UserModel newUser = UserModel(
        name: nameController.text,
        password: passwordController.text,
        mail: mailController.text,
        comment: commentController.text,
      );

      final response = await userService.createUser(newUser);

      if (response != null && response == 201) {
        Get.snackbar('Èxit', 'Usuario creado correctamente');
        clearForm();
        Get.toNamed('/login');
      } else {
        errorMessage.value = 'Error: Este E-Mail o Teléfono ya están en uso';
        Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      errorMessage.value = 'Error al registrar usuario';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }


  //Afegit: funció pel formulari del modificar usuari
  void fillFormWithUserData(UserModel user) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    nameController.text = user.name ?? '';
    mailController.text = user.mail ?? '';
    commentController.text = user.comment ?? '';
    passwordController.text = '';  
    userId = user.id;  
  });
}

  //Afegit: funció per actualitzar un usuari que ja existeix
  void updateUser() async {
    if (userId == null) return;

    if (!_validateFields()) return;

    isLoading.value = true;

    try {
      UserModel updatedUser = UserModel(
        id: userId,
        name: nameController.text,
        mail: mailController.text,
        comment: commentController.text,
        password: "1234567",
      );

      final response = await userService.EditUser(userId!, updatedUser);

      if (response != null && response == 200) {
        Get.snackbar('Èxit', 'Usuari actualitzat correctament');
        clearForm();
      } else {
        
        Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  //Afegit: Validar els camps
  bool _validateFields() {
    if (nameController.text.isEmpty ||
        mailController.text.isEmpty ||
        commentController.text.isEmpty) {
      errorMessage.value = 'Hay campos vacíos';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (!GetUtils.isEmail(mailController.text)) {
      errorMessage.value = 'Formato de correo no valid';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  //Afegit: netejar el formulari
  void clearForm() {
    nameController.clear();
    passwordController.clear();
    mailController.clear();
    commentController.clear();
    userId = null; 
  }
}