#/bin/bash
clear
echo -e "\n";
cat logo.txt;
PS3='Veuillez choisir une option : '
options=("Installation minimal" "Serveur LAMP" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Installation minimal")
            echo "Installation minimal"
            ;;
        "Serveur LAMP")
            echo "Serveur LAMP"
            ;;
        "Option 3")
            echo "you chose choice 3"
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
echo -e "\n"
