Hier is de volledige documentatie, in het Nederlands, zonder emoji’s, zonder iconen, met vermelding dat de database technisch niets doet, en in een serieuze, zakelijke stijl passend voor school of Confluence.


# AnalyticsServicePrototype – Documentatie

## Overzicht

De AnalyticsServicePrototype is een Elixir/Phoenix-gebaseerde microservice die is ontwikkeld voor Project 42.
De service bevat alle basisstructuren voor een toekomstige analytics-module, zoals het verzamelen van gevechtsresultaten, het berekenen van spelerstatistieken, het genereren van leaderboards en het tonen van gameplaytrends.

In deze prototypeversie worden alle resultaten en berekeningen uitgevoerd via een interne mock-service.
Dit betekent dat er geen echte data wordt opgeslagen en dat de database, hoewel technisch ingericht, op dit moment niet actief wordt gebruikt.
Ecto en PostgreSQL zijn aangesloten om aan te sluiten op de eisen van de opdracht en toekomstbestendigheid, maar functioneren in deze fase alleen als infrastructuurvoorbereiding.

Ons onderzoek wees uit dat de analytics-logica efficiënter kon worden uitgevoerd via in-memory mock services zolang er geen echte data wordt geproduceerd in het spel. Daarom is ervoor gekozen om de database niet te vullen of migraties te implementeren.


# Functionaliteit

1. Game Result Tracking
   Verwerkt gevechtsresultaten als mock-data. De service valideert input en geeft een bevestigingsbericht terug. Er wordt niets opgeslagen in de database.

2. Statistiekberekening
   Levert statistieken zoals winrate, wins, losses, gemiddelde schade en totaal aantal gevechten, volledig gegenereerd door de mock-service.

3. Leaderboard
   Retourneert een lijst met spelers gesorteerd op prestaties. De waarden zijn statisch en gegenereerd door de mock-service.

4. Trends en Gameplay Insights
   Geeft informatie over populaire kaarten, algemene winrates en trends. Deze waarden zijn eveneens mock-data.


# Het draaien van de service

## 1. Start PostgreSQL via Docker

Hoewel de database op dit moment niet gebruikt wordt, moet PostgreSQL draaien omdat Phoenix anders een foutmelding geeft zodra Ecto probeert te verbinden.

```
docker run --name analytics-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

Herstarten kan als volgt:

```
docker start analytics-db
```

## 2. Dependencies installeren

```
mix deps.get
```

## 3. Database aanmaken

De database wordt formeel aangemaakt zodat Ecto geen fout genereert.
Er worden geen tabellen of migraties uitgevoerd, en er wordt geen data opgeslagen.

```
mix ecto.create
```

## 4. Server starten

```
mix phx.server
```

De API draait op
[http://localhost:4000](http://localhost:4000)


# Folderstructuur

Deze structuur komt overeen met het huidige prototype.

```
analytics_service_prototype/
├── _build/
├── config/
├── deps/
├── lib/
│   ├── analytics_service/
│   │   ├── contracts/
│   │   │   ├── game_result.ex
│   │   │   ├── leaderboard_entry.ex
│   │   │   ├── player_stats.ex
│   │   │   └── trend_data.ex
│   │   ├── endpoints/
│   │   │   ├── leaderboard_controller.ex
│   │   │   ├── results_controller.ex
│   │   │   ├── stats_controller.ex
│   │   │   └── trends_controller.ex
│   │   ├── services/
│   │   │   ├── mock_analytics_service.ex
│   │   │   ├── application.ex
│   │   │   ├── mailer.ex
│   │   │   └── repo.ex
│   │   ├── analytics_service.ex
│   │   └── analytics_service_web.ex
│   └── analytics_service_web/
│       ├── controllers/
│       │   └── error_json.ex
│       ├── endpoint.ex
│       ├── gettext.ex
│       ├── router.ex
│       └── telemetry.ex
├── priv/
├── test/
├── analytics.http
├── mix.exs
├── mix.lock
└── README.md
```


# API Endpoints

## POST /results

Verwerkt de uitslag van een gevecht.
De data wordt niet opgeslagen, maar verwerkt door de mock-service.

Voorbeeldrequest:

```json
{
  "winner_id": "player123",
  "loser_id": "player999",
  "winner_damage": 42,
  "loser_damage": 10
}
```

Voorbeeldresponse:

```json
{
  "ok": true,
  "message": "stored"
}
```

## GET /stats/:playerId

Retourneert mock-statistieken voor een speler.

Voorbeeldresponse:

```json
{
  "player_id": "player123",
  "games_played": 10,
  "wins": 6,
  "losses": 4,
  "win_rate": 0.60,
  "avg_damage": 32.5
}
```

## GET /leaderboard

```json
[
  {
    "player_id": "player1",
    "rank": 1,
    "win_rate": 0.82,
    "games_played": 40
  },
  {
    "player_id": "player2",
    "rank": 2,
    "win_rate": 0.79,
    "games_played": 33
  }
]
```

## GET /trends

```json
{
  "popular_cards": ["Fireball", "Shield", "Goblin Horde"],
  "global_win_rate": 0.53,
  "meta_shifts": ["Aggro rising", "Control stable"]
}
```


# Curl voorbeelden (geschikt voor Windows CMD)

## POST result

```
curl -X POST http://localhost:4000/results -H "Content-Type: application/json" -d "{\"winner_id\":\"player123\",\"loser_id\":\"player999\",\"winner_damage\":42,\"loser_damage\":10}"
```

## GET stats

```
curl http://localhost:4000/stats/player123
```

## GET leaderboard

```
curl http://localhost:4000/leaderboard
```

## GET trends

```
curl http://localhost:4000/trends
```

---

# Models (Contracts)

Deze modellen definiëren de structuur van de gebruikte data.
Ze worden gebruikt door de endpointcontrollers en de mock-service.

### GameResult

```elixir
defstruct [:winner_id, :loser_id, :winner_damage, :loser_damage, :timestamp]
```

### PlayerStats

```elixir
defstruct [:player_id, :games_played, :wins, :losses, :win_rate, :avg_damage]
```

### LeaderboardEntry

```elixir
defstruct [:player_id, :rank, :win_rate, :games_played]
```

### TrendData

```elixir
defstruct [:popular_cards, :global_win_rate, :meta_shifts]
```

---

# Conclusie

De AnalyticsServicePrototype biedt een volledige API-structuur met mock-logica.
Hoewel de service een PostgreSQL-database vereist om te starten, wordt deze in de huidige versie niet gebruikt. Dit is een bewuste keuze op basis van onderzoek en projectdoelen. Alle data wordt gegenereerd in-memory via de MockAnalyticsService.

Wanneer het spel echte statistieken gaat leveren, kan deze service eenvoudig worden uitgebreid met Ecto-schema’s, migraties en daadwerkelijke opslag in PostgreSQL.

