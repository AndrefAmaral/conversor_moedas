import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textoEmDolar = TextEditingController();
  double _resultado = 0.0;
  double _fatorDeConversao = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate(); // Busca a taxa de câmbio ao iniciar
  }

  Future<void> _fetchExchangeRate() async {
    setState(() {
      _isLoading = true; // Exibe um indicador de carregamento
    });

    try {
      final response = await http.get(
        Uri.parse("https://economia.awesomeapi.com.br/json/last/USD-BRL"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _fatorDeConversao =
              double.parse(data["USDBRL"]["bid"]); // Taxa de câmbio USD-BRL
        });
      } else {
        throw Exception("Erro ao obter taxa de câmbio.");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${error.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Remove o indicador de carregamento
      });
    }
  }

  void _converterValor() {
    final String textoDigitado = _textoEmDolar.text;
    final double? valorEmDolar = double.tryParse(textoDigitado);

    if (valorEmDolar != null && _fatorDeConversao > 0) {
      setState(() {
        _resultado =
            valorEmDolar * _fatorDeConversao; // Converte dólar para real
      });
    } else {
      setState(() {
        _resultado = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um número válido'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _textoEmDolar,
                    decoration: InputDecoration(
                      hintText: 'Ex: 15.00',
                      labelText: 'Valor em USD',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('\$'),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: _converterValor,
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 200, 203, 206))),
                    child: const Text('Converter em BRL'),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'R\$ ${_resultado.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/* 
Explicação do Código:
Consulta à API:

A API usada no exemplo é a AwesomeAPI.
O endpoint https://economia.awesomeapi.com.br/json/last/USD-BRL retorna a taxa de câmbio USD-BRL.
A propriedade "USDBRL"]["bid" contém a taxa de compra atual.
Exibição da taxa de câmbio:

A taxa de câmbio é buscada ao iniciar o app usando o método _fetchExchangeRate().
Conversão:

O valor digitado no campo de texto (_controller.text) é convertido para double.
O resultado é calculado multiplicando o valor pelo _exchangeRate.
Indicador de carregamento:

Enquanto a taxa de câmbio é carregada, um CircularProgressIndicator é exibido.
Tratamento de erros:

Se a API falhar ou o usuário inserir um valor inválido, é exibida uma mensagem de erro usando SnackBar.

*/