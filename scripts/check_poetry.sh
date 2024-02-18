#!/bin/bash

if pip freeze | grep -q "poetry"; then
    echo "Poetry is installed!"
else
    pip install --upgrade poetry
fi
