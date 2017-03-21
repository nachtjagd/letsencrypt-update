#!/bin/sh


#scl enable python27 bash
source /opt/rh/python27/enable


echo "-------------------------------------------------"
echo [`date +%Y%m%d-%H%M%S`] letsencrypt 自動更新を開始します
/bin/logger -t [letsencrypt] -p local5.info  "letsencrypt 自動更新を開始します"
echo "-------------------------------------------------"


COMMONNAME=i.yabusame.net
SHORTDOMAIN=yabusame.net
SYMCERT=/etc/pki/tls/yabusame-cert.pem
SYMPRIV=/etc/pki/tls/yabusame-privkey.pem
SYMCHAN=/etc/pki/tls/yabusame-chain.pem

echo "公開鍵は[ ${SYMCERT} ]"
echo "秘密鍵は[ ${SYMPRIV} ]"
echo "中間証明書は[ ${SYMCHAN} ]"


echo [`date +%Y%m%d-%H%M%S`] HTTPDを停止します
/bin/logger -t [letsencrypt] -p local5.info  "letsencrypt  HTTPDを停止します"

service httpd stop

echo [`date +%Y%m%d-%H%M%S`] letsencryptをアップデートします
/bin/logger -t [letsencrypt] -p local5.info  "letsencryptをアップデートします"

/var/service/letsencrypt/letsencrypt-auto certonly -a standalone -d ${SHORTDOMAIN} -d ${COMMONNAME} --renew-by-default

echo [`date +%Y%m%d-%H%M%S`] letsencryptをアップデートしました
/bin/logger -t [letsencrypt] -p local5.info  "letsencryptをアップデートしました"

NEWCETTSDIR=`ls -1t /etc/letsencrypt/archive/ | head -1`
NEWCERT=`ls -1t /etc/letsencrypt/archive/${NEWCETTSDIR}/cert*|head -1`
NEWPRIV=`ls -1t /etc/letsencrypt/archive/${NEWCETTSDIR}/privkey*|head -1`
NEWCHAN=`ls -1t /etc/letsencrypt/archive/${NEWCETTSDIR}/chain*|head -1`

echo [`date +%Y%m%d-%H%M%S`] 公開鍵を書き換えます。新規証明書は[${NEWCERT}]シンボリックリンクは[${SYMCERT}]です。
/bin/logger -t [letsencrypt] -p local5.info  "公開鍵を書き換えます新規証明書は[${NEWCERT}]シンボリックリンクは[${SYMCERT}]です。"

echo [`date +%Y%m%d-%H%M%S`] 秘密鍵を書き換えます。新規証明書は[${NEWPRIV}]シンボリックリンクは[${SYMPRIV}]です。
/bin/logger -t [letsencrypt] -p local5.info  "秘密鍵を書き換えます新規証明書は[${NEWPRIV}]シンボリックリンクは[${SYMPRIV}]です。"

echo [`date +%Y%m%d-%H%M%S`] 中間証明書を書き換えます。新規証明書は[${NEWCHAN}]シンボリックリンクは[${SYMCHAN}]です。
/bin/logger -t [letsencrypt] -p local5.info  "中間証明書を書き換えます新規証明書は[${NEWCHAN}]シンボリックリンクは[${SYMCHAN}]です。"


rm -f $SYMCERT
rm -f $SYMPRIV
rm -f $SYMCHAN

ln -s $NEWCERT      $SYMCERT
ln -s $NEWPRIV      $SYMPRIV
ln -s $NEWCHAN      $SYMCHAN

echo [`date +%Y%m%d-%H%M%S`] HTTPDを開始します
/bin/logger -t [letsencrypt] -p local5.info  "letsencrypt  HTTPDを開始します"
service httpd start


echo 有効期間の開始は`openssl x509 -text -in ${SYMCERT} | grep "Not Before"` から
echo 有効期間の終了は`openssl x509 -text -in ${SYMCERT} | grep "Not After"` まで



echo "-------------------------------------------------"
echo [`date +%Y%m%d-%H%M%S`] letsencrypt 自動更新を終了します
/bin/logger -t [letsencrypt] -p local5.info  "letsencrypt 自動更新を終了します"
echo "-------------------------------------------------"



