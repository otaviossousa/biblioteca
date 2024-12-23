import 'package:biblioteca/data/models/usuario_model.dart';
import 'package:biblioteca/data/services/api_service.dart';
import 'package:intl/intl.dart';

class UsuarioService {
  final ApiService _api = ApiService();
  final String apiRoute = 'usuario';

  //Retorna todos os usuários
  Future<UsuariosAtingidos> fetchUsuarios(
      num idDaSessao, String loginDoUsuarioRequerente) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuarioRequerente": loginDoUsuarioRequerente,
      "TextoDeBusca": "_"
    };

    final response = await _api.requisicao(
      apiRoute,
      'GET',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception();
    }
    return usuariosAtingidosFromJson(response.data);
  }

  //Retorna o usuário do requerente
  Future<Usuario> getUsuarioRequerente(
      num idDaSessao, String loginDoUsuarioRequerente) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuarioRequerente": loginDoUsuarioRequerente,
      "TextoDeBusca": "_"
    };

    final response = await _api.requisicao(
      apiRoute,
      'GET',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception();
    }
    return usuariosAtingidosFromJson(response.data).usuarioAtingidos[0];
  }

  //Cria um novo usuario
  Future<Usuario> addUsuario(
      num idDaSessao, String loginDoUsuarioRequerente, Usuario usuario) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuarioRequerente": loginDoUsuarioRequerente,
      "Login": usuario.login,
      "Cpf": usuario.cpf,
      "Nome": usuario.nome,
      "Email": usuario.email,
      "Telefone": usuario.telefone,
      "DataDeNascimento": usuario.dataDeNascimento != null
          ? DateFormat('yyyy-MM-dd')
              .format(usuario.dataDeNascimento!)
              .toString()
          : "",
      "Permissao": usuario.permissao,
      "Senha": usuario.senha,
      "Turma": 0
    };

    final response = await _api.requisicao(
      apiRoute,
      'POST',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception();
    }

    return usuariosAtingidosFromJson(response.data).usuarioAtingidos[0];
  }

  //Altera  um usuário existente
  Future<Usuario> alterUsuario(
      num idDaSessao, String loginDoUsuarioRequerente, Usuario usuario) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuarioRequerente": loginDoUsuarioRequerente,
      "Login": usuario.login,
      "Cpf": usuario.cpf,
      "Senha": usuario.senha,
      "Nome": usuario.nome,
      "Email": usuario.email,
      "Telefone": usuario.telefone,
      "DataDeNascimento": usuario.dataDeNascimento != null
          ? DateFormat('yyyy-MM-dd')
              .format(usuario.dataDeNascimento!)
              .toString()
          : "",
      "Permissao": usuario.permissao,
      "Id": usuario.idDoUsuario,
      "Ativo": usuario.ativo
    };

    final response = await _api.requisicao(
      apiRoute,
      'PUT',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception();
    }

    return usuariosAtingidosFromJson(response.data).usuarioAtingidos[0];
  }

  //inativa um usuario
  Future<Usuario> deleteUsuario(
      num idDaSessao, String loginDoUsuarioRequerente, int id) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuarioRequerente": loginDoUsuarioRequerente,
      "Id": id
    };

    final response = await _api.requisicao(
      apiRoute,
      'DELETE',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception();
    }

    return usuariosAtingidosFromJson(response.data).usuarioAtingidos[0];
  }
}
