#!/bin/bash
echo "==============================================================" | lolcat
echo  -e "\e[1;35m$(figlet -f slant "GIT MANAGER")\e[0m"
echo "==============================================================" | lolcat
mkdir /data/data/com.termux/files/git-logs 2>/dev/null
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
                                        echo "Se ha credor Dir [$dirName] en proyecto $PWD" >> /data/data/com.termux/files/git-logs/insideProyect.log
                                done
                                ;;
                        1)
                                read -p "Cuantos archivos desea crear:" numFile
                                for (( i=1;i<=numFile; i++  ))
                                do
                                        read -p "Enter file name: " fileName
                                        read -p "Enter type extension(ex: py, html, txt, etc): " exFile
                                        touch $fileName"."$exFile
                                        echo "Se ha credor archivo [$fileName.$exFile] en proyecto $PWD" >> /data/data/com.termux/files/git-logs/insideProyect.log
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
    echo "Proyecto creado en $PWD" >> /data/data/com.termux/files/git-logs/create-log.log 

    initProyect
	  menu_file
  else
    read -p "Ingrese el lugar donde lo desea crear:" creationPath
    if [[ -d $creationPath  ]]; then
      cd "${creationPath/\~/$HOME}"
      echo "Proyecto creado en $PWD" >> /data/data/com.termux/files/git-logs/create-log.log
      initProyect
      menu_file
      
    else
      mkdir "${creationPath/\~/$HOME}"
      cd "${creationPath/\~/$HOME}"
      echo "Proyecto creado en $PWD" >> /data/data/com.termux/files/git-logs/create-log.log
      initProyect
      menu_file
      
    fi
    
  fi
}

gitCloner(){
  file_manager
  read -p "Ingrese la clave para poder clonar" CloneKey
  
  git clone $CloneKey
  echo "Se ha clonado el Repositorio $CloneKey en $PWD" >> /data/data/com.termux/files/git-logs/clone-log.log
  dir=$(basename "$CloneKey" .git)
  mv "$dir"/* .
  rm -rf "$dir" 
  git remote add origin $CloneKey
}


gitPullet(){
  userPull=-1
  while [[ $userPull != 0  ]]; do
  echo "[1] Descargar cambios y actualizar rama actual"
  echo "[2] Descargar cambios y crear carpeta con estos cambios"
  echo "[0] Regresar"
  read -p "[user]:" userPull
  
  case $userPull in 
    1)
      read -p "Nombre de rama que desea agarrar" branchName
      git pull origin "$branchName"
      echo "Se ha hecho pull de la rama $branchName en $PWD" >>/data/data/com.termux/files/git-logs/pull-log.log
      
      ;;
    2)
      read -p "Nomvre de la rama qu3 desea tomar" branchName
      git fetch origin "$branchName"
      echo "Se ha hecho pull de la rama $branchName en $PWD" >>/data/data/com.termux/files/git-logs/pull-log.log
  
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
  echo "Se ha hecho push de la rama [$branchName] del proyecto $PWD" >> /data/data/com.termux/files/git-logs/push.log
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


gitCreateBranch(){
  read -p "Enter the name of branch: " branchName
  git branch $branchName
}

gitMerge(){
  read -p "Enter the name of the boss branch: " mainBranch
  
  git checkout $mainBranch
  read -p "Enter the numbers of branchs you need to merge with $mainBranch" nBranchs
  allBranchsToMerge=()
  for ((i = 0; i < $nBranchs; i++)); do
      read -p "Enter the name of branch [$i]" nameBranch
      allBranchsToMerge+=("$nameBranch")
    
  done
  for ((i = 0; i < ${#allBranchsToMerge[@]}; i++)); do
    git merge "${allBranchsToMerge[i]}"
  done
  

  
}
gop=-1
gitOptions=(
  "Crear nuevo proyecto"
  "Clonar Repositorio"
  "Continue workflow"
  "Pull Proyect"
  "Push proyect"
  "Add something"
  "Make commit"
  "Create Branch"
  "Merge Branch"
  "File manager"
  "Generate key"
)

while  [[ $gop != 0 ]]; 
do	
	echo "============================"
	for ((i = 0; i < ${#gitOptions[@]}; i++)); do
  
    echo "[$((i+1))]" "${gitOptions[$i]}"
	done
  echo "[0] Salir"	
	echo "============================"
	read -p "Enter a option: " gop
	
	
	case $gop in
		1)	
			file_manager
      initProyect
			;;
    2)
      gitCloner
      
      ;;
    3)
      gitContinue
      ;;
    4)
      gitPullet
      ;;
    5)
      gitPushed
      ;;
    6)
      gitAdd
      ;;
    7)
      gitCommit
      ;;
    8)
      gitCreateBranch
  
      ;;
    9)
      gitMerge
      ;;
    10)
      file_manager
      ;;
    11)
      gitSshKey
      ;;
		0)
			exit 0
			;;
		*)
			echo "Enter valid option"
			;;
	esac
done



