FROM python:3.7-slim-buster
WORKDIR /app

COPY FlaskApp .
COPY MySQL_Queries /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y gcc libmariadb-dev
RUN pip install --upgrade pip
RUN pip install --no-cache-dir flask==1.1.4 flask-mysqldb 'markupsafe<2.0'

EXPOSE 5002
CMD ["python", "app.py"]
