#!/bin/bash
echo "This script wil provision your laptop using ansible"
ansible-playbook laptop.yml -i localhost --ask-become-pass
