import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'models/product.dart';
import 'helpers/database_helper.dart';
import 'qr_scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Inventory Management'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _statusController = TextEditingController();
  final _quantityController = TextEditingController();
  List<Product> _products = [];

  final List<String> _categories = [
    'Computadoras',
    'Periféricos',
    'Mobiliario',
    'Audio/Video',
    'Redes',
    'Otros'
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que se cierre al tocar fuera
      builder: (dialogContext) {
        // Cambiamos a dialogContext para tener referencia específica
        return AlertDialog(
          title: const Text('Agregar Nuevo Equipo'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            labelText: 'Código',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Campo requerido' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        tooltip: 'Escanear QR',
                        onPressed: () async {
                          final result = await Navigator.push<String>(
                            dialogContext, // Usamos dialogContext en lugar de context
                            MaterialPageRoute(
                              builder: (context) => const QRScanPage(),
                            ),
                          );
                          if (result != null) {
                            final lines = result.split('\n');
                            for (final line in lines) {
                              final parts = line.trim().split(':');
                              if (parts.length == 2) {
                                final field = parts[0].trim();
                                final value = parts[1].trim();
                                setState(() {
                                  switch (field) {
                                    case 'Código':
                                      _codeController.text = value;
                                      break;
                                    case 'Nombre':
                                      _nameController.text = value;
                                      break;
                                    case 'Categoría':
                                      _categoryController.text = value;
                                      break;
                                    case 'Descripción':
                                      _descriptionController.text = value;
                                      break;
                                    case 'Marca':
                                      _brandController.text = value;
                                      break;
                                    case 'Modelo':
                                      _modelController.text = value;
                                      break;
                                    case 'Estado':
                                      _statusController.text = value;
                                      break;
                                    case 'Cantidad':
                                      final numValue = value.replaceAll(
                                          RegExp(r'[^0-9]'), '');
                                      _quantityController.text = numValue;
                                      break;
                                  }
                                });
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _categoryController.text = newValue ?? '';
                    },
                    validator: (value) =>
                        value == null ? 'Seleccione una categoría' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      labelText: 'Marca',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: 'Modelo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _statusController,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final product = Product(
                    code: _codeController.text,
                    name: _nameController.text,
                    category: _categoryController.text,
                    description: _descriptionController.text,
                    brand: _brandController.text,
                    model: _modelController.text,
                    status: _statusController.text,
                    quantity: int.parse(_quantityController.text),
                  );
                  await DatabaseHelper.instance.insertProduct(product);
                  _clearFormFields();
                  Navigator.pop(context);
                  _loadProducts();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _clearFormFields() {
    _codeController.clear();
    _nameController.clear();
    _categoryController.clear();
    _descriptionController.clear();
    _brandController.clear();
    _modelController.clear();
    _statusController.clear();
    _quantityController.clear();
  }

  void _showQRDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Código QR - ${product.name}'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QrImageView(
                    data: '''
                    Código: ${product.code}
                    Nombre: ${product.name}
                    Categoría: ${product.category}
                    Marca: ${product.brand}
                    Modelo: ${product.model}
                    Estado: ${product.status}
                    Cantidad: ${product.quantity}
                    Descripción: ${product.description}
                    ''',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 16),
                  Text('${product.brand} ${product.model}'),
                  Text('Código: ${product.code}'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(product.category[0]),
              ),
              title: Text(product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${product.code}'),
                  Text('${product.brand} ${product.model}'),
                  Text('Estado: ${product.status}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cant: ${product.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () => _showQRDialog(product),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        label: const Text('Agregar Equipo'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _statusController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
