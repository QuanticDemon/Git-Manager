#!/bin/bash
echo "==============================================================" | lolcat
echo  -e "\e[1;35m$(figlet -f slant "GIT MANAGER")\e[0m"
echo "==============================================================" | lolcat

initProyect(){
  git init
}

menu_file(){
  while   [[ $typeFile != -1  ]];
        do
                echo "[0] Crear carpetas"
                echo "[1] Crear archivos"
                echo "[2] Salir"
                read typeFile
                case $typeFile in
                        0)
                                read -p "Cuantas carpetas desea crear:" numDir
                                for (( i=1; i<=numDir; i++ ))
                                do
                                        read -p "Enter the Dir Name: " dirName
                                        mkdir ./$dirName
                                done
                                ;;
                        1)
                                read -p "Cuantos archivos desea crear:" numFile
                                for (( i=1;i<=numFile; i++  ))
                                do
                                        read -p "Enter file name: " fileName
                                        read -p "Enter type extension(ex: py, html, txt, etc): " exFile
                                        touch $fileName"."$exFile
                                done
                                ;;
                        2)
                                break
                                ;;
                        *)
                                echo "Ingrese una opcion valida"
                                ;;
                esac
        done
}

file_manager(){
	echo "Desea crear el proyecto aqui? y/n:"
	read hereProject
	if [[ ${hereProject,,} == "y"  ]]; then
    initProyect
	  menu_file
  else
    read -p "Ingrese el lugar donde lo desea crear:" creationPath
    if [[ -d $creationPath  ]]; then
      cd "${creationPath/\~/$HOME}"
      initProyect
      menu_file
    else
      mkdir "${creationPath/\~/$HOME}"
      cd "${creationPath/\~/$HOME}"
      initProyect
      menu_file
    fi
    
  fi
}

gitCloner(){
  file_manager
  read -p "Ingrese la clave para poder clonar" CloneKey
  git clone $CloneKey
  dir=$(basename "$CloneKey" .git)
  mv "$dir"/* .
  rm -rf "$dir" 
  git remote add origin $CloneKey
}


gitPullet(){
  userPull = -1
  while [[ $userPull != 0  ]]; do
  echo "[1] Descargar cambios y actualizar rama actual"
  echo "[2] Descargar cambios y crear carpeta con estos cambios"
  echo "[0] Regresar"
  read -p "[user]:" userPull

  case $userPull in 
    1)
      read -p "Nombre de rama que desea agarrar" branchName
      git pull origin "$branchName"
      
      ;;
    2)
      read -p "Nomvre de la rama qu3 desea tomar" branchName
      git fetch origin "$branchName"
  
      ;;
    0)
      break 
      ;;
    *)
      echo "Opcion invalida"
      ;;
  esac
  done 
}


gitPushed(){
  git branch 
  read -p "Enter the name of branch" branchName
  git push -u origin "$branchName"
}


gitAdd(){
  git add --all

  read -p "Desea hacee commit de una vez [y/n]" commitMark

  if [[ ${commitMark,,} == "y" ]]; then
      gitCommit
  fi
}

gitCommit(){
  read -p "Message: " msg 
  git commit -m "$msg"
}

gitSshKey(){
  read -p "Identificador ssh key: " id
  ssh-keygen -t ed25519 -C "$id"
  cat ~/.ssh/id_ed25519.pub
}


gitContinue(){
  read -p "Ingrese la ubucacion de donde quiere seguur trabajando: " path 
  cd "${path/\~/$HOME}"
}

gop=""
while  [[ $gop != 0 ]]; 
do	
	echo "============================"
	echo "[1] Crear nuevo proyecto"
	echo "[2] Pull proyect"
	echo "[3] Push proyect"
	echo "[4] Add something"
	echo "[5] Make commit"
	echo "[6] Create branchs"
	echo "[7] Merge branchs"
  echo "[8] Clonar repo"
  echo "[9] File Manager"
  echo "[10] Generate SSH key"
  echo "[11] Continue workflow"
	echo "[0] Salir"
	echo "Enter a option"
	echo "============================"
	read -p "Enter a option: " gop
	
	
	case $gop in
		1)	
			file_manager
      initProyect
			;;
    2)
      gitPullet
      
      ;;
    3)
      gitPushed
      ;;
    4)
      gitAdd
      ;;
    5)
      gitCommit
      ;;
    8)
      gitCloner
  
      ;;
    9)
      file_manager
      ;;
    10)
      gitSshKey
      ;;
    11)
      gitContinue
      ;;
		0)
			exit 0
			;;
		*)
			echo "Enter valid option"
			;;
	esac
done



