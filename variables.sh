IPADDR4="192.95.10.154"
IPADDR6="2607:5300:60:4234::3e1:aaaa"

GATEWAY4="192.99.17.254"
GATEWAY6="2607:5300:60:42ff:ff:ff:ff:ff"

INSTALLER_DEVICE_NAME="ens3"

HOSTNAME="madiathv"
TIME_ZOME="America/New_York"


PACKAGES=("openssh"
          "nginx"
          "the_silver_searcher"
          "dnsutils"
          "emacs-nox"
          "unzip"
          "aspell"
          "jdk8-openjdk"
          "reflector"
          "wget"
          "syslinux"

          # Needed for automated syslinux script
          "gptfdisk"

          # Aura Dependencies
          "abs"
          "gmp"
          "pcre"

          # Needed for mkinitcpio compression.
          "lz4"
         )

AUR_PACKAGE=("aur-git"
            )
