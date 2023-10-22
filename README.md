# gianni_clubcentral

De PHP code voor uw REST-API om objecten (zoals gebruikers, tickets, clubs, events,...) toe te voegen en op te vragen. De Mollie implementatie om betalingen te doen. En Dart-code als voorbeeld om u op weg te helpen.

## Setup
- Importeer database/database.sql in een nieuwe of lege databank.
- Gebruik ngrok om een publieke test-URL te krijgen. Mollie werkt niet via localhost. https://ngrok.com
- Registreer op Mollie om een MOLLIE_KEY te verkrijgen.
- Zet in config.php de juiste configuratie. Zet in de Dart-code in globals.dart de juiste constante waardes.

## Study
In study.pdf heb ik de moeite genomen om de theorie aangaande REST API's kort toe te lichten. Lees dat snel even door, met een beetje achtergrondinformatie gaat alles duidelijker zijn.

## API
Ge hebt in PHP een REST API. Deze heeft de volgende endpoints.
- `/api/users.php`
- `/api/clubs.php`
- `/api/events.php`
- `/api/eventtickets.php`
- `/api/tickets.php`
- `/api/addresses.php`

Via deze endpoints kunt ge data opvragen, toevoegen, wijzigen of verwijderen van de overeenkomende tabels.

Voorbeelden:
- `HTTP GET /api/users.php` Geeft alle gebruikers terug.
- `HTTP GET /api/users.php/1` Geeft de gebruiker met ID 1 terug.
- `HTTP GET /api/users.php/email/voorbeeld@mail` Geeft de gebruiker met e-mailadres 'voorbeeld@mail' terug.
- `HTTP POST /api/users.php` Maakt een nieuwe gebruiker aan met de meegestuurde JSON.
- `HTTP PUT /api/users.php/1` Update gebruiker met ID 1 met de meegestuurde JSON.
- `HTTP DELETE /api/users.php/1` Verwijdert de gebruiker met ID 1.
- `HTTP GET /api/tickets.php/user/1` Geeft alle tickets terug die gebruiker met ID 1 besteld heeft.

## Payments
Dit is de PHP code om betalingen te doen. Ge geeft aan deze endpoint het ID mee van de gebruiker die de bestelling doet en het event_ticket dat de gebruiker wilt bestellen. De response bevat een URL van Mollie waarop de gebruiker zijn betaalmethode kan selecteren en de betaling doet.

Deze URL opent ge vanuit uw app in de standaard browser op het toestel.

Gebruik App Links om na de betaling de gebruiker terug te leiden naar uw app naar het scherm met "success" of "failure".
https://docs.flutter.dev/cookbook/navigation/set-up-app-links

## Examples
In examples vindt ge drie Dart-projecten. Deze code zou u moeten helpen de API en de Payments geimplementeerd te krijgen in uw Flutter-project.

- **api:** Dart-code waarin de API op verschillende manieren gebruikt wordt. Voor elke situatie die ge tegen gaat komen zal hier wel een voorbeeld in staan.
- **payments:**: Toont hoe een ticket te bestellen en de betaling te voltooien in Dart.
- **app:** Een 'volledig' werkende CLI-versie van uw app. Hier vindt ge de Dart code om een gebruiker te registreren, te laten inloggen, weergeven van alle clubs, weergeven van events die een club heeft, event bekijken, ticket bestellen, tickets bekijken,... Dit is uiteraard slechts een simpele CLI versie. Maar ge kunt er wel wat code uithalen om te implementeren in uw GUI-app.

## TODO
Volgens mij kunt ge op deze basis wel verder bouwen maar uiteraard gaat ge nog een paar dingen willen implementeren. Bijvoorbeeld:
- Geef events een datum. Events die gepasseerd zijn hoeven niet meer weergegeven te worden in de app.
- Zet een limiet op aantal beschikbare tickets voor een event.
- Voeg een kolom 'picture' toe aan de tabel clubs zodat een club een visuele foto kan uploaden.
- Ticket verzenden via mail na gelukte betaling.
- ...

  
