# Hitsterbingo (Flutter)

Flutter-ombyggnad av Hitsterbingo-appen (slumpgenerator, bingobricka och
spelinstruktioner), med samma "neon vinyl"-designspråk som webbversionen
i repots rot men byggd med native Flutter-widgets, animationer och en
handritad vinylskive-logga.

Byggd för webben (`flutter build web`). Poppins-typsnittet är buntat
lokalt som assets så appen inte är beroende av nätverket för text.

## Kom igång

```
flutter pub get
flutter run -d chrome
```

Bygg för produktion:

```
flutter build web --no-web-resources-cdn
```

`--no-web-resources-cdn` paketerar CanvasKit-motorn lokalt istället för
att hämta den från Googles CDN vid körning.
