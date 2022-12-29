import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/student.dart';

class StudentRepository {
  Future<List<Student>> findAll() async {
    final studentsResult = await http.get(
      Uri.parse('http://localhost:8080/students'),
    );

    if (studentsResult.statusCode != 200) {
      throw Exception('Não foi possível buscar os alunos');
    }

    final studentsData = jsonDecode(studentsResult.body) as List;

    return studentsData
        .map<Student>((student) => Student.fromMap(student))
        .toList();
  }

  Future<Student> findById(int id) async {
    final studentsResult = await http.get(
      Uri.parse('http://localhost:8080/students/$id'),
    );

    if (studentsResult.statusCode != 200) {
      throw Exception('Não foi possível buscar o aluno');
    }

    return Student.fromJson(studentsResult.body);
  }

  Future<void> insert(Student student) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/students'),
      body: student.toJson(),
      headers: {
        'content-type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Ocorreu um erro para inserir o aluno');
    }
  }

  Future<void> update(Student student) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/students/${student.id}'),
      body: student.toJson(),
      headers: {
        'content-type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Ocorreu um erro para atualizar os dados do aluno');
    }
  }

  Future<void> deleteById(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/students/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Ocorreu um erro ao deletar o aluno');
    }
  }
}
