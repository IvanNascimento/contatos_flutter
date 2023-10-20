import 'package:contatos/models/contato.dart';
import 'package:contatos/services/b4a.dart';
import 'package:contatos/widgets/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const EclipseContatos());
}

class EclipseContatos extends StatelessWidget {
  const EclipseContatos({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eclipse Contatos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Eclipse Contatos'),
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
  B4aRepository repository = B4aRepository();
  Contatos _contatos = Contatos([]);
  final ImagePicker _picker = ImagePicker();

  TextEditingController imageCtrl = TextEditingController();
  String imagePath = "";
  TextEditingController nomeCtrl = TextEditingController();
  TextEditingController numeroCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _contatos = await repository.getContatos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
        actions: [
          IconButton(
              onPressed: () {
                _init();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      alignment: Alignment.centerLeft,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: const Text("Solar Eclipse IMC"),
                      content: const Wrap(
                        children: [
                          Text("Sair do aplicativo!"),
                          Text("Deseja realmente sair do aplicativo ?")
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Não')),
                        TextButton(
                            onPressed: () {
                              SystemNavigator.pop(animated: true);
                            },
                            child: const Text('Sim'))
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _contatos.contatos.length,
              itemBuilder: (BuildContext bc, int index) {
                ContatoModel contato = _contatos.contatos[index];
                return InkWell(
                  child: CardContato(
                    email: contato.email ?? "",
                    nome: contato.name ?? "",
                    numero: contato.number ?? "",
                    photoUri: contato.image ?? "",
                  ),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext _) {
                          return AlertDialog(
                            title: const Text("Deletar Contato"),
                            content: const Text(
                                "Tem certeza que deseja deletar esse contato ?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Não")),
                              TextButton(
                                  onPressed: () async {
                                    await repository.remover(contato.objectId!);
                                    _init();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Contato removido")));
                                  },
                                  child: const Text("Sim"))
                            ],
                          );
                        });
                  },
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imageCtrl.text = "";
          showDialog(
              context: context,
              useSafeArea: true,
              builder: (BuildContext bc) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Adicionar Contado"),
                  content: Column(children: [
                    const Text(
                      "Foto: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      readOnly: true,
                      onTap: () async {
                        XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          imageCtrl.text = image.name;
                          imagePath = image.path;
                        }
                      },
                      controller: imageCtrl,
                      decoration:
                          const InputDecoration(hintText: "Selecionar imagem"),
                    ),
                    const SizedBox(height: 15), //Get image
                    const Text(
                      "Nome do Contato: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: nomeCtrl,
                      decoration: const InputDecoration(hintText: "José Silva"),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Número do Contato: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: numeroCtrl,
                      decoration:
                          const InputDecoration(hintText: "(99) 98877-5566"),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Email do Contato: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: emailCtrl,
                      decoration:
                          const InputDecoration(hintText: "email@email.com"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ]),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () async {
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Salvando contato")));
                            await repository.criar(ContatoModel(
                                email: emailCtrl.text,
                                name: nomeCtrl.text,
                                number: numeroCtrl.text,
                                image: imagePath));

                            _init();
                            emailCtrl.text = "";
                            nomeCtrl.text = "";
                            numeroCtrl.text = "";
                            imageCtrl.text = "";
                            imagePath = "";
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Error ao salvar contato.")));
                          }
                          Navigator.pop(context);
                        },
                        child: const Text("Salvar")),
                  ],
                );
              });
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
