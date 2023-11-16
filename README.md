
# Samasy app

La aplicación propuesta representa una solución integral para gestionar eficientemente el registro de ventas a través del escaneo de códigos QR generados por un sistema web externo. Esto posibilita un control preciso de las ventas individuales de cada usuario, simplificando así el proceso de seguimiento y optimizando la gestión comercial. Puedes acceder al sistema web correspondiente haciendo clic [aquí](https://github.com/carlosantonio98/samasy-laravel).

## Pre-requisitos 📋

Para la correcta ejecución de este proyecto, necesitas tener las siguientes tecnologías instaladas en tu ordenador.
* Flutter 3.7.8
* Android SDK 33.0.1
* Android Studios 2021.3

## Instalación 🔧

1. Clona este proyecto.
```bash
git clone https://github.com/carlosantonio98/samasy-app-flutter.git
```

2. Abre el proyecto en un editor de código.

3. Instala las dependencias del pubspec.yaml con flutter.
```bash
flutter pub get
```

4. Crea el archivo config.dart dentro del folder lib y configura las variables de samasy correspondientes.
```
class SamasyConfig {
  static const String baseURL = "TU_URL_DEL_SISTEMA_SAMASY";

  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Charset": "utf-8"
  };
}
```

5. Conecta un dispositivo o inicia un emulador.

6. Ejecuta la aplicación.
```bash
flutter run
```

## Construido con 🛠️

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [http ^0.13.5](https://pub.dev/packages/http/versions)
- [flutter_barcode_scanner ^2.0.0](https://pub.dev/packages/flutter_barcode_scanner/versions)
- [provider ^6.0.5](https://pub.dev/packages/provider/versions)
- [shared_preferences ^2.0.20](https://pub.dev/packages/shared_preferences/versions)

## Estructura del Proyecto

```
samasy-app-flutter/
├── android/
├── assets/
├── ios/
├── lib/
│ ├── config.dart <--- Nota: Archivo sensible no incluido en el repositorio.
│ ├── components/
│ │ ├── sale_card.dart
│ │ └── ...
│ ├── models/
│ │ ├── sale.dart
│ │ └── ...
│ ├── pages/
│ │ ├── home_page.dart
│ │ └── ...
│ ├── services/
│ │ ├── auth_services.dart
│ │ └── ...
│ ├── main.dart
│ └── snackbars.dart
├── test/
├── ...
└── pubspec.yaml
```

## Preview 📸

- Pagina de inicio de sesión

    ![App Screenshot](https://i.imgur.com/Qi5Vc5g.jpg)

- Pagina de ventas
    
    ![App Screenshot](https://i.imgur.com/6tVwWie.jpg)

- Pagina de escaneo de código QR
    
    ![App Screenshot](https://i.imgur.com/5bPdSL9.jpg)

## Autor 🖋️

- [@carlosantonio98](https://github.com/carlosantonio98)