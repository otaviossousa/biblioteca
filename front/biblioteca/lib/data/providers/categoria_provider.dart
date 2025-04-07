import 'package:biblioteca/data/models/categorias_model.dart';
import 'package:biblioteca/data/services/categoria_service.dart';
import 'package:flutter/material.dart';

class CategoriaProvider extends ChangeNotifier {
  final CategoriaService _categoriaService = CategoriaService();

  final num idDaSessao;
  final String usuarioLogado;

  bool _isLoading = false;
  String? _error;
  List<Categoria> _categorias = [];

  CategoriaProvider(this.idDaSessao, this.usuarioLogado);

  // Getters
  bool get isloading => _isLoading;
  String? get error => _error;
  bool get hasErrors => _error != null ? true : false;
  List<Categoria> get   categorias => _categorias;

  Future<void> loadCategorias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      final apiResponse = await _categoriaService.fetchCategorias(idDaSessao, usuarioLogado);

      if (apiResponse.responseCode == 200) {
        _categorias = apiResponse.body;
      } else {
        _error = apiResponse.body;
      }
      
    } catch (e) {
      _error = "Erro ao carregar as Categorias:\n$e";
    } finally {
      _isLoading = false;
      print('Provider: $_categorias');
      notifyListeners();
    }
  }

  Future<void> addCategoria(String descricao) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _categoriaService.addCategoria(idDaSessao, usuarioLogado, descricao);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      } else {
        _categorias.add(apiResponse.body);
      }
    } catch (e) {
      _error = "Erro ao inserir nova Categoria:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCatgoria(Categoria categoria) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _categoriaService.deleteCategoria(idDaSessao, usuarioLogado, categoria.idDaCategoria);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      } else {
        _categorias.add(apiResponse.body);
      }
    } catch (e) {
      _error = "Erro ao deletar Categoria ${categoria.descricao}:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
