import 'dart:io';

import 'package:args/command_runner.dart';

import '../../../repositories/student_repository.dart';

class DeleteCommand extends Command {
  final StudentRepository repository;

  DeleteCommand(this.repository) {
    argParser.addOption('id', help: 'Student Id', abbr: 'i');
  }

  @override
  String get description => 'Delete a Studen by ID';

  @override
  String get name => 'delete';

  @override
  Future<void> run() async {
    final id = int.tryParse(argResults?['id']);

    if (id == null) {
      print('Forneça um ID para deletar um aluno [ex: --id=1 ou -i 1]');
      return;
    }
    print('Aguarde...');
    final student = await repository.findById(id);

    print('Deseja realmente deletar o aluno ${student.name}? (S ou N)');
    final confirmDelete = stdin.readLineSync();

    if (confirmDelete?.toLowerCase() == 's') {
      await repository.deleteById(id);
      print('---------------------------');
      print('Aluno deletado com sucesso');
    } else if (confirmDelete?.toLowerCase() == 'n') {
      print('---------------------------');
      print('Operação cancelada');
      print('---------------------------');
    } else {
      print('Opção inválida');
    }
  }
}
