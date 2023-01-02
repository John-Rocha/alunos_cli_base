import 'dart:io';

import 'package:args/command_runner.dart';

import '../../../models/address.dart';
import '../../../models/city.dart';
import '../../../models/phone.dart';
import '../../../models/student.dart';
import '../../../repositories/product_repository.dart';
import '../../../repositories/student_repository.dart';

class UpdateCommand extends Command {
  final StudentRepository studentRepository;
  final productRepository = ProductRepository();

  UpdateCommand(this.studentRepository) {
    argParser.addOption('file', help: 'Path of the .csv file', abbr: 'f');
    argParser.addOption('id', help: 'Student ID', abbr: 'i');
  }

  @override
  String get description => 'Update Students';

  @override
  String get name => 'update';

  @override
  Future<void> run() async {
    print('Aguarde...');
    // Recupera o arguemento "file" com o path do arquivo
    final filePath = argResults?['file'];
    // Recupera o ID
    final id = argResults?['id'];
    if (id == null) {
      print('Por favor, informe o ID do aluno com o comando --id=0 ou -i 0');
      return;
    }

    // Faz a leitura do arquivo .csv
    final students = File(filePath).readAsLinesSync();
    print('Atualizando os dados do aluno...');
    print('---------------------------------------------');

    if (students.length > 1) {
      print('Por favor informe somente um aluno no arquivo $filePath');
      return;
    } else if (students.isEmpty) {
      print('Por favor informe um aluno no arquivo $filePath');
      return;
    }

    var student = students.first;

    // Transforma em array usando o ; como delimitador
    final studentData = student.split(';');
    // Separa os cursos usando a "," como delimitadora
    final courseCsv = studentData[2].split(',').map((e) => e.trim()).toList();

    // Busca o modelo dos Cursos
    final courseFutures = courseCsv.map((c) async {
      final course = await productRepository.findByName(c);
      course.isStudent = true;
      return course;
    }).toList();

    // Aguarda a execução dos cursos
    final courses = await Future.wait(courseFutures);

    // Cria o modelo de Student
    final studentModel = Student(
      id: int.parse(id),
      name: studentData[0],
      age: int.tryParse(studentData[1]),
      nameCourses: courseCsv,
      courses: courses,
      address: Address(
        street: studentData[3],
        number: int.parse(studentData[4]),
        zipCode: studentData[5],
        city: City(id: 1, name: studentData[6]),
        phone: Phone(ddd: int.parse(studentData[7]), phone: studentData[8]),
      ),
    );
    await studentRepository.update(studentModel);
    print('---------------------------------------------');
    print('Alunos atualizado com sucesso');
  }
}
