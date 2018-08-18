#!/bin/bash
rand=$(head -c 100 /dev/urandom | tr -dc A-Za-z0-9 | head -c13)
echo 'Password : '$rand;
