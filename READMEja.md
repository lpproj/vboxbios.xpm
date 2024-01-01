VirtualBox野良ビルド版ROMBIOS
=============================

VirtualBoxの仮想マシン内に内蔵されている非UEFIのシステムROM BIOS部分です。  
VirtualBoxは[kBuild](https://trac.netlabs.org/kbuild)という独自のビルド環境を使ってビルドが行われており、BIOS部分も例外ではないのですが、BIOSビルドのためだけにソースツリー全体やkBuild環境の構築を行うのもあまりにオオゴトなので、OpenWatcom (2.0beta)のみでビルド可能となるように若干の変更を加えてあります。

ご利用に関しては**自己責任**でお願いいたします。


状況の大まかな説明
------------------

XPmodeのディスクイメージをVirtualBox内で認証させる方法をネット上で検索すると、「仮想マシン内のシステムBIOSの特定部分を特定の文字パターンで書き換える」という方法が出てくるのですが、

  - 環境により書き換えの必要なアドレスが異なるようだ（自分の環境では、ネット上で見つかるどのアドレスを書き換えても認証できなかった）
  - 書き換え位置にあるBIOSコードが潰されるため、万が一その部分のコードが実行された場合はあまり想像したくない事態に陥る

ということで、「なんか書き換えが必要そうな場所」に「空き地」を大きめに確保したBIOSイメージを作り、その中の任意のアドレスに文字パターンを書き込んで、認証可能かどうか試行錯誤することにしました。

自分の環境（VirtualBox 5.2.44）だと3回程度の試行で認証できたので、それなりに運が良かったと思われます。


How to Build
------------

[OpenWatcom V2 beta](https://github.com/open-watcom/open-watcom-v2/releases)が必要です（Windowsなら V1.9でもいけるかもしれない）。
Linux上でビルドする場合にはホスト環境用のCコンパイラ(cc)も別途必要になります。  
そのほかにGNU makeが使えるとほんのすこしだけ便利になります。
Windows上ではmingw-w64のgccに付属しているmingw32-make (mingw64-make)をご利用ください。

基本的にはBIOSのソース本体が置いてあるディレクトリに移動してwmake（OpenWatcom付属のmake。他のmakeと若干構文が違う）を実行するだけでBIOSイメージ vboxbios.rom ができます。

    cd src/VBox/Devices/PC/BIOS
    wmake clean
    wmake

出来上がったBIOSは、**おおむね**オフセット0x9000～0x9400付近に「隙間」ができているはずです。
正確な位置は同時に生成されるvboxbios.map内にある_memory_hole_beginと_memory_hole_endの書いてある行で確認することができます。

また、「例の特定文字パターン」を埋め込んだ状態のBIOSを作ることもできます。
この場合はwmakeの引数として、「隙間」の先頭からのオフセット位置をSIGXP_OFFSETに指定します。

    cd src/VBox/Devices/PC/BIOS
    wmake clean
    wmake "SIGXP_OFFSET=256"

文字パターンの埋め込まれた正確な位置はvboxbios.map内にある_xpm_signatureの書いてある行で確認することができます。

