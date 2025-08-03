@echo off
set FLASK_APP= app.py
set SECRET_KEY= eb8c798b460ae7bb6272
set DATABASE_URL= postgresql://promotoras_db_user:FJcsS1wL8Onxw992sJKAH117NzuXeFDi@dpg-d26m18ogjchc73e4k4j0-a.oregon-postgres.render.com/promotoras_db
echo A iniciar o servidor Flask localmente...
flask run

@echo off
set FLASK_APP=app.py
set SECRET_KEY=eb8c798b460ae7bb6272
set DATABASE_URL=postgresql://promotoras_db_user:FJcsS1wL8Onxw992sJKAH117NzuXeFDi@dpg-d26m18ogjchc73e4k4j0-a.oregon-postgres.render.com/promotoras_db

echo A iniciar o servidor Flask localmente...
flask run