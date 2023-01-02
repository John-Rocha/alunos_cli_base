import 'package:alunos_cli_base/src/commands/students/student_command.dart';
import 'package:args/command_runner.dart';

void main(List<String> args) {
  CommandRunner('CLI', 'CLI')
    ..addCommand(StudentCommand())
    ..run(args);
}
