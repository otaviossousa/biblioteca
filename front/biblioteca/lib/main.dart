import 'package:biblioteca/data/providers/auth_provider.dart';
import 'package:biblioteca/data/providers/autor_provider.dart';
import 'package:biblioteca/data/providers/exemplares_provider.dart';
import 'package:biblioteca/data/providers/login_provider.dart';
import 'package:biblioteca/data/providers/menu_provider.dart';
import 'package:biblioteca/data/providers/usuario_provider.dart';
import 'package:biblioteca/data/providers/livro_provider.dart';
import 'package:biblioteca/screens/login.dart';
import 'package:biblioteca/screens/pagina_inicial.dart';
import 'package:biblioteca/screens/pesquisar_livro.dart';

import 'package:biblioteca/screens/tela_emprestimo.dart';


import 'package:biblioteca/screens/telas_testes.dart';
import 'package:biblioteca/utils/routes.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:biblioteca/widgets/forms/form_user.dart';
import 'package:biblioteca/widgets/tables/author_table_page.dart';
import 'package:biblioteca/widgets/tables/book_table_page.dart';
import 'package:biblioteca/widgets/tables/user_table_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  // iniciando o banco de dados caso o front venha do instalador
  final caminhoPgCtl = Platform.isWindows ? Directory.current.path +  r'\postgres\bin\pg_ctl.exe' : Directory.current.path + '/postgres/bin/pg_ctl';
  final pastaBanco = Platform.isWindows ? Directory.current.path + r'\postgres\banco' : Directory.current.path + '/postgres/banco';
  Process? processoApi = null;
  if (File(caminhoPgCtl).existsSync()) {
    if (Platform.isWindows) {
      Process.runSync("powershell ", [caminhoPgCtl, "start", "-D", pastaBanco]);
    } else {
      Process.runSync(caminhoPgCtl, ["start", "-D", pastaBanco]);
    }
    
  }

  // rodando a api caso o front venha do instalador
  final caminhoApi = Platform.isWindows ? r'.\api.exe' : './api'; // se o front foi instalado apartir do instalador o front e back vão estar no mesmo diretório
  if (File(caminhoApi).existsSync()) {
    processoApi = await Process.start(caminhoApi, List.empty());
  }

    //Carregando variáveis de ambiente
  try{
    await dotenv.load(fileName: ".env");
  }on EmptyEnvFileError{
    print("O arquivo .env não existe ou está vazio");
  }
  Provider.debugCheckInvalidValueType = null;
  runApp(const Myapp());

    if (processoApi != null) {
      processoApi.kill();
    }

      if (File(caminhoPgCtl).existsSync()) {
    if (Platform.isWindows) {
      Process.runSync("powershell ", [caminhoPgCtl, "stop", "-D", pastaBanco]);
    } else {
      Process.runSync(caminhoPgCtl, ["stop", "-D", pastaBanco]);
    }
    
  }
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(),),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => MenuState()),
        ChangeNotifierProvider(create: (context) => AutorProvider()),
        ProxyProvider<AuthProvider, UsuarioProvider>(
          create: (_) => UsuarioProvider(0, ''),
          update: (_, authProvider, usuarioProvider) => UsuarioProvider(
              authProvider.idDaSessao!, authProvider.usuarioLogado!),
          dispose: (_, usuarioProvider) => usuarioProvider.dispose(),
        ),
        ProxyProvider<AuthProvider, ExemplarProvider>(
          create: (_) => ExemplarProvider(0, ''),
          update: (_, authProvider, exemplarprovider) => ExemplarProvider(
              authProvider.idDaSessao!, authProvider.usuarioLogado!),
        ),
        ProxyProvider<AuthProvider, LivroProvider>(
          create: (_) => LivroProvider(0, ''),
          update: (_, authProvider, exemplarprovider) => LivroProvider(
              authProvider.idDaSessao!, authProvider.usuarioLogado!),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('pt', 'BR'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: AppTheme.colorScheme,
          scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
          textTheme: GoogleFonts.robotoTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(textStyle: GoogleFonts.roboto())),
        ),
        initialRoute: AppRoutes.login,
        //home: const TelaPaginaIncial(),
        routes: {
          AppRoutes.login: (ctx) => const TelaLogin(),
          AppRoutes.home: (ctx) => const TelaPaginaIncial(),
          AppRoutes.usuarios: (ctx) => const UserTablePage(),
          AppRoutes.novoUsuario: (ctx) => const FormUser(),
          AppRoutes.editarUsuario: (ctx) => const FormUser(),
          AppRoutes.livros: (context) => const BookTablePage(),
          AppRoutes.autores: (context) => const AuthorTablePage(),

          //paginas temporarias para teste
          AppRoutes.pesquisarLivro: (context) => const PesquisarLivro(),
          AppRoutes.emprestimo: (context) => const PaginaEmprestimo(),
          AppRoutes.devolucao: (context) => const Devolucao(),
          
          AppRoutes.relatorios: (context) => const Relatorios(),
          AppRoutes.nadaConsta: (context) => const NadaConsta(),
          AppRoutes.configuracoes: (context) => const Configuracoes(),

        },
      ),
    );
  }
}
