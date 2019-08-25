#!/bin/bash

killall gpg-agent
rm -rf $HOME/.gnupg/private-keys-v1.d
gpg --card-status
gpg-connect-agent updatestartuptty /bye
