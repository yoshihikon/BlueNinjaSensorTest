# BlueNinjaSensorTest
CerevoのBlueNinjaのセンサー値を取得するiPhone用サンプルアプリ

BlueNinja
http://blueninja.cerevo.com/ja/

実例紹介にある、[BlueNinjaを使って「ミニ四駆テレメトリーシステム（ロガー）」をつくる]のbinを使用し、
iOSでデータを取得するサンプルアプリです。
Swift2で記述しています。

#準備
####BlueNinjaの準備
実例紹介のページから[BlueNinjaのプログラム]をダウンロードし、
BlueNinjaに書き込んでください。

[BlueNinjaを使って「ミニ四駆テレメトリーシステム（ロガー）」をつくる]
http://blueninja.cerevo.com/ja/example/001_telemetry.html

####iPhoneアプリの準備
ソースコードをダウンロードし、Xcodeでビルドしてください。

#使い方
* BlueNinjaをONにし、ペアリングボタンを押してください。
* iPhoneアプリを起動し[Connect]ボタンを押してください。
* 各センサーの数値が取得できると、数値が表示されます。

#注意
* [Disconnect]すると、BlueNinja側のペアリングも解除されるため、再接続する場合は、BlueNinjaを再起動してください。
