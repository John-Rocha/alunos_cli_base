import 'dart:io';

import 'package:args/command_runner.dart';

import '../../../models/address.dart';
import '../../../models/city.dart';
import '../../../models/phone.dart';
import '../../../models/student.dart';
import '../../../repositories/product_repository.dart';
import '../../../repositories/student_repository.dart';

class InsertCommand extends Command {
  final StudentRepository studentRepository;
  final productRepository = ProductRepository();

  @override
  String get description => 'Insert Student';

  @override
  String get name => 'insert';

  InsertCommand(this.studentRepository) {
    argParser.addOption('file', help: 'Path of the csv file', abbr: 'f');
  }

  @override
  Future<void> run() async {
    print('Aguarde...');
    // Recupera o arguemento "file" com o path do arquivo
    final filePath = argResults?['file'];
    // Faz a leitura do arquivo .csv
    final students = File(filePath).readAsLinesSync();
    print('---------------------------------------------');

    for (var student in students) {
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
        name: studentData[0],
        age: int.tryParse(studentData[1]),
        nameCourses: courseCsv,
        courses: courses,
        address: Address(
            street: studentData[3],
            number: int.parse(studentData[4]),
            zipCode: studentData[5],
            city: City(id: 1, name: studentData[6]),
            phone:
                Phone(ddd: int.parse(studentData[7]), phone: studentData[8])),
      );
      await studentRepository.insert(studentModel);
    }
    print('---------------------------------------------');
    print('Alunos adicionados com sucesso');
  }
}
