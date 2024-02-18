#!/usr/bin/env sh

# Constants
# If you want to run the script from the folder 'scripts'
# Please replace the variable path
#readonly path=$(dirname $(pwd)) # Debug

readonly path=$(pwd) # Only for launching from MakeFile
readonly dir_allure="$path/allure"
readonly url="https://github.com/allure-framework/allure2/releases"


download_and_install_allure() {
    echo "Checking the internet connection..."
    if curl -sSf $url > /dev/null
    then
        echo "- connection OK!"
        echo "Getting last version allure..."
        html=$(curl -s $url )
        versions=$(echo "$html" | grep -oP '(?<=\/allure-framework\/allure2\/releases\/tag\/)\d+\.\d+\.\d+')
        last_version=$(echo "$versions" | awk 'NR < 2')
        echo "- Last version: $last_version"
        name_last_version="allure-$last_version.tgz"
        echo "Downloading $name_last_version ..."
        curl -L -O $url/download/"$last_version"/"$name_last_version"
        echo "Unzipping $name_last_version ..."
        tar -xvzf "$name_last_version" -C "$dir_allure" --strip 1
        echo "Removing src $name_last_version ..."
        rm "$name_last_version"
        echo "- src $name_last_version removed OK!"
    else
        printf "Error with internet connection!\nPlease check the internet connection and restart the script"
    fi
}


main() {
    echo "Does the Allure catalog exist?"
    if [ -d "$dir_allure" ]; then
        # shellcheck disable=SC2046
        # shellcheck disable=SC2006
        # shellcheck disable=SC2012
        if [ `ls "$dir_allure" | wc -l` -eq 0 ]; then # checking on empty
            echo "- allure directory exists and is empty."
            download_and_install_allure
        else 
            echo "- allure directory exists and is not empty."
        fi
    else
        # shellcheck disable=SC2039
        echo -e "The Allure directory does not exist!\nDownloading the Allure folder from Github..."
        echo "Creating directory allure [path=$dir_allure]"
        mkdir "$dir_allure"
        download_and_install_allure
    fi
}

# Start main function
main
