# login_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#########################
Run the following command to get the dependencies:
`flutter pub get`
Once all dependencies are installed, run the following command to run the app:
`flutter build web`
`firebase deploy --only hosting`
If firebase is not installed then need to install firebase. Here are the commands
`npm install -g firebase-tools`
If npm is not installed then install npm first.
Assuming npm is already installed, run the following command to install firebase
`firebase login`
`firebase init`
```
When asked which Firebase CLI features you want to set up for this folder, select Hosting.
Then, select the Firebase project you want to connect to (you should create one in the Firebase Console if you haven't already).
For the public directory, type build/web (or the path to your Flutter web build if different).
Configure as a single-page app: respond Yes.
Overwrite index.html: respond No (since Flutter has already created this for you).
```

After all the above steps are done, run the following command to deploy the app:
`firebase deploy --only hosting`

########
Running the backend server:

Backend server is run in python. You have to run the following commmand
`python auth_server/app.py`

Before this you need to install python and set it's PATH. Then you need to run `pip install -r requirements.txt` to install all the dependencoes.
If still you get an error that `psycopg2` or `flask-cors` is not found then first get to venv (virtual environment) and then install these libraries by running
`pip install psycopg2`
`pip install flask-cors`

##### How to get to Virtual Environment
In windows: In command prompt or powershell command ONLY
1. cd path\to\your\project
2. python -m venv venv
3. .\venv\Scripts\activate

#### Create .env file in auth_server folder
create a file called .env in auth_server folder and add the following lines
```
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=xxx
DB_HOST=localhost
```

##### Download Postgres
```
In postgres or pgAdmin you need to create two schemas
1. login
2. records
```

Follow scripts/login.sql and scripts/records.sql to create tables in login and records schema respectively.

After this run 

`python auth_server/app.py`

Then first you need to create username
Then login after that and you should get to the app.

``
## DOCKERIZED THE APPLICATION --> INSTRUCTIONS TO RUN
# Pre-Requisite
1. Make sure you download docker desktop first
2. Once Docker Desktop is downloaded run the following commands
3. To Build the application run -> `docker-compose up -d --build`
4. To stop the containers run -> `docker-compose stop`
5. To remove the containers run -> `docker-compose down`
