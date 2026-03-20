import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// =============================================================================
// AULA 1.5 — MAPAS E GEOLOCALIZAÇÃO — VIEW MODEL (MVVM) — VERSÃO EXERCÍCIO
// =============================================================================
// O ViewModel guarda a posição atual (lat/lng) e o estado de carregamento/erro.
// A lógica de obter a localização do usuário fica aqui; na View só exibimos o
// mapa e reagimos ao estado. No Flutter Web o navegador pede permissão de
// localização (igual à aula de permissões).
// =============================================================================

class AulaMapasGeolocalizacaoViewModel extends ChangeNotifier {
  /// Centro inicial do mapa (ex.: Brasil) até o usuário clicar em "Minha localização".
  static const LatLng centroInicialPadrao = LatLng(-23.5505, -46.6333);

  LatLng? _posicaoAtual;
  bool _loading = false;
  String? _mensagemErro;

  List<LatLng> _pontosRota = [];
  bool _rotaLoading = false;
  String? _rotaErro;

  LatLng? get posicaoAtual => _posicaoAtual;
  bool get loading => _loading;
  String? get mensagemErro => _mensagemErro;
  List<LatLng> get pontosRota => _pontosRota;
  bool get rotaLoading => _rotaLoading;
  String? get rotaErro => _rotaErro;

  /// Chamado quando o usuário toca em "Minha localização".
  /// Deve obter a posição via Geolocator, atualizar _posicaoAtual (ou _mensagemErro)
  /// e chamar notifyListeners().
  Future<void> obterMinhaLocalizacao() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mensagemErro = 'Serviço de localização desabilitado';
        _loading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _mensagemErro = 'Permissão de localização negada permanentemente';
        _loading = false;
        notifyListeners();
        return;
      } else if (permission == LocationPermission.denied) {
        _mensagemErro = 'Permissão de localização negada';
        _loading = false;
        notifyListeners();
        return;
      }

      final Position position = await Geolocator.getCurrentPosition();
      _posicaoAtual = LatLng(position.latitude, position.longitude);
      _mensagemErro = null;
    } catch (e) {
      _mensagemErro = 'Erro ao obter localização: $e';
      _posicaoAtual = null;
    }

    _loading = false;
    notifyListeners();
  }

  /// Chamado quando o usuário define origem/destino e toca em "Rota até".
  /// Deve chamar a API OSRM (GET com os dois pontos), parsear a resposta,
  /// preencher _pontosRota com a lista de LatLng da geometria e chamar notifyListeners().
  Future<void> buscarRota(LatLng origem, LatLng destino) async {
    _rotaLoading = true;
    _rotaErro = null;
    _pontosRota = [];
    notifyListeners();

    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/${origem.longitude},${origem.latitude};${destino.longitude},${destino.latitude}?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final routes = json['routes'] as List?;

        if (routes != null && routes.isNotEmpty) {
          final coordinates = routes[0]['geometry']['coordinates'] as List?;

          if (coordinates != null) {
            _pontosRota = coordinates
                .map((coord) =>
                    LatLng(coord[1] as double, coord[0] as double))
                .toList();
          }
        }
      } else {
        _rotaErro = 'Erro na requisição: ${response.statusCode}';
      }
    } catch (e) {
      _rotaErro = 'Erro ao buscar rota: $e';
    }

    _rotaLoading = false;
    notifyListeners();
  }
}
