import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _valorEmReal = TextEditingController();
  double _resultado = 0.0;
  final double _fatorDeConversao = 5.87;

  void _converterValor() {
    final String textoDigitado = _valorEmReal.text;
    final double? numero = double.tryParse(textoDigitado);

    if (numero != null) {
      setState(() {
        _resultado = numero * _fatorDeConversao;
      });
    } else {
      setState(() {
        _resultado = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira um número válido')));
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _valorEmReal,
                decoration: InputDecoration(
                  hintText: 'Dólares',
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
                child: const Text('Converter'),
              ),
              const SizedBox(height: 50),
              Text(
                'R\$ $_resultado',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
