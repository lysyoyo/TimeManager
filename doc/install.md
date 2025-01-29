# Batman Project

Ce projet est une application Phoenix utilisant Docker pour le développement et la base de données PostgreSQL.

## Prérequis

- Docker
- Docker Compose
- Git

## Installation

1. Clonez le dépôt :
   ```
   git clone git@github.com:EpitechMscProPromo2026/T-POO-700-PAR_20.git
   cd batman
   ```

2. Construisez les images Docker :
   ```
   docker-compose build
   ```

3. Démarrez les conteneurs :
   ```
   docker-compose up -d
   ```

4. Créez la base de données :
   ```
   docker-compose exec web mix ecto.create
   ```

5. Exécutez les migrations :
   ```
   docker-compose exec web mix ecto.migrate
   ```

## Commandes utiles

### Démarrer l'application
```
docker-compose up -d
```

### Arrêter l'application
```
docker-compose down
```

### Accéder au shell du conteneur web
```
docker-compose exec web bash
```

### Exécuter des commandes Phoenix

- Générer une ressource :
  ```
  docker-compose exec web mix phx.gen.html Context Schema schemas table_name field1:type field2:type
  ```

- Générer une migration :
  ```
  docker-compose exec web mix ecto.gen.migration nom_de_la_migration
  ```

- Exécuter les migrations :
  ```
  docker-compose exec web mix ecto.migrate
  ```

- Revenir en arrière sur une migration :
  ```
  docker-compose exec web mix ecto.rollback
  ```

### Commandes de développement

- Lancer la console interactive IEx :
  ```
  docker-compose exec web iex -S mix
  ```

- Exécuter les tests :
  ```
  docker-compose exec web mix test
  ```

- Vérifier le formatage du code :
  ```
  docker-compose exec web mix format --check-formatted
  ```

- Formater le code :
  ```
  docker-compose exec web mix format
  ```

- Lancer l'analyseur de code statique :
  ```
  docker-compose exec web mix credo
  ```

## Accéder à l'application

Une fois l'application démarrée, vous pouvez y accéder à l'adresse suivante :
[http://localhost:4000](http://localhost:4000)

## Développement

Pour travailler sur le projet en mode développement :

1. Assurez-vous que les conteneurs sont en cours d'exécution :
   ```
   docker-compose up -d
   ```

2. Vous pouvez modifier les fichiers de votre projet localement. Les changements seront reflétés automatiquement grâce au volume monté dans Docker.

3. Si vous ajoutez de nouvelles dépendances ou modifiez le fichier `mix.exs`, vous devrez reconstruire l'image :
   ```
   docker-compose build web
   docker-compose up -d web
   ```

4. Pour voir les logs en temps réel :
   ```
   docker-compose logs -f web
   ```

## Dépannage

- Si vous rencontrez des problèmes de connexion à la base de données, assurez-vous que le service `db` est en cours d'exécution :
  ```
  docker-compose ps
  ```

- Vérifiez les logs pour plus d'informations sur les erreurs :
  ```
  docker-compose logs
  ```

- Si vous modifiez la configuration de la base de données, assurez-vous de mettre à jour le fichier `config/runtime.exs` et les variables d'environnement dans `docker-compose.yml`.

```
