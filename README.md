
# L10n

# Example

```yaml
WelcomeViewController:
  Label:
    Title:
      l10n:
        Base: "Welcome!" 
        ja: "ようこそ!"
    Message:
      l10n:
        Base: "Enjoy!" 
        ja: "楽しんで!"
  Button:
    Signup:
      l10n:
        Base: "Signup" 
        ja: "登録する"
Alert:
  OK:
    l10n:
      Base: "OK"
      ja: "確認"
  Cancel:
    l10n:
      Base: "Cancel"
      ja: "キャンセル"
App:
  l10n:
    Base: "Awesome App"
    ja: "素晴らしいアプリ"
```

```sh
$ ./l10n gen l10n.yaml ./Resorces Base
$ ./l10n gen l10n.yaml ./Resorces ja 
```

## Results

```
"WelcomeViewController.Label.Title" = "ようこそ!";
"WelcomeViewController.Label.Message" = "楽しんで!";
"WelcomeViewController.Button.Signup" = "登録する";
"Alert.OK" = "確認";
"Alert.Cancel" = "キャンセル";
"App" = "素晴らしいアプリ";
```

```
"WelcomeViewController.Label.Title" = "Welcome!";
"WelcomeViewController.Label.Message" = "Enjoy!";
"WelcomeViewController.Button.Signup" = "Signup";
"Alert.OK" = "OK";
"Alert.Cancel" = "Cancel";
"App" = "Awesome App";
```

# Installation

```sh
git clone https://github.com/muukii/L10n.git ./L10n
cd L10n
make release
make install
```
