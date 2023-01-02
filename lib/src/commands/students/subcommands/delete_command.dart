import 'dart:io';

import 'package:args/command_runner.dart';

import '../../../repositories/student_repository.dart';

class DeleteCommand extends Command {
  final StudentRepository repository;

  DeleteCommand(this.repository) {
    argParser.addOption('id', help: 'Delete by Id', abbr: 'i');
  }

  @override
  String get description => 'Delete a Studen by ID';

  @override
  String get name => 'delete';

  @override
  Future<void> run() async {
    final id = argResults?['id'];
    final studentId = int.parse(id);
    final student = await repository.findById(studentId);

    if (id == null) {
      print('Forneça um ID para deletar um aluno [ex: --id=1 ou -i 1]');
      return;
    }

    print('Deseja realmente deletar esse aluno? (S ou N)');
    final confirmDelete = stdin.readLineSync();
    if (student.id == studentId) {
      if (confirmDelete?.toLowerCase() == 's') {
        print('Deletando o aluno: ${student.name}...');
        await repository.deleteById(studentId);
      } else if (confirmDelete?.toLowerCase() == 'n') {
        print('Obrigado!');
      } else {
        print('Opção inválida');
      }
    }
  }
}
