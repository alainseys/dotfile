# OS Detection script
#!/usr/bin/env bash

case "$(uname -s)" in 
	Linux*) OS="linux" ;;
	MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
	*) 	OS="unknown" ;;
esac
export OS
