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

## Contribution

I'm open to anyone contributing to this repo. I'd advise using Android Studio and running a `dartfmt` before creating a pull request: `dartfmt -w lib`.
Pages are setup using [Mobx](https://pub.dev/packages/mobx) and a viewmodel pattern. Check out `src/main.dart` and `src/mainpage_viewmodel.dart`.

## TODO

- Saving subreddits accessed in drawer
- Additional options for posts (copying link, viewing profile of author, etc)
- Refresh subreddit posts by scrolling up
- Sorting subreddits by sort type
- Sorting comments by sort type

## License

```
MIT License

Copyright (c) 2020 Matthew Zegar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Images

Retter is always changing so these images may be outdated

https://imgur.com/a/sPhutbW


![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img1.jpg "img1")
![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img2.jpg "img2")
![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img3.jpg "img3")
![alt text](https://raw.githubusercontent.com/mzegar/Retter/master/screenshots/img4.jpg "img4")
