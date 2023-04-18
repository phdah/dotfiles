#!/bin/bash
# https://www.deanthomson.com/blog/microsoft-sql-server-on-arch-linux/
paru
# Dependency for mssql-server
paru -S libldap24
# AUR packages for mssql
paru -S \
    azure-cli-bin \
    azure-functions-core-tools-bin \
    mssql-server \
    msodbcsql \
    mssql-tools \
    azuredatastudio-bin
