# CentOS7 vagrantbox
Lamp開発環境  

## 起動
起動は以下になります。  
```
$ vagrant up
```

## 失敗メッセージについて
```
==> default: Mounting shared folders...
    default: /var/www => C:/_work/vm/centos7_0413/www
Failed to mount folders in Linux guest. This is usually because
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly. The command attempted was:

mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3`,
dmode=777,fmode=777 var_www /var/www
mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant`,dmode=777,fmode=777 v
ar_www /var/www

The error output from the last command was:

/sbin/mount.vboxsf: mounting failed with the error: No such device
```
初回は失敗します。  
その時は以下のバッチ処理の実行、キッティングが必要になります。  
```
$ vagrant provision
$ vagrant reload
```

chef,puppet 等は用いず、bashによるバッチ処理のみで解決しております。  

## フォルダ連携を確保する
もし、wwwフォルダがvirtualboxと連動しなければ、以下のコマンドを実行してから再起動してください。  
```
> vagrant ssh
$ sudo /etc/init.d/vboxadd setup
$ exit
> vagrant reload
```

## 困ったときに
### コピーした時同じVMが起動されてしまう。
```.vagrant``` フォルダに情報が含まれているので削除すると初期化されます。  
Vagrantfile の ```vb.name = "******"``` を変更して、別のVMの名前になるようにしてください。  


### 
