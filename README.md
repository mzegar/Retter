![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/assets/icon/rettericon.png "RetterLogo")
# Retter
[![License badge](https://img.shields.io/github/license/mzegar/retter)](https://github.com/mzegar/Retter/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/mzegar/retter?style=social)](https://github.com/mzegar/retter/stargazers)


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

    `{ "clientId": "PROVIDE_CLIENT_ID", "clientSecret": "PROVIDE_SECRET", "userAgent": "RetterApp"}`



- Copy over information into config.json
    - clientId: underneath "personal use script"
    - clientSecret: next to "secret"
    
- Run using `flutter run` or with IDE such as Android Studio

## Contribution

I'm open to anyone contributing to this repo. I'd advise using Android Studio and running a `dartfmt` before creating a pull request: `dartfmt -w lib`.
Pages are setup using [Mobx](https://pub.dev/packages/mobx) and a viewmodel pattern. Check out `src/main.dart` and `src/mainpage_viewmodel.dart`.

## TODO

- Saving subreddits accessed in drawer
- Additional options for posts (copying link, viewing profile of author, etc)
- Refresh subreddit posts by scrolling up
- Sorting subreddits by sort type
- Sorting comments by sort type

## Preview

Retter is always changing so these videos/images may be outdated

Outdated video demo
[![Retter app demo](https://img.youtube.com/vi/rVWFXjuiuVA/maxresdefault.jpg)](https://www.youtube.com/watch?v=rVWFXjuiuVA)

Outdated images
https://imgur.com/a/sPhutbW
![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img1.jpg "img1")
![retterimg](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img2.jpg "img2")
![retterimg](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img3.jpg "img3")
![retterimg](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img4.jpg "img4")
