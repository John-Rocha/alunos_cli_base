import 'package:args/command_runner.dart';

import '../../../repositories/student_repository.dart';

class FindByIdCommand extends Command {
  final StudentRepository studentRepository;

  FindByIdCommand(this.studentRepository) {
    argParser.addOption(
      'id',
      help: 'Student Id',
      abbr: 'i',
    );
  }

  @override
  String get description => 'Find Student By Id';

  @override
  String get name => 'byId';

  @override
  Future<void> run() async {
    if (argResults?['id'] == null) {
      print('Forneça um ID para buscar um aluno [ex: --id=1 ou -i 1]');
      return;
    }
    final id = int.parse(argResults?['id']);
    print('Aguarde, buscando dados...');
    final student = await studentRepository.findById(id);
    print('--------------');
    print('Aluno: ${student.name}');
    print('--------------');
    print('Idade: ${student.age ?? 'Não informado'}');
    print('Curso(s): ');
    student.nameCourses.forEach(print);
    print('Endereço:');
    print('   ${student.address.street} - ${student.address.zipCode}');
  }
}
