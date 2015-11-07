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
