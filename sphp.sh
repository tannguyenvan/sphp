#!/bin/bash
# Creator: Phil Cook
# Modified: Andy Miller
osx_major_version=$(sw_vers -productVersion | cut -d. -f1)
osx_minor_version=$(sw_vers -productVersion | cut -d. -f2)
osx_patch_version=$(sw_vers -productVersion | cut -d. -f3)
osx_patch_version=${osx_patch_version:-0}
osx_version=$((${osx_major_version} * 10000 + ${osx_minor_version} * 100 + ${osx_patch_version}))
homebrew_path=$(brew --prefix)
brew_prefix=$(brew --prefix | sed 's#/#\\\/#g')

brew_array=("7.2","7.4","8.1")
php_array=("php@7.2" "php@7.4" "php@8.1")
php_installed_array=()
php_version="php@$1"
php_opt_path="$brew_prefix\/opt\/"

# Has the user submitted a version required
if [[ -z "$1" ]]; then
    echo "usage: sphp version [-s|-s=*] [-c=*]"
    echo
    echo "    version    one of:" ${brew_array[@]}
    echo
    exit
fi

# What versions of php are installed via brew
for i in ${php_array[*]}; do
    version=$(echo "$i" | sed 's/^php@//')
    if [[ -d "$homebrew_path/etc/php/$version" ]]; then
        php_installed_array+=("$i")
    fi
done

# Check that the requested version is supported
if [[ " ${php_array[*]} " == *"$php_version"* ]]; then
    # Check that the requested version is installed
    if [[ " ${php_installed_array[*]} " == *"$php_version"* ]]; then

        # Switch Shell
        echo "Switching to $php_version"
        echo "Switching your shell"
        for i in ${php_installed_array[@]}; do
            brew unlink $i
        done
        brew link --force "$php_version"

	echo ""
        php -v
        echo ""

        echo "All done!"
    else
        echo "Sorry, but $php_version is not installed via brew. Install by running: brew install $php_version"
    fi
else
    echo "Unknown version of PHP. PHP Switcher can only handle arguments of:" ${brew_array[@]}
fi
