# Retter

IOS/Android Reddit app created with Flutter

## Building from source

- Reddit OAuth2 key needs to be added locally
- Navigate to https://old.reddit.com/prefs/apps
    - Name: type "flutterapp"
    - Select "script"
    - Redirect url: type "http://localhost:8080"
    - Click create app
- Create config.json inside of /assets
    - Copy and paste this into config.json
    `{
         "clientId": "PROVIDE_REDDIT_API_INFO",
         "clientSecret": "PROVIDE_REDDIT_API_INFO",
         "userAgent": "PROVIDE_REDDIT_API_INFO",
         "username": "PROVIDE_REDDIT_API_INFO",
         "password": "PROVIDE_REDDIT_API_INFO"
     }`



- Copy over information into config.json
    - clientId: underneath "personal use script"
    - clientSecret: next to "secret"
    - userAgent: name of app (above "personal use script"_
    - username: username of reddit account
    - password: password of reddit account

## Contribution

I'm open to anyone contributing to this repo. I'd advise using Android Studio and running a `dartfmt` before creating a pull request.
Pages are setup using [Mobx](https://pub.dev/packages/mobx) and a viewmodel pattern. Check out `src/main.dart` and `src/mainpage_viewmodel.dart`.

![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img1.jpg "img1")
