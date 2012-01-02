#!/bin/sh
git config commit.template ".git.commit.template" 
git submodule foreach git config commit.template "../../.git.commit.template" 