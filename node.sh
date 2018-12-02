## docker 提前从gcr的国内仓库里拉取kubernetes的核心image, 并修改为原image的tag
echo "installing kubernetes images"
curl -fsSL -O https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/k8s-node-images
file="k8s-node-images"

if [ -f "$file" ]
then
  echo "$file found."

  cat "$file" | while IFS='=' read -r key value
  do
    #echo "${key}=${value}"
    if [[ -z `docker images | grep ${key%:*}` ]]
    then
      sudo docker pull ${value}
      sudo docker tag ${value} ${key}
      sudo docker rmi ${value}
    fi
  done

else
  echo "$file not found."
fi
echo "installed kubernetes images"